/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_action.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_comment.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_date.dart';
import 'package:aewallet/ui/views/transactions/components/transaction_input/transaction_input_icon.dart';
import 'package:aewallet/ui/views/transactions/components/transaction_output/transaction_output_icon.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionTemplate extends ConsumerWidget {
  const TransactionTemplate({
    super.key,
    required this.transaction,
    required this.borderColor,
    required this.backgroundColor,
    required this.content,
    required this.information,
    this.fees,
  });

  final RecentTransaction transaction;
  final Color borderColor;
  final Color backgroundColor;
  final Widget content;
  final Widget information;
  final Widget? fees;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(9.5),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(
                          '${ref.read(environmentProvider).endpoint}/explorer/transaction/${transaction.address}',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        TransactionAction(action: transaction.action),
                        TransactionDate(timestamp: transaction.timestamp),
                        information,
                        content,
                        if (fees != null) fees!,
                      ],
                    ),
                  ),
                  if (transaction.typeTx == 1)
                    const TransactionInputIcon()
                  else
                    transaction.typeTx == 2
                        ? TransactionOutputIcon(transaction)
                        : const SizedBox.shrink(),
                  if (transaction.decryptedSecret != null &&
                      transaction.decryptedSecret!.isNotEmpty)
                    Positioned(
                      top: 13,
                      child: TransactionComment(transaction: transaction),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
