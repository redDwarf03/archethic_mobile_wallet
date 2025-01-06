import 'package:aewallet/application/dapps/dapps.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DAppSheetIconRefresh extends ConsumerWidget {
  factory DAppSheetIconRefresh({
    required String dappKey,
    String? featureCode,
  }) =>
      DAppSheetIconRefresh._(
        dappKey: dappKey,
        featureCode: featureCode,
        key: Key(dappKey),
      );
  const DAppSheetIconRefresh._({
    required this.dappKey,
    this.featureCode,
    super.key,
  });

  final String dappKey;
  final String? featureCode;

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
          getDAppProvider(dappKey).future,
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
