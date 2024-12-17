/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:ui';

import 'package:aewallet/domain/repositories/transaction_remote.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/modules/aeswap/application/contracts/archethic_contract.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_notification.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/util/notification_service/task_notification_service.dart'
    as ns;
import 'package:aewallet/modules/aeswap/util/string_util.dart';
import 'package:aewallet/ui/views/aeswap_swap/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

const logName = 'SwapCase';

class SwapCase with aedappfm.TransactionMixin {
  SwapCase({
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
    SwapFormNotifier swapNotifier,
    AppLocalizations localizations,
    String poolGenesisAddress,
    DexToken tokenToSwap,
    DexToken tokenSwapped,
    double tokenToSwapAmount,
    double slippage,
    VoidCallback onDone,
  ) async {
    final operationId = const Uuid().v4();
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );

    archethic.Transaction? transactionSwap;
    swapNotifier.setFinalAmount(null);

    var outputAmount = 0.0;
    try {
      final outputAmountMap = await archethicContract.getOutputAmount(
        tokenToSwap,
        tokenToSwapAmount,
        poolGenesisAddress,
      );

      outputAmountMap.map(
        success: (success) {
          outputAmount = success;

          if (outputAmount <= 0) {
            throw const aedappfm.Failure.other(
              cause: 'Error outputAmount',
            );
          }
        },
        failure: (failure) {
          swapNotifier
            ..setFailure(failure)
            ..setCurrentStep(4)
            ..setProcessInProgress(false);
          throw failure;
        },
      );
    } catch (e) {
      throw aedappfm.Failure.fromError(e);
    }

    try {
      final transactionSwapMap = await archethicContract.getSwapTx(
        tokenToSwap,
        tokenToSwapAmount,
        poolGenesisAddress,
        slippage,
        outputAmount,
      );

      transactionSwapMap.map(
        success: (success) {
          transactionSwap = success;
          swapNotifier.setRecoveryTransactionSwap(
            transactionSwap,
          );
        },
        failure: (failure) {
          swapNotifier
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
        transactionSwap!,
        selectedAccount.lastAddress!,
        selectedAccount.name,
      );

      swapNotifier.setRecoveryTransactionSwap(transationSignedRaw);

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );

      if (confirmation == null) return;

      swapNotifier
        ..setResumeProcess(false)
        ..setSwapOk(true);

      notificationService.start(
        operationId,
        DexNotification.swap(
          txAddress: transationSignedRaw.address!.address,
          tokenSwapped: tokenSwapped,
        ),
      );

      final amount = await aedappfm.PeriodicFuture.periodic<double>(
        () => getAmountFromTxInput(
          transationSignedRaw.address!.address!,
          tokenSwapped.address,
          apiService,
        ),
        sleepDuration: const Duration(seconds: 3),
        until: (amount) => amount > 0,
        timeout: const Duration(minutes: 1),
      );

      swapNotifier.setFinalAmount(amount);

      notificationService.succeed(
        operationId,
        DexNotification.swap(
          txAddress: transationSignedRaw.address!.address,
          tokenSwapped: tokenSwapped,
          amountSwapped: amount,
        ),
      );
      onDone();
    } on archethic.TransactionError catch (error) {
      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(error.messageLabel),
      );
      swapNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setSwapOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
      onDone();
    } catch (e) {
      swapNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setSwapOk(false);

      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(e),
      );

      if (e is aedappfm.Failure) {
        swapNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      swapNotifier.setFailure(
        aedappfm.Failure.other(
          cause: e.toString().replaceAll('Exception: ', '').capitalize(),
        ),
      );

      throw aedappfm.Failure.fromError(e);
    }
  }

  String getAEStepLabel(
    AppLocalizations localizations,
    int step,
  ) {
    switch (step) {
      case 1:
        return localizations.swapProcessStep1;
      case 2:
        return localizations.swapProcessStep2;
      case 3:
        return localizations.swapProcessStep3;
      case 4:
        return localizations.swapProcessStep4;
      default:
        return localizations.swapProcessStep0;
    }
  }

  Future<double> estimateFees(
    String poolGenesisAddress,
    DexToken tokenToSwap,
    double tokenToSwapAmount,
    double slippage,
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionSwap;
    var outputAmount = 0.0;

    try {
      final outputAmountMap = await archethicContract.getOutputAmount(
        tokenToSwap,
        tokenToSwapAmount,
        poolGenesisAddress,
      );

      outputAmountMap.map(
        success: (success) {
          outputAmount = success;

          if (outputAmount <= 0) {
            return 0.0;
          }
        },
        failure: (failure) {
          return 0.0;
        },
      );
    } catch (e) {
      return 0.0;
    }

    try {
      final transactionSwapMap = await archethicContract.getSwapTx(
        tokenToSwap,
        tokenToSwapAmount,
        poolGenesisAddress,
        slippage,
        outputAmount,
      );

      return transactionSwapMap.map(
        success: (success) async {
          transactionSwap = success;
          // Add fake signature and address to allow estimation by node
          transactionSwap = transactionSwap!.copyWith(
            address: const archethic.Address(
              address:
                  '00000000000000000000000000000000000000000000000000000000000000000000',
            ),
            previousPublicKey:
                '00000000000000000000000000000000000000000000000000000000000000000000',
          );

          if (transactionSwap != null) {
            final fees = await calculateFees(
              transactionSwap!,
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
}
