/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'dex_pool.dart';

@riverpod
Future<DexPool?> _pool(
  Ref ref,
  String poolAddress,
) async {
  final dexPoolRepository = ref.watch(_dexPoolRepositoryProvider);
  final tokenVerifiedList = await ref.watch(
    verifiedTokensProvider.future,
  );
  final environment = ref.read(environmentProvider);

  final pool = await dexPoolRepository.getPool(
    poolAddress,
    tokenVerifiedList,
    environment,
  );

  if (pool == null) return null;

  final userBalance = await ref.watch(userBalanceProvider.future);
  final lpTokenInUserBalance = userBalance.token.any(
    (token) =>
        token.address!.toUpperCase() == pool.lpToken.address.toUpperCase(),
  );

  return pool.copyWith(
    lpTokenInUserBalance: lpTokenInUserBalance,
  );
}

@riverpod
Future<DexPoolInfos> _poolInfos(
  Ref ref,
  String poolAddress,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final dexPoolRepository = PoolFactoryRepositoryImpl(
    poolAddress,
    apiService,
  );

  return dexPoolRepository.getPoolInfos().valueOrThrow;
}
