import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/application/farm/dex_farm_lock.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/application/session/state.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/state.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
FarmLockFormBalances farmLockFormBalances(
  Ref ref,
) {
  final pool = ref.watch(farmLockFormPoolProvider).valueOrNull;

  if (pool == null) return const FarmLockFormBalances();

  return FarmLockFormBalances(
    lpTokenBalance: ref
            .watch(
              getBalanceProvider(
                pool.lpToken.address,
              ),
            )
            .value ??
        0,
  );
}

@riverpod
Future<FarmLockFormSummary> farmLockFormSummary(
  Ref ref,
) async {
  final farmLock = await ref.watch(farmLockFormFarmLockProvider.future);

  if (farmLock == null) return const FarmLockFormSummary();

  var capitalInvested = 0.0;
  var rewardsEarned = 0.0;
  var farmedTokensCapitalInFiat = 0.0;
  var price = 0.0;

  farmLock.userInfos.forEach((depositId, userInfos) {
    capitalInvested = capitalInvested + userInfos.amount;
    rewardsEarned = rewardsEarned + userInfos.rewardAmount;
  });

  final farmedTokensCapitalInFiatFuture = ref.watch(
    DexTokensProviders.estimateLPTokenInFiat(
      farmLock.lpTokenPair!.token1.address,
      farmLock.lpTokenPair!.token2.address,
      capitalInvested,
      farmLock.poolAddress,
    ).future,
  );

  final priceFuture = ref.watch(
    DexTokensProviders.estimateTokenInFiat(
      farmLock.rewardToken!.address,
    ).future,
  );

  final results = await Future.wait([
    farmedTokensCapitalInFiatFuture,
    priceFuture,
  ]);

  farmedTokensCapitalInFiat = results[0];
  price = results[1];

  return FarmLockFormSummary(
    farmedTokensCapital: capitalInvested,
    farmedTokensRewards: rewardsEarned,
    farmedTokensCapitalInFiat: farmedTokensCapitalInFiat,
    farmedTokensRewardsInFiat:
        (Decimal.parse('$price') * Decimal.parse('$rewardsEarned')).toDouble(),
  );
}

@riverpod
Future<DexPool?> farmLockFormPool(Ref ref) async {
  final environment = ref.watch(environmentProvider);
  return await ref.watch(
    DexPoolProviders.getPool(
      environment.aeETHUCOPoolAddress,
    ).future,
  );
}

@riverpod
Future<DexFarmLock?> farmLockFormFarmLock(
  Ref ref,
) async {
  final environment = ref.watch(environmentProvider);

  return await ref.watch(
    DexFarmLockProviders.getFarmLockInfos(
      environment.aeETHUCOFarmLockAddress,
      environment.aeETHUCOPoolAddress,
      dexFarmLockInput: DexFarmLock(
        poolAddress: environment.aeETHUCOPoolAddress,
        farmAddress: environment.aeETHUCOFarmLockAddress,
      ),
    ).future,
  );
}
