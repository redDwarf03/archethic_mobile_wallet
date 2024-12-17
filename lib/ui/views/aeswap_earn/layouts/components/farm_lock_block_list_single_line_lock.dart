import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock_user_infos.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/dex_lp_token_fiat_value.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/fiat_value.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_earn/layouts/components/farm_lock_btn_claim.dart';
import 'package:aewallet/ui/views/aeswap_earn/layouts/components/farm_lock_btn_level_up.dart';
import 'package:aewallet/ui/views/aeswap_earn/layouts/components/farm_lock_btn_withdraw.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';

class FarmLockBlockListSingleLineLock extends ConsumerWidget {
  const FarmLockBlockListSingleLineLock({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final farmLock = ref.watch(farmLockFormFarmLockProvider).value;
    final pool = ref.watch(farmLockFormPoolProvider).value;
    if (farmLock == null || pool == null) {
      return const SizedBox.shrink();
    }

    final sortedUserInfos =
        farmLock.userInfos.entries.map((entry) => entry.value).toList()
          ..sort((a, b) {
            return a.level.compareTo(b.level);
          });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: Text(
            AppLocalizations.of(
              context,
            )!
                .farmLockListLocksHeader,
            style: AppTextStyles.bodyLarge(context),
          ),
        ),
        Expanded(
          child: aedappfm.ArchethicScrollbar(
            thumbVisibility: false,
            child: Column(
              children: [
                ...sortedUserInfos.map(
                  (userInfo) {
                    return farmLockBlockListSingleLineLock(
                      context,
                      ref,
                      userInfo,
                      farmLock,
                      pool,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget farmLockBlockListSingleLineLock(
    BuildContext context,
    WidgetRef ref,
    DexFarmLockUserInfos farmLockUserInfos,
    DexFarmLock farmLock,
    DexPool pool,
  ) {
    var isFlexDuration = false;
    var progressPercentage = 0.0;
    if (farmLockUserInfos.start == null && farmLockUserInfos.end == null) {
      isFlexDuration = true;
      progressPercentage = 1.0;
    } else {
      final startDate =
          DateTime.fromMillisecondsSinceEpoch(farmLockUserInfos.start! * 1000);
      final endDate =
          DateTime.fromMillisecondsSinceEpoch(farmLockUserInfos.end! * 1000);
      final currentDate = DateTime.now().toUtc();
      final totalDuration = endDate.difference(startDate).inMinutes;
      final elapsedDuration = currentDate.difference(startDate).inMinutes;
      progressPercentage = elapsedDuration / totalDuration;
      progressPercentage = progressPercentage.clamp(0, 1);
    }

    final style = AppTextStyles.bodyMedium(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          ClipRRect(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SheetDetailCard(
                        children: [
                          Text(
                            '${AppLocalizations.of(
                              context,
                            )!.farmLockBlockListHeaderAmount}: ',
                            style: style,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SelectableText(
                                '${farmLockUserInfos.amount.formatNumber(precision: farmLockUserInfos.amount < 1 ? 8 : 3)} ${farmLockUserInfos.amount < 1 ? AppLocalizations.of(context)!.lpToken : AppLocalizations.of(context)!.lpTokens}',
                                style: style,
                              ),
                              SelectableText(
                                ref.watch(
                                  dexLPTokenFiatValueProvider(
                                    farmLock.lpTokenPair!.token1,
                                    farmLock.lpTokenPair!.token2,
                                    farmLockUserInfos.amount,
                                    farmLock.poolAddress,
                                  ),
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SheetDetailCard(
                        children: [
                          Text(
                            '${AppLocalizations.of(
                              context,
                            )!.farmLockBlockListHeaderRewards}: ',
                            style: style,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SelectableText(
                                '${farmLockUserInfos.rewardAmount.formatNumber(precision: farmLockUserInfos.rewardAmount < 1 ? 8 : 3)} ${farmLock.rewardToken!.symbol}',
                                style: AppTextStyles.bodyMediumSecondaryColor(
                                  context,
                                ),
                              ),
                              FutureBuilder<String>(
                                future: FiatValue().display(
                                  ref,
                                  farmLock.rewardToken!,
                                  farmLockUserInfos.rewardAmount,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SelectableText(
                                      snapshot.data!,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (isFlexDuration)
                        SheetDetailCard(
                          children: [
                            const SizedBox.shrink(),
                            Text(
                              AppLocalizations.of(context)!.available,
                              style: style.copyWith(
                                color: aedappfm
                                    .ArchethicThemeBase.systemPositive600,
                              ),
                            ),
                          ],
                        )
                      else
                        SheetDetailCard(
                          children: [
                            Text(
                              '${AppLocalizations.of(
                                context,
                              )!.farmLockBlockListHeaderUnlocks}: ',
                              style: style,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SelectableText(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    farmLockUserInfos.end! * 1000,
                                  )
                                      .difference(
                                        DateTime.now().toUtc(),
                                      )
                                      .toDurationString(
                                        includeWeeks: true,
                                        round: false,
                                        delimiter: ', ',
                                      ),
                                  style: style,
                                ),
                                SelectableText(
                                  DateFormat.yMMMEd(
                                    Localizations.localeOf(
                                      context,
                                    ).languageCode,
                                  ).format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      farmLockUserInfos.end! * 1000,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      SheetDetailCard(
                        children: [
                          Text(
                            '${AppLocalizations.of(
                              context,
                            )!.level}: ',
                            style: style,
                          ),
                          SelectableText(
                            farmLock.availableLevels.isNotEmpty
                                ? '${AppLocalizations.of(context)!.lvl} ${farmLockUserInfos.level}/${farmLock.availableLevels.entries.last.key}'
                                : 'N/A',
                            style: style,
                          ),
                        ],
                      ),
                      SheetDetailCard(
                        children: [
                          Text(
                            '${AppLocalizations.of(
                              context,
                            )!.farmLockBlockListHeaderAPR}: ',
                            style: style,
                          ),
                          SelectableText(
                            '${(farmLockUserInfos.apr * 100).formatNumber(precision: 2)}%',
                            style: style,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FarmLockBtnLevelUp(
                                    farmAddress: farmLock.farmAddress,
                                    lpTokenAddress: farmLock.lpToken!.address,
                                    lpTokenAmount: farmLockUserInfos.amount,
                                    rewardToken: farmLock.rewardToken!,
                                    depositId: farmLockUserInfos.id,
                                    currentLevel: farmLockUserInfos.level,
                                    enabled: int.tryParse(
                                          farmLockUserInfos.level,
                                        )! <
                                        int.tryParse(
                                          farmLock
                                              .availableLevels.entries.last.key,
                                        )!,
                                    rewardAmount:
                                        farmLockUserInfos.rewardAmount,
                                    pool: pool,
                                  ),
                                ),
                                Expanded(
                                  child: FarmLockBtnWithdraw(
                                    farmAddress: farmLock.farmAddress,
                                    poolAddress: farmLock.poolAddress,
                                    lpToken: farmLock.lpToken!,
                                    lpTokenPair: farmLock.lpTokenPair!,
                                    depositedAmount: farmLockUserInfos.amount,
                                    rewardAmount:
                                        farmLockUserInfos.rewardAmount,
                                    rewardToken: farmLock.rewardToken!,
                                    depositId: farmLockUserInfos.id,
                                    endDate: farmLock.endDate!,
                                    enabled: isFlexDuration ||
                                        (!isFlexDuration &&
                                            DateTime.fromMillisecondsSinceEpoch(
                                              farmLockUserInfos.end! * 1000,
                                            ).isBefore(
                                              DateTime.now().toUtc(),
                                            )),
                                  ),
                                ),
                                if (isFlexDuration)
                                  Expanded(
                                    child: FarmLockBtnClaim(
                                      farmAddress: farmLock.farmAddress,
                                      lpTokenAddress: farmLock.lpToken!.address,
                                      rewardToken: farmLock.rewardToken!,
                                      depositId: farmLockUserInfos.id,
                                      rewardAmount:
                                          farmLockUserInfos.rewardAmount,
                                      enabled: farmLockUserInfos.rewardAmount >
                                              0 &&
                                          (isFlexDuration ||
                                              (!isFlexDuration &&
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                    farmLockUserInfos.end! *
                                                        1000,
                                                  ).isBefore(
                                                    DateTime.now().toUtc(),
                                                  ))),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Container(
                      width: progressPercentage > 0
                          ? MediaQuery.of(context).size.width *
                              progressPercentage
                          : 3,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: aedappfm.AppThemeBase.gradientWelcomeTxt,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.white.withOpacity(0.3),
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
