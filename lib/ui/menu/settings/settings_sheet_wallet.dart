/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'settings_sheet.dart';

class SettingsSheetWallet extends ConsumerWidget {
  const SettingsSheetWallet({super.key});

  static const String routerPage = '/settings';

  bool notNull(Object? o) => o != null;

  void showSecurity(BuildContext context) {
    context.push(SecurityMenuView.routerPage);
  }

  void showCustom(BuildContext context) {
    context.push(CustomizationMenuView.routerPage);
  }

  void showAbout(BuildContext context) {
    context.push(AboutMenuView.routerPage);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      drawerEdgeDragWidth: 0,
      resizeToAvoidBottomInset: false,
      backgroundColor: ArchethicTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: ArchethicTheme.brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: ClipRect(
        child: Stack(
          children: <Widget>[
            Container(
              color: ArchethicTheme.backgroundDark,
              constraints: const BoxConstraints.expand(),
            ),
            MainMenuView(
              showSecurity: () => showSecurity(context),
              showCustom: () => showCustom(context),
              showAbout: () => showAbout(context),
            ),
          ],
        ),
      ),
    );
  }
}
