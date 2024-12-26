import 'dart:async';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/price_history/providers.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/components/token_detail_chart.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/components/token_detail_chart_interval.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/components/token_detail_info.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/components/token_detail_menu.dart';
import 'package:aewallet/ui/widgets/balance/balance_infos.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class TokenDetailSheet extends ConsumerWidget
    implements SheetSkeletonInterface {
  const TokenDetailSheet({
    super.key,
    required this.aeToken,
  });

  final aedappfm.AEToken aeToken;

  static const String routerPage = '/tokenDetail';

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
    return const SizedBox.shrink();
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: '',
      widgetBeforeTitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            aeToken.symbol,
            style: ArchethicThemeStyles.textStyleSize24W700Primary,
          ),
          if (aeToken.isVerified)
            Padding(
              padding: const EdgeInsets.only(
                left: 5,
                bottom: 1,
              ),
              child: Icon(
                Symbols.verified,
                color: ArchethicTheme.activeColorSwitch,
                size: 15,
              ),
            ),
        ],
      ),
      widgetAfterTitle: aeToken.address != null && aeToken.address!.isNotEmpty
          ? InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: aeToken.address ?? '',
                  ),
                );
                UIUtil.showSnackbar(
                  '${localizations.addressCopied}\n${aeToken.address!.toLowerCase()}',
                  context,
                  ref,
                  ArchethicTheme.text,
                  ArchethicTheme.snackBarShadow,
                  icon: Symbols.info,
                );
              },
              child: Row(
                children: [
                  Text(
                    AddressFormatters(
                      aeToken.address ?? '',
                    ).getShortString4().toLowerCase(),
                    style: ArchethicThemeStyles.textStyleSize14W600Primary,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(
                    Symbols.content_copy,
                    weight: IconSize.weightM,
                    opticalSize: IconSize.opticalSizeM,
                    grade: IconSize.gradeM,
                    size: 16,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
      widgetRight: aeToken.isUCO
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 13, right: 15),
              child: InkWell(
                child: Column(
                  children: [
                    const Icon(
                      Symbols.hide_source,
                      size: 20,
                      weight: IconSize.weightM,
                      opticalSize: IconSize.opticalSizeM,
                      grade: IconSize.gradeM,
                    ),
                    Text(
                      localizations.hideBtn,
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ),
                onTap: () async {
                  await AppDialogs.showConfirmDialog(
                    context,
                    ref,
                    localizations.hideTokenConfirmationTitle,
                    localizations.hideTokenConfirmationDesc,
                    localizations.yes,
                    () async {
                      final accountSelected = ref.read(
                        AccountProviders.accounts.select(
                          (accounts) => accounts.valueOrNull?.selectedAccount,
                        ),
                      );
                      if (accountSelected != null && aeToken.address != null) {
                        await accountSelected
                            .removeCustomTokenAddress(aeToken.address!);

                        final poolListRaw = await ref
                            .read(DexPoolProviders.getPoolListRaw.future);
                        unawaited(
                          (await ref
                                  .read(AccountProviders.accounts.notifier)
                                  .selectedAccountNotifier)
                              ?.refreshBalance(),
                        );
                        unawaited(
                          (await ref
                                  .read(AccountProviders.accounts.notifier)
                                  .selectedAccountNotifier)
                              ?.refreshFungibleTokens(poolListRaw),
                        );
                      }
                      context.pop();
                    },
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final chartInfos = aeToken.ucid != null && aeToken.ucid != 0
        ? ref.watch(priceHistoryProvider(ucid: aeToken.ucid)).valueOrNull
        : null;

    return Column(
      children: <Widget>[
        TokenDetailInfo(
          aeToken: aeToken,
        ),
        const SizedBox(
          height: 20,
        ),
        TokenDetailMenu(
          aeToken: aeToken,
        ),
        if (chartInfos != null && chartInfos.isNotEmpty)
          TokenDetailChart(chartInfos: chartInfos),
        const SizedBox(
          height: 20,
        ),
        if (chartInfos != null && chartInfos.isNotEmpty)
          TokenDetailChartInterval(chartInfos: chartInfos),
        if (chartInfos != null && chartInfos.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10),
            child: BalanceInfosKpi(
              chartInfos: chartInfos,
              aeToken: aeToken,
            ),
          ),
      ],
    );
  }
}
