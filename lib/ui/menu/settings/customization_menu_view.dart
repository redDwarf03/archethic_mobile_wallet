part of 'settings_sheet.dart';

class CustomizationMenuView extends ConsumerWidget
    implements SheetSkeletonInterface {
  const CustomizationMenuView({
    super.key,
  });

  static const routerPage = '/customization_menu_view';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      menu: true,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    return const SizedBox.shrink();
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.customHeader,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);
    final environment = ref.watch(environmentProvider);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            ArchethicThemeBase.blue700.withOpacity(0.4),
            ArchethicThemeBase.blue700.withOpacity(1),
          ],
          begin: Alignment.topLeft,
          end: const Alignment(5, 0),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      _SettingsListItem.withDefaultValue(
                        heading: localizations.primaryCurrency,
                        defaultValue: primaryCurrency,
                        icon: Symbols.currency_exchange,
                        onPressed: () =>
                            PrimaryCurrencyDialog.getDialog(context, ref),
                      ),
                      const _SettingsListItem.spacer(),
                      const _LanguageSettingsListItem(),
                      const _SettingsListItem.spacer(),
                      const _ShowBalancesSettingsListItem(),
                      const _SettingsListItem.spacer(),
                      const _ShowPriceChartSettingsListItem(),
                      const _SettingsListItem.spacer(),
                      if (environment == aedappfm.Environment.mainnet)
                        const _TestnetEnabledSettingsListItem(),
                      if (environment == aedappfm.Environment.mainnet)
                        const _SettingsListItem.spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSettingsListItem extends ConsumerWidget {
  const _LanguageSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final language = ref.watch(LanguageProviders.selectedLanguage);

    return _SettingsListItem.withDefaultValue(
      heading: localizations.language,
      defaultValue: LanguageSetting(language),
      icon: Symbols.translate,
      onPressed: () => LanguageDialog.getDialog(context, ref),
    );
  }
}

class _ShowBalancesSettingsListItem extends ConsumerWidget {
  const _ShowBalancesSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final showBalancesSetting = ref.watch(
      SettingsProviders.settings.select((settings) => settings.showBalances),
    );
    final preferencesNotifier = ref.read(SettingsProviders.settings.notifier);
    return _SettingsListItem.withSwitch(
      heading: localizations.showBalances,
      icon: Symbols.account_balance_wallet,
      isSwitched: showBalancesSetting,
      onChanged: (showBalances) async {
        await preferencesNotifier.setShowBalances(showBalances);
      },
    );
  }
}

class _ShowPriceChartSettingsListItem extends ConsumerWidget {
  const _ShowPriceChartSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final showPriceChart = ref.watch(
      SettingsProviders.settings.select((settings) => settings.showPriceChart),
    );
    final preferencesNotifier = ref.read(SettingsProviders.settings.notifier);

    return _SettingsListItem.withSwitch(
      heading: localizations.showPriceChart,
      icon: Symbols.show_chart,
      isSwitched: showPriceChart,
      onChanged: (showPriceChart) async {
        await preferencesNotifier.setShowPriceChart(showPriceChart);
      },
    );
  }
}

class _TestnetEnabledSettingsListItem extends ConsumerWidget {
  const _TestnetEnabledSettingsListItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final testnetEnabledSetting = ref.watch(
      SettingsProviders.settings.select((settings) => settings.testnetEnabled),
    );
    final preferencesNotifier = ref.read(SettingsProviders.settings.notifier);
    return _SettingsListItem.withSwitch(
      heading: localizations.testnetEnabled,
      icon: Symbols.deployed_code_account,
      isSwitched: testnetEnabledSetting,
      onChanged: (testnetEnabled) async {
        await preferencesNotifier.setTestnetEnabled(testnetEnabled);
      },
    );
  }
}
