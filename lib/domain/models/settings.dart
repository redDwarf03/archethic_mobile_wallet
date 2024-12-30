import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

enum MainScreenTab {
  accountTab,
  transactionTab,
  swapTab,
  earnTab,
  bridgeTab,
}

@freezed
class Settings with _$Settings {
  const factory Settings({
    required AvailablePrimaryCurrency primaryCurrency,
    required AvailableLanguage language,
    required aedappfm.Environment environment,
    required String languageSeed,
    required bool firstLaunch,
    required bool showBalances,
    required bool testnetEnabled,
    required bool activeRPCServer,
    required int mainScreenCurrentPage,
    required bool showPriceChart,
    required aedappfm.MarketPriceHistoryInterval priceChartIntervalOption,
  }) = _Settings;

  factory Settings.empty() => const Settings(
        activeRPCServer: true,
        firstLaunch: true,
        language: AvailableLanguage.english,
        languageSeed: '',
        mainScreenCurrentPage: 0,
        environment: aedappfm.Environment.mainnet,
        primaryCurrency:
            AvailablePrimaryCurrency(AvailablePrimaryCurrencyEnum.native),
        showBalances: true,
        testnetEnabled: false,
        showPriceChart: true,
        priceChartIntervalOption: aedappfm.MarketPriceHistoryInterval.hour,
      );

  const Settings._();

  MainScreenTab get mainScreenTab => MainScreenTab.values.firstWhere(
        (value) => value.index == mainScreenCurrentPage,
      );
}
