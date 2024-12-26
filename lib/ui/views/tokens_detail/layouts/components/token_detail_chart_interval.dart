/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/price_history/providers.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/chart_option_label.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenDetailChartInterval extends ConsumerWidget {
  const TokenDetailChartInterval({
    super.key,
    this.chartInfos,
  });

  final List<aedappfm.PriceHistoryValue>? chartInfos;

  static const List<aedappfm.MarketPriceHistoryInterval> _chartIntervalOptions =
      [
    aedappfm.MarketPriceHistoryInterval.hour,
    aedappfm.MarketPriceHistoryInterval.day,
    aedappfm.MarketPriceHistoryInterval.week,
    aedappfm.MarketPriceHistoryInterval.twoWeeks,
    aedappfm.MarketPriceHistoryInterval.month,
    aedappfm.MarketPriceHistoryInterval.twoMonths,
    aedappfm.MarketPriceHistoryInterval.year,
  ];

  int _intervalOptionIndex(aedappfm.MarketPriceHistoryInterval interval) =>
      _chartIntervalOptions.indexWhere((element) => element == interval);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInterval = ref.watch(priceHistoryIntervalOptionProvider);

    if (chartInfos == null) {
      return const SizedBox.shrink();
    }

    return Wrap(
      children: [
        BottomBar(
          selectedIndex: _intervalOptionIndex(selectedInterval),
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 500),
          itemPadding: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(right: 10, left: 10),
          onTap: (int index) async {
            await ref
                .read(SettingsProviders.settings.notifier)
                .setPriceChartInterval(_chartIntervalOptions[index]);
          },
          items: _chartIntervalOptions.map((optionChart) {
            return BottomBarItem(
              icon: Text(
                optionChart.getChartOptionLabel(context),
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              backgroundColorOpacity:
                  ArchethicTheme.bottomBarBackgroundColorOpacity,
              activeIconColor: ArchethicTheme.bottomBarActiveIconColor,
              activeTitleColor: ArchethicTheme.bottomBarActiveTitleColor,
              activeColor: ArchethicTheme.bottomBarActiveColor,
              inactiveColor: ArchethicTheme.bottomBarInactiveIcon,
            );
          }).toList(),
        ),
      ],
    );
  }
}
