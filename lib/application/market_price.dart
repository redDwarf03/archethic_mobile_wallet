import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/models/market_price.dart';
import 'package:aewallet/domain/repositories/market/market.dart';
import 'package:aewallet/domain/usecases/market/get_market_price.dart';
import 'package:aewallet/infrastructure/repositories/market/archethic_oracle_uco_market.dart';
import 'package:aewallet/infrastructure/repositories/market/local_uco_market.dart';
import 'package:aewallet/model/available_currency.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'market_price.g.dart';

@Riverpod(keepAlive: true)
List<MarketRepositoryInterface> _remoteRepositories(
  Ref ref,
) =>
    [
      ArchethicOracleUCOMarketRepository(),
    ];

@Riverpod(keepAlive: true)
MarketLocalRepositoryInterface _localRepository(Ref ref) =>
    HiveUcoMarketRepository();

@Riverpod(keepAlive: true)
Future<MarketPrice> _currencyMarketPrice(
  Ref ref, {
  required AvailableCurrencyEnum currency,
}) =>
    GetUCOMarketPriceUsecases(
      remoteRepositories: ref.watch(_remoteRepositoriesProvider),
      localRepository: ref.watch(_localRepositoryProvider),
      oracleService: ref.watch(aedappfm.oracleServiceProvider),
    ).updateFromRemoteUseCase.run(currency).valueOrThrow;

@Riverpod(keepAlive: true)
Future<MarketPrice> _selectedCurrencyMarketPrice(
  Ref ref,
) async {
  final archethicOracleUCO = await ref.watch(
    aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.future,
  );
  return MarketPrice(
    amount: archethicOracleUCO.usd,
    lastLoading: archethicOracleUCO.timestamp,
    useOracle: true,
  );
}

@riverpod
Future<double> _convertedToSelectedCurrency(
  Ref ref, {
  required double nativeAmount,
}) async {
  final selectedCurrencyMarketPrice = await ref.watch(
    _selectedCurrencyMarketPriceProvider.future,
  );
  return selectedCurrencyMarketPrice.amount * nativeAmount;
}

abstract class MarketPriceProviders {
  static const currencyMarketPrice = _currencyMarketPriceProvider;
  static final selectedCurrencyMarketPrice =
      _selectedCurrencyMarketPriceProvider;
  static const convertedToSelectedCurrency =
      _convertedToSelectedCurrencyProvider;
}
