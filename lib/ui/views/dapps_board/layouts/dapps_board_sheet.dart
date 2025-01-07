import 'dart:ui';

import 'package:aewallet/application/dapps/dapps.dart';
import 'package:aewallet/application/dapps/my_dapps.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/dapps_board/layouts/dapps_board_webview.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DAppsBoardSheet extends ConsumerWidget implements SheetSkeletonInterface {
  const DAppsBoardSheet({super.key});

  static const routerPage = '/dapps_board';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(localizations.dappBoardDisclaimer),
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.dappBoardTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final dAppsFromNetwork = ref.watch(getDAppsFromNetworkProvider);
    final myDapps = ref.watch(getMyDAppsProvider);
    final localizations = AppLocalizations.of(context)!;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            myDapps.when(
              data: (dApps) {
                return _dAppsList(
                  context,
                  dApps,
                  localizations.dappBoardMySelectionTitle,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const SizedBox(),
            ),
            const SizedBox(
              height: 20,
            ),
            dAppsFromNetwork.when(
              data: (dApps) {
                dApps.removeWhere((item) => item.name == null);
                return _dAppsList(
                  context,
                  dApps,
                  localizations.dappBoardArchethicSelectionTitle,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const SizedBox(),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dAppsList(BuildContext context, List<DApp> dAppsList, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dAppsList.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              title,
              style: AppTextStyles.bodyMedium(context),
            ),
          ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dAppsList.length,
          itemBuilder: (context, index) {
            final dApp = dAppsList[index];
            return Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: ArchethicTheme.backgroundFungiblesTokensListCard,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
              color: ArchethicTheme.backgroundFungiblesTokensListCard,
              child: ListTile(
                leading: dApp.iconUrl == null
                    ? null
                    : SizedBox(
                        width: 25,
                        height: 25,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(dApp.iconUrl!),
                        ),
                      ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dApp.name!,
                      style: AppTextStyles.bodyLarge(context),
                    ),
                    Text(
                      dApp.description ?? '',
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    Text(
                      dApp.url,
                      style: AppTextStyles.bodySmallSecondaryColor(
                        context,
                      ),
                    ),
                  ],
                ),
                onTap: () async {
                  await context.push(
                    DAppsBoardWebview.routerPage,
                    extra: {
                      'url': dApp.url,
                      'name': dApp.name,
                      'code': dApp.code,
                      'iconUrl': dApp.iconUrl,
                      'description': dApp.description,
                      'category': dApp.category,
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
