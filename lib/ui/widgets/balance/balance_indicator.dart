/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/util/currency_util.dart';
import 'package:aewallet/util/number_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class BalanceIndicatorWidget extends ConsumerWidget {
  const BalanceIndicatorWidget({
    super.key,
    this.displaySwitchButton = true,
    this.allDigits = true,
    this.displayLabel = true,
  });

  final bool displaySwitchButton;
  final bool allDigits;
  final bool displayLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(SettingsProviders.settings);
    final primaryCurrency =
        ref.watch(PrimaryCurrencyProviders.selectedPrimaryCurrency);
    final localizations = AppLocalizations.of(context)!;

    return preferences.showBalances
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (displayLabel)
                    Text(
                      '${localizations.ucoBalance}: ',
                      style: ArchethicThemeStyles.textStyleSize14W200Primary,
                    ),
                  if (displaySwitchButton == true)
                    const _BalanceIndicatorButton(),
                ],
              ),
              if (primaryCurrency.primaryCurrency ==
                  AvailablePrimaryCurrencyEnum.native)
                Row(
                  children: [
                    _BalanceIndicatorNative(
                      primary: true,
                      allDigits: allDigits,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        '/',
                        style: ArchethicThemeStyles.textStyleSize14W200Primary,
                      ),
                    ),
                    _BalanceIndicatorFiat(
                      primary: false,
                      allDigits: allDigits,
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    _BalanceIndicatorFiat(
                      primary: true,
                      allDigits: allDigits,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        '/',
                        style: ArchethicThemeStyles.textStyleSize14W200Primary,
                      ),
                    ),
                    _BalanceIndicatorNative(
                      primary: false,
                      allDigits: allDigits,
                    ),
                  ],
                ),
            ],
          )
        : const SizedBox();
  }
}

class _BalanceIndicatorButton extends ConsumerWidget {
  const _BalanceIndicatorButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Symbols.currency_exchange),
      color: ArchethicTheme.textFieldIcon,
      iconSize: 14,
      onPressed: () async {
        await ref
            .read(SettingsProviders.settings.notifier)
            .switchSelectedPrimaryCurrency();
      },
    );
  }
}

class _BalanceIndicatorFiat extends ConsumerWidget {
  const _BalanceIndicatorFiat({
    required this.primary,
    this.allDigits = true,
  });

  final bool primary;
  final bool allDigits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelectedBalance = ref.watch(
      AccountProviders.accounts
          .select((value) => value.valueOrNull?.selectedAccount?.balance),
    );

    if (accountSelectedBalance == null) return const SizedBox();

    final archethicOracleUCO = ref
        .read(aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO)
        .valueOrNull;

    final fiatValue =
        archethicOracleUCO?.usd ?? 0 * accountSelectedBalance.nativeTokenValue;

    return Text(
      NumberUtil.formatThousandsStr(
        CurrencyUtil.format(
          fiatValue,
        ),
      ),
      style: ArchethicThemeStyles.textStyleSize14W200Primary,
    );
  }
}

class _BalanceIndicatorNative extends ConsumerWidget {
  const _BalanceIndicatorNative({
    required this.primary,
    this.allDigits = true,
  });

  final bool primary;
  final bool allDigits;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelectedBalance = ref.watch(
      AccountProviders.accounts.select(
        (value) => value.valueOrNull?.selectedAccount?.balance,
      ),
    );
    final language = ref.watch(
      LanguageProviders.selectedLanguage,
    );
    if (accountSelectedBalance == null) return const SizedBox();

    if (allDigits == true) {
      return Text(
        '${NumberUtil.formatThousandsStr(
          accountSelectedBalance.nativeTokenValueToString(
            language.getLocaleStringWithoutDefault(),
          ),
        )} ${accountSelectedBalance.nativeTokenName}',
        style: ArchethicThemeStyles.textStyleSize14W200Primary,
      );
    } else {
      return Text(
        '${NumberUtil.formatThousandsStr(
          accountSelectedBalance.nativeTokenValueToString(
            language.getLocaleStringWithoutDefault(),
            digits: accountSelectedBalance.nativeTokenValue < 1 ? 8 : 2,
          ),
        )} ${accountSelectedBalance.nativeTokenName}',
        style: ArchethicThemeStyles.textStyleSize14W200Primary,
      );
    }
  }
}
