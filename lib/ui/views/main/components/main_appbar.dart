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
import 'package:aewallet/ui/views/sheets/dapp_sheet_icon_refresh.dart';
import 'package:aewallet/ui/widgets/components/icon_network_warning.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    final tab = preferences.mainScreenTab;

    return switch (tab) {
      MainScreenTab.accountTab => _MainAppBar(
          key: const Key('account'),
          actions: [
            _BalanceVisibilityButton(preferences: preferences),
          ],
          title: const MainAppBarAccount(),
        ),
      MainScreenTab.transactionTab => _MainAppBar(
          key: const Key('transaction'),
          actions: [
            _BalanceVisibilityButton(preferences: preferences),
          ],
          title: const MainAppBarTransactions(),
        ),
      MainScreenTab.swapTab => _MainAppBar(
          key: const Key('swap'),
          actions: const [
            SwapTokenIconRefresh(),
          ],
          title: MainAppBarBasic(header: localizations.swapHeader),
        ),
      MainScreenTab.earnTab => _MainAppBar(
          key: const Key('earn'),
          actions: const [],
          title: MainAppBarBasic(header: localizations.aeSwapEarnHeader),
        ),
      MainScreenTab.bridgeTab => _MainAppBar(
          key: const Key('bridge'),
          actions: [
            DAppSheetIconRefresh(dappKey: 'aeBridge'),
          ],
          title: MainAppBarBasic(
            header: localizations.aeBridgeHeader,
          ),
        ),
    };
  }
}

class _BalanceVisibilityButton extends ConsumerWidget {
  const _BalanceVisibilityButton({
    required this.preferences,
  });

  final Settings preferences;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        preferences.showBalances ? Symbols.visibility : Symbols.visibility_off,
        weight: IconSize.weightM,
        opticalSize: IconSize.opticalSizeM,
        grade: IconSize.gradeM,
      ),
      onPressed: () async {
        final preferencesNotifier =
            ref.read(SettingsProviders.settings.notifier);
        await preferencesNotifier.setShowBalances(!preferences.showBalances);
      },
    );
  }
}

class _MainAppBar extends ConsumerWidget {
  const _MainAppBar({
    super.key,
    required this.actions,
    required this.title,
  });

  final List<Widget> actions;
  final Widget title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);

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
        ...actions,
        if (connectivityStatusProvider == ConnectivityStatus.isDisconnected)
          const IconNetworkWarning(),
      ],
      title: title,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ArchethicTheme.text),
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
