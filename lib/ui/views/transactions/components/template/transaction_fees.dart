/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/util/currency_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionFees extends ConsumerWidget {
  const TransactionFees({
    super.key,
    required this.transaction,
  });

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final settings = ref.watch(SettingsProviders.settings);
    final primaryCurrency =
        ref.watch(PrimaryCurrencyProviders.selectedPrimaryCurrency);

    final archethicOracleUCO = ref
        .watch(aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO)
        .valueOrNull;

    final amountConverted =
        CurrencyUtil.convertAmountFormatedWithNumberOfDigits(
      archethicOracleUCO?.usd ?? 0,
      transaction.fee!,
      3,
    );

    return Row(
      children: <Widget>[
        if (transaction.indexInLedger > 0)
          Row(
            children: [
              Text(
                '${localizations.txListFees} ',
                style: ArchethicThemeStyles.textStyleSize12W100Primary60,
              ),
              Text(
                localizations.txListFeesIncluded,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          )
        else
          settings.showBalances == true
              ? Row(
                  children: [
                    Text(
                      '${localizations.txListFees} ',
                      style: ArchethicThemeStyles.textStyleSize12W100Primary60,
                    ),
                    if (primaryCurrency.primaryCurrency ==
                        AvailablePrimaryCurrencyEnum.native)
                      Text(
                        '${transaction.fee!.toStringAsFixed(3)} ${AccountBalance.cryptoCurrencyLabel} ($amountConverted)',
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      )
                    else
                      Text(
                        '$amountConverted (${transaction.fee!.toStringAsFixed(3)} ${AccountBalance.cryptoCurrencyLabel})',
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      '${localizations.txListFees} ',
                      style: ArchethicThemeStyles.textStyleSize12W100Primary60,
                    ),
                    Text(
                      '···········',
                      style: ArchethicThemeStyles.textStyleSize12W100Primary60,
                    ),
                  ],
                ),
      ],
    );
  }
}
