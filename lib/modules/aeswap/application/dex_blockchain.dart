/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_blockchain.dart';
import 'package:aewallet/modules/aeswap/domain/repositories/dex_blockchain.repository.dart';
import 'package:aewallet/modules/aeswap/infrastructure/dex_blockchain.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_blockchain.g.dart';

@riverpod
Future<List<DexBlockchain>> _getBlockchainsListConf(
  Ref ref,
) async {
  return ref.watch(_dexBlockchainsRepositoryProvider).getBlockchainsListConf();
}

@riverpod
DexBlockchainsRepository _dexBlockchainsRepository(
  Ref ref,
) =>
    DexBlockchainsRepositoryImpl();

@riverpod
Future<List<DexBlockchain>> _getBlockchainsList(
  Ref ref,
) async {
  final blockchainsList =
      await ref.watch(_getBlockchainsListConfProvider.future);
  return ref
      .watch(_dexBlockchainsRepositoryProvider)
      .getBlockchainsList(blockchainsList);
}

@riverpod
Future<DexBlockchain?> _currentBlockchain(
  Ref ref,
) async {
  final blockchainsList = await ref.watch(_getBlockchainsListProvider.future);

  final environment = ref.watch(environmentProvider);
  return ref
      .watch(_dexBlockchainsRepositoryProvider)
      .getBlockchainFromEnv(blockchainsList, environment.name);
}

abstract class DexBlockchainsProviders {
  static final getBlockchainsList = _getBlockchainsListProvider;
  static final currentBlockchain = _currentBlockchainProvider;
  static final getBlockchainsListConf = _getBlockchainsListConfProvider;
}
