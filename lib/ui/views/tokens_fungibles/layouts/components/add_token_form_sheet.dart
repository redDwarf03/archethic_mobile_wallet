// Project imports:
import 'package:aewallet/application/currency.dart';
import 'package:aewallet/application/theme.dart';
import 'package:aewallet/appstate_container.dart';
import 'package:aewallet/localization.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/formatters.dart';
import 'package:aewallet/ui/util/styles.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/provider.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/state.dart';
import 'package:aewallet/ui/widgets/balance/balance_indicator.dart';
import 'package:aewallet/ui/widgets/components/app_button.dart';
import 'package:aewallet/ui/widgets/components/app_text_field.dart';
import 'package:aewallet/ui/widgets/components/network_indicator.dart';
import 'package:aewallet/ui/widgets/components/sheet_header.dart';
import 'package:aewallet/ui/widgets/components/tap_outside_unfocus.dart';
import 'package:aewallet/ui/widgets/fees/fee_infos.dart';
// Package imports:
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'add_token_textfield_name.dart';
part 'add_token_textfield_symbol.dart';
part 'add_token_textfield_initial_supply.dart';

class AddTokenFormSheet extends ConsumerWidget {
  const AddTokenFormSheet({
    required this.seed,
    super.key,
  });

  final String seed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalization.of(context)!;
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final accountSelected = StateContainer.of(context)
        .appWallet!
        .appKeychain!
        .getAccountSelected()!;
    final currency = ref.watch(CurrencyProviders.selectedCurrency);
    final addToken = ref.watch(AddTokenFormProvider.addTokenForm);
    final addTokenNotifier =
        ref.watch(AddTokenFormProvider.addTokenForm.notifier);

    return TapOutsideUnfocus(
      child: SafeArea(
        minimum:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.035),
        child: Column(
          children: <Widget>[
            SheetHeader(
              title: localizations.createFungibleToken,
              widgetBeforeTitle: const NetworkIndicator(),
              widgetAfterTitle: const BalanceIndicatorWidget(
                displaySwitchButton: false,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Stack(
                  children: <Widget>[
                    Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: bottom + 80),
                          child: Column(
                            children: <Widget>[
                              const AddTokenTextFieldName(),
                              const AddTokenTextFieldSymbol(),
                              const AddTokenTextFieldInitialSupply(),
                              FeeInfos(
                                feeEstimation: addToken.feeEstimation,
                                tokenPrice: accountSelected
                                        .balance!.tokenPrice!.amount ??
                                    0,
                                currencyName: currency.currency.name,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (addToken.canAddToken)
                      AppButton(
                        AppButtonType.primary,
                        localizations.createToken,
                        Dimens.buttonBottomDimens,
                        key: const Key('createToken'),
                        onPressed: () async {
                          addTokenNotifier.controlName(context);
                          addTokenNotifier.controlSymbol(context);
                          addTokenNotifier.controlInitialSupply(context);

                          if (addToken.isControlsOk) {
                            addTokenNotifier.setAddTokenProcessStep(
                              AddTokenProcessStep.confirmation,
                            );
                          }
                        },
                      )
                    else
                      AppButton(
                        AppButtonType.primaryOutline,
                        localizations.createToken,
                        Dimens.buttonBottomDimens,
                        key: const Key('createToken'),
                        onPressed: () {},
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
