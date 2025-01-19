/// SPDX-License-Identifier: AGPL-3.0-or-later

// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:aewallet/infrastructure/datasources/tokens_list.hive.dart';
import 'package:aewallet/infrastructure/datasources/wallet_token_dto.hive.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/model/keychain_service_keypair.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:aewallet/util/task.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

const blockchainTxVersion = 3;

class AppService {
  AppService({
    required this.apiService,
  });

  static final _logger = Logger('AppService');

  final ApiService apiService;

  // TODO(reddwarf03): doublons with TokenRepositoryImpl
  Future<Map<String, Token>> getToken(
    List<String> addresses,
  ) async {
    if (addresses.isEmpty) {
      return <String, Token>{};
    }
    final tokenMap = <String, Token>{};

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

    final getTokens = await addressesOutCache
        .map(
          (address) => Task(
            name: 'GetToken - address: $address',
            logger: _logger,
            action: () => apiService.getToken([address]),
          ),
        )
        .autoRetry()
        .batch();

    for (final getToken in getTokens) {
      tokenMap.addAll(getToken);

      getToken.forEach((key, value) async {
        value = value.copyWith(address: key);
        await tokensListDatasource.setToken(value.toHive());
      });
    }

    return tokenMap;
  }

  Future<Map<String, List<TransactionInput>>> getTransactionInputs(
    List<String> addresses,
    String request, {
    int limit = 0,
    int pagingOffset = 0,
  }) async {
    final transactionInputs = <String, List<TransactionInput>>{};

    final getTransactionInputs = await addresses
        .toSet()
        .map(
          (address) => Task(
            name: 'GetTransactionInputs : address: $address',
            logger: _logger,
            action: () => apiService.getTransactionInputs(
              [address],
              request: request,
              limit: limit,
              pagingOffset: pagingOffset,
            ),
          ),
        )
        .autoRetry()
        .batch();
    for (final getTransactionInput in getTransactionInputs) {
      transactionInputs.addAll(getTransactionInput);
    }

    return transactionInputs;
  }

  // TODO(reddwarf03): USE PROVIDER
  Future<List<AccountToken>> getFungiblesTokensList(
    String address,
    List<GetPoolListResponse> poolsListRaw,
  ) async {
    _logger.info(
      '>> START getFungiblesTokensList : ${DateTime.now()}',
    );

    final balanceMap = await apiService.fetchBalance([address]);
    final balance = balanceMap[address];
    final fungiblesTokensList = List<AccountToken>.empty(growable: true);

    final tokenAddressList = <String>[];
    if (balance == null) {
      return [];
    }

    for (final tokenBalance in balance.token) {
      if (tokenBalance.address != null) {
        tokenAddressList.add(tokenBalance.address!);
      }
    }

    // Search token Information
    final tokenMap = await getToken(
      tokenAddressList.toSet().toList(),
    );

    for (final tokenBalance in balance.token) {
      final token = tokenMap[tokenBalance.address];
      String? pairSymbolToken1;
      String? pairSymbolToken2;
      String? token1Address;
      String? token2Address;
      if (token != null && token.type == tokenFungibleType) {
        var pairSymbolToken = '';
        token1Address = null;
        token2Address = null;
        final tokenSymbolSearch = <String>[];
        final poolRaw = poolsListRaw.firstWhereOrNull(
          (item) => item.lpTokenAddress == token.address,
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

          final tokensSymbolMap = await getToken(
            tokenSymbolSearch,
          );
          pairSymbolToken1 = token1Address != kUCOAddress
              ? tokensSymbolMap[token1Address]!.symbol!
              : kUCOAddress;
          pairSymbolToken2 = token2Address != kUCOAddress
              ? tokensSymbolMap[token2Address]!.symbol!
              : kUCOAddress;

          pairSymbolToken = '$pairSymbolToken1/$pairSymbolToken2';
        }

        final tokenInformation = TokenInformation(
          address: tokenBalance.address,
          aeip: token.aeip,
          name: token.name,
          id: token.id,
          type: token.type,
          supply: fromBigInt(token.supply).toDouble(),
          isLPToken: pairSymbolToken.isNotEmpty,
          symbol: pairSymbolToken.isNotEmpty ? pairSymbolToken : token.symbol,
          tokenProperties: token.properties,
        );
        final accountFungibleToken = AccountToken(
          tokenInformation: tokenInformation,
          amount: fromBigInt(tokenBalance.amount).toDouble(),
        );
        fungiblesTokensList.add(accountFungibleToken);
      }
    }
    fungiblesTokensList.sort(
      (a, b) => a.tokenInformation!.name!.compareTo(b.tokenInformation!.name!),
    );

    _logger.info(
      '>> END getFungiblesTokensList : ${DateTime.now()}',
    );

    return fungiblesTokensList;
  }

  Future<Map<String, Balance>> getBalanceGetResponse(
    List<String> addresses,
  ) async {
    if (addresses.isEmpty) {
      return <String, Balance>{};
    }
    final balanceMap = <String, Balance>{};

    final fetchBalances = await addresses
        .map(
          (address) => Task(
            name: 'getBalanceGetResponse - address: $address',
            logger: _logger,
            action: () => apiService.fetchBalance([address]),
          ),
        )
        .autoRetry()
        .batch();
    for (final fetchBalance in fetchBalances) {
      balanceMap.addAll(fetchBalance);
    }

    final balancesToReturn = <String, Balance>{};
    for (final address in addresses) {
      balancesToReturn[address] = balanceMap[address] ?? const Balance();
    }
    return balancesToReturn;
  }

  Future<double> getFeesEstimation(
    String originPrivateKey,
    String seed,
    String address,
    List<UCOTransfer> listUcoTransfer,
    List<TokenTransfer> listTokenTransfer,
    String message,
    KeychainServiceKeyPair keychainServiceKeyPair,
  ) async {
    final lastTransactionMap =
        await apiService.getLastTransaction([address], request: 'chainLength');

    final transaction = Transaction(
      type: 'transfer',
      version: blockchainTxVersion,
      data: Transaction.initData(),
    );
    for (final transfer in listUcoTransfer) {
      transaction.addUCOTransfer(transfer.to!, transfer.amount!);
    }
    for (final transfer in listTokenTransfer) {
      transaction.addTokenTransfer(
        transfer.to!,
        transfer.amount!,
        transfer.tokenAddress!,
        tokenId: transfer.tokenId == null ? 0 : transfer.tokenId!,
      );
    }
    if (message.isNotEmpty) {
      final aesKey = uint8ListToHex(
        Uint8List.fromList(
          List<int>.generate(32, (int i) => Random.secure().nextInt(256)),
        ),
      );

      final authorizedPublicKeys = List<String>.empty(growable: true)
        ..add(
          uint8ListToHex(
            Uint8List.fromList(keychainServiceKeyPair.publicKey),
          ).toUpperCase(),
        );

      for (final transfer in listUcoTransfer) {
        final firstTxListRecipientMap = await apiService.getTransactionChain(
          {transfer.to!: ''},
          request: 'previousPublicKey',
        );
        if (firstTxListRecipientMap.isNotEmpty) {
          final firstTxListRecipient = firstTxListRecipientMap[transfer.to!];
          if (firstTxListRecipient != null && firstTxListRecipient.isNotEmpty) {
            authorizedPublicKeys
                .add(firstTxListRecipient.first.previousPublicKey!);
          }
        }
      }

      for (final transfer in listTokenTransfer) {
        final firstTxListRecipientMap = await apiService.getTransactionChain(
          {transfer.to!: ''},
          request: 'previousPublicKey',
        );
        if (firstTxListRecipientMap.isNotEmpty) {
          final firstTxListRecipient = firstTxListRecipientMap[transfer.to!];
          if (firstTxListRecipient != null && firstTxListRecipient.isNotEmpty) {
            authorizedPublicKeys
                .add(firstTxListRecipient.first.previousPublicKey!);
          }
        }
      }

      final authorizedKeys = List<AuthorizedKey>.empty(growable: true);
      for (final key in authorizedPublicKeys) {
        authorizedKeys.add(
          AuthorizedKey(
            encryptedSecretKey: uint8ListToHex(ecEncrypt(aesKey, key)),
            publicKey: key,
          ),
        );
      }

      transaction.addOwnership(
        uint8ListToHex(aesEncrypt(message, aesKey)),
        authorizedKeys,
      );
    }

    var transactionFee = const TransactionFee();
    final lastTransaction = lastTransactionMap[address];
    transaction
        .build(seed, lastTransaction!.chainLength ?? 0)
        .transaction
        .originSign(originPrivateKey);
    try {
      transactionFee = await apiService.getTransactionFee(transaction);
    } catch (e, stack) {
      _logger.severe('Failed to get transaction fees', e, stack);
    }
    return fromBigInt(transactionFee.fee).toDouble();
  }
}
