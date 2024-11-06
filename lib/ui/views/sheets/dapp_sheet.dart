import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/dapps.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/sheets/unavailable_feature_warning.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
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
  String? aeSwapUrl;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final networkSettings = ref.watch(
        SettingsProviders.settings.select((settings) => settings.network),
      );

      final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
      DApp? dapp;
      if (connectivityStatusProvider == ConnectivityStatus.isConnected) {
        dapp = await ref.read(
          DAppsProviders.getDApp(networkSettings.network, widget.dappKey)
              .future,
        );

        setState(() {
          // aeSwapUrl = 'https://bridge.testnet.archethic.net?isEmbedded';
          aeSwapUrl = 'http://192.168.1.22:8081?isEmbedded';
          // aeSwapUrl = '${dapp!.url}?isEmbedded';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktopOrWeb) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.aeSwapLaunchMessage,
              ),
              SizedBox(
                height: 55,
                child: AppButtonTiny(
                  AppButtonTinyType.primary,
                  AppLocalizations.of(context)!.aeSwapLaunchButton,
                  Dimens.buttonBottomDimens,
                  key: const Key('LaunchApplication'),
                  onPressed: aeSwapUrl != null
                      ? () async {
                          await launchUrl(Uri.parse(aeSwapUrl!));
                        }
                      : null,
                  disabled: aeSwapUrl == null,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: FutureBuilder<bool>(
          future: AWCWebview.isAWCSupported,
          builder: (context, snapshot) {
            final isAWCSupported = snapshot.data;
            if (isAWCSupported == null) {
              return const Center(child: LoadingListHeader());
            }
            if (aeSwapUrl == null) {
              return const Center(child: LoadingListHeader());
            }

            if (!isAWCSupported) return const UnavailableFeatureWarning();

            return AWCWebview(
              uri: Uri.parse(aeSwapUrl!),
            );
          },
        ),
      );
    }
  }
}
