import 'package:aewallet/util/universal_platform.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class BridgeSheetFeatureFlagFalse extends StatelessWidget {
  const BridgeSheetFeatureFlagFalse({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 150,
      ),
      child: Column(
        children: [
          Text(
            UniversalPlatform.isMobile
                ? AppLocalizations.of(context)!.aeBridgeInfosTitleMobile
                : UniversalPlatform.isWeb
                    ? AppLocalizations.of(context)!.aeBridgeInfosTitleWeb
                    : AppLocalizations.of(context)!.aeBridgeInfosTitleDesktop,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            UniversalPlatform.isMobile
                ? AppLocalizations.of(context)!.aeBridgeInfosDetail1Mobile
                : UniversalPlatform.isWeb
                    ? AppLocalizations.of(context)!.aeBridgeInfosDetail1Web
                    : AppLocalizations.of(context)!.aeBridgeInfosDetail1Desktop,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              _launchURL('https://bridge.archethic.net');
            },
            child: Text(
              'https://bridge.archethic.net',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    decoration: TextDecoration.underline,
                    color: aedappfm.AppThemeBase.secondaryColor,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            UniversalPlatform.isMobile
                ? AppLocalizations.of(context)!.aeBridgeInfosDetail2Mobile
                : UniversalPlatform.isWeb
                    ? AppLocalizations.of(context)!.aeBridgeInfosDetail2Web
                    : AppLocalizations.of(context)!.aeBridgeInfosDetail2Desktop,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
