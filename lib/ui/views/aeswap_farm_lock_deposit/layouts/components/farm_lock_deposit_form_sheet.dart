import 'dart:convert';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/ui/views/aeswap_pool_list/layouts/components/pool_details_info_header.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_lock_duration_btn.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_textfield_amount.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/liquidity_add_sheet.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockDepositFormSheet extends ConsumerWidget
    implements SheetSkeletonInterface {
  const FarmLockDepositFormSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final localizations = AppLocalizations.of(context)!;
    final farmLockDeposit = ref.watch(farmLockDepositFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.btn_farmLockDeposit,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockDeposit'),
          onPressed: () async {
            await ref
                .read(
                  farmLockDepositFormNotifierProvider.notifier,
                )
                .validateForm(localizations);
          },
          disabled: !farmLockDeposit.isControlsOk,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.farmLockDepositFormTitle,
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
    final farmLockDeposit = ref.watch(farmLockDepositFormNotifierProvider);

    if (farmLockDeposit.pool == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 80, bottom: 80),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 0.5),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          PoolDetailsInfoHeader(
            pool: farmLockDeposit.pool,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      AppLocalizations.of(context)!
                          .farmLockDepositFormAmountLbl,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    if (farmLockDeposit.aprEstimation != null)
                      SelectableText(
                        '${AppLocalizations.of(context)!.farmLockDepositAPREstimationLbl} ${farmLockDeposit.aprEstimation!.formatNumber(precision: 2)}%',
                        style: AppTextStyles.bodyMedium(context),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FarmLockDepositAmount(),
                  ],
                ),
                aedappfm.BlockInfo(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  paddingEdgeInsetsClipRRect:
                      const EdgeInsets.symmetric(vertical: 10),
                  paddingEdgeInsetsInfo:
                      const EdgeInsets.symmetric(horizontal: 10),
                  info: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth - 50,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .farmLockDepositGetLPToken,
                              style: AppTextStyles.bodyMedium(context),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child: Container(
                              height: 36,
                              width: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: aedappfm.AppThemeBase.gradientBtn,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                aedappfm.Iconsax.import4,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            onTap: () async {
                              final poolJson = jsonEncode(
                                farmLockDeposit.pool!.toJson(),
                              );
                              final poolEncoded = Uri.encodeComponent(poolJson);
                              await context.push(
                                Uri(
                                  path: LiquidityAddSheet.routerPage,
                                  queryParameters: {
                                    'pool': poolEncoded,
                                  },
                                ).toString(),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    SelectableText(
                      AppLocalizations.of(context)!
                          .farmLockDepositFormLockDurationLbl,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    ...farmLockDeposit.filterAvailableLevels.entries
                        .map((entry) {
                          return FarmLockDepositDurationButton(
                            farmLockDepositDuration:
                                getFarmLockDepositDurationTypeFromLevel(
                              entry.key,
                            ),
                            level: entry.key,
                            aprEstimation: (farmLockDeposit.farmLock!
                                        .stats[entry.key]?.aprEstimation ??
                                    0) *
                                100,
                          );
                        })
                        .toList()
                        .reversed,
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    aedappfm.ErrorMessage(
                      failure: farmLockDeposit.failure,
                      failureMessage: FailureMessage(
                        context: context,
                        failure: farmLockDeposit.failure,
                      ).getMessage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
