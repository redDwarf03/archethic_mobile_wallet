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
import 'package:aewallet/ui/views/aeswap_liquidity_remove/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

const logName = 'RemoveLiquidityCase';

class RemoveLiquidityCase with aedappfm.TransactionMixin {
  RemoveLiquidityCase({
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
    LiquidityRemoveFormNotifier liquidityRemoveNotifier,
    String poolGenesisAddress,
    String lpTokenAddress,
    double lpTokenAmount,
    DexToken token1,
    DexToken token2,
    DexToken lpToken,
  ) async {
    final operationId = const Uuid().v4();
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );

    archethic.Transaction? transactionRemoveLiquidity;
    liquidityRemoveNotifier
      ..setFinalAmountToken1(null)
      ..setFinalAmountToken2(null)
      ..setFinalAmountLPToken(null);

    try {
      final transactionRemoveLiquiditylMap =
          await archethicContract.getRemoveLiquidityTx(
        lpTokenAddress,
        lpTokenAmount,
        poolGenesisAddress,
      );

      transactionRemoveLiquiditylMap.map(
        success: (success) {
          transactionRemoveLiquidity = success;
        },
        failure: (failure) {
          liquidityRemoveNotifier
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
        transactionRemoveLiquidity!,
        selectedAccount.genesisAddress,
        selectedAccount.name,
      );

      liquidityRemoveNotifier
          .setTransactionRemoveLiquidity(transationSignedRaw);

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );

      if (confirmation == null) return;

      liquidityRemoveNotifier
        ..setResumeProcess(false)
        ..setLiquidityRemoveOk(true);

      notificationService.start(
        operationId,
        DexNotification.removeLiquidity(
          txAddress: transationSignedRaw.address!.address,
        ),
      );

      final amounts = await aedappfm.PeriodicFuture.periodic<List<double>>(
        () => Future.wait([
          getAmountFromTxInput(
            transationSignedRaw.address!.address!,
            token1.address,
            apiService,
          ),
          getAmountFromTxInput(
            transationSignedRaw.address!.address!,
            token2.address,
            apiService,
          ),
          getAmountFromTx(
            apiService,
            transationSignedRaw.address!.address!,
            false,
            '00000000000000000000000000000000000000000000000000000000000000000000',
          ),
        ]),
        sleepDuration: const Duration(seconds: 3),
        until: (amounts) {
          final amountToken1 = amounts[0];
          final amountToken2 = amounts[1];
          final amountLPToken = amounts[2];
          return amountToken1 > 0 && amountToken2 > 0 && amountLPToken > 0;
        },
        timeout: const Duration(minutes: 1),
      );

      final amountToken1 = amounts[0];
      final amountToken2 = amounts[1];
      final amountLPToken = amounts[2];

      liquidityRemoveNotifier
        ..setFinalAmountToken1(amountToken1)
        ..setFinalAmountToken2(amountToken2)
        ..setFinalAmountLPToken(amountLPToken);

      notificationService.succeed(
        operationId,
        DexNotification.removeLiquidity(
          txAddress: transationSignedRaw.address!.address,
          token1: token1,
          token2: token2,
          lpToken: lpToken,
          amountToken1: amountToken1,
          amountToken2: amountToken2,
          amountLPToken: amountLPToken,
        ),
      );
    } on archethic.TransactionError catch (error) {
      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(error.messageLabel),
      );
      liquidityRemoveNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setLiquidityRemoveOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
    } catch (e) {
      liquidityRemoveNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setLiquidityRemoveOk(false);

      if (e is aedappfm.Failure) {
        liquidityRemoveNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      liquidityRemoveNotifier.setFailure(
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
    String poolGenesisAddress,
    String lpTokenAddress,
    double lpTokenAmount,
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionRemoveLiquidity;

    try {
      final transactionRemoveLiquiditylMap =
          await archethicContract.getRemoveLiquidityTx(
        lpTokenAddress,
        lpTokenAmount,
        poolGenesisAddress,
      );

      transactionRemoveLiquiditylMap.map(
        success: (success) {
          transactionRemoveLiquidity = success;
          // Add fake signature and address to allow estimation by node
          transactionRemoveLiquidity = transactionRemoveLiquidity!.copyWith(
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

    if (transactionRemoveLiquidity != null) {
      final fees = await calculateFees(
        transactionRemoveLiquidity!,
        apiService,
        slippage: 1.1,
      );
      return fees;
    } else {
      return 0;
    }
  }

  String getAEStepLabel(
    BuildContext context,
    int step,
  ) {
    switch (step) {
      case 1:
        return AppLocalizations.of(context)!.removeLiquidityProcessStep1;
      case 2:
        return AppLocalizations.of(context)!.removeLiquidityProcessStep2;
      case 3:
        return AppLocalizations.of(context)!.removeLiquidityProcessStep3;
      default:
        return AppLocalizations.of(context)!.removeLiquidityProcessStep0;
    }
  }
}
