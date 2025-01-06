import 'package:aewallet/application/dapps/my_dapp_notifier.dart';
import 'package:aewallet/application/dapps/my_dapps.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class DAppSheetIconFavorite extends ConsumerStatefulWidget {
  const DAppSheetIconFavorite({
    super.key,
    required this.dapp,
  });

  final DApp dapp;

  @override
  ConsumerState<DAppSheetIconFavorite> createState() =>
      DAppSheetIconFavoriteState();
}

class DAppSheetIconFavoriteState extends ConsumerState<DAppSheetIconFavorite> {
  @override
  Widget build(
    BuildContext context,
  ) {
    if (Uri.tryParse(widget.dapp.url) == null) return const SizedBox.shrink();

    return ref.watch(getMyDAppProvider(widget.dapp.url)).when(
      data: (data) {
        return IconButton(
          icon: Icon(
            data == null ? Symbols.heart_plus : Symbols.heart_minus,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () async {
            if (data == null) {
              await ref
                  .read(myDAppNotifierProvider(widget.dapp.url).notifier)
                  .addMyDApp(widget.dapp);
              UIUtil.showSnackbar(
                AppLocalizations.of(context)!.dappBoardMyDAppFavoriteAdd,
                context,
                ref,
                ArchethicTheme.text,
                ArchethicTheme.snackBarShadow,
                icon: Symbols.info,
              );
            } else {
              await ref
                  .read(myDAppNotifierProvider(widget.dapp.url).notifier)
                  .removeMyDApp();
              UIUtil.showSnackbar(
                AppLocalizations.of(context)!.dappBoardMyDAppFavoriteRemove,
                context,
                ref,
                ArchethicTheme.text,
                ArchethicTheme.snackBarShadow,
                icon: Symbols.info,
              );
            }
            ref.invalidate(getMyDAppProvider(widget.dapp.url));
          },
        );
      },
      error: (error, stack) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}
