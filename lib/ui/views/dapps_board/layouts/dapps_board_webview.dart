import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/rpc/awc_webview.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/views/sheets/dapp_sheet_icon_favorite.dart';
import 'package:aewallet/ui/views/sheets/dapp_sheet_icon_refresh.dart';
import 'package:aewallet/ui/views/sheets/unavailable_feature_warning.dart';
import 'package:aewallet/ui/widgets/components/loading_list_header.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DAppsBoardWebview extends ConsumerWidget
    implements SheetSkeletonInterface {
  const DAppsBoardWebview({
    required this.dappUrl,
    required this.dappName,
    required this.dappCode,
    this.deeplink,
    this.dappIconUrl,
    this.dappDescription,
    this.dappCategory,
    super.key,
  });

  static const routerPage = '/dapps_webview';

  final String dappUrl;
  final String dappName;
  final String dappCode;
  final bool? deeplink;
  final String? dappIconUrl;
  final String? dappDescription;
  final String? dappCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      menu: true,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    return const SizedBox();
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    return SheetAppBar(
      title: dappName,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          if (deeplink != null) {
            context.go(HomePage.routerPage);
            return;
          }
          context.pop();
        },
      ),
      widgetRight: Row(
        children: [
          DAppSheetIconFavorite(
            dapp: DApp(
              code: dappCode,
              name: dappName,
              url: dappUrl,
              category: dappCategory,
              description: dappDescription,
              iconUrl: dappIconUrl,
            ),
          ),
          DAppSheetIconRefresh(dappKey: dappCode),
        ],
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<bool>(
              future: AWCWebview.isAWCSupported,
              builder: (context, snapshot) {
                final isAWCSupported = snapshot.data;
                if (isAWCSupported == null) {
                  return const Center(child: LoadingListHeader());
                }

                if (!isAWCSupported) {
                  return UnavailableFeatureWarning(
                    title: localizations.webChannelIncompatibilityWarning,
                    description:
                        localizations.webChannelIncompatibilityWarningDesc,
                  );
                }

                return AWCWebview(
                  uri: Uri.parse(dappUrl),
                );
              },
            ),
          ),
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(AppLocalizations.of(context)!.dappBoardDisclaimer),
            ),
          ),
        ],
      ),
    );
  }
}
