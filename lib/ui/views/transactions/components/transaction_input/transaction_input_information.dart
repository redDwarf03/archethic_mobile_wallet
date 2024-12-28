/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionInputInformation extends ConsumerWidget {
  const TransactionInputInformation({super.key, required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return TransactionInformation(
      isEmpty: transaction.from == null,
      prefixMessage: localizations.txListFrom,
      message:
          AddressFormatters(transaction.from == null ? '' : transaction.from!)
              .getShortString4(),
    );
  }
}
