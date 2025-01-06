import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock_stats.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/dex_lp_token_fiat_value.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FarmLockDetailsLevelSingle extends ConsumerWidget {
  const FarmLockDetailsLevelSingle({
    super.key,
    required this.level,
    required this.farmLockStats,
  });

  final String level;
  final DexFarmLockStats farmLockStats;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final style = TextStyle(
      fontSize: AppTextStyles.bodyMedium(context).fontSize,
    );
    final farmLock = ref.watch(farmLockFormFarmLockProvider).value;
    if (farmLock == null) return const SizedBox.shrink();
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: int.tryParse(level)!.isEven
            ? LinearGradient(
                colors: [
                  aedappfm.AppThemeBase.sheetBackgroundTertiary
                      .withOpacity(0.4),
                  aedappfm.AppThemeBase.sheetBackgroundTertiary,
                ],
                stops: const [0, 1],
              )
            : LinearGradient(
                colors: [
                  aedappfm.AppThemeBase.sheetBackgroundSecondary
                      .withOpacity(0.4),
                  aedappfm.AppThemeBase.sheetBackgroundSecondary,
                ],
                stops: const [0, 1],
              ),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              aedappfm.AppThemeBase.sheetBorderTertiary.withOpacity(0.4),
              aedappfm.AppThemeBase.sheetBorderTertiary,
            ],
            stops: const [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Opacity(
        opacity: AppTextStyles.kOpacityText,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(
                    '${AppLocalizations.of(context)!.level}: $level',
                    style: style,
                  ),
                  SelectableText(
                    '${AppLocalizations.of(context)!.farmDetailsInfoNbDeposit}: ${farmLockStats.depositsCount}',
                    style: style,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SelectableText(
                    '${AppLocalizations.of(context)!.farmLockDetailsLevelSingleWeight}: ${(farmLockStats.weight * 100).formatNumber(precision: 2)}%',
                    style: style,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    '${AppLocalizations.of(context)!.farmDetailsInfoLPDeposited}:',
                    style: style,
                  ),
                  SelectableText(
                    '${farmLockStats.lpTokensDeposited.formatNumber(precision: 8)} ${farmLockStats.lpTokensDeposited > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken} ${ref.watch(
                      dexLPTokenFiatValueProvider(
                        farmLock.lpTokenPair!.token1,
                        farmLock.lpTokenPair!.token2,
                        farmLockStats.lpTokensDeposited,
                        farmLock.poolAddress,
                      ),
                    )}',
                    style: style,
                  ),
                ],
              ),
              Column(
                children: [
                  if (farmLockStats.lpTokensDeposited > 0)
                    FutureBuilder<({double token1, double token2})>(
                      future: ref.watch(
                        DexTokensProviders.getRemoveAmounts(
                          farmLock.poolAddress,
                          farmLockStats.lpTokensDeposited,
                        ).future,
                      ),
                      builder: (
                        context,
                        snapshotAmounts,
                      ) {
                        if (snapshotAmounts.hasData &&
                            snapshotAmounts.data != null) {
                          return SelectableText(
                            '= ${snapshotAmounts.data!.token1.formatNumber(precision: snapshotAmounts.data!.token1 > 1 ? 2 : 8)} ${farmLock.lpTokenPair!.token1.symbol.reduceSymbol()} / ${snapshotAmounts.data!.token2.formatNumber(precision: snapshotAmounts.data!.token2 > 1 ? 2 : 8)} ${farmLock.lpTokenPair!.token2.symbol.reduceSymbol()}',
                            style: style,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
