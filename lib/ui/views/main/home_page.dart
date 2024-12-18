import 'dart:async';
import 'dart:core';
import 'dart:ui';

import 'package:aewallet/application/migrations/migration_manager.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/local_data_migration_widget.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/aeswap_earn/layouts/earn_tab.dart';
import 'package:aewallet/ui/views/aeswap_swap/layouts/swap_tab.dart';
import 'package:aewallet/ui/views/main/account_tab.dart';
import 'package:aewallet/ui/views/main/bloc/providers.dart';
import 'package:aewallet/ui/views/main/components/home_providers_keepalive.dart';
import 'package:aewallet/ui/views/main/components/main_appbar.dart';
import 'package:aewallet/ui/views/main/components/recovery_phrase_banner.dart';
import 'package:aewallet/ui/views/main/transactions_tab.dart';
import 'package:aewallet/ui/views/sheets/bridge_sheet_feature_flag_false.dart';
import 'package:aewallet/ui/views/sheets/dapp_sheet.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/ui/widgets/tab_item.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routerPage = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin
    implements SheetSkeletonInterface {
  int tabCount = 4;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(mainTabControllerProvider.notifier).initState(this);

      ref.read(mainTabControllerProvider)!.animateTo(
            ref.read(SettingsProviders.settings).mainScreenCurrentPage,
            duration: Duration.zero,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeProvidersKeepalive(
      child: SheetSkeleton(
        appBar: getAppBar(context, ref),
        bottomNavigationBar: getFloatingActionButton(context, ref),
        sheetContent: getSheetContent(context, ref),
        menu: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    return const MainAppBar();
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(mainTabControllerProvider);
    if (tabController == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            child: TabBar(
              dividerColor: Colors.transparent,
              controller: tabController,
              labelColor: ArchethicTheme.text,
              indicatorColor: ArchethicTheme.text,
              labelPadding: EdgeInsets.zero,
              onTap: (selectedIndex) async {
                unawaited(
                  ref
                      .read(SettingsProviders.settings.notifier)
                      .setMainScreenCurrentPage(selectedIndex),
                );
              },
              tabs: [
                TabItem(
                  icon: Symbols.account_box,
                  label: AppLocalizations.of(context)!.bottomMainMenuAccounts,
                ),
                TabItem(
                  icon: Symbols.schedule,
                  label:
                      AppLocalizations.of(context)!.bottomMainMenuTransactions,
                ),
                TabItem(
                  icon: aedappfm.Iconsax.arrange_circle_2,
                  label: AppLocalizations.of(context)!.bottomMainMenuSwap,
                ),
                TabItem(
                  icon: aedappfm.Iconsax.wallet_add,
                  label: AppLocalizations.of(context)!.bottomMainMenuEarn,
                ),
                TabItem(
                  icon: aedappfm.Iconsax.recovery_convert,
                  label: AppLocalizations.of(context)!.bottomMainMenuBridge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final tabController = ref.watch(mainTabControllerProvider);
    if (tabController == null) {
      return Container();
    }

    final localDataMigration =
        ref.watch(LocalDataMigrationProviders.localDataMigration);
    if (localDataMigration.migrationInProgress) {
      return const LocalDataMigrationWidget();
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ArchethicTheme.backgroundSmall,
          ),
          fit: BoxFit.fitHeight,
          alignment: Alignment.centerRight,
          opacity: 0.7,
        ),
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          const Stack(
            alignment: Alignment.topCenter,
            children: [
              AccountTab(),
              Positioned(
                bottom: 0,
                child: RecoveryPhraseBanner(),
              ),
            ],
          ),
          const TransactionsTab(),
          const SwapTab(),
          const EarnTab(),
          DAppSheet(
            dappKey: 'aeBridge',
            featureCode: 'bridge',
            launchMessage: AppLocalizations.of(context)!.aeBridgeLaunchMessage,
            launchButtonLabel:
                AppLocalizations.of(context)!.aeBridgeLaunchButton,
            featureFlagFalseWidget: const BridgeSheetFeatureFlagFalse(),
          ),
        ],
      ),
    );
  }
}

class ExpandablePageView extends ConsumerStatefulWidget {
  const ExpandablePageView({
    super.key,
    @required this.children,
  });
  final List<Widget>? children;

  @override
  ConsumerState<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends ConsumerState<ExpandablePageView>
    with TickerProviderStateMixin {
  PageController? _pageController;
  late List<double> _heights;
  int _currentPage = 0;

  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children!.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        final newPage = _pageController!.page!.round();
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
        }
      });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final session = ref.watch(sessionNotifierProvider).loggedIn;
    if (session == null) return const SizedBox();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: 80,
            child: TabBar(
              labelColor: ArchethicTheme.text,
              indicatorColor: ArchethicTheme.text,
              labelPadding: EdgeInsets.zero,
              tabs: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      key: const Key('fungibleTokenTab'),
                      localizations.tokensHeader,
                      style: ArchethicThemeStyles.textStyleSize14W600Primary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.nft,
                      style: ArchethicThemeStyles.textStyleSize14W600Primary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
              onTap: (index) {
                _pageController!.jumpToPage(index);
              },
            ),
          ),
          TweenAnimationBuilder<double>(
            curve: Curves.easeInOutCubic,
            duration: const Duration(milliseconds: 100),
            tween: Tween<double>(begin: _heights[0], end: _currentHeight),
            builder: (context, value, child) =>
                SizedBox(height: value, child: child),
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: _sizeReportingChildren
                  .asMap() //
                  .map(MapEntry.new)
                  .values
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children!
      .asMap() //
      .map(
        (index, child) => MapEntry(
          index,
          OverflowBox(
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: SizeReportingWidget(
              onSizeChange: (size) =>
                  setState(() => _heights[index] = size.height),
              child: Align(child: child),
            ),
          ),
        ),
      )
      .values
      .toList();
}

class SizeReportingWidget extends StatefulWidget {
  const SizeReportingWidget({
    super.key,
    required this.child,
    required this.onSizeChange,
  });
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  final _widgetKey = GlobalKey();
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: Container(
          key: _widgetKey,
          child: widget.child,
        ),
      ),
    );
  }

  void _notifySize() {
    final context = _widgetKey.currentContext;
    if (context == null) return;
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      widget.onSizeChange(size!);
    }
  }
}
