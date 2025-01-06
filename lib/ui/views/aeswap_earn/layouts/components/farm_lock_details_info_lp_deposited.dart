import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmLockDetailsInfoLPDeposited extends ConsumerWidget {
  const FarmLockDetailsInfoLPDeposited({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final farmLock = ref.watch(farmLockFormFarmLockProvider).value;
    if (farmLock == null) return const SizedBox.shrink();

    return SheetDetailCard(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              AppLocalizations.of(context)!.farmDetailsInfoLPDeposited,
              style: AppTextStyles.bodyMedium(context),
            ),
            SelectableText(
              '${farmLock.lpTokensDeposited.formatNumber(precision: 8)} ${farmLock.lpTokensDeposited > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
              style: AppTextStyles.bodyMedium(context),
            ),
            SelectableText(
              '(\$${farmLock.estimateLPTokenInFiat.formatNumber(precision: 2)})',
              style: AppTextStyles.bodyMedium(context),
            ),
            if (farmLock.lpTokensDeposited > 0)
              FutureBuilder<({double token1, double token2})>(
                future: ref.watch(
                  DexTokensProviders.getRemoveAmounts(
                    farmLock.poolAddress,
                    farmLock.lpTokensDeposited,
                  ).future,
                ),
                builder: (
                  context,
                  snapshotAmounts,
                ) {
                  if (snapshotAmounts.hasData && snapshotAmounts.data != null) {
                    return SelectableText(
                      '${AppLocalizations.of(context)!.poolDetailsInfoDepositedEquivalent} ${snapshotAmounts.data!.token1.formatNumber(precision: snapshotAmounts.data!.token1 > 1 ? 2 : 8)} ${farmLock.lpTokenPair!.token1.symbol.reduceSymbol()} / ${snapshotAmounts.data!.token2.formatNumber(precision: snapshotAmounts.data!.token2 > 1 ? 2 : 8)} ${farmLock.lpTokenPair!.token2.symbol.reduceSymbol()}',
                      style: AppTextStyles.bodySmall(context),
                    );
                  }
                  return SelectableText(
                    ' ',
                    style: AppTextStyles.bodySmall(context),
                  );
                },
              )
            else
              SelectableText(' ', style: AppTextStyles.bodySmall(context)),
          ],
        ),
      ],
    );
  }
}
