/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aewallet/domain/repositories/transaction_remote.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/modules/aeswap/application/contracts/archethic_contract.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_notification.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:aewallet/modules/aeswap/util/notification_service/task_notification_service.dart'
    as ns;
import 'package:aewallet/modules/aeswap/util/string_util.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

const logName = 'LevelUpFarmLockCase';

class LevelUpFarmLockCase with aedappfm.TransactionMixin {
  LevelUpFarmLockCase({
    required this.apiService,
    required this.notificationService,
    required this.verifiedTokensRepository,
    required this.transactionRepository,
    required this.keychainSecuredInfos,
    required this.selectedAccount,
  });

  final archethic.ApiService apiService;
  final ns.TaskNotificationService<DexNotification, aedappfm.Failure>
      notificationService;
  final aedappfm.VerifiedTokensRepositoryInterface verifiedTokensRepository;
  final TransactionRemoteRepositoryInterface transactionRepository;
  final KeychainSecuredInfos keychainSecuredInfos;
  final Account selectedAccount;

  Future<void> run(
    AppLocalizations localizations,
    FarmLockLevelUpFormNotifier farmLevelUpNotifier,
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
    String depositId,
    String farmAddress,
    bool isUCO,
    FarmLockDepositDurationType durationType,
    String level,
  ) async {
    final operationId = const Uuid().v4();
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );

    archethic.Transaction? transactionLevelUp;
    farmLevelUpNotifier.setFinalAmount(null);

    try {
      final transactionLevelUpMap = await archethicContract.getFarmLockRelockTx(
        farmGenesisAddress,
        lpTokenAddress,
        amount,
        depositId,
        durationType,
        level,
      );

      transactionLevelUpMap.map(
        success: (success) {
          transactionLevelUp = success;
          farmLevelUpNotifier.setTransactionFarmLockLevelUp(
            transactionLevelUp!,
          );
        },
        failure: (failure) {
          farmLevelUpNotifier
            ..setFailure(failure)
            ..setProcessInProgress(false);
          throw failure;
        },
      );
    } catch (e) {
      throw aedappfm.Failure.fromError(e);
    }

    try {
      final transationSignedRaw =
          await transactionRepository.buildTransactionRaw(
        keychainSecuredInfos,
        transactionLevelUp!,
        selectedAccount.lastAddress!,
        selectedAccount.name,
      );

      farmLevelUpNotifier.setTransactionFarmLockLevelUp(transationSignedRaw);

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );

      if (confirmation == null) return;
      farmLevelUpNotifier
        ..setResumeProcess(false)
        ..setFarmLockLevelUpOk(true);

      notificationService.start(
        operationId,
        DexNotification.levelUpFarmLock(
          txAddress: transationSignedRaw.address!.address,
          farmAddress: farmAddress,
          isUCO: isUCO,
        ),
      );

      await aedappfm.PeriodicFuture.periodic<bool>(
        () => isSCCallExecuted(
          apiService,
          farmAddress,
          transationSignedRaw.address!.address!,
        ),
        sleepDuration: const Duration(seconds: 3),
        until: (depositOk) => depositOk == true,
        timeout: const Duration(minutes: 1),
      );

      farmLevelUpNotifier.setFinalAmount(amount);

      notificationService.succeed(
        operationId,
        DexNotification.levelUpFarmLock(
          txAddress: transationSignedRaw.address!.address,
          amount: amount,
          farmAddress: farmAddress,
          isUCO: isUCO,
        ),
      );
    } on archethic.TransactionError catch (error) {
      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(error.messageLabel),
      );
      farmLevelUpNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockLevelUpOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
    } catch (e) {
      farmLevelUpNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockLevelUpOk(false);

      if (e is aedappfm.Failure) {
        farmLevelUpNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      farmLevelUpNotifier.setFailure(
        aedappfm.Failure.other(
          cause: e.toString().replaceAll('Exception: ', '').capitalize(),
        ),
      );

      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(e),
      );
      throw aedappfm.Failure.fromError(e);
    }
  }

  Future<double> estimateFees(
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
    String depositId,
    FarmLockDepositDurationType durationType,
    String level,
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionLevelUp;

    try {
      final transactionLevelUpMap = await archethicContract.getFarmLockRelockTx(
        farmGenesisAddress,
        lpTokenAddress,
        amount,
        depositId,
        durationType,
        level,
      );

      return transactionLevelUpMap.map(
        success: (success) async {
          transactionLevelUp = success;
          // Add fake signature and address to allow estimation by node
          transactionLevelUp = transactionLevelUp!.copyWith(
            address: const archethic.Address(
              address:
                  '00000000000000000000000000000000000000000000000000000000000000000000',
            ),
            previousPublicKey:
                '00000000000000000000000000000000000000000000000000000000000000000000',
          );
          if (transactionLevelUp != null) {
            final fees = await calculateFees(
              transactionLevelUp!,
              apiService,
              slippage: 1.1,
            );
            return fees;
          } else {
            return 0;
          }
        },
        failure: (failure) {
          return 0.0;
        },
      );
    } catch (e) {
      return 0.0;
    }
  }

  String getAEStepLabel(
    BuildContext context,
    int step,
  ) {
    switch (step) {
      case 1:
        return AppLocalizations.of(context)!.levelUpFarmLockProcessStep1;
      case 2:
        return AppLocalizations.of(context)!.levelUpFarmLockProcessStep2;
      case 3:
        return AppLocalizations.of(context)!.levelUpFarmLockProcessStep3;
      default:
        return AppLocalizations.of(context)!.levelUpFarmLockProcessStep0;
    }
  }
}
