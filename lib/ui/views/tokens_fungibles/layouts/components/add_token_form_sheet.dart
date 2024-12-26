/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/formatters.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/provider.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/state.dart';
import 'package:aewallet/ui/widgets/balance/balance_indicator.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/ui/widgets/fees/fee_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'add_token_textfield_initial_supply.dart';
part 'add_token_textfield_name.dart';
part 'add_token_textfield_symbol.dart';

class AddTokenFormSheet extends ConsumerWidget
    implements SheetSkeletonInterface {
  const AddTokenFormSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    if (accountSelected == null) return const SizedBox();

    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      thumbVisibility: false,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final addToken = ref.watch(AddTokenFormProvider.addTokenForm);
    final addTokenNotifier =
        ref.watch(AddTokenFormProvider.addTokenForm.notifier);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.createToken,
          Dimens.buttonBottomDimens,
          key: const Key('createToken'),
          onPressed: () async {
            addTokenNotifier.setAddTokenProcessStep(
              AddTokenProcessStep.confirmation,
            );
          },
          disabled: !addToken.canAddToken,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.createFungibleToken,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final addToken = ref.watch(AddTokenFormProvider.addTokenForm);
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: AddTokenTextFieldName(
            key: Key('ftName'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: AddTokenTextFieldSymbol(
            key: Key('ftSymbol'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: AddTokenTextFieldInitialSupply(
            key: Key('ftOffer'),
          ),
        ),
        const SizedBox(height: 20),
        const BalanceIndicatorWidget(allDigits: false),
        FeeInfos(
          asyncFeeEstimation: addToken.feeEstimation,
          estimatedFeesNote: localizations.estimatedFeesAddTokenNote,
        ),
      ],
    );
  }
}
