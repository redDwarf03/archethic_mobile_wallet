import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainAppBarTransactions extends ConsumerWidget {
  const MainAppBarTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final keychain = ref.watch(
      sessionNotifierProvider.select(
        (value) => value.loggedIn?.wallet.appKeychain,
      ),
    );

    return InkWell(
      onTap: () {
        Clipboard.setData(
          ClipboardData(
            text: keychain?.address.toUpperCase() ?? '',
          ),
        );
        UIUtil.showSnackbar(
          localizations.keychainAddressCopied,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
          icon: Symbols.info,
        );
      },
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: AutoSizeText(
          localizations.transactionHeader,
          style: ArchethicThemeStyles.textStyleSize24W700Primary,
        ),
      ).animate().fade(duration: const Duration(milliseconds: 300)),
    );
  }
}
