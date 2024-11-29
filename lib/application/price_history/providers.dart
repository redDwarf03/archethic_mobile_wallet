import 'package:aewallet/application/settings/settings.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
CoinPriceHistoryRepositoryInterface _repository(Ref ref) =>
    CoinPriceHistoryRepository();

@Riverpod(keepAlive: true)
MarketPriceHistoryInterval _intervalOption(Ref ref) => ref.watch(
      SettingsProviders.settings
          .select((value) => value.priceChartIntervalOption),
    );

@Riverpod(keepAlive: true)
Future<List<PriceHistoryValue>?> _priceHistory(
  Ref ref, {
  int? ucid,
}) async {
  if (ucid == null || ucid == 0) return null;
  final scaleOption = ref.watch(_intervalOptionProvider);
  return ref
      .watch(_repositoryProvider)
      .getWithInterval(
        interval: scaleOption,
        ucid: ucid,
      )
      .valueOrThrow;
}

abstract class PriceHistoryProviders {
  static final scaleOption = _intervalOptionProvider;
  static const priceHistory = _priceHistoryProvider;
}
