import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/aeswap/usecases.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pair.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/util/browser_util_desktop.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:decimal/decimal.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class FarmLockWithdrawFormNotifier extends _$FarmLockWithdrawFormNotifier {
  FarmLockWithdrawFormNotifier();

  @override
  FarmLockWithdrawFormState build() => const FarmLockWithdrawFormState();

  void setTransactionWithdrawFarmLock(
    archethic.Transaction transactionWithdrawFarmLock,
  ) {
    state = state.copyWith(
      transactionWithdrawFarmLock: transactionWithdrawFarmLock,
    );
  }

  void setDepositId(String depositId) {
    state = state.copyWith(depositId: depositId);
  }

  void setAmount(
    AppLocalizations localizations,
    double amount,
  ) {
    state = state.copyWith(
      failure: null,
      amount: amount,
    );

    if (state.amount > state.depositedAmount!) {
      setFailure(
        aedappfm.Failure.other(
          cause:
              localizations.farmLockWithdrawControlLPTokenAmountExceedDeposited,
        ),
      );
    }
  }

  void setDepositedAmount(double? depositedAmount) {
    state = state.copyWith(depositedAmount: depositedAmount);
  }

  void setRewardAmount(double? rewardAmount) {
    state = state.copyWith(rewardAmount: rewardAmount);
  }

  void setAmountMax(AppLocalizations appLocalizations) {
    setAmount(appLocalizations, state.depositedAmount!);
  }

  void setPoolAddress(String poolAddress) {
    state = state.copyWith(poolAddress: poolAddress);
  }

  void setEndDate(DateTime endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void setAmountHalf(AppLocalizations appLocalizations) {
    setAmount(
      appLocalizations,
      (Decimal.parse(state.depositedAmount.toString()) / Decimal.fromInt(2))
          .toDouble(),
    );
  }

  void setFarmAddress(String farmAddress) {
    state = state.copyWith(
      farmAddress: farmAddress,
    );
  }

  void setRewardToken(DexToken rewardToken) {
    state = state.copyWith(
      rewardToken: rewardToken,
    );
  }

  void setLpToken(DexToken lpToken) {
    state = state.copyWith(
      lpToken: lpToken,
    );
  }

  void setLPTokenPair(DexPair lpTokenPair) {
    state = state.copyWith(
      lpTokenPair: lpTokenPair,
    );
  }

  void setFailure(aedappfm.Failure? failure) {
    state = state.copyWith(
      failure: failure,
    );
  }

  void setFarmLockWithdrawOk(bool farmLockWithdrawOk) {
    state = state.copyWith(
      farmLockWithdrawOk: farmLockWithdrawOk,
    );
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

  void setFinalAmountReward(double? finalAmountReward) {
    state = state.copyWith(finalAmountReward: finalAmountReward);
  }

  void setFinalAmountWithdraw(double? finalAmountWithdraw) {
    state = state.copyWith(finalAmountWithdraw: finalAmountWithdraw);
  }

  void setFarmLockWithdrawProcessStep(
    aedappfm.ProcessStep farmLockWithdrawProcessStep,
  ) {
    state = state.copyWith(
      processStep: farmLockWithdrawProcessStep,
    );
  }

  Future<void> validateForm(AppLocalizations appLocalizations) async {
    if (await control(appLocalizations) == false) {
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

    setFarmLockWithdrawProcessStep(
      aedappfm.ProcessStep.confirmation,
    );
  }

  Future<bool> control(AppLocalizations appLocalizations) async {
    setFailure(null);

    if (BrowserUtil().isEdgeBrowser() ||
        BrowserUtil().isInternetExplorerBrowser()) {
      setFailure(
        const aedappfm.Failure.incompatibleBrowser(),
      );
      return false;
    }

    if (state.amount <= 0) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.farmLockWithdrawControlAmountEmpty,
        ),
      );
      return false;
    }

    if (state.amount > state.depositedAmount!) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations
              .farmLockWithdrawControlLPTokenAmountExceedDeposited,
        ),
      );
      return false;
    }

    var feesEstimatedUCO = 0.0;
    feesEstimatedUCO =
        await ref.read(withdrawFarmLockCaseProvider).estimateFees(
              state.farmAddress!,
              state.lpToken!.address,
              state.amount,
              state.depositId,
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

  Future<bool> withdraw(AppLocalizations localizations) async {
    setFarmLockWithdrawOk(false);
    setProcessInProgress(true);

    if (await control(localizations) == false) {
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
    await ref.read(withdrawFarmLockCaseProvider).run(
          localizations,
          this,
          state.isFarmClose,
          state.farmAddress!,
          state.lpToken!.address,
          state.amount,
          state.depositId,
          state.rewardToken!,
        );

    ref
      ..invalidate(userBalanceProvider)
      ..invalidate(farmLockFormFarmLockProvider);

    return true;
  }
}
