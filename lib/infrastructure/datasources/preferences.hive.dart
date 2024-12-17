/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/domain/models/authentication.dart';
import 'package:aewallet/infrastructure/datasources/hive.extension.dart';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/model/available_networks.dart';
import 'package:aewallet/model/device_lock_timeout.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/model/privacy_mask_option.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class PreferencesHiveDatasource {
  PreferencesHiveDatasource._(this._box);

  static const String _preferencesBox = '_preferencesBox';
  final Box<dynamic> _box;

  static const String firstLaunch = 'archethic_wallet_first_launch';
  static const String authMethod = 'archethic_wallet_auth_method';
  static const String curLanguage = 'archethic_wallet_cur_language';
  static const String curPrimarySetting =
      'archethic_wallet_cur_primary_setting';
  static const String curNetwork = 'archethic_wallet_cur_network';
  static const String curNetworkDevEndpoint = '_cur_network_dev_endpoint';
  static const String curTheme = 'archethic_wallet_cur_theme';
  static const String lock = 'archethic_wallet_lock';
  static const String privacyMaskEnabled =
      'archethic_wallet_privacy_mask_enabled';
  static const String lockTimeout = 'archethic_wallet_lock_timeout';
  static const String lastInteractionDate =
      'archethic_wallet_last_interaction_date';
  static const String hasShownRootWarning =
      'archethic_wallet_has_shown_root_warning';
  static const String pinAttempts = 'archethic_wallet_pin_attempts';
  static const String pinLockUntil = 'archethic_wallet_pin_lock_until';
  static const String pinPadShuffle = 'archethic_wallet_pinPadShuffle';
  static const String showBalances = 'archethic_wallet_showBalances';
  static const String showPriceChart = 'archethic_wallet_showPriceChart';
  static const String priceChartScale = 'archethic_wallet_priceChartScale';
  static const String activeRPCServer = 'archethic_wallet_activeRPCServer';
  static const String recoveryPhraseSaved =
      'archethic_wallet_recoveryPhraseSaved';

  static const String languageSeed = 'archethic_wallet_language_seed';
  static const String mainScreenCurrentPage =
      'archethic_wallet_main_screen_current_page';
  static const String currentVersion = 'archethic_wallet_currentVersion';

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static PreferencesHiveDatasource? _instance;
  static Future<PreferencesHiveDatasource> getInstance() async {
    if (_instance?._box.isOpen == true) return _instance!;

    final box = await Hive.openBox<dynamic>(_preferencesBox);
    return _instance = PreferencesHiveDatasource._(box);
  }

  T _getValue<T>(dynamic key, {T? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);

  Future<void> _removeValue<T>(dynamic key) => _box.delete(key);

  Future<void> setHasShownRootWarning(bool hasShown) =>
      _setValue(hasShownRootWarning, hasShown);

  bool getHasSeenRootWarning() =>
      _getValue(hasShownRootWarning, defaultValue: false);

  Future<void> setCurrentDataVersion(int version) =>
      _setValue(currentVersion, version);

  Future<int?> getCurrentDataVersion() async {
    // implicit String to Int conversion to ensure
    // compatibility with first MigrationSystem version.
    final value = _box.get(currentVersion);
    if (value is String) {
      return int.tryParse(value);
    }

    return value;
  }

  Future<void> setAuthMethod(AuthenticationMethod method) =>
      _setValue(authMethod, method.getIndex());

  AuthenticationMethod getAuthMethod() => AuthenticationMethod(
        AuthMethod.values[_getValue(
          authMethod,
          defaultValue:
              AuthenticationSettings.defaultValue.authenticationMethod.index,
        )],
      );

  Future<void> setLanguage(LanguageSetting language) =>
      _setValue(curLanguage, language.getIndex());

  LanguageSetting getLanguage() => LanguageSetting(
        AvailableLanguage.values[_getValue(
          curLanguage,
          defaultValue: AvailableLanguage.systemDefault.index,
        )],
      );

  Future<void> setPrimaryCurrency(AvailablePrimaryCurrency primaryCurrency) =>
      _setValue(curPrimarySetting, primaryCurrency.getIndex());

  AvailablePrimaryCurrency getPrimaryCurrency() => AvailablePrimaryCurrency(
        AvailablePrimaryCurrencyEnum.values[_getValue(
          curPrimarySetting,
          defaultValue: AvailablePrimaryCurrencyEnum.native.index,
        )],
      );

  Future<void> setNetwork(NetworksSetting network) async {
    await _setValue(curNetwork, network.getIndex());
    await _setValue(curNetworkDevEndpoint, network.networkDevEndpoint);
  }

  NetworksSetting getNetwork() => NetworksSetting(
        network: AvailableNetworks.values[_getValue(
          curNetwork,
          defaultValue: AvailableNetworks.archethicMainNet.index,
        )],
        networkDevEndpoint: _getValue(
          curNetworkDevEndpoint,
          defaultValue: '',
        ),
      );

  Future<void> setLanguageSeed(String v) => _setValue(languageSeed, v);

  String getLanguageSeed() => _getValue(languageSeed, defaultValue: '');

  Future<void> setFirstLaunch(bool value) => _setValue(firstLaunch, value);

  bool getFirstLaunch() => _getValue(firstLaunch, defaultValue: true);

  Future<void> setPinPadShuffle(bool value) => _setValue(pinPadShuffle, value);

  bool getPinPadShuffle() => _getValue(
        pinPadShuffle,
        defaultValue: AuthenticationSettings.defaultValue.pinPadShuffle,
      );

  Future<void> setShowBalances(bool value) => _setValue(showBalances, value);

  bool getShowBalances() => _getValue(showBalances, defaultValue: true);

  Future<void> setActiveRPCServer(bool value) =>
      _setValue(activeRPCServer, value);

  bool getActiveRPCServer() => _getValue(activeRPCServer, defaultValue: true);

  Future<void> setRecoveryPhraseSaved(bool value) =>
      _setValue(recoveryPhraseSaved, value);

  bool getRecoveryPhraseSaved() =>
      _getValue(recoveryPhraseSaved, defaultValue: false);

  Future<void> setMainScreenCurrentPage(int value) =>
      _setValue(mainScreenCurrentPage, value);

  int getMainScreenCurrentPage() =>
      _getValue(mainScreenCurrentPage, defaultValue: 0);

  Future<void> setShowPriceChart(bool value) =>
      _setValue(showPriceChart, value);

  bool getShowPriceChart() => _getValue(showPriceChart, defaultValue: true);

  Future<void> setPriceChartIntervalOption(
    aedappfm.MarketPriceHistoryInterval scaleOption,
  ) =>
      _setValue(
        priceChartScale,
        scaleOption.index,
      );

  aedappfm.MarketPriceHistoryInterval getPriceChartIntervalOption() =>
      aedappfm.MarketPriceHistoryInterval.values[_getValue(
        priceChartScale,
        defaultValue: aedappfm.MarketPriceHistoryInterval.hour.index,
      )];

  bool getPrivacyMaskEnabled() => _getValue(
        privacyMaskEnabled,
        defaultValue: AuthenticationSettings.defaultValue.privacyMask ==
            PrivacyMaskOption.enabled,
      );

  Future<void> setPrivacyMaskEnabled(bool enabled) =>
      _setValue(privacyMaskEnabled, enabled);

  Future<void> setLockTimeout(LockTimeoutOption lockTimeoutOption) =>
      _setValue(lockTimeout, lockTimeoutOption.index);

  LockTimeoutOption getLockTimeout() => LockTimeoutOption.values[_getValue(
        lockTimeout,
        defaultValue: AuthenticationSettings.defaultValue.lockTimeout.index,
      )];

  int getLockAttempts() => _getValue(pinAttempts, defaultValue: 0);

  Future<void> incrementLockAttempts() => _setValue(
        pinAttempts,
        getLockAttempts() + 1,
      );

  Future<void> resetLockAttempts() async {
    await _removeValue(pinAttempts);
  }

  Future<void> removeLockDate() async {
    await _removeValue(pinLockUntil);
  }

  Future<void> setLockDate(DateTime lockDate) async {
    final lockDateStr = DateFormat.yMd().add_jms().format(lockDate.toUtc());
    await _setValue(pinLockUntil, lockDateStr);
  }

  DateTime? getLockDate() {
    final lockDateStr = _getValue(pinLockUntil);

    if (lockDateStr != null) {
      return DateFormat.yMd().add_jms().parseUtc(lockDateStr);
    } else {
      return null;
    }
  }

  static Future<void> clear() => Hive.deleteBox<dynamic>(_preferencesBox);

  Future<DateTime?> getLastInteractionDate() async {
    return _getValue(lastInteractionDate);
  }

  Future<void> setLastInteractionDate(DateTime date) async {
    return _setValue(lastInteractionDate, date);
  }

  Future<void> clearLastInteractionDate() async {
    await _removeValue(lastInteractionDate);
  }
}
