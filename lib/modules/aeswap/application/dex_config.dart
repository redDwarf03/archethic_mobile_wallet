/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_config.dart';
import 'package:aewallet/modules/aeswap/domain/repositories/dex_config.repository.dart';
import 'package:aewallet/modules/aeswap/infrastructure/dex_config.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_config.g.dart';

@riverpod
DexConfigRepository _dexConfigRepository(
  Ref ref,
) =>
    DexConfigRepositoryImpl();

@riverpod
Future<DexConfig> _dexConfig(Ref ref) async {
  final environment = ref.watch(environmentProvider);
  return ref.watch(_dexConfigRepositoryProvider).getDexConfig(environment);
}

abstract class DexConfigProviders {
  static final dexConfigRepository = _dexConfigRepositoryProvider;
  static final dexConfig = _dexConfigProvider;
}
