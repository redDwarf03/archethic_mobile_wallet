import 'package:aewallet/model/blockchain/recent_transaction.dart';

abstract class RecentTransactionsRepository {
  Future<List<RecentTransaction>> getAccountRecentTransactions(
    String genesisAddress,
  );
}
