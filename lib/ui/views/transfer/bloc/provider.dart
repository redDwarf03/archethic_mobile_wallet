import 'dart:async';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/application/market_price.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/transaction_repository.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/domain/models/transaction.dart';
import 'package:aewallet/domain/models/transfer.dart';
import 'package:aewallet/domain/usecases/transaction/calculate_fees.dart';
import 'package:aewallet/infrastructure/datasources/contacts.hive.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/util/delayed_task.dart';
import 'package:aewallet/ui/util/transaction_send_event_error_localization.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final _initialTransferFormProvider = Provider<TransferFormState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _transferFormProvider =
    NotifierProvider.autoDispose<TransferFormNotifier, TransferFormState>(
  () {
    return TransferFormNotifier();
  },
  dependencies: [
    TransferFormProvider.initialTransferForm,
    AccountProviders.accounts,
    PrimaryCurrencyProviders.selectedPrimaryCurrency,
    PrimaryCurrencyProviders.convertedValue,
    sessionNotifierProvider,
  ],
);

class TransferFormNotifier extends AutoDisposeNotifier<TransferFormState> {
  TransferFormNotifier();

  CancelableTask<double?>? _calculateFeesTask;

  final _contactsHiveDatasource = ContactsHiveDatasource.instance();

  Future<void> _updateFees(
    BuildContext context, {
    Duration delay = const Duration(milliseconds: 800),
  }) async {
    state = state.copyWith(
      feeEstimation: const AsyncValue.loading(),
    );

    // TODO(reddwarf03): Factorize fees calculation (3)
    late final double fees;
    switch (state.transferType) {
      case TransferType.uco:
        var amountInUCO = state.amount;
        final primaryCurrency =
            ref.read(PrimaryCurrencyProviders.selectedPrimaryCurrency);
        if (primaryCurrency.primaryCurrency ==
            AvailablePrimaryCurrencyEnum.fiat) {
          amountInUCO = state.amountConverted;
        }

        try {
          fees = await Future<double>(
            () async {
              if (amountInUCO <= 0 || !state.recipient.isAddressValid) {
                return 0;
              }

              _calculateFeesTask?.cancel();
              _calculateFeesTask = CancelableTask<double?>(
                task: () => _calculateFees(
                  context: context,
                  formState: state.copyWith(
                    amount: amountInUCO,
                  ),
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
          errorAmountText: amountInUCO >
                  state.accountBalance.nativeTokenValue - fees
              ? AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                    '%1',
                    state.symbol(context),
                  )
              : '',
        );
        break;
      case TransferType.token:
        try {
          fees = await Future<double>(
            () async {
              if (state.amount <= 0 || !state.recipient.isAddressValid) {
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
          errorAmountText: state.amount > state.aeToken!.balance
              ? AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                    '%1',
                    state.symbol(context),
                  )
              : fees > state.accountBalance.nativeTokenValue
                  ? AppLocalizations.of(context)!
                      .insufficientBalance
                      .replaceAll(
                        '%1',
                        state.symbolFees(context),
                      )
                  : '',
        );
        break;

      case TransferType.nft:
        try {
          fees = await Future<double>(
            () async {
              if (!state.recipient.isAddressValid) {
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
          errorAmountText: fees > state.accountBalance.nativeTokenValue
              ? AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                    '%1',
                    state.symbolFees(context),
                  )
              : '',
        );
        break;
      case null:
        state = state.copyWith(
          feeEstimation: const AsyncValue.data(0),
        );
        break;
    }
  }

  @override
  TransferFormState build() => ref.watch(
        TransferFormProvider.initialTransferForm,
      );

  void setErrors({
    String? errorAddressText,
    String? errorAmountText,
    String? errorMessageText,
  }) {
    state = state.copyWith(
      errorAddressText: errorAddressText ?? '',
      errorMessageText: errorMessageText ?? '',
      errorAmountText: errorAmountText ?? '',
    );
  }

  void setTokenId({
    String? tokenId,
  }) {
    state = state.copyWith(
      tokenId: tokenId ?? '',
    );
  }

  void _setRecipient({
    required TransferRecipient recipient,
  }) {
    state = state.copyWith(
      recipient: recipient,
      errorAddressText: '',
      errorMessageText: '',
      errorAmountText: '',
    );
  }

  Future<bool> _checkAddressType(BuildContext context) async {
    final typesAllowed = <String>['token', 'transfer'];
    if (state.recipient.address == null ||
        state.recipient.isAddressValid == false) {
      return true;
    }

    final appService = ref.read(appServiceProvider);
    final transactionTypeMap = await appService
        .getTransaction([state.recipient.address!.address!], request: 'type');
    if (transactionTypeMap[state.recipient.address!.address] == null) {
      return true;
    }
    if (typesAllowed.contains(
          transactionTypeMap[state.recipient.address!.address]!.type,
        ) ==
        false) {
      state = state.copyWith(
        errorAddressText: AppLocalizations.of(context)!.invalidAddress,
      );

      return false;
    }
    return true;
  }

  Future<void> setRecipientNameOrAddress({
    required BuildContext context,
    required String text,
    required archethic.ApiService apiService,
  }) async {
    if (!text.startsWith('@')) {
      if (!archethic.Address(address: text).isValid()) {
        _setRecipient(
          recipient: TransferRecipient.unknownContact(
            name: text,
          ),
        );
        return;
      }

      final contact =
          await _contactsHiveDatasource.getContactWithAddress(text, apiService);
      if (contact != null) {
        _setRecipient(
          recipient: TransferRecipient.contact(
            contact: contact,
          ),
        );
      } else {
        _setRecipient(
          recipient: TransferRecipient.address(
            address: archethic.Address(address: text),
          ),
        );
      }

      if (await _checkAddressType(context) == false) {
        return;
      }
      unawaited(_updateFees(context));
      return;
    }

    try {
      final contact = await _contactsHiveDatasource.getContactWithName(text);
      _setRecipient(
        recipient: TransferRecipient.contact(
          contact: contact!,
        ),
      );
    } catch (e) {
      _setRecipient(
        recipient: TransferRecipient.unknownContact(
          name: text,
        ),
      );
    }
    if (await _checkAddressType(context) == false) {
      return;
    }
    unawaited(_updateFees(context));
  }

  void setRecipient({
    required BuildContext context,
    required TransferRecipient contact,
  }) {
    _setRecipient(
      recipient: contact,
    );
    unawaited(
      _updateFees(
        context,
        delay: Duration.zero,
      ),
    );
  }

  Future<void> setContactAddress({
    required BuildContext context,
    required archethic.Address address,
    required archethic.ApiService apiService,
  }) async {
    final contact = await _contactsHiveDatasource.getContactWithAddress(
      address.address!,
      apiService,
    );

    if (contact != null) {
      _setRecipient(
        recipient: TransferRecipient.contact(contact: contact),
      );
    } else {
      _setRecipient(
        recipient: TransferRecipient.address(
          address: address,
        ),
      );
    }
    unawaited(
      _updateFees(
        context,
        delay: Duration.zero,
      ),
    );
  }

  Future<double?> _calculateFees({
    required BuildContext context,
    required TransferFormState formState,
  }) async {
    final selectedAccount = await ref
        .read(
          AccountProviders.accounts.future,
        )
        .selectedAccount;
    final recipientAddress = formState.recipient.address;
    if (recipientAddress == null) return null;

    late Transaction transaction;

    final keychainSecuredInfos =
        ref.read(sessionNotifierProvider).loggedIn!.wallet.keychainSecuredInfos;

    switch (state.transferType) {
      case TransferType.token:
        transaction = Transaction.transfer(
          transfer: Transfer.token(
            accountSelectedName: selectedAccount!.name,
            amount: formState.amount,
            message: formState.message,
            recipientAddress: recipientAddress,
            keychainSecuredInfos: keychainSecuredInfos,
            transactionLastAddress: selectedAccount.lastAddress!,
            tokenAddress: formState.aeToken!.address!.toUpperCase(),
            type: 'fungible',
            aeip: [2, 9],
            tokenId: 0,
            properties: {},
          ),
        );
        break;
      case TransferType.uco:
        transaction = Transaction.transfer(
          transfer: Transfer.uco(
            accountSelectedName: selectedAccount!.name,
            amount: formState.amount,
            message: formState.message,
            recipientAddress: recipientAddress,
            keychainSecuredInfos: keychainSecuredInfos,
            transactionLastAddress: selectedAccount.lastAddress!.toUpperCase(),
          ),
        );
        break;
      case TransferType.nft:
        transaction = Transaction.transfer(
          transfer: Transfer.token(
            accountSelectedName: selectedAccount!.name,
            amount: formState.amount,
            message: formState.message,
            recipientAddress: recipientAddress,
            keychainSecuredInfos: keychainSecuredInfos,
            transactionLastAddress: selectedAccount.lastAddress!.toUpperCase(),
            tokenAddress: formState.accountToken?.tokenInformation!.address!
                .toUpperCase(),
            type: 'non-fungible',
            aeip: [2, 9],
            tokenId: 1,
            properties:
                formState.accountToken?.tokenInformation!.tokenProperties ?? {},
          ),
        );
        break;
      case null:
        break;
    }

    final calculateFeesResult = await CalculateFeesUsecase(
      repository: ref.read(archethicTransactionRepositoryProvider),
    ).run(transaction);

    return calculateFeesResult.valueOrNull;
  }

  Future<void> setMaxAmount({
    required BuildContext context,
    double? tokenPrice,
  }) async {
    if (state.transferType == TransferType.token && state.aeToken != null) {
      state = state.copyWith(
        amount: state.aeToken!.balance,
        errorAmountText: '',
      );
      unawaited(_updateFees(context));
      return;
    }

    final balance = state.accountBalance;

    final fees = await _calculateFees(
      context: context,
      formState: state.copyWith(amount: balance.nativeTokenValue),
    );

    if (fees == null) {
      return;
    }

    final primaryCurrency =
        ref.read(PrimaryCurrencyProviders.selectedPrimaryCurrency);

    switch (primaryCurrency.primaryCurrency) {
      case AvailablePrimaryCurrencyEnum.fiat:
        var amountMax = 0.0;
        if (tokenPrice != null) {
          amountMax = (balance.nativeTokenValue > fees
                  ? balance.nativeTokenValue - fees
                  : 0) *
              tokenPrice;
          state = state.copyWith(
            amount: amountMax,
            amountConverted: balance.nativeTokenValue > fees
                ? balance.nativeTokenValue - fees
                : 0,
            feeEstimation: AsyncValue.data(fees),
            errorAmountText: balance.nativeTokenValue > fees
                ? ''
                : AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                      '%1',
                      state.symbol(context),
                    ),
          );
        }
        break;
      case AvailablePrimaryCurrencyEnum.native:
        state = state.copyWith(
          amount: balance.nativeTokenValue > fees
              ? balance.nativeTokenValue - fees
              : 0,
          feeEstimation: AsyncValue.data(fees),
          errorAmountText: balance.nativeTokenValue > fees
              ? ''
              : AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                    '%1',
                    state.symbol(context),
                  ),
        );
        break;
    }
  }

  Future<void> setAmount({
    required BuildContext context,
    required double amount,
  }) async {
    if (state.transferType == TransferType.token) {
      state = state.copyWith(
        amount: amount,
        amountConverted: 0,
        errorAmountText: '',
      );
      unawaited(_updateFees(context));
      return;
    }

    state = state.copyWith(
      amount: amount,
      errorAmountText: '',
    );

    final selectedCurrencyMarketPrice = await ref.read(
      MarketPriceProviders.selectedCurrencyMarketPrice.future,
    );

    var amountConverted = 0.0;
    if (amount > 0) {
      amountConverted = ref.read(
        PrimaryCurrencyProviders.convertedValue(
          amount: amount,
          tokenPrice: selectedCurrencyMarketPrice.amount,
        ),
      );
    }

    state = state.copyWith(
      amount: amount,
      amountConverted: amountConverted,
      errorAmountText: '',
    );

    unawaited(_updateFees(context));
  }

  void setDefineMaxAmountInProgress({
    required bool defineMaxAmountInProgress,
  }) {
    state = state.copyWith(
      defineMaxAmountInProgress: defineMaxAmountInProgress,
    );
  }

  void setAEToken(BuildContext context, aedappfm.AEToken aeToken) {
    if (aeToken.isUCO) {
      state = state.copyWith(aeToken: aeToken, transferType: TransferType.uco);
    } else {
      state =
          state.copyWith(aeToken: aeToken, transferType: TransferType.token);
    }
    unawaited(
      _updateFees(
        context,
        delay: Duration.zero,
      ),
    );
  }

  void setMessage({
    required BuildContext context,
    required String message,
  }) {
    state = state.copyWith(
      message: message.trim(),
    );
    unawaited(_updateFees(context));
  }

  void setTransferProcessStep(TransferProcessStep transferProcessStep) {
    state = state.copyWith(
      transferProcessStep: transferProcessStep,
    );
  }

  bool controlMaxSend(
    BuildContext context,
  ) {
    if (state.transferType == TransferType.uco &&
        (state.recipient.address == null ||
            state.recipient.address!.address == null ||
            state.recipient.address!.address!.isEmpty)) {
      state = state.copyWith(
        errorAmountText: AppLocalizations.of(context)!.maxSendRecipientMissing,
      );
      return false;
    }
    return true;
  }

  bool controlAmount(
    BuildContext context,
    Account accountSelected,
  ) {
    if (state.amount <= 0) {
      state = state.copyWith(
        errorAmountText: AppLocalizations.of(context)!.amountZero,
      );
      return false;
    }

    final feeEstimation = state.feeEstimation.valueOrNull ?? 0;

    switch (state.transferType) {
      case TransferType.uco:
        var amountInUCO = state.amount;
        final primaryCurrency =
            ref.read(PrimaryCurrencyProviders.selectedPrimaryCurrency);
        if (primaryCurrency.primaryCurrency ==
            AvailablePrimaryCurrencyEnum.fiat) {
          amountInUCO = state.amountConverted;
        }

        if (amountInUCO + feeEstimation >
            accountSelected.balance!.nativeTokenValue) {
          state = state.copyWith(
            errorAmountText:
                AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                      '%1',
                      state.symbol(context),
                    ),
          );
          return false;
        }
        break;
      case TransferType.token:
        if (feeEstimation > accountSelected.balance!.nativeTokenValue) {
          state = state.copyWith(
            errorAmountText:
                AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                      '%1',
                      state.symbol(context),
                    ),
          );
          return false;
        }

        if (state.amount > state.aeToken!.balance) {
          state = state.copyWith(
            errorAmountText:
                AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                      '%1',
                      state.symbol(context),
                    ),
          );
          return false;
        }
        break;
      case TransferType.nft:
        if (feeEstimation > accountSelected.balance!.nativeTokenValue) {
          state = state.copyWith(
            errorAmountText:
                AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                      '%1',
                      state.symbolFees(context),
                    ),
          );
          return false;
        }

        if (state.amount > state.accountToken!.amount!) {
          state = state.copyWith(
            errorAmountText:
                AppLocalizations.of(context)!.insufficientBalance.replaceAll(
                      '%1',
                      'NFT',
                    ),
          );
          return false;
        }
        break;
      case null:
        break;
    }

    state = state.copyWith(
      errorAmountText: '',
    );
    return true;
  }

  bool controlAddress(
    BuildContext context,
    Account accountSelected,
  ) {
    final error = state.recipient.when(
      address: (address) {
        if (address.address == null || address.address!.isEmpty) {
          return AppLocalizations.of(context)!.addressMissing;
        }
        if (!address.isValid()) {
          return AppLocalizations.of(context)!.invalidAddress;
        }
        if (accountSelected.lastAddress == address.address) {
          return AppLocalizations.of(context)!.sendToMeError.replaceAll(
                '%1',
                state.symbol(context),
              );
        }
      },
      contact: (contact) {
        if (contact.address.isEmpty) {
          return AppLocalizations.of(context)!.addressMissing;
        }

        if (!archethic.Address(address: contact.address).isValid()) {
          return AppLocalizations.of(context)!.invalidAddress;
        }

        if (accountSelected.lastAddress == contact.address) {
          return AppLocalizations.of(context)!.sendToMeError.replaceAll(
                '%1',
                state.symbol(context),
              );
        }
      },
      unknownContact: (_) {
        return AppLocalizations.of(context)!.contactInvalid;
      },
    );

    if (error == null) return true;

    state = state.copyWith(
      errorAddressText: error,
    );
    return false;
  }

  Future<void> send(BuildContext context) async {
    final transferRepository = ref.read(archethicTransactionRepositoryProvider);

    final localizations = AppLocalizations.of(context)!;

    final selectedAccount = await ref
        .read(
          AccountProviders.accounts.future,
        )
        .selectedAccount;

    var amountInUCO = state.amount;
    final primaryCurrency =
        ref.read(PrimaryCurrencyProviders.selectedPrimaryCurrency);
    if (primaryCurrency.primaryCurrency == AvailablePrimaryCurrencyEnum.fiat &&
        state.transferType == TransferType.uco) {
      amountInUCO = state.amountConverted;
    }

    late Transaction transaction;

    final keychainSecuredInfos =
        ref.read(sessionNotifierProvider).loggedIn!.wallet.keychainSecuredInfos;

    switch (state.transferType) {
      case TransferType.token:
        transaction = Transaction.transfer(
          transfer: Transfer.token(
            accountSelectedName: selectedAccount!.name,
            amount: amountInUCO,
            message: state.message,
            recipientAddress: state.recipient.address!,
            keychainSecuredInfos: keychainSecuredInfos,
            transactionLastAddress: selectedAccount.lastAddress!.toUpperCase(),
            tokenAddress: state.aeToken!.address!.toUpperCase(),
            type: 'fungible',
            tokenId: 0,
            aeip: [2, 9],
            properties: {},
          ),
        );
        break;
      case TransferType.uco:
        transaction = Transaction.transfer(
          transfer: Transfer.uco(
            accountSelectedName: selectedAccount!.name,
            amount: amountInUCO,
            message: state.message,
            recipientAddress: state.recipient.address!,
            keychainSecuredInfos: keychainSecuredInfos,
            transactionLastAddress: selectedAccount.lastAddress!.toUpperCase(),
          ),
        );
        break;
      case TransferType.nft:
        transaction = Transaction.transfer(
          transfer: Transfer.token(
            accountSelectedName: selectedAccount!.name,
            amount: amountInUCO,
            message: state.message,
            recipientAddress: state.recipient.address!,
            keychainSecuredInfos: keychainSecuredInfos,
            transactionLastAddress: selectedAccount.lastAddress!.toUpperCase(),
            tokenAddress:
                state.accountToken?.tokenInformation!.address!.toUpperCase(),
            type: 'non-fungible',
            tokenId: int.tryParse(state.tokenId) ?? 1,
            aeip: [2, 9],
            properties:
                state.accountToken?.tokenInformation!.tokenProperties ?? {},
          ),
        );
        break;
      case null:
        break;
    }
    try {
      final confirmation = await transferRepository.send(
        transaction: transaction,
      );
      if (confirmation == null) return;
      EventTaxiImpl.singleton().fire(
        TransactionSendEvent(
          transactionType: TransactionSendEventType.transfer,
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
              transactionType: TransactionSendEventType.transfer,
              response: localizations.insufficientBalance.replaceAll(
                '%1',
                state.symbol(context),
              ),
              nbConfirmations: 0,
            ),
          );
        },
        orElse: () {
          EventTaxiImpl.singleton().fire(
            error.localizedEvent(
              localizations,
              TransactionSendEventType.transfer,
            ),
          );
        },
      );
    }
  }
}

abstract class TransferFormProvider {
  static final initialTransferForm = _initialTransferFormProvider;
  static final transferForm = _transferFormProvider;
}
