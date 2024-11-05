import 'dart:convert';

import 'package:aewallet/modules/aeswap/domain/models/dex_pair.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/model_parser.dart';
import 'package:aewallet/modules/aeswap/domain/repositories/dex_token.repository.dart';
import 'package:aewallet/modules/aeswap/infrastructure/hive/dex_token.hive.dart';
import 'package:aewallet/modules/aeswap/infrastructure/hive/tokens_list.hive.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

class DexTokenRepositoryImpl with ModelParser implements DexTokenRepository {
  DexTokenRepositoryImpl({required this.apiService});

  final archethic.ApiService apiService;

  @override
  Future<DexToken?> getToken(
    String address,
    aedappfm.Environment environment,
  ) async {
    DexToken? token;
    final tokensListDatasource = await HiveTokensListDatasource.getInstance();
    final tokenHive = tokensListDatasource.getToken(
      environment,
      address,
    );
    if (tokenHive == null) {
      final tokenMap = await apiService.getToken(
        [address],
        request: 'name, symbol, type',
      );
      if (tokenMap[address] != null && tokenMap[address]!.type == 'fungible') {
        token = tokenSDKToModel(tokenMap[address]!, 0);
        token = token.copyWith(address: address);
        await tokensListDatasource.setToken(
          environment,
          token.toHive(),
        );
      }
    } else {
      token = tokenHive.toModel();
    }

    return token;
  }

  @override
  Future<List<DexToken>> getTokensFromAccount(
    String accountAddress,
    List<String> userTokenLocalAddresses,
  ) async {
    final dexTokens = <DexToken>[];

    final tokenAddressList = <String>[];
    for (final tokenAddress in userTokenLocalAddresses) {
      tokenAddressList.add(tokenAddress);
    }

    final dexTokenUCO = DexToken.uco();
    dexTokens.add(dexTokenUCO);

    final tokenMap = await apiService.getToken(
      tokenAddressList,
      request: 'name, symbol, properties',
    );

    // Fetch all token of pairs from API
    final tokensAddresses = tokenMap.entries
        .expand<String>((entry) {
          final token1Address = entry.value.properties['token1_address'];
          final token2Address = entry.value.properties['token2_address'];
          if (token1Address == null || token2Address == null) return [];

          return [
            token1Address,
            token2Address,
          ];
        })
        .whereNot((address) => address == kUCOAddress)
        .toSet()
        .toList();

    final tokensSymbolMap = await apiService.getToken(
      tokensAddresses,
      request: 'name, symbol',
    );

    // Build [DexToken]s with previously fetched data
    for (final entry in tokenMap.entries) {
      final key = entry.key;
      final value = entry.value;

      final token1Address = value.properties['token1_address'];
      final token2Address = value.properties['token2_address'];

      final _token = value.copyWith(address: key);

      var dexToken = tokenSDKToModel(_token, 0);

      if (token1Address != null && token2Address != null) {
        dexToken = dexToken.copyWith(
          isLpToken: true,
          lpTokenPair: DexPair(
            token1: token1Address == kUCOAddress
                ? DexToken.uco()
                : DexToken(
                    address: token1Address,
                    name: tokensSymbolMap[token1Address] != null
                        ? tokensSymbolMap[token1Address]!.name!
                        : '',
                    symbol: tokensSymbolMap[token1Address] != null
                        ? tokensSymbolMap[token1Address]!.symbol!
                        : '',
                  ),
            token2: token2Address == kUCOAddress
                ? DexToken.uco()
                : DexToken(
                    address: token2Address,
                    name: tokensSymbolMap[token2Address] != null
                        ? tokensSymbolMap[token2Address]!.name!
                        : '',
                    symbol: tokensSymbolMap[token2Address] != null
                        ? tokensSymbolMap[token2Address]!.symbol!
                        : '',
                  ),
          ),
        );
      }
      dexTokens.add(
        dexToken,
      );
    }

    dexTokens.sort((a, b) {
      final symbolA = a.symbol.toUpperCase();
      final symbolB = b.symbol.toUpperCase();

      if (a.isLpToken && !b.isLpToken) {
        return 1;
      } else if (!a.isLpToken && b.isLpToken) {
        return -1;
      } else {
        return symbolA.compareTo(symbolB);
      }
    });

    return dexTokens;
  }

  @override
  Future<List<DexToken>> getLocalTokensDescriptions(
    aedappfm.Environment environment,
  ) async {
    final jsonContent = await rootBundle
        .loadString('lib/modules/aeswap/domain/repositories/common_bases.json');

    final jsonData = jsonDecode(jsonContent);

    final jsonTokens = jsonData['tokens'][environment.name] as List<dynamic>;
    return jsonTokens
        .map(
          (jsonToken) => DexToken.fromJson(jsonToken as Map<String, dynamic>),
        )
        .toList();
  }
}
