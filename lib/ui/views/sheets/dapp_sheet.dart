import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/dapps/dapps.dart';
import 'package:aewallet/application/feature_flags.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/main.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

enum DAppUnavaibleCause {
  featureNotSupported,
  disabled,
}

typedef FeatureUnavailableBuilder = Widget Function(
  DAppUnavaibleCause unavailabilityCause,
  DApp dapp,
)?;

class DAppSheet extends ConsumerStatefulWidget {
  factory DAppSheet({
    required String dappKey,
    String? launchMessage,
    String? launchButtonLabel,
  }) =>
      DAppSheet._(
        dappKey: dappKey,
        launchMessage: launchMessage,
        launchButtonLabel: launchButtonLabel,
        key: Key(dappKey),
      );

  factory DAppSheet.withFeatureFlag({
    required String dappKey,
    required String featureCode,
    required FeatureUnavailableBuilder featureUnavailableBuilder,
    String? launchMessage,
    String? launchButtonLabel,
  }) =>
      DAppSheet._(
        dappKey: dappKey,
        featureCode: featureCode,
        launchMessage: launchMessage,
        launchButtonLabel: launchButtonLabel,
        featureUnavailableBuilder: featureUnavailableBuilder,
        key: Key(dappKey),
      );

  const DAppSheet._({
    required this.dappKey,
    this.featureCode,
    this.launchMessage,
    this.launchButtonLabel,
    this.featureUnavailableBuilder,
    super.key,
  });

  final String dappKey;
  final String? featureCode;
  final String? launchMessage;
  final String? launchButtonLabel;
  final FeatureUnavailableBuilder? featureUnavailableBuilder;

  @override
  ConsumerState<DAppSheet> createState() => DAppSheetState();
}

class DAppSheetState extends ConsumerState<DAppSheet>
    with AutomaticKeepAliveClientMixin {
  DApp? dapp;
  DAppUnavaibleCause? unavailabilityCause;

  @override
  bool get wantKeepAlive => true;

  Future<bool> checkIsSupported() async {
    if (!AWCWebview.isAvailable) return false;
    if (!await AWCWebview.isAWCSupported) return false;
    return true;
  }

  Future<bool> checkShouldUseExternalBrowser() async {
    final featureCode = widget.featureCode;

    if (featureCode == null) return false;

    final flag = await ref.watch(
      getFeatureFlagProvider(
        kApplicationCode,
        featureCode,
      ).future,
    );

    if (flag == null) return true;
    return !flag;
  }

  Future<DAppUnavaibleCause?> checkUnavailabilityCause() async {
    if (!await checkIsSupported()) {
      return DAppUnavaibleCause.featureNotSupported;
    }
    if (await checkShouldUseExternalBrowser()) {
      return DAppUnavaibleCause.disabled;
    }
    return null;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
      if (connectivityStatusProvider != ConnectivityStatus.isConnected) return;

      final _unavailabilityCause = await checkUnavailabilityCause();

      final dappKey = _unavailabilityCause == null
          ? widget.dappKey
          : '${widget.dappKey}Ext';

      final dapp = await ref.read(
        getDAppProvider(dappKey).future,
      );
      setState(() {
        unavailabilityCause = _unavailabilityCause;
        this.dapp = dapp;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (unavailabilityCause != null) {
      return widget.featureUnavailableBuilder!(unavailabilityCause!, dapp!);
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
                      await launchUrl(Uri.parse(dapp!.url));
                    },
                    disabled: dapp?.url == null,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return SafeArea(
      child: Builder(
        builder: (context) {
          if (dapp == null) {
            return const Center(child: LoadingListHeader());
          }

          return AWCWebview(
            uri: Uri.parse(dapp!.url),
          );
        },
      ),
    );
  }
}
