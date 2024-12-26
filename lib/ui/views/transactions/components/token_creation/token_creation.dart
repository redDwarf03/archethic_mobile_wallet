import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_fees.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_template.dart';
import 'package:aewallet/ui/views/transactions/components/token_creation/token_creation_balance.dart';
import 'package:aewallet/ui/views/transactions/components/token_creation/token_creation_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenCreation extends ConsumerWidget {
  const TokenCreation({
    required this.transaction,
    super.key,
  });

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionTemplate(
      transaction: transaction,
      borderColor: ArchethicTheme.backgroundRecentTxListCardTokenCreation,
      backgroundColor: ArchethicTheme.backgroundRecentTxListCardTokenCreation,
      content: TokenCreationBalance(
        transaction: transaction,
      ),
      information: TokenCreationInformation(
        transaction: transaction,
      ),
      fees: TransactionFees(
        transaction: transaction,
      ),
    );
  }
}
