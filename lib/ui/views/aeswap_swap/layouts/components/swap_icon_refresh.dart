import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/aeswap_swap/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class SwapTokenIconRefresh extends ConsumerStatefulWidget {
  const SwapTokenIconRefresh({
    super.key,
  });

  @override
  ConsumerState<SwapTokenIconRefresh> createState() =>
      _SwapTokenIconRefreshState();
}

class _SwapTokenIconRefreshState extends ConsumerState<SwapTokenIconRefresh> {
  bool? isRefreshSuccess;

  @override
  void initState() {
    super.initState();
    isRefreshSuccess = false;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return IconButton(
      icon: Icon(
        isRefreshSuccess != null && isRefreshSuccess == true
            ? Icons.check
            : aedappfm.Iconsax.refresh,
        size: 16,
        color: isRefreshSuccess != null && isRefreshSuccess == true
            ? Colors.white
            : null,
      ),
      onPressed: () async {
        if (isRefreshSuccess != null && isRefreshSuccess == true) return;
        setState(
          () {
            isRefreshSuccess = true;
          },
        );

        final swapNotifier = ref.read(swapFormNotifierProvider.notifier);
        final swap = ref.read(swapFormNotifierProvider);

        if (swap.tokenToSwap != null && swap.tokenSwapped != null) {
          await swapNotifier.calculateSwapInfos(
            swap.tokenToSwap!.isUCO ? kUCOAddress : swap.tokenToSwap!.address,
            swap.tokenToSwapAmount,
            true,
          );
          await swapNotifier.getRatio();
          await swapNotifier.getPool();
        }

        UIUtil.showSnackbar(
          localizations.swapRefreshDone,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
          icon: Symbols.info,
        );

        await Future.delayed(const Duration(seconds: 4));
        if (mounted) {
          setState(
            () {
              isRefreshSuccess = false;
            },
          );
        }
      },
    );
  }
}
