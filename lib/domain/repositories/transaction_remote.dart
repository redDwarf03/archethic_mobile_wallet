/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/domain/models/core/failures.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/models/transaction.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;

typedef TransactionConfirmationHandler = Future<void> Function(
  archethic.TransactionConfirmation confirmation,
);
typedef TransactionErrorHandler = Future<void> Function(
  archethic.TransactionError error,
);

abstract class TransactionRemoteRepositoryInterface {
  const TransactionRemoteRepositoryInterface();

  Future<Result<double, Failure>> calculateFees(Transaction transaction);

  Future<archethic.TransactionConfirmation?> send({
    required Transaction transaction,
    Duration timeout = const Duration(seconds: 10),
    TransactionConfirmationHandler? onConfirmation,
  });

  Future<archethic.TransactionConfirmation?> sendSignedRaw({
    required archethic.Transaction transaction,
    Duration timeout = const Duration(seconds: 10),
    TransactionConfirmationHandler? onConfirmation,
  });

  Future<archethic.Transaction> buildTransactionRaw(
    KeychainSecuredInfos keychainSecuredInfos,
    archethic.Transaction transactionRaw,
    String transactionLastAddress,
    String serviceName,
  );

  Future<String?> getLastTransactionAddress({
    required String genesisAddress,
  });

  Future<Result<List<RecentTransaction>, Failure>> getRecentTransactions({
    required Account account,
    required KeychainSecuredInfos keychainSecuredInfos,
  });
}
