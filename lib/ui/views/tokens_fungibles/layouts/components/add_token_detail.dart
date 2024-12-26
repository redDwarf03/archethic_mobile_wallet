/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/provider.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/util/number_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTokenDetail extends ConsumerWidget {
  const AddTokenDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final addToken = ref.watch(AddTokenFormProvider.addTokenForm);
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SheetDetailCard(
            children: [
              Text(
                localizations.tokenName,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Expanded(
                child: Text(
                  addToken.name,
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.tokenSymbol,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Text(
                addToken.symbol,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.tokenInitialSupply,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Text(
                NumberUtil.formatThousands(addToken.initialSupply),
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.estimatedFees,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Text(
                AmountFormatters.standardSmallValue(
                  addToken.feeEstimationOrZero,
                  AccountBalance.cryptoCurrencyLabel,
                ),
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.availableAfterCreation,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Text(
                AmountFormatters.standard(
                  accountSelected!.balance!.nativeTokenValue -
                      addToken.feeEstimationOrZero,
                  addToken.symbolFees(context),
                ),
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
