import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/dapps.dart';
import 'package:aewallet/application/feature_flags.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/sheets/bridge_sheet_feature_flag_false.dart';
import 'package:aewallet/ui/views/sheets/unavailable_feature_warning.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DAppSheetIconRefresh extends ConsumerWidget {
  factory DAppSheetIconRefresh({required String dappKey}) =>
      DAppSheetIconRefresh._(
        dappKey: dappKey,
        key: Key(dappKey),
      );
  const DAppSheetIconRefresh._({
    required this.dappKey,
    super.key,
  });

  final String dappKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(
        aedappfm.Iconsax.refresh,
        size: 16,
        color: Colors.white,
      ),
      onPressed: () async {
        final dapp = await ref.read(
          DAppsProviders.getDApp(dappKey).future,
        );
        if (dapp == null) return;
        final webviewController =
            AWCWebviewControllers.find(Uri.parse(dapp.url));
        if (webviewController == null) return;

        if (await webviewController.isLoading()) return;
        await webviewController.reload();
      },
    );
  }
}

class DAppSheet extends ConsumerStatefulWidget {
  factory DAppSheet({required String dappKey}) => DAppSheet._(
        dappKey: dappKey,
        key: Key(dappKey),
      );

  const DAppSheet._({
    required this.dappKey,
    super.key,
  });

  final String dappKey;

  static bool get isAvailable => AWCWebview.isAvailable;
  static const String routerPage = '/dex';

  @override
  ConsumerState<DAppSheet> createState() => DAppSheetState();
}

class DAppSheetState extends ConsumerState<DAppSheet>
    with AutomaticKeepAliveClientMixin {
  String? dappUrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var dappKey = widget.dappKey;

      final networkSettings = ref.watch(
        SettingsProviders.settings.select((settings) => settings.network),
      );

      final bridgeFlag = await ref.watch(
        getFeatureFlagProvider(
          networkSettings.network,
          applicationCode,
          featureCode,
        ).future,
      );
      if (bridgeFlag == null || bridgeFlag == false || !DAppSheet.isAvailable) {
        dappKey = '${dappKey}Ext';
      }

      final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
      DApp? dapp;
      if (connectivityStatusProvider == ConnectivityStatus.isConnected) {
        dapp = await ref.read(
          DAppsProviders.getDApp(dappKey).future,
        );
        setState(() {
          dappUrl = dapp!.url;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizations = AppLocalizations.of(context)!;

    if (featureFlags != null && featureFlags == false) {
      return const BridgeSheetFeatureFlagFalse();
    }

    if (UniversalPlatform.isDesktopOrWeb) {

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.dAppLaunchMessage,
              ),
              SizedBox(
                height: 55,
                child: AppButtonTiny(
                  AppButtonTinyType.primary,
                  AppLocalizations.of(context)!.dAppLaunchButton,
                  Dimens.buttonBottomDimens,
                  key: const Key('LaunchApplication'),
                  onPressed: dappUrl != null
                      ? () async {
                          await launchUrl(Uri.parse(dappUrl!));
                        }
                      : null,
                  disabled: dappUrl == null,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 55,
            child: AppButtonTiny(
              AppButtonTinyType.primary,
              AppLocalizations.of(context)!.aeSwapLaunchButton,
              Dimens.buttonBottomDimens,
              key: const Key('LaunchApplication'),
              onPressed: dappUrl != null
                  ? () async {
                      await launchUrl(Uri.parse(dappUrl!));
                    }
                  : null,
              disabled: dappUrl == null,
            ),
          ),
        ],
      );
    }

    if (!DAppSheet.isAvailable) {
      return SafeArea(
        child: UnavailableFeatureWarning(
          title: localizations.androidWebViewIncompatibilityWarning,
          description: localizations.androidWebViewIncompatibilityWarningDesc,
        ),
      );
    }

    return SafeArea(
      child: FutureBuilder<bool>(
        future: AWCWebview.isAWCSupported,
        builder: (context, snapshot) {
          final isAWCSupported = snapshot.data;
          if (isAWCSupported == null) {
            return const Center(child: LoadingListHeader());
          }
          if (dappUrl == null) {
            return const Center(child: LoadingListHeader());
          }

          if (!isAWCSupported) {
            return UnavailableFeatureWarning(
              title: localizations.webChannelIncompatibilityWarning,
              description: localizations.webChannelIncompatibilityWarningDesc,
            );
          }

          return AWCWebview(
            uri: Uri.parse(dappUrl!),
          );
        },
      ),
    );
  }
}
