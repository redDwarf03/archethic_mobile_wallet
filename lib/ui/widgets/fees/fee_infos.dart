import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/util/currency_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FeeInfos extends ConsumerWidget {
  const FeeInfos({
    required this.asyncFeeEstimation,
    required this.estimatedFeesNote,
    super.key,
  });

  final AsyncValue<double> asyncFeeEstimation;
  final String estimatedFeesNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final primaryCurrency =
        ref.watch(PrimaryCurrencyProviders.selectedPrimaryCurrency);

    final nativeFeeEstimation = asyncFeeEstimation.valueOrNull;
    if (nativeFeeEstimation == null) {
      return const _LoadingFeeInfos();
    }

    if (nativeFeeEstimation <= 0) {
      return _CannotLoadFeeInfos(estimatedFeesNote: estimatedFeesNote);
    }

    final archethicOracleUCO = ref
        .read(aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO)
        .valueOrNull;

    final fiatFeeEstimation =
        archethicOracleUCO?.usd ?? 0 * nativeFeeEstimation;

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.estimatedFees,
          ),
          if (primaryCurrency.primaryCurrency ==
              AvailablePrimaryCurrencyEnum.native)
            Text(
              '${AmountFormatters.standardSmallValue(
                nativeFeeEstimation,
                AccountBalance.cryptoCurrencyLabel,
                decimal: 2,
              )} / ${CurrencyUtil.formatWithNumberOfDigits(
                fiatFeeEstimation,
                2,
              )}',
              style: ArchethicThemeStyles.textStyleSize14W200Primary,
            )
          else
            Text(
              '${CurrencyUtil.formatWithNumberOfDigits(
                fiatFeeEstimation,
                2,
              )} / ${AmountFormatters.standardSmallValue(
                nativeFeeEstimation,
                AccountBalance.cryptoCurrencyLabel,
                decimal: 2,
              )}',
              style: ArchethicThemeStyles.textStyleSize14W200Primary,
            ),
        ],
      ),
    );
  }
}

class _CannotLoadFeeInfos extends ConsumerWidget {
  const _CannotLoadFeeInfos({
    required this.estimatedFeesNote,
  });
  final String estimatedFeesNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: Text(
        estimatedFeesNote,
        style: ArchethicThemeStyles.textStyleSize14W200Primary,
      ),
    );
  }
}

class _LoadingFeeInfos extends ConsumerWidget {
  const _LoadingFeeInfos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.estimatedFeesCalculationNote,
            style: ArchethicThemeStyles.textStyleSize14W200Primary,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 3,
              top: 10,
            ),
            child: LoadingAnimationWidget.progressiveDots(
              color: ArchethicTheme.text,
              size: 10,
            ),
          ),
        ],
      ),
    );
  }
}
