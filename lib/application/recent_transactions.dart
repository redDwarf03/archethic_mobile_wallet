import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/tokens/tokens.dart';
import 'package:aewallet/domain/repositories/transaction/recent_transactions.repository.dart';
import 'package:aewallet/infrastructure/repositories/transaction/recent_transactions.repository.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recent_transactions.g.dart';

@riverpod
RecentTransactionsRepository recentTransactionsRepository(
  Ref ref,
) {
  final apiService = ref.watch(apiServiceProvider);
  final tokensRepository = ref.watch(tokensRepositoryProvider);
  final session = ref.read(sessionNotifierProvider).loggedIn!;
  final accountSelected = ref.watch(
    accountsNotifierProvider.select(
      (accounts) => accounts.valueOrNull?.selectedAccount,
    ),
  );

  return RecentTransactionsRepositoryImpl(
    apiService: apiService,
    tokensRepository: tokensRepository,
    keyPair: session
        .wallet.keychainSecuredInfos.services[accountSelected!.name]!.keyPair!,
  );
}

@riverpod
Future<List<RecentTransaction>> recentTransactions(
  Ref ref,
  String genesisAddress,
) async {
  final recentTransactions = await ref
      .watch(recentTransactionsRepositoryProvider)
      .getAccountRecentTransactions(genesisAddress);

  return recentTransactions;
}
