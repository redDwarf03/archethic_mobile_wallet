import 'package:aewallet/domain/models/token_parser.dart';
import 'package:aewallet/domain/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/infrastructure/datasources/tokens_list.hive.dart';
import 'package:aewallet/infrastructure/datasources/wallet_token_dto.hive.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;

class TokensRepositoryImpl with TokenParser implements TokensRepository {
  @override
  Future<Map<String, archethic.Token>> getTokensFromAddresses(
    List<String> addresses,
    archethic.ApiService apiService,
  ) async {
    final tokenMap = <String, archethic.Token>{};

    final addressesOutCache = <String>[];
    final tokensListDatasource = await TokensListHiveDatasource.getInstance();

    for (final address in addresses.toSet()) {
      final token = tokensListDatasource.getToken(address);
      if (token != null) {
        tokenMap[address] = token.toModel();
      } else {
        addressesOutCache.add(address);
      }
    }

    var antiSpam = 0;
    final futures = <Future>[];
    for (final address in addressesOutCache) {
      // Delay the API call if we have made more than 10 requests
      if (antiSpam > 0 && antiSpam % 10 == 0) {
        await Future.delayed(const Duration(seconds: 1));
      }

      // Make the API call and update the antiSpam counter
      futures.add(
        apiService.getToken(
          [address],
        ),
      );
      antiSpam++;
    }

    final getTokens = await Future.wait(futures);
    for (final Map<String, archethic.Token> getToken in getTokens) {
      getToken.forEach((key, value) async {
        if (value.type == 'fungible') {
          value = value.copyWith(address: key);
          await tokensListDatasource.setToken(value.toHive());
        }
      });
    }

    return tokenMap;
  }

  @override
  Future<List<aedappfm.AEToken>> getTokensFromUserBalance(
    String userGenesisAddress,
    List<String> userTokenLocalAddresses,
    archethic.ApiService apiService,
    List<GetPoolListResponse> poolsListRaw,
    aedappfm.Environment environment, {
    bool withVerified = true,
    bool withLPToken = true,
    bool withNotVerified = true,
    bool withCustomToken = true,
  }) async {
    final tokensList = <aedappfm.AEToken>[];
    final balanceMap = await apiService.fetchBalance([userGenesisAddress]);
    if (balanceMap[userGenesisAddress] == null) {
      return tokensList;
    }
    if (withVerified) {
      final defUCOToken = await aedappfm.DefTokensRepositoryImpl()
          .getDefToken(environment, 'UCO');
      tokensList.add(
        aedappfm.ucoToken.copyWith(
          name: defUCOToken?.name ?? '',
          isVerified: true,
          icon: defUCOToken?.icon,
          ucid: defUCOToken?.ucid,
          balance: archethic
              .fromBigInt(balanceMap[userGenesisAddress]!.uco)
              .toDouble(),
        ),
      );
    }
    final tokenAddressList = <String>[];
    if (userTokenLocalAddresses.isNotEmpty && withCustomToken) {
      tokenAddressList.addAll(userTokenLocalAddresses);
    }

    if (balanceMap[userGenesisAddress]!.token.isNotEmpty) {
      for (final tokenBalance in balanceMap[userGenesisAddress]!.token) {
        if (tokenBalance.address != null) {
          tokenAddressList.add(tokenBalance.address!);
        }
      }
    }

    if (tokenAddressList.isNotEmpty) {
      final tokenMap = await getTokensFromAddresses(
        tokenAddressList.toSet().toList(),
        apiService,
      );

      final verifiedTokens = await aedappfm.VerifiedTokensRepositoryImpl(
        apiService: apiService,
        environment: environment,
      ).getVerifiedTokens();

      for (final tokenBalance in balanceMap[userGenesisAddress]!.token) {
        final token = tokenMap[tokenBalance.address];
        if (token != null && token.type == 'fungible') {
          var aeToken = await tokenModelToAETokenModel(
            token,
            verifiedTokens,
            poolsListRaw,
            environment,
            apiService,
          );
          aeToken = aeToken.copyWith(
            balance: archethic.fromBigInt(tokenBalance.amount).toDouble(),
          );

          if (aeToken.isVerified && withVerified ||
              aeToken.isLpToken && withLPToken ||
              withCustomToken &&
                  userTokenLocalAddresses
                      .contains(aeToken.address!.toUpperCase()) ||
              !aeToken.isVerified && withNotVerified) {
            tokensList.add(aeToken);
          }
        }
      }
    }
    return tokensList;
  }
}
