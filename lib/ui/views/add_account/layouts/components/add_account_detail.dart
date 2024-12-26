/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/views/add_account/bloc/provider.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddAccountDetail extends ConsumerWidget {
  const AddAccountDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final addAccount = ref.watch(AddAccountFormProvider.addAccountForm);
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    return Column(
      children: [
        SheetDetailCard(
          children: [
            Text(
              localizations.serviceName,
              style: ArchethicThemeStyles.textStyleSize12W100Primary,
            ),
            Expanded(
              child: Text(
                addAccount.name,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
                textAlign: TextAlign.end,
              ),
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
              '0 ${AccountBalance.cryptoCurrencyLabel}',
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
                accountSelected!.balance!.nativeTokenValue,
                addAccount.symbolFees(context),
              ),
              style: ArchethicThemeStyles.textStyleSize12W100Primary,
            ),
          ],
        ),
      ],
    );
  }
}
