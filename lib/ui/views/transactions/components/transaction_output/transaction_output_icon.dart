/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionOutputIcon extends ConsumerWidget {
  const TransactionOutputIcon(this.recentTransaction, {super.key});

  final RecentTransaction? recentTransaction;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const burnAddress =
        '00000000000000000000000000000000000000000000000000000000000000000000';
    String? recipient;
    if (recentTransaction != null &&
        recentTransaction!.ledgerOperationMvtInfo != null &&
        recentTransaction!.ledgerOperationMvtInfo!.isNotEmpty &&
        recentTransaction!.ledgerOperationMvtInfo!.first.to != null) {
      recipient = recentTransaction!.ledgerOperationMvtInfo!.first.to;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Icon(
        recipient == null
            ? Symbols.call_made
            : recipient == burnAddress
                ? Symbols.mode_heat
                : Symbols.call_made,
        size: 12,
        color: Colors.red,
      ),
    );
  }
}
