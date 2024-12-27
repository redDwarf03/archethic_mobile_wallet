/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/transaction_repository.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/domain/models/token.dart';
import 'package:aewallet/domain/models/transaction.dart';
import 'package:aewallet/domain/usecases/transaction/calculate_fees.dart';
import 'package:aewallet/ui/util/delayed_task.dart';
import 'package:aewallet/ui/util/transaction_send_event_error_localization.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/state.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

const addTokenBCValidationRatio = 0.5;

final _initialAddTokenFormProvider = Provider<AddTokenFormState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _addTokenFormProvider =
    NotifierProvider.autoDispose<AddTokenFormNotifier, AddTokenFormState>(
  () {
    return AddTokenFormNotifier();
  },
  dependencies: [
    AddTokenFormProvider.initialAddTokenForm,
    accountsNotifierProvider,
    sessionNotifierProvider,
  ],
);

class AddTokenFormNotifier extends AutoDisposeNotifier<AddTokenFormState> {
  AddTokenFormNotifier();

  CancelableTask<double?>? _calculateFeesTask;

  Future<void> _updateFees(
    BuildContext context, {
    Duration delay = const Duration(milliseconds: 800),
  }) async {
    state = state.copyWith(
      feeEstimation: const AsyncValue.loading(),
    );

    late final double fees;

    try {
      fees = await Future<double>(
        () async {
          if (state.initialSupply <= 0 ||
              state.name.isEmpty ||
              state.symbol.isEmpty) {
            return 0;
          }

          _calculateFeesTask?.cancel();
          _calculateFeesTask = CancelableTask<double?>(
            task: () => _calculateFees(
              context: context,
              formState: state,
            ),
          );
          final fees = await _calculateFeesTask?.schedule(delay);

          return fees ?? 0;
        },
      );
    } on CanceledTask {
      return;
    }

    state = state.copyWith(
      feeEstimation: AsyncValue.data(fees),
      errorAmountText: '',
    );
    if (state.feeEstimationOrZero > state.accountBalance.nativeTokenValue) {
      state = state.copyWith(
        errorAmountText:
            AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                  '%1',
                  state.symbolFees(context),
                ),
      );
    }
  }

  @override
  AddTokenFormState build() => ref.watch(
        AddTokenFormProvider.initialAddTokenForm,
      );

  Future<double?> _calculateFees({
    required BuildContext context,
    required AddTokenFormState formState,
  }) async {
    final selectedAccount = await ref
        .read(
          accountsNotifierProvider.future,
        )
        .selectedAccount;

    late Transaction transaction;

    final keychainSecuredInfos =
        ref.read(sessionNotifierProvider).loggedIn!.wallet.keychainSecuredInfos;

    transaction = Transaction.token(
      token: Token(
        accountSelectedName: selectedAccount!.name,
        name: formState.name,
        symbol: formState.symbol,
        initialSupply: formState.initialSupply,
        keychainSecuredInfos: keychainSecuredInfos,
        genesisAddress: selectedAccount.genesisAddress,
        type: 'fungible',
        aeip: [2, 9],
        properties: [],
      ),
    );

    final calculateFeesResult = await CalculateFeesUsecase(
      repository: ref.read(archethicTransactionRepositoryProvider),
    ).run(transaction);

    return calculateFeesResult.valueOrNull;
  }

  Future<void> setName({
    required BuildContext context,
    required String name,
  }) async {
    _initError();
    if (name.isEmpty) {
      state = state.copyWith(
        errorNameText: AppLocalizations.of(context)!.tokenNameMissing,
      );
      return;
    }

    if (kTokenFordiddenName.contains(name.toUpperCase())) {
      state = state.copyWith(
        errorNameText: AppLocalizations.of(context)!.tokenNameUCO,
      );
      return;
    }

    state = state.copyWith(
      name: name,
    );
    await _updateFees(
      context,
    );
    return;
  }

  void _initError() {
    setErrors(
      errorAmountText: '',
      errorInitialSupplyText: '',
      errorNameText: '',
      errorSymbolText: '',
    );
  }

  void setErrors({
    String? errorAmountText,
    String? errorInitialSupplyText,
    String? errorNameText,
    String? errorSymbolText,
  }) {
    state = state.copyWith(
      errorAmountText: errorAmountText ?? '',
      errorInitialSupplyText: errorInitialSupplyText ?? '',
      errorNameText: errorNameText ?? '',
      errorSymbolText: errorSymbolText ?? '',
    );
  }

  Future<void> setSymbol({
    required BuildContext context,
    required String symbol,
  }) async {
    _initError();

    if (symbol.isEmpty) {
      state = state.copyWith(
        errorSymbolText: AppLocalizations.of(context)!.tokenSymbolMissing,
      );
      return;
    }

    if (kTokenFordiddenName.contains(symbol.toUpperCase())) {
      state = state.copyWith(
        errorSymbolText: AppLocalizations.of(context)!.tokenSymbolUCO,
      );
      return;
    }

    state = state.copyWith(
      symbol: symbol,
    );
    unawaited(
      _updateFees(
        context,
      ),
    );
    return;
  }

  Future<void> setInitialSupply({
    required BuildContext context,
    required double initialSupply,
  }) async {
    _initError();

    if (initialSupply <= 0) {
      state = state.copyWith(
        errorInitialSupplyText:
            AppLocalizations.of(context)!.tokenInitialSupplyPositive,
      );
      return;
    }

    // TODO(reddwarf03): Pb avec la gestion des bigint à régler (1)
    if (initialSupply > 9999999999) {
      state = state.copyWith(
        errorInitialSupplyText:
            AppLocalizations.of(context)!.tokenInitialSupplyTooHigh,
      );
      return;
    }

    state = state.copyWith(
      initialSupply: initialSupply,
    );
    unawaited(
      _updateFees(
        context,
      ),
    );
    return;
  }

  void setAddTokenProcessStep(AddTokenProcessStep addTokenProcessStep) {
    state = state.copyWith(
      addTokenProcessStep: addTokenProcessStep,
    );
  }

  Future<void> send(BuildContext context) async {
    final transactionRepository =
        ref.read(archethicTransactionRepositoryProvider);

    final localizations = AppLocalizations.of(context)!;

    final selectedAccount = await ref
        .read(
          accountsNotifierProvider.future,
        )
        .selectedAccount;

    late Transaction transaction;

    final keychainSecuredInfos =
        ref.read(sessionNotifierProvider).loggedIn!.wallet.keychainSecuredInfos;

    transaction = Transaction.token(
      token: Token(
        name: state.name,
        symbol: state.symbol,
        initialSupply: state.initialSupply,
        accountSelectedName: selectedAccount!.name,
        keychainSecuredInfos: keychainSecuredInfos,
        genesisAddress: selectedAccount.genesisAddress,
        type: 'fungible',
        aeip: [2, 9],
        properties: [],
      ),
    );

    try {
      final confirmation = await transactionRepository.send(
        transaction: transaction,
      );

      if (confirmation == null) return;
      EventTaxiImpl.singleton().fire(
        TransactionSendEvent(
          transactionType: TransactionSendEventType.token,
          response: 'ok',
          nbConfirmations: confirmation.nbConfirmations,
          transactionAddress: confirmation.transactionAddress,
          maxConfirmations: confirmation.maxConfirmations,
        ),
      );
    } on archethic.TransactionError catch (error) {
      error.maybeMap(
        insufficientFunds: (error) {
          EventTaxiImpl.singleton().fire(
            TransactionSendEvent(
              transactionType: TransactionSendEventType.token,
              response: localizations.insufficientBalance.replaceAll(
                '%1',
                state.symbolFees(context),
              ),
              nbConfirmations: 0,
            ),
          );
        },
        orElse: () {
          EventTaxiImpl.singleton().fire(
            error.localizedEvent(
              localizations,
              TransactionSendEventType.token,
            ),
          );
        },
      );
    }
  }
}

abstract class AddTokenFormProvider {
  static final initialAddTokenForm = _initialAddTokenFormProvider;
  static final addTokenForm = _addTokenFormProvider;
}
