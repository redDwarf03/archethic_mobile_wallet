import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/format_address_link_copy_big_icon.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/layouts/components/liquidity_remove_final_amount.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LiquidityRemoveResultSheet extends ConsumerStatefulWidget {
  const LiquidityRemoveResultSheet({
    super.key,
  });

  static const String routerPage = '/liquidy_remove_result';

  @override
  ConsumerState<LiquidityRemoveResultSheet> createState() =>
      LiquidityRemoveResultSheetState();
}

class LiquidityRemoveResultSheetState
    extends ConsumerState<LiquidityRemoveResultSheet>
    implements SheetSkeletonInterface {
  @override
  Widget build(BuildContext context) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    if (accountSelected == null) return const SizedBox();

    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.close,
          Dimens.buttonBottomDimens,
          key: const Key('close'),
          onPressed: () async {
            ref.invalidate(liquidityRemoveFormNotifierProvider);
            context
              ..pop()
              ..pop();
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return SheetAppBar(
      title: localizations.removeLiquidity,
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final liquidityRemove = ref.watch(liquidityRemoveFormNotifierProvider);
    if (liquidityRemove.lpToken == null) {
      return const SizedBox.shrink();
    }
    final finalAmountToken1 = liquidityRemove.finalAmountToken1;
    final finalAmountToken2 = liquidityRemove.finalAmountToken2;
    final finalAmountLPToken = liquidityRemove.finalAmountLPToken;
    final timeout = ref.watch(
      liquidityRemoveFormNotifierProvider
          .select((value) => value.failure != null),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetDetailCard(
              children: [
                if (finalAmountToken1 == null &&
                    finalAmountToken2 == null &&
                    finalAmountLPToken == null)
                  if (timeout == false)
                    Row(
                      children: [
                        AutoSizeText(
                          AppLocalizations.of(context)!.processingInProgress,
                          style: AppTextStyles.bodyLarge(context),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        ),
                      ],
                    )
                  else
                    Text(
                      FailureMessage(
                        context: context,
                        failure: liquidityRemove.failure,
                      ).getMessage(),
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: aedappfm.ArchethicThemeBase.systemDanger500,
                      ),
                    )
                else
                  Text(
                    AppLocalizations.of(context)!.liquidityRemoveSuccessInfo,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: aedappfm.ArchethicThemeBase.systemPositive600,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (liquidityRemove.transactionRemoveLiquidity != null &&
                liquidityRemove.transactionRemoveLiquidity!.address != null &&
                liquidityRemove.transactionRemoveLiquidity!.address!.address !=
                    null &&
                finalAmountToken1 != null &&
                finalAmountToken2 != null &&
                finalAmountLPToken != null)
              Column(
                children: [
                  FormatAddressLinkCopyBigIcon(
                    address: liquidityRemove
                        .transactionRemoveLiquidity!.address!.address!
                        .toUpperCase(),
                    header: AppLocalizations.of(context)!
                        .liquidityRemoveInProgressTxAddresses,
                    typeAddress: TypeAddressLinkCopyBigIcon.transaction,
                    reduceAddress: true,
                    fontSize: 16,
                    iconSize: 26,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            if ((finalAmountToken1 != null &&
                    finalAmountToken2 != null &&
                    finalAmountLPToken != null) ||
                timeout)
              const SheetDetailCard(
                children: [
                  LiquidityRemoveFinalAmount(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
