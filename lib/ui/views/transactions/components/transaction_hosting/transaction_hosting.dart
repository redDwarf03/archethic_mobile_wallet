import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_fees.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_template.dart';
import 'package:aewallet/ui/views/transactions/components/transaction_hosting/transaction_hosting_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionHosting extends ConsumerWidget {
  const TransactionHosting({
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
      content: const SizedBox.shrink(),
      information: TransactionHostingInformation(
        transaction: transaction,
      ),
      fees: TransactionFees(
        transaction: transaction,
      ),
    );
  }
}
