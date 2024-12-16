/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/transaction_repository.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/domain/models/transaction.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/ui/util/transaction_send_event_error_localization.dart';
import 'package:aewallet/ui/views/add_account/bloc/state.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final _initialAddAccountFormProvider = Provider<AddAccountFormState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _addAccountFormProvider =
    NotifierProvider.autoDispose<AddAccountFormNotifier, AddAccountFormState>(
  () {
    return AddAccountFormNotifier();
  },
  dependencies: [
    AddAccountFormProvider.initialAddAccountForm,
    AccountProviders.accounts,
    AccountProviders.sortedAccounts,
    sessionNotifierProvider,
  ],
);

class AddAccountFormNotifier extends AutoDisposeNotifier<AddAccountFormState> {
  AddAccountFormNotifier();

  @override
  AddAccountFormState build() => ref.watch(
        AddAccountFormProvider.initialAddAccountForm,
      );

  Future<void> setName(
    String name,
  ) async {
    state = state.copyWith(
      name: name,
    );
    return;
  }

  void setError(
    String errorText,
  ) {
    state = state.copyWith(
      errorText: errorText,
    );
  }

  void setAddAccountProcessStep(AddAccountProcessStep addAccountProcessStep) {
    state = state.copyWith(
      addAccountProcessStep: addAccountProcessStep,
    );
  }

  bool controlName(
    BuildContext context,
  ) {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(
        errorText:
            AppLocalizations.of(context)!.introNewWalletGetFirstInfosNameBlank,
      );
      return false;
    }

    final accounts =
        ref.read(AccountProviders.sortedAccounts).valueOrNull ?? [];
    if (accounts
        .where(
          (Account element) =>
              element.nameDisplayed == state.name &&
              element.serviceType == 'archethicWallet',
        )
        .isNotEmpty) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!.addAccountExists,
      );
      return false;
    }

    return true;
  }

  Future<void> send(BuildContext context) async {
    final transactionRepository =
        ref.read(archethicTransactionRepositoryProvider);

    final localizations = AppLocalizations.of(context)!;

    late Transaction transaction;

    transaction = Transaction.keychain(
      name: 'archethic-wallet-${Uri.encodeFull(state.name)}',
      seed: state.seed,
    );

    try {
      final confirmation = await transactionRepository.send(
        transaction: transaction,
      );
      if (confirmation != null) {
        EventTaxiImpl.singleton().fire(
          TransactionSendEvent(
            transactionType: TransactionSendEventType.keychain,
            response: 'ok',
            nbConfirmations: confirmation.nbConfirmations,
            transactionAddress: confirmation.transactionAddress,
            maxConfirmations: confirmation.maxConfirmations,
          ),
        );
      }
    } on archethic.TransactionError catch (error) {
      EventTaxiImpl.singleton().fire(
        error.localizedEvent(
          localizations,
          TransactionSendEventType.keychain,
        ),
      );
    }
  }

  Future<void> removeAccount(BuildContext context, String account) async {
    final transactionRepository =
        ref.read(archethicTransactionRepositoryProvider);

    final localizations = AppLocalizations.of(context)!;

    late Transaction transaction;

    transaction = Transaction.keychain(
      name: 'archethic-wallet-${Uri.encodeFull(state.name)}',
      seed: state.seed,
    );

    try {
      final confirmation = await transactionRepository.send(
        transaction: transaction,
      );
      if (confirmation != null) {
        EventTaxiImpl.singleton().fire(
          TransactionSendEvent(
            transactionType: TransactionSendEventType.keychain,
            response: 'ok',
            nbConfirmations: confirmation.nbConfirmations,
            transactionAddress: confirmation.transactionAddress,
            maxConfirmations: confirmation.maxConfirmations,
          ),
        );
      }
    } on archethic.TransactionError catch (error) {
      EventTaxiImpl.singleton().fire(
        error.localizedEvent(
          localizations,
          TransactionSendEventType.keychain,
        ),
      );
    }
  }
}

abstract class AddAccountFormProvider {
  static final initialAddAccountForm = _initialAddAccountFormProvider;
  static final addAccountForm = _addAccountFormProvider;
}
