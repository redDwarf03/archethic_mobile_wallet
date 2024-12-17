/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aewallet/domain/repositories/transaction_remote.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/modules/aeswap/application/contracts/archethic_contract.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_notification.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/util/notification_service/task_notification_service.dart'
    as ns;
import 'package:aewallet/modules/aeswap/util/string_util.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

const logName = 'WithdrawFarmLockCase';

class WithdrawFarmLockCase with aedappfm.TransactionMixin {
  WithdrawFarmLockCase({
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
    FarmLockWithdrawFormNotifier farmLockWithdrawNotifier,
    bool isFarmClose,
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
    String depositId,
    DexToken rewardToken,
  ) async {
    final operationId = const Uuid().v4();
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );

    archethic.Transaction? transactionWithdraw;
    farmLockWithdrawNotifier
      ..setFinalAmountReward(null)
      ..setFinalAmountWithdraw(null);

    try {
      final transactionWithdrawMap =
          await archethicContract.getFarmLockWithdrawTx(
        farmGenesisAddress,
        amount,
        depositId,
      );

      transactionWithdrawMap.map(
        success: (success) {
          transactionWithdraw = success;
          farmLockWithdrawNotifier.setTransactionWithdrawFarmLock(
            transactionWithdraw!,
          );
        },
        failure: (failure) {
          farmLockWithdrawNotifier
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
        transactionWithdraw!,
        selectedAccount.lastAddress!,
        selectedAccount.name,
      );

      farmLockWithdrawNotifier
          .setTransactionWithdrawFarmLock(transationSignedRaw);

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );
      if (confirmation == null) return;

      farmLockWithdrawNotifier
        ..setResumeProcess(false)
        ..setFarmLockWithdrawOk(true);

      notificationService.start(
        operationId,
        DexNotification.withdrawFarmLock(
          txAddress: transationSignedRaw.address!.address,
          rewardToken: rewardToken,
          isFarmClose: isFarmClose,
        ),
      );

      await aedappfm.PeriodicFuture.periodic<bool>(
        () => isSCCallExecuted(
          apiService,
          farmGenesisAddress,
          transationSignedRaw.address!.address!,
        ),
        sleepDuration: const Duration(seconds: 3),
        until: (depositOk) => depositOk == true,
        timeout: const Duration(minutes: 1),
      );

      final amounts = await aedappfm.PeriodicFuture.periodic<List<double>>(
        () => Future.wait([
          getAmountFromTxInput(
            transationSignedRaw.address!.address!,
            rewardToken.address,
            apiService,
          ),
          getAmountFromTxInput(
            transationSignedRaw.address!.address!,
            lpTokenAddress,
            apiService,
          ),
        ]),
        sleepDuration: const Duration(seconds: 3),
        until: (amounts) {
          return amounts[1] > 0;
        },
        timeout: const Duration(minutes: 1),
      );

      final amountReward = amounts[0];
      final amountWithdraw = amounts[1];

      farmLockWithdrawNotifier
        ..setFinalAmountReward(amountReward)
        ..setFinalAmountWithdraw(amountWithdraw);

      notificationService.succeed(
        operationId,
        DexNotification.withdrawFarmLock(
          txAddress: transationSignedRaw.address!.address,
          amountReward: amountReward,
          amountWithdraw: amountWithdraw,
          rewardToken: rewardToken,
          isFarmClose: isFarmClose,
        ),
      );
    } on archethic.TransactionError catch (error) {
      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(error.messageLabel),
      );
      farmLockWithdrawNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockWithdrawOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
    } catch (e) {
      farmLockWithdrawNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockWithdrawOk(false);

      if (e is aedappfm.Failure) {
        farmLockWithdrawNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      farmLockWithdrawNotifier.setFailure(
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
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionWithdraw;

    try {
      final transactionWithdrawMap =
          await archethicContract.getFarmLockWithdrawTx(
        farmGenesisAddress,
        amount,
        depositId,
      );
      return transactionWithdrawMap.map(
        success: (success) async {
          transactionWithdraw = success;
          // Add fake signature and address to allow estimation by node
          transactionWithdraw = transactionWithdraw!.copyWith(
            address: const archethic.Address(
              address:
                  '00000000000000000000000000000000000000000000000000000000000000000000',
            ),
            previousPublicKey:
                '00000000000000000000000000000000000000000000000000000000000000000000',
          );
          if (transactionWithdraw != null) {
            final fees = await calculateFees(
              transactionWithdraw!,
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
        return AppLocalizations.of(context)!.withdrawFarmLockProcessStep1;
      case 2:
        return AppLocalizations.of(context)!.withdrawFarmLockProcessStep2;
      case 3:
        return AppLocalizations.of(context)!.withdrawFarmLockProcessStep3;
      default:
        return AppLocalizations.of(context)!.withdrawFarmLockProcessStep0;
    }
  }
}
