import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/modules/aeswap/application/dex_config.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/router_factory.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/application/verified_tokens.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_farm.dart';
import 'package:aewallet/modules/aeswap/infrastructure/dex_farm.repository.dart';
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_farm.g.dart';
part 'dex_farm_list.dart';

@riverpod
DexFarmRepositoryImpl _dexFarmRepository(Ref ref) => DexFarmRepositoryImpl(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(
        verifiedTokensRepositoryProvider,
      ),
    );

@riverpod
Future<DexFarm?> _getFarmInfos(
  Ref ref,
  String farmGenesisAddress,
  String poolAddress, {
  DexFarm? dexFarmInput,
}) async {
  final poolList = await ref.watch(DexPoolProviders.getPoolList.future);
  final selectedAccount = await ref
      .read(
        AccountProviders.accounts.future,
      )
      .selectedAccount;

  final dexFarmRepository = ref.watch(_dexFarmRepositoryProvider);

  final pool = poolList.firstWhereOrNull(
    (poolSelect) =>
        poolSelect.poolAddress.toUpperCase() == poolAddress.toUpperCase(),
  );
  if (pool == null) return null;

  final farmInfos = await dexFarmRepository.populateFarmInfos(
    farmGenesisAddress,
    pool,
    dexFarmInput!,
    selectedAccount!.genesisAddress,
  );

  var apr = 0.0;
  final estimateLPTokenInFiat = await ref.watch(
    DexTokensProviders.estimateLPTokenInFiat(
      farmInfos.lpTokenPair!.token1.address,
      farmInfos.lpTokenPair!.token2.address,
      farmInfos.lpTokenDeposited,
      dexFarmInput.poolAddress,
    ).future,
  );
  final now = DateTime.now().toUtc();

  final priceTokenInFiat = await ref.read(
    DexTokensProviders.estimateTokenInFiat(farmInfos.rewardToken!.address)
        .future,
  );

  final remainingRewardInFiat = (Decimal.parse('$priceTokenInFiat') *
          Decimal.parse('${farmInfos.remainingReward}'))
      .toDouble();

  if (remainingRewardInFiat > 0 &&
      estimateLPTokenInFiat > 0 &&
      farmInfos.endDate != null &&
      now.isBefore(farmInfos.endDate!)) {
    final secondsUntilEnd = farmInfos.endDate!.difference(now).inSeconds;

    if (secondsUntilEnd > 0) {
      // 31 536 000 second in a year
      final rewardScalledToYear =
          remainingRewardInFiat * (31536000 / secondsUntilEnd);

      apr = (Decimal.parse('$rewardScalledToYear') /
              Decimal.parse('$estimateLPTokenInFiat'))
          .toDouble();
    }
  }

  return farmInfos.copyWith(
    estimateLPTokenInFiat: estimateLPTokenInFiat,
    remainingRewardInFiat: remainingRewardInFiat,
    apr: apr,
  );
}

abstract class DexFarmProviders {
  static final getFarmList = _getFarmListProvider;
  static const getFarmInfos = _getFarmInfosProvider;
}
