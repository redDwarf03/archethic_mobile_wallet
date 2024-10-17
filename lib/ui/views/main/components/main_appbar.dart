/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:ui';

import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/settings.dart';
import 'package:aewallet/ui/menu/settings/settings_sheet.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/aeswap_swap/layouts/components/swap_icon_refresh.dart';
import 'package:aewallet/ui/views/main/components/main_appbar_account.dart';
import 'package:aewallet/ui/views/main/components/main_appbar_basic.dart';
import 'package:aewallet/ui/views/main/components/main_appbar_transactions.dart';
import 'package:aewallet/ui/widgets/components/icon_network_warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final preferences = ref.watch(SettingsProviders.settings);
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    if (preferences.mainScreenCurrentPage == 4) {
      return const _MainAppbarForWebView();
    }

    return AppBar(
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      systemOverlayStyle: ArchethicTheme.brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      automaticallyImplyLeading: false,
      leading: const _MenuButton(),
      actions: [
        if (preferences.mainScreenCurrentPage ==
                MainScreenTab.accountTab.index ||
            preferences.mainScreenCurrentPage ==
                MainScreenTab.transactionTab.index)
          IconButton(
            icon: Icon(
              preferences.showBalances
                  ? Symbols.visibility
                  : Symbols.visibility_off,
              weight: IconSize.weightM,
              opticalSize: IconSize.opticalSizeM,
              grade: IconSize.gradeM,
            ),
            onPressed: () async {
              final preferencesNotifier =
                  ref.read(SettingsProviders.settings.notifier);
              await preferencesNotifier
                  .setShowBalances(!preferences.showBalances);
            },
          )
        else if (preferences.mainScreenCurrentPage ==
            MainScreenTab.swapTab.index)
          const SwapTokenIconRefresh(),
        if (connectivityStatusProvider == ConnectivityStatus.isDisconnected)
          const IconNetworkWarning(),
      ],
      title: preferences.mainScreenCurrentPage == MainScreenTab.accountTab.index
          ? const MainAppBarAccount()
          : preferences.mainScreenCurrentPage ==
                  MainScreenTab.transactionTab.index
              ? const MainAppBarTransactions()
              : preferences.mainScreenCurrentPage == MainScreenTab.swapTab.index
                  ? MainAppBarBasic(header: localizations.swapHeader)
                  : preferences.mainScreenCurrentPage ==
                          MainScreenTab.earnTab.index
                      ? MainAppBarBasic(header: localizations.aeSwapEarnHeader)
                      : MainAppBarBasic(header: localizations.aeBridgeHeader),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ArchethicTheme.text),
    );
  }
}

/// AppBar containing only the menu button.
/// Useful for webview screens.
class _MainAppbarForWebView extends ConsumerWidget {
  const _MainAppbarForWebView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Align(
              child: Text(
                localizations.aeBridgeHeader,
                style: ArchethicThemeStyles.textStyleSize24W700Primary,
              ).animate().fade(duration: const Duration(milliseconds: 300)),
            ),
          ),
          const Positioned(
            left: 5,
            child: _MenuButton(),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends ConsumerWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
        icon: const Icon(
          Symbols.menu,
          weight: IconSize.weightM,
          opticalSize: IconSize.opticalSizeM,
          grade: IconSize.gradeM,
        ),
        onPressed: () {
          context.push(SettingsSheetWallet.routerPage);
        },
      );
}
