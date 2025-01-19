/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenCreationInformation extends ConsumerWidget {
  const TokenCreationInformation({super.key, required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    if (transaction.ledgerOperationMvtInfo == null ||
        transaction.ledgerOperationMvtInfo!.isEmpty ||
        transaction.ledgerOperationMvtInfo!.first.tokenInformation == null) {
      return const SizedBox.shrink();
    }
    final tokenInformation =
        transaction.ledgerOperationMvtInfo!.first.tokenInformation;

    return Row(
      children: [
        if (tokenInformation!.type == 'fungible')
          Expanded(
            child: Row(
              children: [
                AutoSizeText(
                  '${localizations.tokenCreated} ',
                  style: ArchethicThemeStyles.textStyleSize12W100Primary60,
                ),
                AutoSizeText(
                  tokenInformation.name!,
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                ),
              ],
            ),
          )
        else
          Expanded(
            child: Row(
              children: [
                AutoSizeText(
                  '${localizations.nftCreated} ',
                  style: ArchethicThemeStyles.textStyleSize12W100Primary60,
                ),
                AutoSizeText(
                  tokenInformation.name!,
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                ),
              ],
            ),
          ),
        const SizedBox(
          width: 2,
        ),
      ],
    );
  }
}
