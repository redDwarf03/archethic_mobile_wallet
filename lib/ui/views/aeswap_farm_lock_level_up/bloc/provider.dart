import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/aeswap/usecases.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:aewallet/modules/aeswap/util/browser_util_desktop.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:decimal/decimal.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class FarmLockLevelUpFormNotifier extends _$FarmLockLevelUpFormNotifier {
  FarmLockLevelUpFormNotifier();

  @override
  FarmLockLevelUpFormState build() => const FarmLockLevelUpFormState();

  Future<void> initBalances() async {
    final lpTokenBalance = await ref.read(
      getBalanceProvider(
        state.pool!.lpToken.isUCO ? kUCOAddress : state.pool!.lpToken.address,
      ).future,
    );
    state = state.copyWith(lpTokenBalance: lpTokenBalance);
  }

  void setDepositId(String depositId) {
    state = state.copyWith(depositId: depositId);
  }

  void setTransactionFarmLockLevelUp(
    archethic.Transaction transactionFarmLockLevelUp,
  ) {
    state =
        state.copyWith(transactionFarmLockLevelUp: transactionFarmLockLevelUp);
  }

  void setAmount(
    double amount,
  ) {
    state = state.copyWith(
      failure: null,
      amount: amount,
    );
  }

  void setAmountMax() {
    setAmount(state.lpTokenBalance);
  }

  void setAmountHalf() {
    setAmount(
      (Decimal.parse(state.lpTokenBalance.toString()) / Decimal.fromInt(2))
          .toDouble(),
    );
  }

  void setDexPool(DexPool pool) {
    state = state.copyWith(
      pool: pool,
    );
  }

  void setDexFarmLock(DexFarmLock farmLock) {
    state = state.copyWith(
      farmLock: farmLock,
    );
  }

  void setFailure(aedappfm.Failure? failure) {
    state = state.copyWith(
      failure: failure,
    );
  }

  void setFarmLockLevelUpOk(bool farmLockLevelUpOk) {
    state = state.copyWith(
      farmLockLevelUpOk: farmLockLevelUpOk,
    );
  }

  void setCurrentLevel(String currentLevel) {
    state = state.copyWith(currentLevel: currentLevel);
  }

  void setFinalAmount(double? finalAmount) {
    state = state.copyWith(finalAmount: finalAmount);
  }

  void setCurrentStep(int currentStep) {
    state = state.copyWith(currentStep: currentStep);
  }

  void setFarmLockLevelUpDuration(
    FarmLockDepositDurationType farmLockLevelUpDuration,
  ) {
    state = state.copyWith(farmLockLevelUpDuration: farmLockLevelUpDuration);
  }

  void setLevel(String level) {
    state = state.copyWith(level: level);
  }

  void setResumeProcess(bool resumeProcess) {
    state = state.copyWith(resumeProcess: resumeProcess);
  }

  void setProcessInProgress(bool isProcessInProgress) {
    state = state.copyWith(isProcessInProgress: isProcessInProgress);
  }

  void setAPREstimation(double? aprEstimation) {
    state = state.copyWith(aprEstimation: aprEstimation);
  }

  void setFarmLockLevelUpProcessStep(
    aedappfm.ProcessStep processStep,
  ) {
    state = state.copyWith(
      processStep: processStep,
    );
  }

  void filterAvailableLevels() {
    final availableLevelsFiltered = <String, int>{};
    var needMax = false;
    final farmEndDate = state.farmLock!.endDate!;

    for (final entry in state.farmLock!.availableLevels.entries) {
      final numLevel = int.tryParse(entry.key) ?? 0;
      final numCurrentLevel = int.tryParse(state.currentLevel!) ?? 0;
      final endDate = entry.value;
      if (DateTime.fromMillisecondsSinceEpoch(
        entry.value * 1000,
      ).isBefore(farmEndDate)) {
        if (numLevel != 0 && numLevel > numCurrentLevel) {
          availableLevelsFiltered[numLevel.toString()] = endDate;
        }
      } else {
        if (needMax == false) {
          availableLevelsFiltered['max'] =
              farmEndDate.millisecondsSinceEpoch ~/ 1000;
          state = state.copyWith(
            farmLockLevelUpDuration: FarmLockDepositDurationType.max,
          );
          needMax = true;
        }
      }
    }
    state = state.copyWith(filterAvailableLevels: availableLevelsFiltered);
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

    setFarmLockLevelUpProcessStep(
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
          cause: appLocalizations.farmDepositControlAmountEmpty,
        ),
      );
      return false;
    }

    var feesEstimatedUCO = 0.0;
    feesEstimatedUCO = await ref.read(levelUpFarmLockCaseProvider).estimateFees(
          state.farmLock!.farmAddress,
          state.farmLock!.lpToken!.address,
          state.amount,
          state.depositId!,
          state.farmLockLevelUpDuration,
          state.level,
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

  Future<bool> lock(AppLocalizations appLocalizations) async {
    setFarmLockLevelUpOk(false);
    setProcessInProgress(true);

    if (await control(appLocalizations) == false) {
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

    await ref.read(levelUpFarmLockCaseProvider).run(
          appLocalizations,
          this,
          state.farmLock!.farmAddress,
          state.farmLock!.lpToken!.address,
          state.amount,
          state.depositId!,
          state.farmLock!.farmAddress,
          false,
          state.farmLockLevelUpDuration,
          state.level,
        );

    ref
      ..invalidate(userBalanceProvider)
      ..invalidate(farmLockFormFarmLockProvider);

    return true;
  }
}
