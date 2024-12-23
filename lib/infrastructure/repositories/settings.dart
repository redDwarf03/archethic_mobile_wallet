import 'dart:ui';

import 'package:aewallet/domain/models/settings.dart';
import 'package:aewallet/domain/repositories/settings.dart';
import 'package:aewallet/infrastructure/datasources/preferences.hive.dart';
import 'package:aewallet/model/available_language.dart';

class SettingsRepository implements SettingsRepositoryInterface {
  Future<PreferencesHiveDatasource> get preferences async =>
      PreferencesHiveDatasource.getInstance();

  @override
  Future<Settings> getSettings(Locale currentLocale) async {
    final loadedPreferences = await preferences;

    return Settings(
      activeRPCServer: loadedPreferences.getActiveRPCServer(),
      firstLaunch: loadedPreferences.getFirstLaunch(),
      language: loadedPreferences.getLanguage().language,
      languageSeed: loadedPreferences.getLanguageSeed(),
      mainScreenCurrentPage: loadedPreferences.getMainScreenCurrentPage(),
      network: loadedPreferences.getNetwork(),
      primaryCurrency: loadedPreferences.getPrimaryCurrency(),
      showBalances: loadedPreferences.getShowBalances(),
      testnetEnabled: loadedPreferences.getTestnetEnabled(),
      showPriceChart: loadedPreferences.getShowPriceChart(),
      priceChartIntervalOption: loadedPreferences.getPriceChartIntervalOption(),
    );
  }

  @override
  Future<void> setSettings(Settings settings) async {
    final loadedPreferences = await preferences;
    await loadedPreferences.setActiveRPCServer(settings.activeRPCServer);
    await loadedPreferences.setFirstLaunch(settings.firstLaunch);
    await loadedPreferences.setLanguage(LanguageSetting(settings.language));
    await loadedPreferences.setLanguageSeed(settings.languageSeed);
    await loadedPreferences
        .setMainScreenCurrentPage(settings.mainScreenCurrentPage);
    await loadedPreferences.setNetwork(settings.network);
    await loadedPreferences.setPrimaryCurrency(settings.primaryCurrency);
    await loadedPreferences.setShowBalances(settings.showBalances);
    await loadedPreferences.setTestnetEnabled(settings.testnetEnabled);
    await loadedPreferences.setShowPriceChart(settings.showPriceChart);
    await loadedPreferences
        .setPriceChartIntervalOption(settings.priceChartIntervalOption);
  }
}
