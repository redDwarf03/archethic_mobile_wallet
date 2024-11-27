import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/dapps.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/sheets/unavailable_feature_warning.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/haptic_util.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:url_launcher/url_launcher.dart';

class DEXSheet extends ConsumerStatefulWidget {
  const DEXSheet({
    required this.dappKey,
    super.key,
  });

  final String dappKey;

  static bool get isAvailable => AWCWebview.isAvailable;
  static const String routerPage = '/dex';

  @override
  ConsumerState<DEXSheet> createState() => DEXSheetState();
}

class DEXSheetState extends ConsumerState<DEXSheet> {
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
          aeSwapUrl = dapp!.url;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktopOrWeb) {
      final preferences = ref.watch(SettingsProviders.settings);
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
                          sl.get<HapticUtil>().feedback(
                                FeedbackType.light,
                                preferences.activeVibrations,
                              );
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
        bottom: false,
        child: FutureBuilder<bool>(
          future: AWCWebview.isAWCSupported,
          builder: (context, snapshot) {
            final isAWCSupported = snapshot.data;
            if (isAWCSupported == null) {
              return const Center(child: LoadingListHeader());
            }

            if (!isAWCSupported) return const UnavailableFeatureWarning();

            if (aeSwapUrl != null) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: AWCWebview(
                  uri: Uri.parse(aeSwapUrl!),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      );
    }
  }
}
