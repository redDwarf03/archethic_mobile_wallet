import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorerButton extends ConsumerWidget {
  const ExplorerButton({required this.address, super.key});

  final String address;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final localizations = AppLocalizations.of(context)!;
    return AppButtonTinyConnectivity(
      localizations.explorer,
      Dimens.buttonBottomDimens,
      key: const Key('share'),
      onPressed: () async {
        await launchUrl(
          Uri.parse(
            '${ref.read(environmentProvider).endpoint}/explorer/chain?address=$address',
          ),
          mode: LaunchMode.externalApplication,
        );
      },
    );
  }
}
