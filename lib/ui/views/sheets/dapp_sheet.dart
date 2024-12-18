import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/dapps.dart';
import 'package:aewallet/application/feature_flags.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/main.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/sheets/unavailable_feature_warning.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class DAppSheet extends ConsumerStatefulWidget {
  factory DAppSheet({
    required String dappKey,
    String? featureCode,
    String? launchMessage,
    String? launchButtonLabel,
    Widget? featureFlagFalseWidget,
  }) =>
      DAppSheet._(
        dappKey: dappKey,
        featureCode: featureCode,
        launchMessage: launchMessage,
        launchButtonLabel: launchButtonLabel,
        featureFlagFalseWidget: featureFlagFalseWidget,
        key: Key(dappKey),
      );

  const DAppSheet._({
    required this.dappKey,
    this.featureCode,
    this.launchMessage,
    this.launchButtonLabel,
    this.featureFlagFalseWidget,
    super.key,
  });

  final String dappKey;
  final String? featureCode;
  final String? launchMessage;
  final String? launchButtonLabel;
  final Widget? featureFlagFalseWidget;

  static bool get isAvailable => AWCWebview.isAvailable;

  @override
  ConsumerState<DAppSheet> createState() => DAppSheetState();
}

class DAppSheetState extends ConsumerState<DAppSheet>
    with AutomaticKeepAliveClientMixin {
  String? dappUrl;
  bool? featureFlags;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var dappKey = widget.dappKey;

      if (widget.featureCode != null) {
        final _featureFlag = await ref.watch(
          getFeatureFlagProvider(
            kApplicationCode,
            widget.featureCode!,
          ).future,
        );
        if (_featureFlag == null ||
            _featureFlag == false ||
            !DAppSheet.isAvailable) {
          dappKey = '${dappKey}Ext';
        }
        setState(() {
          featureFlags = _featureFlag;
        });
      }

      final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
      DApp? dapp;
      if (connectivityStatusProvider == ConnectivityStatus.isConnected) {
        dapp = await ref.read(
          getDAppProvider(dappKey).future,
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

    if (widget.featureFlagFalseWidget != null &&
        featureFlags != null &&
        featureFlags == false) {
      return widget.featureFlagFalseWidget ?? const SizedBox.shrink();
    }

    if (UniversalPlatform.isDesktopOrWeb) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  aedappfm.ArchethicScrollbar(
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
                                  widget.launchMessage ??
                                      AppLocalizations.of(context)!
                                          .dAppLaunchMessage,
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
                    widget.launchButtonLabel ??
                        AppLocalizations.of(context)!.dAppLaunchButton,
                    Dimens.buttonBottomDimens,
                    key: const Key('LaunchApplication'),
                    onPressed: () async {
                      await launchUrl(Uri.parse(dappUrl!));
                    },
                    disabled: dappUrl == null,
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
          if (isAWCSupported == null || dappUrl == null) {
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
