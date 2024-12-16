/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class FarmLockDepositFormState with _$FarmLockDepositFormState {
  const factory FarmLockDepositFormState({
    @Default(ProcessStep.form) ProcessStep processStep,
    @Default(false) bool resumeProcess,
    @Default(0) int currentStep,
    DexPool? pool,
    DexFarmLock? farmLock,
    @Default(false) bool isProcessInProgress,
    @Default(false) bool farmLockDepositOk,
    @Default(0.0) double amount,
    double? aprEstimation,
    @Default(FarmLockDepositDurationType.threeYears)
    FarmLockDepositDurationType farmLockDepositDuration,
    @Default('') String level,
    @Default(0.0) double lpTokenBalance,
    @Default(0.0) double feesEstimatedUCO,
    Transaction? transactionFarmLockDeposit,
    @Default({}) Map<String, int> filterAvailableLevels,
    Failure? failure,
    double? finalAmount,
    DateTime? consentDateTime,
  }) = _FarmLockDepositFormState;
  const FarmLockDepositFormState._();

  bool get isControlsOk => failure == null && amount > 0;

  String? get lpTokenAddress =>
      pool?.lpToken.isUCO == true ? kUCOAddress : pool?.lpToken.address;
}
