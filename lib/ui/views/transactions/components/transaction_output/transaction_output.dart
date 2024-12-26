/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_fees.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_template.dart';
import 'package:aewallet/ui/views/transactions/components/template/transfer_balance.dart';
import 'package:aewallet/ui/views/transactions/components/transaction_output/transaction_output_information.dart';
import 'package:aewallet/ui/views/transactions/components/transfer_transaction.dart';
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
    final primaryCurrency =
        ref.watch(PrimaryCurrencyProviders.selectedPrimaryCurrency);

    return TransactionTemplate(
      transaction: transaction,
      borderColor: ArchethicTheme.backgroundRecentTxListCardTransferOutput,
      backgroundColor: ArchethicTheme.backgroundRecentTxListCardTransferOutput,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TransfertBalance(
            isCurrencyNative: primaryCurrency.primaryCurrency ==
                AvailablePrimaryCurrencyEnum.native,
            transaction: transaction,
            child: TransferTransaction(
              isCurrencyNative: primaryCurrency.primaryCurrency ==
                  AvailablePrimaryCurrencyEnum.native,
              transaction: transaction,
              isInput: false,
            ),
          ),
        ],
      ),
      information: TransactionOutputInformation(
        transaction: transaction,
      ),
      fees: TransactionFees(
        transaction: transaction,
      ),
    );
  }
}
