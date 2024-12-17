/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:io';

import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/application/migrations/migration_manager.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/repositories/features_flags.dart';
import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/infrastructure/datasources/vault/vault.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/modules/aeswap/infrastructure/hive/db_helper.hive.dart';
import 'package:aewallet/router/router.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/views/authenticate/auto_lock_guard.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_welcome.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/limited_width_layout.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/window_size.dart';
import 'package:aewallet/ui/widgets/dialogs/logs_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/remove_wallet_dialog.dart';
import 'package:aewallet/util/device_info.dart';
import 'package:aewallet/util/security_manager.dart';
import 'package:aewallet/util/service_locator.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:oktoast/oktoast.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  aedappfm.LoggerOutput.setup();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await DBHelper.setupDatabase();
  await DBHelperModuleAESwap.setupDatabase();
  await setupServiceLocator();
  await DeviceInfo.init();

  if (UniversalPlatform.isDesktop) {
    await windowManager.ensureInitialized();

    final idealSize = WindowSize().idealSize;

    final windowOptions = WindowOptions(
      size: idealSize,
      center: false,
      maximumSize: idealSize,
      backgroundColor: Colors.transparent,
      fullScreen: false,
      title: 'Archethic Wallet',
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      // https://github.com/leanflutter/window_manager/issues/238
      if (UniversalPlatform.isLinux) {
        await windowManager.setResizable(true);
      } else {
        await windowManager.setResizable(false);
      }

      // ignore: cascade_invocations
      if (UniversalPlatform.isWindows) {
        await windowManager.setMaximizable(false);
      }
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Fix LetsEncrypt root certificate for Android<7.1
  if (UniversalPlatform.isAndroid) {
    // WARNING ! Any change here must be repercuted to
    // the Android `xml/network_security_config.xml` file
    final certificates = [
      'assets/ssl/isrg-root-x1.pem',
      'assets/ssl/isrg-root-x2.pem',
      'assets/ssl/r10.pem',
      'assets/ssl/r11.pem',
      'assets/ssl/r12.pem',
      'assets/ssl/r13.pem',
      'assets/ssl/r14.pem',
      'assets/ssl/e5.pem',
      'assets/ssl/e6.pem',
      'assets/ssl/e7.pem',
      'assets/ssl/e8.pem',
      'assets/ssl/e9.pem',
    ];
    for (final certPath in certificates) {
      final cert = await rootBundle.load(certPath);
      SecurityContext.defaultContext.setTrustedCertificatesBytes(
        cert.buffer.asUint8List(),
      );
    }
  }

  // Run app
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp],
    );
  }
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      observers: [
        aedappfm.ProvidersLogger(),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => AppState();
}

class AppState extends ConsumerState<App> with WidgetsBindingObserver {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final router = RoutesPath(rootNavigatorKey).createRouter();
  final _logger = Logger('AppWidget');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    didChangeAppLifecycleStateAsync(state);
  }

  Future<void> didChangeAppLifecycleStateAsync(AppLifecycleState state) async {
    _logger.info('Lifecycle State : $state');
    var isDeviceSecured = false;
    // Account for user changing locale when leaving the app
    switch (state) {
      case AppLifecycleState.paused:
        isDeviceSecured = await SecurityManager().isDeviceSecured();
        break;
      case AppLifecycleState.resumed:
        updateDefaultLocale();
        // Value changed since last time we came in pause state
        if (isDeviceSecured != await SecurityManager().isDeviceSecured()) {
          await SecurityManager().checkDeviceSecurity(
            ref,
            rootNavigatorKey.currentState!.overlay!.context,
          );
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void updateDefaultLocale() {
    ref.read(LanguageProviders.defaultLocale.notifier).update(
          (state) => Localizations.localeOf(
            rootNavigatorKey.currentState!.overlay!.context,
          ),
        );
  }

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    final language = ref.watch(LanguageProviders.selectedLanguage);

    SystemChrome.setSystemUIOverlayStyle(
      ArchethicTheme.statusBar,
    );

    return LimitedWidthLayout(
      child: GestureDetector(
        onTap: () {
          // Hide soft input keyboard after tapping outside anywhere on screen
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: OKToast(
          textStyle: ArchethicThemeStyles.textStyleSize14W700Background,
          backgroundColor: ArchethicTheme.background,
          child: MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            title: 'Archethic Wallet',
            theme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'PPTelegraf',
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'PPTelegraf',
              useMaterial3: true,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              aedappfm.AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: language.getLocale(),
            supportedLocales: ref.read(LanguageProviders.availableLocales),
          ),
        ),
      ),
    );
  }
}

/// Splash
/// Default page route that determines if user is logged in
/// and routes them appropriately.
class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  static const routerPage = '/';

  @override
  ConsumerState<Splash> createState() => SplashState();
}

class SplashState extends ConsumerState<Splash> {
  final _logger = Logger('SplashState');
  Object? restorationFailure;

  Future<void> initializeProviders() async {
    await ref
        .read(LocalDataMigrationProviders.localDataMigration.notifier)
        .migrateLocalData();
    final locale = ref.read(LanguageProviders.selectedLocale);
    await ref.read(SettingsProviders.settings.notifier).initialize(locale);
    await ref.read(AuthenticationProviders.settings.notifier).initialize();
    await SecurityManager().checkDeviceSecurity(ref, context);

    AuthFactory.of(context).init();
  }

  Future<void> checkLoggedIn() async {
    try {
      // iOS key store is persistent, so if this is first launch
      // then we will clear the keystore
      /*bool firstLaunch = preferences.getFirstLaunch();
      if (firstLaunch) {
        Vault vault = await Vault.getInstance();
        vault.clearAll();
        preferences.clearAll();
      }
      await preferences.setFirstLaunch(false);
      */
      if (FeatureFlags.forceLogout) {
        await ref.read(sessionNotifierProvider.notifier).logout();

        context.go(IntroWelcome.routerPage);
        return;
      }

      await ref.read(sessionNotifierProvider.notifier).restore().valueOrThrow;

      final session = ref.read(sessionNotifierProvider);

      if (session.isLoggedOut) {
        context.go(IntroWelcome.routerPage);
        return;
      }
      context.go(HomePage.routerPage);
    } catch (e, stack) {
      _logger.severe(
        'Failed to restore session',
        e,
        stack,
      );

      /// Relock storage if restoration failed
      await Vault.instance().lock();

      setState(() {
        restorationFailure = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeProviders();
      await checkLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (restorationFailure != null) {
      return SheetSkeleton(
        appBar: SheetAppBar(
          title: localizations.restoreFailedTitle,
          widgetAfterTitle: Text(
            localizations.restoreFailedSubtitle,
            style: ArchethicThemeStyles.textStyleSize14W600Primary,
            textAlign: TextAlign.center,
          ),
        ),
        menu: true,
        sheetContent: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ArchethicTheme.backgroundSmall,
              ),
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
              opacity: 0.7,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 32,
              right: 32,
              bottom: 32,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    localizations.restoreFailedInfo1,
                    style: ArchethicThemeStyles.textStyleSize16W700Primary,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    localizations.restoreFailedInfo2,
                    style: ArchethicThemeStyles.textStyleSize14W400Highlighted,
                    textAlign: TextAlign.start,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                LogsDialog.getDialog(
                  context,
                  ref,
                  restorationFailure.toString(),
                );
              },
              child: Text(
                localizations.getSomeHelp,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppButtonTiny(
                  AppButtonTinyType.primary,
                  localizations.retry,
                  Dimens.buttonBottomDimens,
                  onPressed: () {
                    setState(() {
                      restorationFailure = null;
                    });
                    checkLoggedIn();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              margin: Dimens.buttonBottomDimens.edgeInsetsDirectional,
              child: FilledButton(
                onPressed: () {
                  RemoveWalletDialog.show(
                    context,
                    ref,
                    authRequired: false,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: ArchethicThemeStyles
                      .textStyleSize16W400MainButtonLabel.color,
                ),
                child: Row(
                  children: [
                    const Icon(Symbols.delete),
                    const Spacer(),
                    Text(
                      'Remove wallet',
                      style: ArchethicThemeStyles
                          .textStyleSize16W400MainButtonLabel,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const LockMask();
  }
}
