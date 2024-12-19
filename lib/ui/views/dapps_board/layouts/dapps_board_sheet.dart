import 'dart:ui';

import 'package:aewallet/application/dapps.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/sheets/dapp_sheet.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
    return const SizedBox();
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
    final networkSettings = ref.watch(
      SettingsProviders.settings.select((settings) => settings.network),
    );
    final dAppsFromNetwork =
        ref.watch(getDAppsFromNetworkProvider(networkSettings.network));

    return dAppsFromNetwork.when(
      data: (dApps) {
        dApps.removeWhere((item) => item.name == null);

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
              children: <Widget>[
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dApps.length,
                  itemBuilder: (context, index) {
                    final dApp = dApps[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color:
                              ArchethicTheme.backgroundFungiblesTokensListCard,
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
                              dApp.code,
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
                          await CupertinoScaffold.showCupertinoModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 1,
                                child: Scaffold(
                                  backgroundColor: aedappfm
                                      .AppThemeBase.sheetBackground
                                      .withOpacity(0.2),
                                  body: DAppSheet(
                                    dappKey: dApp.code,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const SizedBox(),
    );
  }
}
