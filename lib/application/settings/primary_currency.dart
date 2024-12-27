/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/util/currency_util.dart';
import 'package:aewallet/util/number_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'primary_currency.g.dart';

@riverpod
Future<double> convertedValue(
  Ref ref, {
  required double amount,
}) async {
  final primaryCurrency = ref.watch(
    SettingsProviders.settings.select(
      (settings) => settings.primaryCurrency.primaryCurrency,
    ),
  );
  final archethicOracleUCO = await ref
      .watch(aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.future);

  if (archethicOracleUCO.usd == 0) {
    return 0;
  }

  return primaryCurrency == AvailablePrimaryCurrencyEnum.native
      ? PrimaryCurrencyConverter.networkCurrencyToSelectedCurrency(
          amount,
          archethicOracleUCO.usd,
        )
      : PrimaryCurrencyConverter.selectedCurrencyToNetworkCurrency(
          amount,
          archethicOracleUCO.usd,
        );
}

@riverpod
AvailablePrimaryCurrency selectedPrimaryCurrency(Ref ref) => ref.watch(
      SettingsProviders.settings.select((settings) => settings.primaryCurrency),
    );

abstract class PrimaryCurrencyConverter {
  static double selectedCurrencyToNetworkCurrency(
    double amountEntered,
    double tokenPriceAmount,
  ) {
    if (amountEntered == 0 || tokenPriceAmount == 0) {
      return 0;
    }
    return (Decimal.parse(amountEntered.toString()) /
            Decimal.parse(
              tokenPriceAmount.toString(),
            ))
        .toDouble();
  }

  static double networkCurrencyToSelectedCurrency(
    double amountEntered,
    double tokenPriceAmount,
  ) {
    if (amountEntered == 0 || tokenPriceAmount == 0) {
      return 0;
    }

    final localCurrencyFormat = NumberFormat.currency(
      locale: CurrencyUtil.getLocale().toString(),
      symbol: CurrencyUtil.getCurrencySymbol(),
    );

    final convertedAmt = NumberUtil.sanitizeNumber(
      amountEntered.toString(),
      maxDecimalDigits: localCurrencyFormat.decimalDigits!,
    );
    if (convertedAmt.isEmpty) {
      return 0;
    }
    return (Decimal.parse(
              tokenPriceAmount.toString(),
            ) *
            Decimal.parse(convertedAmt))
        .toDouble();
  }
}
