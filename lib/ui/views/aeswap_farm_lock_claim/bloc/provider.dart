import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/aeswap/usecases.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/util/browser_util_desktop.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class FarmLockClaimFormNotifier extends _$FarmLockClaimFormNotifier {
  FarmLockClaimFormNotifier();

  @override
  FarmLockClaimFormState build() => const FarmLockClaimFormState();

  void setTransactionClaimFarmLock(
    archethic.Transaction transactionClaimFarmLock,
  ) {
    state = state.copyWith(transactionClaimFarmLock: transactionClaimFarmLock);
  }

  void setRewardAmount(double? rewardAmount) {
    state = state.copyWith(rewardAmount: rewardAmount);
  }

  void setFarmAddress(String farmAddress) {
    state = state.copyWith(
      farmAddress: farmAddress,
    );
  }

  void setPoolAddress(String poolAddress) {
    state = state.copyWith(
      poolAddress: poolAddress,
    );
  }

  void setRewardToken(DexToken rewardToken) {
    state = state.copyWith(
      rewardToken: rewardToken,
    );
  }

  void setLpTokenAddress(String lpTokenAddress) {
    state = state.copyWith(
      lpTokenAddress: lpTokenAddress,
    );
  }

  void setDepositId(String depositId) {
    state = state.copyWith(depositId: depositId);
  }

  void setFailure(aedappfm.Failure? failure) {
    state = state.copyWith(
      failure: failure,
    );
  }

  void setFarmLockClaimOk(bool farmLockClaimOk) {
    state = state.copyWith(
      farmLockClaimOk: farmLockClaimOk,
    );
  }

  void setFinalAmount(double? finalAmount) {
    state = state.copyWith(finalAmount: finalAmount);
  }

  void setCurrentStep(int currentStep) {
    state = state.copyWith(currentStep: currentStep);
  }

  void setResumeProcess(bool resumeProcess) {
    state = state.copyWith(resumeProcess: resumeProcess);
  }

  void setProcessInProgress(bool isProcessInProgress) {
    state = state.copyWith(isProcessInProgress: isProcessInProgress);
  }

  void setFarmLockClaimProcessStep(
    aedappfm.ProcessStep farmLockClaimProcessStep,
  ) {
    state = state.copyWith(
      processStep: farmLockClaimProcessStep,
    );
  }

  Future<void> validateForm() async {
    if (await control() == false) {
      return;
    }

    final accountSelected = ref.read(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    DateTime? consentDateTime;
    consentDateTime = await aedappfm.ConsentRepositoryImpl()
        .getConsentTime(accountSelected!.genesisAddress);
    state = state.copyWith(consentDateTime: consentDateTime);

    setFarmLockClaimProcessStep(
      aedappfm.ProcessStep.confirmation,
    );
  }

  Future<bool> control() async {
    setFailure(null);

    if (BrowserUtil().isEdgeBrowser() ||
        BrowserUtil().isInternetExplorerBrowser()) {
      setFailure(
        const aedappfm.Failure.incompatibleBrowser(),
      );
      return false;
    }

    var feesEstimatedUCO = 0.0;
    feesEstimatedUCO = await ref.read(claimFarmLockCaseProvider).estimateFees(
          state.farmAddress!,
          state.depositId!,
        );
    state = state.copyWith(
      feesEstimatedUCO: feesEstimatedUCO,
    );

    if (feesEstimatedUCO > 0) {
      final userBalance = await ref.read(userBalanceProvider.future);
      if (feesEstimatedUCO > userBalance.uco) {
        setFailure(const aedappfm.Failure.insufficientFunds());
        return false;
      }
    }

    return true;
  }

  Future<bool> claim(AppLocalizations localizations) async {
    setFarmLockClaimOk(false);
    setProcessInProgress(true);

    if (await control() == false) {
      setProcessInProgress(false);
      return false;
    }

    final accountSelected = ref.read(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    await aedappfm.ConsentRepositoryImpl()
        .addAddress(accountSelected!.genesisAddress);

    await ref.read(claimFarmLockCaseProvider).run(
          localizations,
          this,
          state.farmAddress!,
          state.depositId!,
          state.rewardToken!,
        );

    ref
      ..invalidate(userBalanceProvider)
      ..invalidate(farmLockFormFarmLockProvider);

    return true;
  }
}
