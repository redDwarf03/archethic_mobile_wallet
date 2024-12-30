import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/settings/version.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/archethic_theme_base.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_import_seed.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_new_wallet_get_first_infos.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/icon_network_warning.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/ui/widgets/dialogs/environment_dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/language_dialog.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroWelcome extends ConsumerStatefulWidget {
  const IntroWelcome({super.key});

  static const routerPage = '/intro_welcome';
  @override
  ConsumerState<IntroWelcome> createState() => _IntroWelcomeState();
}

class _IntroWelcomeState extends ConsumerState<IntroWelcome>
    implements SheetSkeletonInterface {
  bool cguChecked = false;

  @override
  Widget build(BuildContext context) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      backgroundImage: ArchethicTheme.backgroundWelcome,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    return _Footer(
      isConnectivityAvailable:
          connectivityStatusProvider == ConnectivityStatus.isConnected,
      cguChecked: cguChecked,
      onToggleCGU: (newValue) {
        setState(() {
          cguChecked = newValue!;
        });
      },
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    return SheetAppBar(
      title: '',
      widgetRight:
          connectivityStatusProvider == ConnectivityStatus.isDisconnected
              ? const Padding(
                  padding: EdgeInsets.only(
                    right: 7,
                    top: 7,
                  ),
                  child: IconNetworkWarning(
                    alignment: Alignment.topRight,
                  ),
                )
              : const _Language(),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    return const _Main();
  }
}

class _Language extends ConsumerWidget {
  const _Language();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 10, right: 10),
      child: IconButton(
        icon: Container(
          alignment: Alignment.center,
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: ArchethicThemeBase.blue600,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Symbols.translate,
            color: ArchethicTheme.iconDrawer,
            size: 20,
            weight: IconSize.weightM,
            opticalSize: IconSize.opticalSizeM,
            grade: IconSize.gradeM,
          ),
        ),
        onPressed: () async {
          await LanguageDialog.getDialog(context, ref);
        },
      ),
    );
  }
}

class _Main extends ConsumerWidget {
  const _Main();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _LogoArchethic(),
        _WelcomeTextFirst(),
        _WelcomeTextSecond(),
      ],
    );
  }
}

class _LogoArchethic extends ConsumerWidget {
  const _LogoArchethic();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: SizedBox(
        height: 200,
        child: AspectRatio(
          aspectRatio: 3 / 1,
          child: SvgPicture.asset(
            '${ArchethicTheme.assetsFolder}Archethic - Logo.svg',
            colorFilter: ColorFilter.mode(ArchethicTheme.text, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _WelcomeTextFirst extends ConsumerWidget {
  const _WelcomeTextFirst();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return AutoSizeText(
      localizations.welcomeText,
      maxLines: 3,
      style: ArchethicThemeStyles.textStyleSize20W700Primary,
    );
  }
}

class _WelcomeTextSecond extends ConsumerWidget {
  const _WelcomeTextSecond();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: AutoSizeText(
        localizations.welcomeText2,
        maxLines: 5,
        style: ArchethicThemeStyles.textStyleSize12W100Primary,
      ),
    );
  }
}

class _Footer extends ConsumerWidget {
  const _Footer({
    required this.isConnectivityAvailable,
    required this.cguChecked,
    required this.onToggleCGU,
  });

  final bool isConnectivityAvailable;
  final bool cguChecked;
  final Function(bool? newValue) onToggleCGU;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isConnectivityAvailable)
                  _CGU(
                    cguChecked: cguChecked,
                    onToggleCGU: onToggleCGU,
                  ),
                const _VersionInfo(),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        _ButtonNewWallet(
          cguChecked: cguChecked,
        ),
        _ButtonImportWallet(
          cguChecked: cguChecked,
        ),
      ],
    );
  }
}

class _CGU extends ConsumerWidget {
  const _CGU({
    required this.cguChecked,
    required this.onToggleCGU,
  });

  final bool cguChecked;
  final Function(bool? newValue) onToggleCGU;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: CheckboxListTile(
              title: InkWell(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(
                      'https://www.archethic.net/privacy-policy-wallet.html',
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  localizations.welcomeDisclaimerChoice,
                  style:
                      ArchethicThemeStyles.textStyleSize12W400UnderlinePrimary,
                ),
              ),
              value: cguChecked,
              onChanged: onToggleCGU,
              checkColor: ArchethicTheme.background,
              activeColor: ArchethicTheme.text,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionInfo extends ConsumerWidget {
  const _VersionInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Consumer(
            builder: (context, ref, child) {
              final asyncVersionString = ref.watch(
                versionStringProvider(
                  AppLocalizations.of(context)!,
                ),
              );

              return Text(
                asyncVersionString.asData?.value ?? '',
                textAlign: TextAlign.left,
                style: ArchethicThemeStyles.textStyleSize10W100Primary,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ButtonNewWallet extends ConsumerWidget {
  const _ButtonNewWallet({required this.cguChecked});

  final bool cguChecked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.newWallet,
          Dimens.buttonTopDimens,
          key: const Key('newWallet'),
          onPressed: () async {
            if (cguChecked) {
              await ref
                  .read(SettingsProviders.settings.notifier)
                  .setEnvironment(aedappfm.Environment.mainnet);

              context.go(
                IntroNewWalletGetFirstInfos.routerPage,
              );
            }
          },
          disabled: !cguChecked,
        ),
      ],
    );
  }
}

class _ButtonImportWallet extends ConsumerWidget {
  const _ButtonImportWallet({required this.cguChecked});

  final bool cguChecked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.importWallet,
          Dimens.buttonBottomDimens,
          key: const Key('importWallet'),
          onPressed: () async {
            if (cguChecked) {
              final environment =
                  await context.push(EnvironmentDialog.routerPage);
              if (environment != null) {
                await ref
                    .read(SettingsProviders.settings.notifier)
                    .setEnvironment(environment as aedappfm.Environment);
                await ref
                    .read(SettingsProviders.settings.notifier)
                    .setTestnetEnabled(
                      environment != aedappfm.Environment.mainnet,
                    );
              }
              context.go(IntroImportSeedPage.routerPage);
            }
          },
          disabled: !cguChecked,
        ),
      ],
    );
  }
}
