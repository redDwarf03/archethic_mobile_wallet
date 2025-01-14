import 'package:aewallet/domain/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:collection/collection.dart';

mixin TokenParser {
  Future<aedappfm.AEToken> tokenModelToAETokenModel(
    archethic.Token token,
    List<String> verifiedTokens,
    List<GetPoolListResponse> poolsListRaw,
    aedappfm.Environment environment,
    archethic.ApiService apiService,
    aedappfm.DefTokensRepositoryInterface defTokensRepository,
    TokensRepository tokensRepository,
  ) async {
    String? pairSymbolToken1;
    String? pairSymbolToken2;
    aedappfm.AEToken? defPairSymbolToken1;
    aedappfm.AEToken? defPairSymbolToken2;
    String? token1Address;
    String? token2Address;

    final tokenSymbolSearch = <String>[];
    final isLPToken =
        poolsListRaw.any((item) => item.lpTokenAddress == token.address);
    token1Address = null;
    token2Address = null;
    if (isLPToken) {
      final poolRaw = poolsListRaw.firstWhereOrNull(
        (item) => item.lpTokenAddress == token.address!,
      );
      if (poolRaw != null) {
        token1Address =
            poolRaw.concatenatedTokensAddresses.split('/')[0].toUpperCase();
        token2Address =
            poolRaw.concatenatedTokensAddresses.split('/')[1].toUpperCase();
        if (token1Address != kUCOAddress) {
          tokenSymbolSearch.add(token1Address);
        }
        if (token2Address != kUCOAddress) {
          tokenSymbolSearch.add(token2Address);
        }

        final tokensSymbolMap = await tokensRepository.getTokensFromAddresses(
          tokenSymbolSearch,
        );
        pairSymbolToken1 = token1Address != kUCOAddress
            ? tokensSymbolMap[token1Address]!.symbol
            : kUCOAddress;
        pairSymbolToken2 = token2Address != kUCOAddress
            ? tokensSymbolMap[token2Address]!.symbol
            : kUCOAddress;

        final futureToken1 = defTokensRepository.getDefToken(
          environment,
          token1Address,
        );

        final futureToken2 = defTokensRepository.getDefToken(
          environment,
          token2Address,
        );

        final results = await Future.wait([futureToken1, futureToken2]);

        defPairSymbolToken1 = results[0];
        defPairSymbolToken2 = results[1];
      }
    }

    final defToken = await defTokensRepository.getDefToken(
      environment,
      token.address!.toUpperCase(),
    );

    return aedappfm.AEToken(
      name: defToken?.name ?? '',
      address: token.address!.toUpperCase(),
      icon: defToken?.icon,
      ucid: defToken?.ucid,
      supply: archethic.fromBigInt(token.supply).toDouble(),
      isLpToken: pairSymbolToken1 != null && pairSymbolToken2 != null,
      symbol: pairSymbolToken1 != null && pairSymbolToken2 != null
          ? 'LP Token'
          : token.symbol!,
      lpTokenPair: pairSymbolToken1 != null && pairSymbolToken2 != null
          ? aedappfm.AETokenPair(
              token1: aedappfm.AEToken(
                symbol: pairSymbolToken1,
                address: token1Address,
                name: defPairSymbolToken1?.name ?? '',
                icon: defPairSymbolToken1?.icon,
                ucid: defPairSymbolToken1?.ucid,
              ),
              token2: aedappfm.AEToken(
                symbol: pairSymbolToken2,
                address: token2Address,
                name: defPairSymbolToken2?.name ?? '',
                icon: defPairSymbolToken2?.icon,
                ucid: defPairSymbolToken2?.ucid,
              ),
            )
          : null,
      isVerified: verifiedTokens.contains(token.address!.toUpperCase()),
    );
  }
}
