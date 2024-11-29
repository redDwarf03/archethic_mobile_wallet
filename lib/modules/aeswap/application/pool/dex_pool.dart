import 'dart:developer';

import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/application/dex_config.dart';
import 'package:aewallet/modules/aeswap/application/router_factory.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/application/session/state.dart';
import 'package:aewallet/modules/aeswap/application/verified_tokens.dart';
import 'package:aewallet/modules/aeswap/domain/enum/dex_action_type.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool_infos.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool_tx.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:aewallet/modules/aeswap/domain/repositories/dex_pool.repository.dart';
import 'package:aewallet/modules/aeswap/infrastructure/dex_pool.repository.dart';
import 'package:aewallet/modules/aeswap/infrastructure/hive/favorite_pools.hive.dart';
import 'package:aewallet/modules/aeswap/infrastructure/pool_factory.repository.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_pool.g.dart';
part 'dex_pool_calculation.dart';
part 'dex_pool_detail.dart';
part 'dex_pool_favorite.dart';
part 'dex_pool_list.dart';
part 'dex_pool_tx_list.dart';

@riverpod
DexPoolRepository _dexPoolRepository(
  Ref ref,
) =>
    DexPoolRepositoryImpl(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
    );

abstract class DexPoolProviders {
  // Pool List
  static final getPoolList = _getPoolListProvider;
  static final getPoolListRaw = _getPoolListRawProvider;
  static const getPoolListForSearch = _getPoolListForSearchProvider;

  // Pool transactions list
  static const getPoolTxList = _getPoolTxListProvider;

  // Pool Detail
  static const poolInfos = _poolInfosProvider;
  static const getPool = _poolProvider;

  // Calculation
  static const getRatio = _getRatioProvider;
  static const estimatePoolTVLInFiat = _estimatePoolTVLInFiatProvider;
  static const estimateStats = _estimateStatsProvider;

  // Favorite
  static const poolFavorite = _poolFavoriteNotifierProvider;
}
