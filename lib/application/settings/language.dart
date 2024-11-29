import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language.g.dart';

@Riverpod(keepAlive: true)
AvailableLanguage _selectedLanguage(Ref ref) => ref.watch(
      SettingsProviders.settings.select(
        (settings) => settings.language,
      ),
    );

/// Resolves the selected locale
///
/// If LanguageSetting is set to LanguageSetting.systemDefault, returns defaultLocale
/// Otherwise returns selected locale.
@Riverpod(keepAlive: true)
Locale _selectedLocale(Ref ref) {
  final languageSetting = ref.watch(_selectedLanguageProvider);
  final defaultLocale = ref.watch(_defaultLocaleProvider);

  return languageSetting.getLocale() ?? defaultLocale;
}

@Riverpod(keepAlive: true)
List<Locale> _availableLocales(Ref ref) {
  return const <Locale>[
    Locale('en'),
    Locale('fr'),
  ];
}

final _defaultLocaleProvider = StateProvider<Locale>(
  (ref) => const Locale('en', 'US'),
);

abstract class LanguageProviders {
  static final selectedLanguage = _selectedLanguageProvider;

  static final availableLocales = _availableLocalesProvider;
  static final defaultLocale = _defaultLocaleProvider;
  static final selectedLocale = _selectedLocaleProvider;
}
