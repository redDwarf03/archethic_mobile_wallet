import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/fiat_value.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_lock_duration_btn.dart';
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

class FarmLockLevelUpFormSheet extends ConsumerWidget
    implements SheetSkeletonInterface {
  const FarmLockLevelUpFormSheet({
    required this.rewardAmount,
    super.key,
  });
  final double rewardAmount;

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
    final farmLockLevelUp = ref.watch(farmLockLevelUpFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.btn_farmLockLevelUp,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockLevelUp'),
          onPressed: () async {
            await ref
                .read(
                  farmLockLevelUpFormNotifierProvider.notifier,
                )
                .validateForm(AppLocalizations.of(context)!);
          },
          disabled: !farmLockLevelUp.isControlsOk,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.farmLockLevelUpFormTitle,
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
    final farmLockLevelUp = ref.watch(farmLockLevelUpFormNotifierProvider);

    if (farmLockLevelUp.pool == null) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SelectableText(
                          '${AppLocalizations.of(context)!.farmLockLevelUpFormAmountLbl}: ',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                        SelectableText(
                          farmLockLevelUp.amount.formatNumber(precision: 8),
                          style:
                              AppTextStyles.bodyMediumSecondaryColor(context),
                        ),
                        SelectableText(
                          ' ${farmLockLevelUp.amount < 1 ? AppLocalizations.of(context)!.lpToken : AppLocalizations.of(context)!.lpTokens}',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ],
                    ),
                    if (farmLockLevelUp.aprEstimation != null)
                      SelectableText(
                        '${AppLocalizations.of(context)!.farmLockLevelUpAPREstimationLbl} ${farmLockLevelUp.aprEstimation!.formatNumber(precision: 2)}%',
                        style: AppTextStyles.bodyMedium(context),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    if (rewardAmount == 0)
                      SelectableText(
                        AppLocalizations.of(context)!
                            .farmLockWithdrawFormTextNoRewardText1,
                        style: AppTextStyles.bodyMedium(context),
                      )
                    else
                      FutureBuilder<String>(
                        future: FiatValue().display(
                          ref,
                          farmLockLevelUp.farmLock!.rewardToken!,
                          rewardAmount,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: Wrap(
                                children: [
                                  SelectableText(
                                    rewardAmount.formatNumber(),
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                  SelectableText(
                                    ' ${farmLockLevelUp.farmLock!.rewardToken!.symbol} ',
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                  SelectableText(
                                    '${snapshot.data}',
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                  SelectableText(
                                    AppLocalizations.of(context)!
                                        .farmLockWithdrawFormTextNoRewardText2,
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SelectableText(
                      AppLocalizations.of(context)!
                          .farmLockLevelUpFormLockDurationLbl,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    ...farmLockLevelUp.filterAvailableLevels.entries
                        .map((entry) {
                          return FarmLockLevelUpDurationButton(
                            farmLockLevelUpDuration:
                                getFarmLockDepositDurationTypeFromLevel(
                              entry.key,
                            ),
                            level: entry.key,
                            aprEstimation: (farmLockLevelUp.farmLock!
                                        .stats[entry.key]?.aprEstimation ??
                                    0) *
                                100,
                          );
                        })
                        .toList()
                        .reversed,
                  ],
                ),
                Row(
                  children: [
                    SelectableText(
                      AppLocalizations.of(context)!
                          .farmLockLevelUpCurrentLvlLbl,
                      style: AppTextStyles.bodyLarge(context),
                    ),
                    if (farmLockLevelUp.currentLevel != null)
                      Row(
                        children: [
                          SelectableText(
                            farmLockLevelUp.currentLevel!,
                            style: AppTextStyles.bodyLargeSecondaryColor(
                              context,
                            ),
                          ),
                          SelectableText(
                            '/',
                            style: AppTextStyles.bodyLarge(context),
                          ),
                          SelectableText(
                            farmLockLevelUp
                                .farmLock!.availableLevels.entries.last.key,
                            style: AppTextStyles.bodyLarge(context),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SelectableText(
                  AppLocalizations.of(context)!.farmLockLevelUpDesc,
                  style: ArchethicThemeStyles.textStyleSize14W200Primary
                      .copyWith(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
