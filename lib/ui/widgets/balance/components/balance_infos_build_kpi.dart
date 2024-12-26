/// SPDX-License-Identifier: AGPL-3.0-or-later

part of '../balance_infos.dart';

class BalanceInfosKpi extends ConsumerWidget {
  const BalanceInfosKpi({
    required this.aeToken,
    this.chartInfos,
    super.key,
  });

  final aedappfm.AEToken aeToken;
  final List<aedappfm.PriceHistoryValue>? chartInfos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final price = ref
        .watch(
          aedappfm.AETokensProviders.estimateTokenInFiat(
            aeToken,
          ),
        )
        .valueOrNull;

    if (chartInfos == null) {
      return const SizedBox.shrink();
    }

    final selectedPriceHistoryInterval =
        ref.watch(priceHistoryIntervalOptionProvider);
    return Row(
      children: <Widget>[
        AutoSizeText(
          '${localizations.price}: ',
          style: ArchethicThemeStyles.textStyleSize12W100Primary60,
        ),
        AutoSizeText(
          price == null
              ? '...'
              : '\$${price.formatNumber(precision: price < 1 ? 5 : 2)}',
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        ),
        const SizedBox(
          width: 10,
        ),
        if (chartInfos != null && chartInfos!.isNotEmpty)
          PriceEvolutionIndicator(chartInfos),
        const SizedBox(
          width: 10,
        ),
        AutoSizeText(
          selectedPriceHistoryInterval.getChartOptionLabel(
            context,
          ),
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        ),
      ],
    );
  }
}
