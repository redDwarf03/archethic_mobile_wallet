import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/dapps.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/sheets/unavailable_feature_warning.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DAppSheet extends ConsumerStatefulWidget {
  const DAppSheet({
    required this.dappKey,
    super.key,
  });

  final String dappKey;

  static bool get isAvailable => AWCWebview.isAvailable;
  static const String routerPage = '/dex';

  @override
  ConsumerState<DAppSheet> createState() => DAppSheetState();
}

class DAppSheetState extends ConsumerState<DAppSheet> {
  String? aeBridgeUrl;
  @override
  void initState() {
    var dappKey = widget.dappKey;
    if (!DAppSheet.isAvailable) dappKey = '${dappKey}Ext';

    Future.delayed(Duration.zero, () async {
      final networkSettings = ref.watch(
        SettingsProviders.settings.select((settings) => settings.network),
      );

      final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
      DApp? dapp;
      if (connectivityStatusProvider == ConnectivityStatus.isConnected) {
        dapp = await ref.read(
          DAppsProviders.getDApp(networkSettings.network, dappKey).future,
        );

        setState(() {
          aeBridgeUrl = dapp!.url;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (UniversalPlatform.isDesktopOrWeb) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  ArchethicScrollbar(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        bottom: 80,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .aeBridgeLaunchMessage,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Row(
                children: [
                  AppButtonTinyConnectivity(
                    AppLocalizations.of(context)!.aeBridgeLaunchButton,
                    Dimens.buttonBottomDimens,
                    key: const Key('LaunchApplication'),
                    onPressed: () async {
                      await launchUrl(Uri.parse(aeBridgeUrl!));
                    },
                    disabled: aeBridgeUrl == null,
                  ),
                ],
              ),
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
          if (aeBridgeUrl == null) {
            return const Center(child: LoadingListHeader());
          }

          if (!isAWCSupported) {
            return UnavailableFeatureWarning(
              title: localizations.webChannelIncompatibilityWarning,
              description: localizations.webChannelIncompatibilityWarningDesc,
            );
          }

          return AWCWebview(
            uri: Uri.parse(aeBridgeUrl!),
          );
        },
      ),
    );
  }
}
