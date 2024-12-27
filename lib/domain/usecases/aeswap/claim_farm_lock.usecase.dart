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
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

const logName = 'ClaimFarmLockCase';

class ClaimFarmLockCase with aedappfm.TransactionMixin {
  ClaimFarmLockCase({
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
    FarmLockClaimFormNotifier farmClaimLockNotifier,
    String farmGenesisAddress,
    String depositId,
    DexToken rewardToken,
  ) async {
    final operationId = const Uuid().v4();
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );

    archethic.Transaction? transactionClaim;
    farmClaimLockNotifier.setFinalAmount(null);

    try {
      final transactionClaimMap = await archethicContract.getFarmLockClaimTx(
        farmGenesisAddress,
        depositId,
      );

      transactionClaimMap.map(
        success: (success) {
          transactionClaim = success;
          farmClaimLockNotifier.setTransactionClaimFarmLock(
            transactionClaim!,
          );
        },
        failure: (failure) {
          farmClaimLockNotifier
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
        transactionClaim!,
        selectedAccount.genesisAddress,
        selectedAccount.name,
      );

      farmClaimLockNotifier.setTransactionClaimFarmLock(
        transationSignedRaw,
      );

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );

      if (confirmation == null) return;
      farmClaimLockNotifier
        ..setResumeProcess(false)
        ..setFarmLockClaimOk(true);

      notificationService.start(
        operationId,
        DexNotification.claimFarmLock(
          txAddress: transationSignedRaw.address!.address,
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

      final amount = await aedappfm.PeriodicFuture.periodic<double>(
        () => getAmountFromTxInput(
          transationSignedRaw.address!.address!,
          rewardToken.address,
          apiService,
        ),
        sleepDuration: const Duration(seconds: 3),
        until: (amount) => amount > 0,
        timeout: const Duration(minutes: 1),
      );

      farmClaimLockNotifier.setFinalAmount(amount);

      notificationService.succeed(
        operationId,
        DexNotification.claimFarmLock(
          txAddress: transationSignedRaw.address!.address,
          amount: amount,
          rewardToken: rewardToken,
        ),
      );
    } on archethic.TransactionError catch (error) {
      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(error.messageLabel),
      );
      farmClaimLockNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockClaimOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
    } catch (e) {
      farmClaimLockNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setFarmLockClaimOk(false);

      if (e is aedappfm.Failure) {
        farmClaimLockNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      farmClaimLockNotifier.setFailure(
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
    String depositId,
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionClaim;

    try {
      final transactionClaimMap = await archethicContract.getFarmLockClaimTx(
        farmGenesisAddress,
        depositId,
      );

      return transactionClaimMap.map(
        success: (success) async {
          transactionClaim = success;
          // Add fake signature and address to allow estimation by node
          transactionClaim = transactionClaim!.copyWith(
            address: const archethic.Address(
              address:
                  '00000000000000000000000000000000000000000000000000000000000000000000',
            ),
            previousPublicKey:
                '00000000000000000000000000000000000000000000000000000000000000000000',
          );

          if (transactionClaim != null) {
            final fees = await calculateFees(
              transactionClaim!,
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
        return AppLocalizations.of(context)!.claimLockProcessStep1;
      case 2:
        return AppLocalizations.of(context)!.claimLockProcessStep2;
      case 3:
        return AppLocalizations.of(context)!.claimLockProcessStep3;
      default:
        return AppLocalizations.of(context)!.claimLockProcessStep0;
    }
  }
}
