import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_ledger_mvts.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_template.dart';
import 'package:aewallet/ui/views/transactions/components/transaction_input/transaction_input_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionInput extends ConsumerWidget {
  const TransactionInput({
    required this.transaction,
    super.key,
  });

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionTemplate(
      transaction: transaction,
      borderColor: ArchethicTheme.backgroundRecentTxListCardTransferInput,
      backgroundColor: ArchethicTheme.backgroundRecentTxListCardTransferInput,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TransactionLedgerMvts(transaction: transaction),
        ],
      ),
      information: TransactionInputInformation(
        transaction: transaction,
      ),
    );
  }
}
