import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

extension TransactionSendEventErrorLocalization on TransactionError {
  TransactionSendEvent localizedEvent(
    AppLocalizations localizations,
    TransactionSendEventType transactionType,
  ) =>
      TransactionSendEvent(
        transactionType: transactionType,
        maxConfirmations: maybeMap(
          invalidConfirmation: (_) => 0,
          orElse: () => null,
        ),
        response: maybeMap(
          connectivity: (_) => localizations.noConnection,
          consensusNotReached: (_) => localizations.consensusNotReached,
          timeout: (_) => localizations.transactionTimeOut,
          invalidConfirmation: (_) => 'ko',
          rpcError: (error) => localizations.rpcError
              .replaceFirst('%1', error.code.toString())
              .replaceFirst(
                '%2',
                '${error.message} ${error.data ?? ''}',
              ),
          other: (_) => localizations.genericError,
          orElse: () => '',
        ),
      );
}
