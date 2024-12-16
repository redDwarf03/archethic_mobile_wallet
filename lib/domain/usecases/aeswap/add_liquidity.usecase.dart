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
import 'package:aewallet/ui/views/aeswap_liquidity_add/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:uuid/uuid.dart';

class AddLiquidityCase with aedappfm.TransactionMixin {
  AddLiquidityCase({
    required this.apiService,
    required this.notificationService,
    required this.verifiedTokensRepository,
    required this.transactionRepository,
    required this.keychainSecuredInfos,
    required this.selectedAccount,
  });

  final archethic.ApiService apiService;
  final aedappfm.VerifiedTokensRepositoryInterface verifiedTokensRepository;

  final ns.TaskNotificationService<DexNotification, aedappfm.Failure>
      notificationService;
  final TransactionRemoteRepositoryInterface transactionRepository;
  final KeychainSecuredInfos keychainSecuredInfos;
  final Account selectedAccount;

  Future<void> run(
    AppLocalizations localizations,
    LiquidityAddFormNotifier liquidityAddNotifier,
    String poolGenesisAddress,
    DexToken token1,
    double token1Amount,
    DexToken token2,
    double token2Amount,
    double slippage,
    DexToken lpToken,
  ) async {
    final operationId = const Uuid().v4();
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );

    archethic.Transaction? transactionAddLiquidity;
    liquidityAddNotifier.setFinalAmount(null);

    try {
      final transactionAddLiquiditylMap =
          await archethicContract.getAddLiquidityTx(
        token1,
        token1Amount,
        token2,
        token2Amount,
        poolGenesisAddress,
        slippage,
      );

      transactionAddLiquiditylMap.map(
        success: (success) {
          transactionAddLiquidity = success;
        },
        failure: (failure) {
          liquidityAddNotifier
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
        transactionAddLiquidity!,
        selectedAccount.lastAddress!,
        selectedAccount.name,
      );

      liquidityAddNotifier.setTransactionAddLiquidity(transationSignedRaw);

      final confirmation = await transactionRepository.sendSignedRaw(
        transaction: transationSignedRaw,
      );

      if (confirmation == null) return;
      liquidityAddNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setLiquidityAddOk(true);

      notificationService.start(
        operationId,
        DexNotification.addLiquidity(
          txAddress: transationSignedRaw.address!.address,
        ),
      );

      final amount = await aedappfm.PeriodicFuture.periodic<double>(
        () => getAmountFromTxInput(
          transationSignedRaw.address!.address!,
          lpToken.address,
          apiService,
        ),
        sleepDuration: const Duration(seconds: 3),
        until: (amount) => amount > 0,
        timeout: const Duration(minutes: 1),
      );

      liquidityAddNotifier.setFinalAmount(amount);

      notificationService.succeed(
        operationId,
        DexNotification.addLiquidity(
          txAddress: transationSignedRaw.address!.address,
          lpToken: lpToken,
          amount: amount,
        ),
      );
    } on archethic.TransactionError catch (error) {
      notificationService.failed(
        operationId,
        aedappfm.Failure.fromError(error.messageLabel),
      );
      liquidityAddNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setLiquidityAddOk(false)
        ..setFailure(
          aedappfm.Failure.other(
            cause: error.messageLabel.capitalize(),
          ),
        );
    } catch (e) {
      liquidityAddNotifier
        ..setResumeProcess(false)
        ..setProcessInProgress(false)
        ..setLiquidityAddOk(false);

      if (e is aedappfm.Failure) {
        liquidityAddNotifier.setFailure(e);
        throw aedappfm.Failure.fromError(e);
      }
      liquidityAddNotifier.setFailure(
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
    DexToken token1,
    double token1Amount,
    DexToken token2,
    double token2Amount,
    double slippage,
  ) async {
    final archethicContract = ArchethicContract(
      apiService: apiService,
      verifiedTokensRepository: verifiedTokensRepository,
    );
    archethic.Transaction? transactionAddLiquidity;

    try {
      final transactionAddLiquiditylMap =
          await archethicContract.getAddLiquidityTx(
        token1,
        token1Amount,
        token2,
        token2Amount,
        poolGenesisAddress,
        slippage,
      );

      transactionAddLiquiditylMap.map(
        success: (success) {
          transactionAddLiquidity = success;
          // Add fake signature and address to allow estimation by node
          transactionAddLiquidity = transactionAddLiquidity!.copyWith(
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

    if (transactionAddLiquidity != null) {
      final fees = await calculateFees(
        transactionAddLiquidity!,
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
        return AppLocalizations.of(context)!.addLiquidityProcessStep1;
      case 2:
        return AppLocalizations.of(context)!.addLiquidityProcessStep2;
      case 3:
        return AppLocalizations.of(context)!.addLiquidityProcessStep3;
      default:
        return AppLocalizations.of(context)!.addLiquidityProcessStep0;
    }
  }
}
