/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'dex_farm.dart';

@riverpod
Future<List<DexFarm>> _getFarmList(
  Ref ref,
) async {
  final environment = ref.watch(environmentProvider);
  final dexConf = await ref
      .watch(DexConfigProviders.dexConfigRepository)
      .getDexConfig(environment);

  final dexFarms = <DexFarm>[];
  final poolList = await ref.watch(DexPoolProviders.getPoolList.future);
  final resultFarmList = await ref
      .watch(routerFactoryProvider(dexConf.routerGenesisAddress))
      .getFarmList(poolList);

  await resultFarmList.map(
    success: (farmList) async {
      for (final farm in farmList) {
        dexFarms.add(farm);
      }
    },
    failure: (failure) {},
  );

  return dexFarms;
}
