import 'dart:convert';
import 'dart:typed_data';

import 'package:aewallet/domain/models/token_parser.dart';
import 'package:aewallet/domain/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/domain/repositories/transaction/recent_transactions.repository.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/keychain_service_keypair.dart';
import 'package:aewallet/util/task.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;

/// A repository implementation for fetching and processing recent transactions
/// for a given account in a wallet. This class integrates with the Archethic
/// blockchain API and processes transactions to provide enriched data,
/// including token information and categorized transaction types.
///
/// This repository handles:
/// - Fetching unspent outputs and transaction chains for a given account.
/// - Filtering and processing transaction inputs and outputs to exclude
///   self-created UTXOs and other non-relevant data.
/// - Enriching transaction data with token details such as name, symbol,
///   and supply using the TokensRepository.
///
/// ### Specifications
/// - Consumed inputs include outputs from the user's own chain (e.g., recalculated UTXOs)
///   that are excluded from the displayed list.
/// - Unspent outputs created by the user are filtered from the transaction chain.
/// - Inputs are derived by combining chain unspent outputs and consumed inputs,
///   minus the user's unspent outputs, to exclude inputs originating from their chain.
/// - Older inputs are filtered to only display those newer than the current transaction.
/// - Transactions are enriched with movements and token metadata.
///
/// ### Dependencies
/// - [ApiService]: For interacting with the Archethic blockchain API.
/// - [TokensRepository]: For fetching token metadata and details.

// TODO(reddwarf03): Skip transactions with protocol version < 7
class RecentTransactionsRepositoryImpl
    with TokenParser
    implements RecentTransactionsRepository {
  RecentTransactionsRepositoryImpl({
    required this.apiService,
    required this.tokensRepository,
    required this.keyPair,
  });

  final archethic.ApiService apiService;
  final TokensRepository tokensRepository;
  final KeychainServiceKeyPair keyPair;

  @override
  Future<List<RecentTransaction>> getAccountRecentTransactions(
    String genesisAddress,
  ) async {
    final results = await _fetchTransactionData(genesisAddress);
    final accountInputs = await _processTransactionInputs(results);
    final recentTransactions = await _processTransactions(
      results,
      accountInputs,
      genesisAddress,
    );
    final enrichedRecentTransactions =
        await _enrichWithTokenInformation(recentTransactions);
    return _enrichMessageFromSecret(enrichedRecentTransactions);
  }

  Future<
      (
        Map<String, List<archethic.UnspentOutputs>>,
        Map<String, List<archethic.Transaction>>
      )> _fetchTransactionData(
    String genesisAddress,
  ) async {
    final results = await Future.wait([
      apiService.chainUnspentOutputs([genesisAddress]),
      apiService.getTransactionChain(
        {genesisAddress: ''},
        orderAsc: false,
        request: '''
      address,
      data { content,  
        ownerships {  authorizedPublicKeys { encryptedSecretKey, publicKey } secret } 
        ledger { uco { transfers { amount, to } }, 
        token { transfers { amount, to, tokenAddress, tokenId } } } 
        recipients, 
        actionRecipients { action address args } 
      }
      type, 
      validationStamp { timestamp, 
        ledgerOperations { fee, 
          unspentOutputs { amount from timestamp tokenAddress tokenId type }
          consumedInputs { amount from timestamp tokenAddress tokenId type protocolVersion }
          transactionMovements { amount to tokenAddress tokenId type }
        } 
        protocolVersion,
      }, 
      version
      ''',
      ),
    ]);

    return (
      results[0] as Map<String, List<archethic.UnspentOutputs>>,
      results[1] as Map<String, List<archethic.Transaction>>,
    );
  }

  Future<List<archethic.TransactionInput>> _processTransactionInputs(
    (
      Map<String, List<archethic.UnspentOutputs>>,
      Map<String, List<archethic.Transaction>>
    ) results,
  ) async {
    final (unspentOutputsResultMap, _) = results;
    final accountInputs = <archethic.TransactionInput>[];

    // Process unspent outputs
    final accountInputsFromChainUnspentOutputs =
        unspentOutputsResultMap.values.expand((e) => e).toList();

    accountInputs.addAll(
      accountInputsFromChainUnspentOutputs.map(
        (output) => archethic.TransactionInput(
          amount: output.amount,
          from: output.from,
          timestamp: output.timestamp,
          tokenAddress: output.tokenAddress,
          tokenId: output.tokenId,
          type: output.type,
        ),
      ),
    );

    return accountInputs;
  }

  Future<List<RecentTransaction>> _processTransactions(
    (
      Map<String, List<archethic.UnspentOutputs>>,
      Map<String, List<archethic.Transaction>>
    ) results,
    List<archethic.TransactionInput> accountInputs,
    String genesisAddress,
  ) async {
    final (_, transactionChainResultMap) = results;
    final recentTransactions = <RecentTransaction>[];

    final transactionChain =
        transactionChainResultMap[genesisAddress] ?? <archethic.Transaction>[];

    // Process each transaction
    for (final transaction in transactionChain) {
      // Process consumed inputs
      final consumedInputs =
          transaction.validationStamp?.ledgerOperations?.consumedInputs ?? [];
      accountInputs.addAll(
        consumedInputs.map(
          (input) => archethic.TransactionInput(
            amount: input.amount,
            from: input.from,
            timestamp: input.timestamp,
            tokenAddress: input.tokenAddress,
            tokenId: input.tokenId,
            type: input.type,
          ),
        ),
      );

      final recentTransaction = await _createRecentTransaction(transaction);
      if (recentTransaction != null) {
        recentTransactions.add(recentTransaction);
      }
    }

    // Process remaining inputs
    await _processRemainingInputs(
      transactionChain,
      accountInputs,
      recentTransactions,
    );

    // Sort and limit transactions
    recentTransactions.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));
    return recentTransactions.take(10).toList();
  }

  Future<RecentTransaction?> _createRecentTransaction(
    archethic.Transaction transaction,
  ) async {
    final movements =
        transaction.validationStamp?.ledgerOperations?.transactionMovements ??
            [];

    final ledgerOperationMvtInfo = movements
        .map(
          (movement) => (
            amount: archethic.fromBigInt(movement.amount).toDouble(),
            to: movement.to,
            type: movement.type,
            tokenInformation: TokenInformation(
              address: movement.type == 'UCO' ? 'UCO' : movement.tokenAddress,
              type: movement.type,
              symbol: movement.type == 'UCO' ? 'UCO' : movement.type,
            ),
          ),
        )
        .toList();

    if (transaction.type == 'token') {
      final tokenInfo =
          archethic.Token.fromJson(jsonDecode(transaction.data!.content!));
      ledgerOperationMvtInfo.add(
        (
          amount: 0,
          to: '',
          type: transaction.type,
          tokenInformation: TokenInformation(
            address: transaction.address!.address,
            supply: archethic.fromBigInt(tokenInfo.supply).toDouble(),
            symbol: tokenInfo.symbol,
            type: tokenInfo.type,
            name: tokenInfo.name,
          ),
        ),
      );
    }

    final action = _extractAction(transaction);

    final recentTransaction = RecentTransaction(
      address: transaction.address!.address,
      timestamp: transaction.validationStamp!.timestamp,
      ledgerOperationMvtInfo: ledgerOperationMvtInfo,
      fee: archethic
          .fromBigInt(transaction.validationStamp!.ledgerOperations!.fee)
          .toDouble(),
    );

    return _applyTransactionType(recentTransaction, transaction.type, action);
  }

  String _extractAction(archethic.Transaction transaction) {
    final actions = transaction.data?.recipients
            .where((r) => r.action != null)
            .map((r) => r.action![0].toUpperCase() + r.action!.substring(1))
            .toList() ??
        [];
    return actions.join(',').replaceAll('_', ' ');
  }

  RecentTransaction? _applyTransactionType(
    RecentTransaction transaction,
    String? type,
    String action,
  ) {
    switch (type) {
      case 'token':
        return transaction.copyWith(
          typeTx: RecentTransaction.tokenCreation,
          action: action.isEmpty ? 'Token' : action,
        );
      case 'hosting':
        return transaction.copyWith(
          typeTx: RecentTransaction.hosting,
          action: action.isEmpty ? 'Hosting' : action,
        );
      case 'transfer':
        return transaction.copyWith(
          typeTx: RecentTransaction.transferOutput,
          action: action.isEmpty ? 'Transfer' : action,
        );
      default:
        return null;
    }
  }

  Future<void> _processRemainingInputs(
    List<archethic.Transaction> transactionChain,
    List<archethic.TransactionInput> accountInputs,
    List<RecentTransaction> recentTransactions,
  ) async {
    // Remove spent outputs
    for (final transaction in transactionChain) {
      final unspentOutputs =
          transaction.validationStamp?.ledgerOperations?.unspentOutputs ?? [];
      for (final unspentOutput in unspentOutputs) {
        accountInputs.removeWhere(
          (input) =>
              input.timestamp == unspentOutput.timestamp &&
              input.amount == unspentOutput.amount &&
              input.from == unspentOutput.from &&
              input.tokenAddress == unspentOutput.tokenAddress &&
              input.tokenId == unspentOutput.tokenId &&
              input.type == unspentOutput.type,
        );
      }
    }

    bool _isValidInput(archethic.TransactionInput input) {
      return input.amount != null &&
          input.amount! > 0 &&
          input.from != null &&
          input.timestamp != null;
    }

    // Add remaining inputs as transactions
    for (final input in accountInputs) {
      if (_isValidInput(input)) {
        recentTransactions.add(
          RecentTransaction(
            typeTx: RecentTransaction.transferInput,
            from: input.from,
            address: input.from,
            timestamp: input.timestamp,
            ledgerOperationMvtInfo: [
              (
                amount: archethic.fromBigInt(input.amount).toDouble(),
                to: '',
                type: input.type,
                tokenInformation: TokenInformation(
                  address: input.type == 'UCO' ? 'UCO' : input.tokenAddress,
                  type: input.type,
                  symbol: input.type == 'UCO' ? 'UCO' : null,
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<List<RecentTransaction>> _enrichMessageFromSecret(
    List<RecentTransaction> recentTransactions,
  ) async {
    final ownershipsAddresses = <String>[];

    for (final recentTransaction in recentTransactions) {
      // Decrypt secrets
      switch (recentTransaction.typeTx) {
        case RecentTransaction.transferInput:
          if (recentTransaction.from != null) {
            ownershipsAddresses.add(recentTransaction.from!);
          }
        case RecentTransaction.transferOutput:
          if (recentTransaction.address != null) {
            ownershipsAddresses.add(recentTransaction.address!);
          }
          break;
      }
    }

    // Get List of ownerships
    final getTransactionOwnerships = await ownershipsAddresses
        .toSet()
        .map(
          (ownershipsAddress) => Task(
            name:
                'GetAccountRecentTransactions - ownershipsAddress: $ownershipsAddress',
            action: () => apiService.getTransactionOwnerships(
              [ownershipsAddress],
            ),
          ),
        )
        .autoRetry()
        .batch();

    final ownershipsMap = <String, List<archethic.Ownership>>{};
    for (final getTransactionOwnership in getTransactionOwnerships) {
      ownershipsMap.addAll(getTransactionOwnership);
    }

    final newRecentTransactions = <RecentTransaction>[];
    for (var recentTransaction in recentTransactions) {
      switch (recentTransaction.typeTx) {
        case RecentTransaction.transferInput:
          if (recentTransaction.from != null) {
            recentTransaction = _decryptedSecret(
              keypair: keyPair,
              ownerships: ownershipsMap[recentTransaction.from!] ?? [],
              recentTransaction: recentTransaction,
            );
          }
          break;
        case RecentTransaction.transferOutput:
          if (recentTransaction.address != null) {
            recentTransaction = _decryptedSecret(
              keypair: keyPair,
              ownerships: ownershipsMap[recentTransaction.address!] ?? [],
              recentTransaction: recentTransaction,
            );
          }
          break;
      }
      newRecentTransactions.add(recentTransaction);
    }

    return newRecentTransactions;
  }

  RecentTransaction _decryptedSecret({
    required KeychainServiceKeyPair keypair,
    required List<archethic.Ownership> ownerships,
    required RecentTransaction recentTransaction,
  }) {
    if (ownerships.isEmpty) {
      return recentTransaction;
    }
    var updatedTransaction =
        recentTransaction.copyWith(decryptedSecret: <String>[]);

    for (final ownership in ownerships) {
      final authorizedPublicKey = ownership.authorizedPublicKeys.firstWhere(
        (archethic.AuthorizedKey authKey) =>
            authKey.publicKey!.toUpperCase() ==
            archethic
                .uint8ListToHex(Uint8List.fromList(keypair.publicKey))
                .toUpperCase(),
        orElse: archethic.AuthorizedKey.new,
      );
      if (authorizedPublicKey.encryptedSecretKey != null) {
        final aesKey = archethic.ecDecrypt(
          authorizedPublicKey.encryptedSecretKey,
          Uint8List.fromList(keypair.privateKey),
        );
        final decryptedSecret = archethic.aesDecrypt(ownership.secret, aesKey);
        final decodedSecret = utf8.decode(decryptedSecret);
        updatedTransaction = updatedTransaction.copyWith(
          decryptedSecret: [
            ...?updatedTransaction.decryptedSecret,
            decodedSecret,
          ],
        );
      }
    }
    return updatedTransaction;
  }

  Future<List<RecentTransaction>> _enrichWithTokenInformation(
    List<RecentTransaction> recentTransactions,
  ) async {
    final tokenAddressSet = <String>{};
    for (final transaction in recentTransactions) {
      for (final mvt in transaction.ledgerOperationMvtInfo ?? []) {
        if (mvt.tokenInformation?.address != null &&
            mvt.tokenInformation!.address!.isNotEmpty &&
            mvt.tokenInformation?.address != 'UCO' &&
            (mvt.tokenInformation?.name == null ||
                mvt.tokenInformation?.name.isEmpty)) {
          tokenAddressSet.add(mvt.tokenInformation!.address!);
        }
      }
    }
    final tokensAddresses = tokenAddressSet.toList();

    if (tokensAddresses.isEmpty) return recentTransactions;

    final tokensAddressMap =
        await tokensRepository.getTokensFromAddresses(tokensAddresses);

    if (tokensAddressMap.isEmpty) {
      return recentTransactions;
    }

    return recentTransactions.map((transaction) {
      final updatedMvtInfo = transaction.ledgerOperationMvtInfo?.map((mvt) {
        final tokenAddress = mvt.tokenInformation?.address;
        if (tokenAddress != null &&
            tokenAddress.isNotEmpty &&
            tokensAddressMap[tokenAddress] != null) {
          final token = tokensAddressMap[tokenAddress]!;
          return (
            amount: mvt.amount,
            to: mvt.to,
            type: mvt.type,
            tokenInformation: TokenInformation(
              address: token.address,
              name: token.name,
              supply: archethic.fromBigInt(token.supply).toDouble(),
              symbol: token.symbol,
              type: token.type,
            ),
          );
        }
        return mvt;
      }).toList();

      return transaction.copyWith(ledgerOperationMvtInfo: updatedMvtInfo);
    }).toList();
  }
}
