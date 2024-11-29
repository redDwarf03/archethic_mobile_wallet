import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/verified_tokens.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock_stats.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm_lock_user_infos.dart';
import 'package:aewallet/modules/aeswap/infrastructure/dex_farm_lock.repository.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_farm_lock.g.dart';

@riverpod
DexFarmLockRepositoryImpl _dexFarmLockRepository(
  Ref ref,
) =>
    DexFarmLockRepositoryImpl(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
    );

@riverpod
Future<DexFarmLock?> _getFarmLockInfos(
  Ref ref,
  String farmGenesisAddress,
  String poolAddress, {
  DexFarmLock? dexFarmLockInput,
}) async {
  final poolList = await ref.watch(DexPoolProviders.getPoolList.future);

  final pool = poolList.firstWhereOrNull(
    (poolSelect) =>
        poolSelect.poolAddress.toUpperCase() == poolAddress.toUpperCase(),
  );
  if (pool == null) return null;

  final selectedAccount = await ref
      .watch(
        AccountProviders.accounts.future,
      )
      .selectedAccount;

  if (selectedAccount == null) return null;

  try {
    final farmLockInfos =
        await ref.watch(_dexFarmLockRepositoryProvider).populateFarmLockInfos(
              farmGenesisAddress,
              pool,
              dexFarmLockInput!,
              selectedAccount.genesisAddress,
            );

    final rewardTokenPriceInFiat = await ref.watch(
      DexTokensProviders.estimateTokenInFiat(farmLockInfos.rewardToken!.address)
          .future,
    );

    final estimateLPTokenInFiat = await ref.watch(
      DexTokensProviders.estimateLPTokenInFiat(
        farmLockInfos.lpTokenPair!.token1.address,
        farmLockInfos.lpTokenPair!.token2.address,
        farmLockInfos.lpTokensDeposited,
        farmLockInfos.poolAddress,
      ).future,
    );

    final now = DateTime.now().toUtc();

    var secondsUntilEnd = 0;
    if (rewardTokenPriceInFiat == 0 || farmLockInfos.isOpen == false) {
      return farmLockInfos;
    }

    // Estimation APR for each period
    final newStats = <String, DexFarmLockStats>{};
    for (final entry in farmLockInfos.stats.entries) {
      final level = entry.key;
      var stats = entry.value;

      var rewardsInPeriod = 0.0;
      for (final rewardsAllocated in stats.remainingRewards) {
        final endPeriodDateTime = DateTime.fromMillisecondsSinceEpoch(
          rewardsAllocated.endPeriod * 1000,
        );

        if (now.isBefore(endPeriodDateTime)) {
          rewardsInPeriod = rewardsAllocated.rewardsAllocated;
          secondsUntilEnd = endPeriodDateTime.difference(now).inSeconds;
          break;
        }
      }

      final rewardsAllocatedInFiat = rewardsInPeriod * rewardTokenPriceInFiat;

      final lpDepositedPerLevelInFiat = await ref.watch(
        DexTokensProviders.estimateLPTokenInFiat(
          farmLockInfos.lpTokenPair!.token1.address,
          farmLockInfos.lpTokenPair!.token2.address,
          stats.lpTokensDeposited,
          dexFarmLockInput.poolAddress,
        ).future,
      );

      if (lpDepositedPerLevelInFiat > 0 && secondsUntilEnd > 0) {
        final rewardScalledToYear =
            rewardsAllocatedInFiat * (31536000 / secondsUntilEnd);

        stats = stats.copyWith(
          aprEstimation: (Decimal.parse('$rewardScalledToYear') /
                  Decimal.parse('$lpDepositedPerLevelInFiat'))
              .toDouble(),
        );
      }

      newStats[level] = stats;
    }

    // APR for each lock
    final newUserInfos = <String, DexFarmLockUserInfos>{};
    for (final entry in farmLockInfos.userInfos.entries) {
      final index = entry.key;
      var userInfos = entry.value;
      userInfos = userInfos.copyWith(
        apr: newStats[userInfos.level]?.aprEstimation ?? 0,
      );
      newUserInfos[index] = userInfos;
    }

    return farmLockInfos.copyWith(
      stats: newStats,
      userInfos: newUserInfos,
      estimateLPTokenInFiat: estimateLPTokenInFiat,
    );
  } catch (e) {
    return null;
  }
}

abstract class DexFarmLockProviders {
  static const getFarmLockInfos = _getFarmLockInfosProvider;
}
