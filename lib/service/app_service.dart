/// SPDX-License-Identifier: AGPL-3.0-or-later

// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:aewallet/infrastructure/datasources/tokens_list.hive.dart';
import 'package:aewallet/infrastructure/datasources/wallet_token_dto.hive.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/model/keychain_service_keypair.dart';
import 'package:aewallet/model/transaction_infos.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:aewallet/util/keychain_util.dart';
import 'package:aewallet/util/number_util.dart';
import 'package:aewallet/util/task.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

const blockchainTxVersion = 3;

class AppService {
  AppService({
    required this.apiService,
  });

  static final _logger = Logger('AppService');

  final ApiService apiService;

  Future<Map<String, List<Transaction>>> getTransactionChain(
    Map<String, String> addresses,
    String? request,
  ) async {
    final transactionChainMap = await apiService.getTransactionChain(
      addresses,
      request: request!,
    );
    return transactionChainMap;
  }

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

  List<RecentTransaction> _removeRecentTransactionsDuplicates(
    List<RecentTransaction> recentTransactions,
  ) =>
      recentTransactions.fold<List<RecentTransaction>>(
        [],
        (keptRecentTransactions, element) {
          final matchingIndex = keptRecentTransactions.indexWhere(
            (keptRecentTransaction) =>
                keptRecentTransaction.typeTx == element.typeTx &&
                keptRecentTransaction.from == element.from &&
                keptRecentTransaction.type == element.type &&
                keptRecentTransaction.tokenAddress == element.tokenAddress &&
                keptRecentTransaction.indexInLedger == element.indexInLedger,
          );

          if (matchingIndex == -1) {
            return [
              ...keptRecentTransactions,
              element,
            ];
          }

          final matchingElement = keptRecentTransactions[matchingIndex];
          if (matchingElement.timestamp! > element.timestamp!) {
            return keptRecentTransactions;
          }

          return [
            for (var i = 0; i < keptRecentTransactions.length; i++)
              i == matchingIndex ? element : keptRecentTransactions[i],
          ];
        },
      );

  List<RecentTransaction> _populateRecentTransactionsFromTransactionInputs(
    List<TransactionInput> transactionInputs,
    String notificationRecipientAddress,
    int mostRecentTimestamp,
    int transactionTimestamp,
  ) {
    final recentTransactions = <RecentTransaction>[];
    for (final transactionInput in transactionInputs) {
      if (transactionInput.from!.toUpperCase() !=
              notificationRecipientAddress.toUpperCase() &&
          transactionInput.timestamp! >= mostRecentTimestamp &&
          transactionInput.timestamp! >= transactionTimestamp) {
        final recentTransaction = RecentTransaction()
          ..address = transactionInput.from
          ..amount = fromBigInt(transactionInput.amount).toDouble()
          ..typeTx = RecentTransaction.transferInput
          ..from = transactionInput.from
          ..recipient = notificationRecipientAddress
          ..timestamp = transactionInput.timestamp
          ..fee = 0
          ..tokenAddress = transactionInput.tokenAddress;
        recentTransactions.add(recentTransaction);
      }
    }
    return recentTransactions;
  }

  List<RecentTransaction> _populateRecentTransactionsFromTransactionChain(
    List<Transaction> transactionChain,
  ) {
    final recentTransactions = <RecentTransaction>[];
    for (final transaction in transactionChain) {
      _logger.info('type ${transaction.type!} ${transaction.toJson()}');
      if (transaction.type! == 'token') {
        final recentTransaction = RecentTransaction()
          ..address = transaction.address!.address
          ..timestamp = transaction.validationStamp!.timestamp
          ..typeTx = RecentTransaction.tokenCreation
          ..fee = fromBigInt(transaction.validationStamp!.ledgerOperations!.fee)
              .toDouble()
          ..tokenAddress = transaction.address!.address;
        recentTransactions.add(recentTransaction);
      }

      if (transaction.type! == 'hosting') {
        final recentTransaction = RecentTransaction()
          ..address = transaction.address!.address
          ..timestamp = transaction.validationStamp!.timestamp
          ..typeTx = RecentTransaction.hosting
          ..fee = fromBigInt(transaction.validationStamp!.ledgerOperations!.fee)
              .toDouble()
          ..tokenAddress = transaction.address!.address;
        recentTransactions.add(recentTransaction);
      }

      if (transaction.type! == 'transfer') {
        var nbTrf = 0;
        var indexInLedger = 0;
        for (final transfer in transaction.data!.ledger!.uco!.transfers) {
          final recentTransaction = RecentTransaction()
            ..address = transaction.address!.address
            ..typeTx = RecentTransaction.transferOutput
            ..amount = fromBigInt(
              transfer.amount,
            ).toDouble()
            ..recipient = transfer.to
            ..fee =
                fromBigInt(transaction.validationStamp!.ledgerOperations!.fee)
                    .toDouble()
            ..timestamp = transaction.validationStamp!.timestamp
            ..from = transaction.address!.address
            ..ownerships = transaction.data!.ownerships
            ..indexInLedger = indexInLedger;
          recentTransactions.add(recentTransaction);
          indexInLedger++;
          nbTrf++;
        }
        indexInLedger = 0;
        for (final transfer in transaction.data!.ledger!.token!.transfers) {
          final recentTransaction = RecentTransaction()
            ..address = transaction.address!.address
            ..typeTx = RecentTransaction.transferOutput
            ..amount = fromBigInt(
              transfer.amount,
            ).toDouble()
            ..recipient = transfer.to
            ..fee =
                fromBigInt(transaction.validationStamp!.ledgerOperations!.fee)
                    .toDouble()
            ..timestamp = transaction.validationStamp!.timestamp
            ..from = transaction.address!.address
            ..ownerships = transaction.data!.ownerships
            ..tokenAddress = transfer.tokenAddress
            ..indexInLedger = indexInLedger;
          recentTransactions.add(recentTransaction);
          indexInLedger++;
          nbTrf++;
        }
        if (nbTrf == 0) {
          for (final contractRecipient in transaction.data!.recipients) {
            final recentTransaction = RecentTransaction()
              ..address = transaction.address!.address
              ..typeTx = RecentTransaction.transferOutput
              ..fee =
                  fromBigInt(transaction.validationStamp!.ledgerOperations!.fee)
                      .toDouble()
              ..timestamp = transaction.validationStamp!.timestamp
              ..from = contractRecipient.address
              ..ownerships = transaction.data!.ownerships
              ..indexInLedger = 0;
            recentTransactions.add(recentTransaction);
          }
        }
      }
    }
    return recentTransactions;
  }

  Future<List<RecentTransaction>> _buildRecentTransactionFromTransaction(
    List<RecentTransaction> recentTransactionList,
    String address,
    int mostRecentTimestamp,
  ) async {
    final _logger = Logger('AppService - recentTx');

    var newRecentTransactionList = recentTransactionList;
    _logger.info('>> START getTransaction : ${DateTime.now()}');
    final transaction = await apiService.getTransaction(
      [address],
      request:
          'address, type, chainLength, validationStamp { timestamp, ledgerOperations { fee } }, data { actionRecipients { action, address, args } ledger { uco { transfers { amount, to } } token {transfers {amount, to, tokenAddress, tokenId } } } }',
    );
    _logger
      ..info('$transaction')
      ..info('>> END getTransaction : ${DateTime.now()}')
      ..info('>> START getTransactionInputs : ${DateTime.now()}');
    final transactionInputs = await apiService.getTransactionInputs(
      [address],
      request: 'from, spent, tokenAddress, tokenId, amount, timestamp',
      limit: 10,
    );
    _logger.info('>> END getTransactionInputs : ${DateTime.now()}');
    if (transaction[address] != null) {
      final transactionTimeStamp =
          transaction[address]!.validationStamp!.timestamp!;

      if (transactionInputs[address] != null) {
        newRecentTransactionList
          ..addAll(
            _populateRecentTransactionsFromTransactionInputs(
              transactionInputs[address]!,
              address,
              mostRecentTimestamp,
              transaction[address]!.validationStamp!.timestamp!,
            ),
          )
          ..sort((tx1, tx2) => tx1.timestamp!.compareTo(tx2.timestamp!));
      }

      _logger
        ..info('1) $transactionInputs')
        ..info(
          'transactionTimeStamp $transactionTimeStamp > mostRecentTimestamp $mostRecentTimestamp)',
        );
      if (transactionTimeStamp > mostRecentTimestamp) {
        newRecentTransactionList
          ..addAll(
            _populateRecentTransactionsFromTransactionChain(
              [transaction[address]!],
            ),
          )
          ..sort((tx1, tx2) => tx1.timestamp!.compareTo(tx2.timestamp!));
      }

      // Remove doublons (on type / token address / from / timestamp)
      if (newRecentTransactionList.isNotEmpty) {
        newRecentTransactionList =
            _removeRecentTransactionsDuplicates(newRecentTransactionList);
      }
    }

    return newRecentTransactionList;
  }

  Future<List<RecentTransaction>> getAccountRecentTransactions(
    String genesisAddress,
    String name,
    KeychainSecuredInfos keychainSecuredInfos,
    List<RecentTransaction> localRecentTransactionList,
  ) async {
    _logger.info(
      '>> START getRecentTransactions : ${DateTime.now()}',
    );

    final _localRecentTransactionList =
        List<RecentTransaction>.from(localRecentTransactionList);

    // get the most recent movement in cache
    var mostRecentTimestamp = 0;
    if (_localRecentTransactionList.isNotEmpty) {
      _localRecentTransactionList.sort(
        (a, b) => b.timestamp!.compareTo(a.timestamp!),
      );
      mostRecentTimestamp = _localRecentTransactionList.first.timestamp ?? 0;
    }
    var recentTransactions = <RecentTransaction>[];

    final keychain = keychainSecuredInfos.toKeychain();

    final lastIndex = await apiService.getTransactionIndex(
      [genesisAddress],
    );
    _logger.info('genesisAddress : $genesisAddress -> lastIndex: $lastIndex');
    var index = lastIndex[genesisAddress] ?? 0;
    String addressToSearch;
    var iterMax = 10;
    recentTransactions.addAll(_localRecentTransactionList);

    while (index > 0 && iterMax > 0) {
      addressToSearch = uint8ListToHex(
        keychain.deriveAddress(
          name,
          index: index,
        ),
      );
      _logger.info('addressToSearch : $addressToSearch');
      if (_localRecentTransactionList.any(
        (element) =>
            element.address!.toUpperCase() == addressToSearch.toUpperCase(),
      )) {
        _logger.info('addressToSearch exists in local -> break');
        recentTransactions = await _buildRecentTransactionFromTransaction(
          recentTransactions,
          addressToSearch,
          mostRecentTimestamp,
        );
        break;
      }

      recentTransactions = await _buildRecentTransactionFromTransaction(
        recentTransactions,
        addressToSearch,
        mostRecentTimestamp,
      );
      index--;
      iterMax--;
    }

    if (recentTransactions.length < 10) {
      // Get transaction inputs from genesis address if filtered list is < 10
      final genesisTransactionInputsMap = await getTransactionInputs(
        [genesisAddress],
        'from, type, spent, tokenAddress, amount, timestamp',
        limit: 10 - recentTransactions.length,
      );

      if (genesisTransactionInputsMap[genesisAddress] != null) {
        recentTransactions.addAll(
          _populateRecentTransactionsFromTransactionInputs(
            genesisTransactionInputsMap[genesisAddress]!,
            genesisAddress,
            mostRecentTimestamp,
            0,
          ),
        );
      }
    }

    // Remove doublons (on type / token address / from / timestamp)
    if (recentTransactions.isNotEmpty) {
      recentTransactions =
          _removeRecentTransactionsDuplicates(recentTransactions);
    }

    // Sort by timestamp desc and index ledger desc
    recentTransactions.sort((a, b) {
      final compareTimestamp = b.timestamp!.compareTo(a.timestamp!);
      if (compareTimestamp != 0) {
        return compareTimestamp;
      } else {
        return b.indexInLedger.compareTo(a.indexInLedger);
      }
    });

    // Get 10 first transactions
    recentTransactions = recentTransactions.sublist(
      0,
      recentTransactions.length > 10 ? 10 : recentTransactions.length,
    );

    // Get token id
    final tokensAddresses = <String>[];
    for (final recentTransaction in recentTransactions) {
      if (recentTransaction.tokenAddress != null &&
          recentTransaction.tokenAddress!.isNotEmpty &&
          recentTransaction.timestamp! >= mostRecentTimestamp) {
        tokensAddresses.add(recentTransaction.tokenAddress!);
      }
    }

    final recentTransactionLastAddresses = <String>[];
    final ownershipsAddresses = <String>[];

    // Search token Information
    final tokensAddressMap = await getToken(
      tokensAddresses.toSet().toList(),
    );

    for (final recentTransaction in recentTransactions) {
      // Get token Information
      if (recentTransaction.tokenAddress != null &&
          recentTransaction.tokenAddress!.isNotEmpty &&
          recentTransaction.timestamp! >= mostRecentTimestamp) {
        final token = tokensAddressMap[recentTransaction.tokenAddress];
        if (token != null) {
          recentTransaction.tokenInformation = TokenInformation(
            address: token.address,
            name: token.name,
            supply: fromBigInt(token.supply).toDouble(),
            symbol: token.symbol,
            type: token.type,
          );
        }
      }

      // Decrypt secrets
      switch (recentTransaction.typeTx) {
        case RecentTransaction.transferInput:
          if (recentTransaction.from != null) {
            if (recentTransaction.timestamp! >= mostRecentTimestamp) {
              ownershipsAddresses.add(recentTransaction.from!);
            }
            recentTransactionLastAddresses.add(recentTransaction.from!);
          }
          break;
        case RecentTransaction.transferOutput:
          if (recentTransaction.from != null) {
            if (recentTransaction.timestamp! >= mostRecentTimestamp) {
              ownershipsAddresses.add(recentTransaction.from!);
            }
            recentTransactionLastAddresses.add(recentTransaction.from!);
          }
          break;
      }
    }

    // Get List of ownerships
    final ownershipsMap = <String, List<Ownership>>{};

    final getTransactionOwnerships = await ownershipsAddresses
        .toSet()
        .map(
          (ownershipsAddress) => Task(
            name:
                'GetAccountRecentTransactions - ownershipsAddress: $ownershipsAddress',
            logger: _logger,
            action: () => apiService.getTransactionOwnerships(
              [ownershipsAddress],
            ),
          ),
        )
        .autoRetry()
        .batch();

    for (final getTransactionOwnership in getTransactionOwnerships) {
      ownershipsMap.addAll(getTransactionOwnership);
    }

    final keychainServiceKeyPair = keychainSecuredInfos.services[name]!.keyPair;
    for (var recentTransaction in recentTransactions) {
      switch (recentTransaction.typeTx) {
        case RecentTransaction.transferInput:
          if (recentTransaction.from != null &&
              recentTransaction.timestamp! >= mostRecentTimestamp) {
            recentTransaction = _decryptedSecret(
              keypair: keychainServiceKeyPair!,
              ownerships: ownershipsMap[recentTransaction.from!] ?? [],
              recentTransaction: recentTransaction,
            );
          }
          break;
        case RecentTransaction.transferOutput:
          if (recentTransaction.address != null &&
              recentTransaction.timestamp! >= mostRecentTimestamp) {
            recentTransaction = _decryptedSecret(
              keypair: keychainServiceKeyPair!,
              ownerships: ownershipsMap[recentTransaction.address!] ?? [],
              recentTransaction: recentTransaction,
            );
          }
          break;
      }
    }

    // Get last transactions for all tx and contacts
    final lastTransactionAddressesToSearch = [
      ...recentTransactionLastAddresses,
    ];

    final lastAddressesMap = <String, Transaction>{};

    final getLastTransactions = await lastTransactionAddressesToSearch
        .toSet()
        .map(
          (lastTransactionAddressToSearch) => Task(
            name:
                'GetAccountRecentTransactions - lastTransactionAddressToSearch: $lastTransactionAddressToSearch',
            logger: _logger,
            action: () => apiService.getLastTransaction(
              [lastTransactionAddressToSearch],
              request: 'address',
            ),
          ),
        )
        .autoRetry()
        .batch();
    for (final getLastTransaction in getLastTransactions) {
      lastAddressesMap.addAll(getLastTransaction);
    }

    // We complete map with last address not found because no tx in the chain
    for (final lastTransactionAddressToSearch
        in lastTransactionAddressesToSearch) {
      if (lastAddressesMap[lastTransactionAddressToSearch] == null) {
        lastAddressesMap[lastTransactionAddressToSearch] = Transaction(
          type: '',
          data: Transaction.initData(),
          address:
              Address(address: lastTransactionAddressToSearch.toUpperCase()),
        );
      }
    }

    _logger.info(
      '>> END getRecentTransactions : ${DateTime.now()}',
    );

    return recentTransactions;
  }

  RecentTransaction _decryptedSecret({
    required KeychainServiceKeyPair keypair,
    required List<Ownership> ownerships,
    required RecentTransaction recentTransaction,
  }) {
    recentTransaction.decryptedSecret = List<String>.empty(growable: true);
    if (ownerships.isEmpty) {
      return recentTransaction;
    }
    for (final ownership in ownerships) {
      final authorizedPublicKey = ownership.authorizedPublicKeys.firstWhere(
        (AuthorizedKey authKey) =>
            authKey.publicKey!.toUpperCase() ==
            uint8ListToHex(Uint8List.fromList(keypair.publicKey)).toUpperCase(),
        orElse: AuthorizedKey.new,
      );
      if (authorizedPublicKey.encryptedSecretKey != null) {
        final aesKey = ecDecrypt(
          authorizedPublicKey.encryptedSecretKey,
          Uint8List.fromList(keypair.privateKey),
        );
        final decryptedSecret = aesDecrypt(ownership.secret, aesKey);
        recentTransaction.decryptedSecret!.add(utf8.decode(decryptedSecret));
      }
    }
    return recentTransaction;
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

  Future<Map<String, Transaction>> getTransaction(
    List<String> addresses, {
    String request = Transaction.kTransactionQueryAllFields,
  }) async {
    final transactionMap = await apiService.getTransaction(
      addresses.toSet().toList(),
      request: request,
    );
    return transactionMap;
  }

  Future<List<TransactionInfos>> getTransactionAllInfos(
    String address,
    DateFormat dateFormat,
    String cryptoCurrency,
    BuildContext context,
    KeychainServiceKeyPair keychainServiceKeyPair,
  ) async {
    final transactionsInfos = List<TransactionInfos>.empty(growable: true);

    final transactionMap = await apiService.getTransaction(
      [address],
      request:
          ' address, data { content,  ownerships {  authorizedPublicKeys { encryptedSecretKey, publicKey } secret } ledger { uco { transfers { amount, to } }, token { transfers { amount, to, tokenAddress, tokenId } } } actionRecipients { action, address, args } }, type ',
    );
    final transaction = transactionMap[address];
    if (transaction == null) {
      return [];
    }
    if (transaction.address != null) {
      transactionsInfos.add(
        TransactionInfos(
          domain: '',
          titleInfo: 'Address',
          valueInfo: transaction.address!.address!,
        ),
      );
    }
    if (transaction.type != null) {
      transactionsInfos.add(
        TransactionInfos(
          domain: '',
          titleInfo: 'Type',
          valueInfo: transaction.type!,
        ),
      );
    }
    if (transaction.data != null) {
      transactionsInfos
          .add(TransactionInfos(domain: 'Data', titleInfo: '', valueInfo: ''));

      if (transaction.data!.content != null) {
        transactionsInfos.add(
          TransactionInfos(
            domain: 'Data',
            titleInfo: 'Content',
            valueInfo:
                transaction.type == 'token' || transaction.type == 'hosting'
                    ? 'See explorer...'
                    : transaction.data!.content == ''
                        ? 'N/A'
                        : transaction.data!.content!,
          ),
        );
      }

      if (transaction.data!.code != null) {
        transactionsInfos.add(
          TransactionInfos(
            domain: 'Data',
            titleInfo: 'Code',
            valueInfo: transaction.data!.code!,
          ),
        );
      }
      if (transaction.data!.ownerships.isNotEmpty) {
        for (final ownership in transaction.data!.ownerships) {
          final authorizedPublicKey = ownership.authorizedPublicKeys.firstWhere(
            (AuthorizedKey authKey) =>
                authKey.publicKey!.toUpperCase() ==
                uint8ListToHex(
                  Uint8List.fromList(keychainServiceKeyPair.publicKey),
                ).toUpperCase(),
            orElse: AuthorizedKey.new,
          );
          if (authorizedPublicKey.encryptedSecretKey != null) {
            final aesKey = ecDecrypt(
              authorizedPublicKey.encryptedSecretKey,
              Uint8List.fromList(keychainServiceKeyPair.privateKey),
            );
            final decryptedSecret = aesDecrypt(ownership.secret, aesKey);
            transactionsInfos.add(
              TransactionInfos(
                domain: 'Data',
                titleInfo: 'Secret',
                valueInfo: utf8.decode(decryptedSecret),
              ),
            );
          }
        }
      }
      if (transaction.data!.ledger != null &&
          transaction.data!.ledger!.uco != null &&
          transaction.data!.ledger!.uco!.transfers.isNotEmpty) {
        transactionsInfos.add(
          TransactionInfos(
            domain: 'UCOLedger',
            titleInfo: '',
            valueInfo: '',
          ),
        );
        for (var i = 0;
            i < transaction.data!.ledger!.uco!.transfers.length;
            i++) {
          if (transaction.data!.ledger!.uco!.transfers[i].to != null) {
            transactionsInfos.add(
              TransactionInfos(
                domain: 'UCOLedger',
                titleInfo: 'To',
                valueInfo: transaction.data!.ledger!.uco!.transfers[i].to!,
              ),
            );
          }
          if (transaction.data!.ledger!.uco!.transfers[i].amount != null) {
            transactionsInfos.add(
              TransactionInfos(
                domain: 'UCOLedger',
                titleInfo: 'Amount',
                valueInfo:
                    '${NumberUtil.formatThousands(fromBigInt(transaction.data!.ledger!.uco!.transfers[i].amount))} $cryptoCurrency',
              ),
            );
          }
        }
      }
      if (transaction.data!.ledger != null &&
          transaction.data!.ledger!.token != null &&
          transaction.data!.ledger!.token!.transfers.isNotEmpty) {
        transactionsInfos.add(
          TransactionInfos(
            domain: 'TokenLedger',
            titleInfo: '',
            valueInfo: '',
          ),
        );
        for (var i = 0;
            i < transaction.data!.ledger!.token!.transfers.length;
            i++) {
          if (transaction.data!.ledger!.token!.transfers[i].tokenAddress !=
              null) {
            transactionsInfos.add(
              TransactionInfos(
                domain: 'TokenLedger',
                titleInfo: 'Token',
                valueInfo:
                    transaction.data!.ledger!.token!.transfers[i].tokenAddress!,
              ),
            );
          }
          if (transaction.data!.ledger!.token!.transfers[i].to != null) {
            transactionsInfos.add(
              TransactionInfos(
                domain: 'TokenLedger',
                titleInfo: 'To',
                valueInfo: transaction.data!.ledger!.token!.transfers[i].to!,
              ),
            );
          }
          if (transaction.data!.ledger!.token!.transfers[i].amount != null) {
            final tokenMap = await getToken(
              [transaction.data!.ledger!.token!.transfers[i].tokenAddress!],
            );
            var tokenSymbol = '';
            if (tokenMap[transaction
                    .data!.ledger!.token!.transfers[i].tokenAddress!] !=
                null) {
              tokenSymbol = tokenMap[transaction
                          .data!.ledger!.token!.transfers[i].tokenAddress!]!
                      .symbol ??
                  '';
            }
            transactionsInfos.add(
              TransactionInfos(
                domain: 'TokenLedger',
                titleInfo: 'Amount',
                valueInfo:
                    '${NumberUtil.formatThousands(fromBigInt(transaction.data!.ledger!.token!.transfers[i].amount))} $tokenSymbol',
              ),
            );
          }
        }
      }
    }
    return transactionsInfos;
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
