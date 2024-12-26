import 'package:aewallet/application/price_history/providers.dart';
import 'package:aewallet/model/available_currency.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/widgets/components/history_chart.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenDetailChart extends ConsumerWidget {
  const TokenDetailChart({
    super.key,
    this.chartInfos,
  });

  final List<aedappfm.PriceHistoryValue>? chartInfos;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterval = ref.watch(priceHistoryIntervalOptionProvider);
    if (chartInfos == null) {
      return const SizedBox.shrink();
    }
    return aedappfm.BlockInfo(
      paddingEdgeInsetsInfo: const EdgeInsets.only(top: 15, right: 15),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      info: HistoryChart(
        intervals: chartInfos!,
        gradientColors: LinearGradient(
          colors: <Color>[
            ArchethicTheme.text20,
            ArchethicTheme.text,
          ],
        ),
        gradientColorsBar: LinearGradient(
          colors: <Color>[
            ArchethicTheme.text.withOpacity(0.9),
            ArchethicTheme.text.withOpacity(0.1),
          ],
          begin: Alignment.center,
          end: Alignment.bottomCenter,
        ),
        tooltipBg: ArchethicTheme.backgroundDark,
        tooltipText: ArchethicThemeStyles.textStyleSize12W100Primary,
        axisTextStyle: ArchethicThemeStyles.textStyleSize12W100Primary,
        optionChartSelected: selectedInterval,
        currency: AvailableCurrencyEnum.usd.name,
        completeChart: true,
        lineTouchEnabled: true,
      ),
    );
  }
}
