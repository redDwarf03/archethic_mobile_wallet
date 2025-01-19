import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_fees.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_ledger_mvts.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionOuput extends ConsumerWidget {
  const TransactionOuput({
    required this.transaction,
    super.key,
  });

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionTemplate(
      transaction: transaction,
      borderColor: ArchethicTheme.backgroundRecentTxListCardTransferOutput,
      backgroundColor: ArchethicTheme.backgroundRecentTxListCardTransferOutput,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TransactionLedgerMvts(transaction: transaction),
        ],
      ),
      information: const SizedBox.shrink(),
      fees: TransactionFees(
        transaction: transaction,
      ),
    );
  }
}
