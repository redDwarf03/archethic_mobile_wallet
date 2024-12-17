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
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

class DepositFarmLockCase with aedappfm.TransactionMixin {
  DepositFarmLockCase({
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
    FarmLockDepositFormNotifier farmLockDepositNotifier,
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
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

    archethic.Transaction? transactionDeposit;
    farmLockDepositNotifier.setFinalAmount(null);

    try {
      final transactionDepositMap =
          await archethicContract.getFarmLockDepositTx(
        farmGenesisAddress,
        lpTokenAddress,
        amount,
        durationType,
        level,
      );

      transactionDepositMap.map(
        success: (success) {
          transactionDeposit = success;
          farmLockDepositNotifier.setTransactionFarmLockDeposit(
            transactionDeposit!,
          );
        },
        failure: (failure) {
          farmLockDepositNotifier
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
        transactionDeposit!,
        selectedAccount.lastAddress!,
        selectedAccount.name,
      );

      farmLockDepositNotifier
          .setTransactionFarmLockDeposit(transationSignedRaw);

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );

      if (confirmation == null) return;
      farmLockDepositNotifier
        ..setResumeProcess(false)
        ..setFarmLockDepositOk(true);

      notificationService.start(
        operationId,
        DexNotification.depositFarmLock(
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

      farmLockDepositNotifier.setFinalAmount(amount);

      notificationService.succeed(
        operationId,
        DexNotification.depositFarmLock(
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
      farmLockDepositNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockDepositOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
    } catch (e) {
      farmLockDepositNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockDepositOk(false);

      if (e is aedappfm.Failure) {
        farmLockDepositNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      farmLockDepositNotifier.setFailure(
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
    FarmLockDepositDurationType durationType,
    String level,
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionDeposit;

    try {
      final transactionDepositMap =
          await archethicContract.getFarmLockDepositTx(
        farmGenesisAddress,
        lpTokenAddress,
        amount,
        durationType,
        level,
      );

      transactionDepositMap.map(
        success: (success) {
          transactionDeposit = success;
          // Add fake signature and address to allow estimation by node
          transactionDeposit = transactionDeposit!.copyWith(
            address: const archethic.Address(
              address:
                  '00000000000000000000000000000000000000000000000000000000000000000000',
            ),
            previousPublicKey:
                '00000000000000000000000000000000000000000000000000000000000000000000',
          );
        },
        failure: (failure) {
          return 0.0;
        },
      );
    } catch (e) {
      return 0.0;
    }

    if (transactionDeposit != null) {
      final fees = await calculateFees(
        transactionDeposit!,
        apiService,
        slippage: 1.1,
      );
      return fees;
    } else {
      return 0.0;
    }
  }

  String getAEStepLabel(
    AppLocalizations localizations,
    int step,
  ) {
    switch (step) {
      case 1:
        return localizations.depositFarmLockProcessStep1;
      case 2:
        return localizations.depositFarmLockProcessStep2;
      case 3:
        return localizations.depositFarmLockProcessStep3;
      default:
        return localizations.depositFarmLockProcessStep0;
    }
  }
}
