import 'package:aewallet/application/settings/settings.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
CoinPriceHistoryRepositoryInterface priceHistoryRepository(Ref ref) =>
    CoinPriceHistoryRepository();

@riverpod
MarketPriceHistoryInterval priceHistoryIntervalOption(Ref ref) => ref.watch(
      SettingsProviders.settings
          .select((value) => value.priceChartIntervalOption),
    );

@riverpod
Future<List<PriceHistoryValue>?> priceHistory(
  Ref ref, {
  int? ucid,
}) async {
  if (ucid == null || ucid == 0) return null;
  final scaleOption = ref.watch(priceHistoryIntervalOptionProvider);
  return ref
      .watch(priceHistoryRepositoryProvider)
      .getWithInterval(
        interval: scaleOption,
        ucid: ucid,
      )
      .valueOrThrow;
}
