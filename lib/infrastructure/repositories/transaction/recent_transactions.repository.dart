import 'package:aewallet/domain/models/token_parser.dart';
import 'package:aewallet/domain/repositories/transaction/recent_transactions.repository.dart';
import 'package:aewallet/infrastructure/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;

class RecentTransactionsRepositoryImpl
    with TokenParser
    implements RecentTransactionsRepository {
  RecentTransactionsRepositoryImpl({
    required this.apiService,
    required this.defTokensRepository,
  });

  final archethic.ApiService apiService;
  final TokensRepositoryImpl defTokensRepository;

  @override
  Future<List<RecentTransaction>> getAccountRecentTransactions(
    String genesisAddress,
  ) async {
    var recentTransactions = <RecentTransaction>[];

    final results = await Future.wait([
      apiService.chainUnspentOutputs([genesisAddress]),
      apiService.getTransactionChain({genesisAddress: ''}),
    ]);

    final unspentOutputsResultMap =
        results[0] as Map<String, List<archethic.UnspentOutputs>>;
    final transactionChainResultMap =
        results[1] as Map<String, List<archethic.Transaction>>;

    // Unspent Outputs list
    final accountUnspentOutputs = transactionChainResultMap[genesisAddress]!
        .first
        .validationStamp!
        .ledgerOperations!
        .unspentOutputs;

    // Inputs list
    final accountInputsFromChainUnspentOutputs =
        unspentOutputsResultMap[genesisAddress] ?? [];

    final accountInputsFromConsumedInputsTxChain =
        transactionChainResultMap[genesisAddress]!
            .first
            .validationStamp!
            .ledgerOperations!
            .consumedInputs;

    final accountInputs = <archethic.TransactionInput>[];
    for (final accountInputsFromChainUnspentOutput
        in accountInputsFromChainUnspentOutputs) {
      accountInputs.add(
        archethic.TransactionInput(
          amount: accountInputsFromChainUnspentOutput.amount,
          from: accountInputsFromChainUnspentOutput.from,
          timestamp: accountInputsFromChainUnspentOutput.timestamp,
          tokenAddress: accountInputsFromChainUnspentOutput.tokenAddress,
          tokenId: accountInputsFromChainUnspentOutput.tokenId,
          type: accountInputsFromChainUnspentOutput.type,
        ),
      );
    }

    for (final accountInputFromConsumedInputsTxChain
        in accountInputsFromConsumedInputsTxChain) {
      accountInputs.add(
        archethic.TransactionInput(
          amount: accountInputFromConsumedInputsTxChain.amount,
          from: accountInputFromConsumedInputsTxChain.from,
          timestamp: accountInputFromConsumedInputsTxChain.timestamp,
          tokenAddress: accountInputFromConsumedInputsTxChain.tokenAddress,
          tokenId: accountInputFromConsumedInputsTxChain.tokenId,
          type: accountInputFromConsumedInputsTxChain.type,
        ),
      );
    }

    for (final accountInput in accountInputs) {
      final recentTransaction = RecentTransaction()
        ..amount = archethic.fromBigInt(accountInput.amount).toDouble()
        ..typeTx = RecentTransaction.transferInput
        ..tokenAddress = accountInput.tokenAddress
        ..from = accountInput.from
        ..address = accountInput.from
        ..timestamp = accountInput.timestamp;
      recentTransactions.add(recentTransaction);
    }

    // Movements
    final transaction = transactionChainResultMap[genesisAddress]!.first;
    final accountTransactionMovements =
        transaction.validationStamp!.ledgerOperations!.transactionMovements;

    for (final accountTransactionMovement in accountTransactionMovements) {
      final recentTransaction = RecentTransaction()
        ..amount =
            archethic.fromBigInt(accountTransactionMovement.amount).toDouble()
        ..address = transaction.address!.address
        ..timestamp = transaction.validationStamp!.timestamp
        ..fee = archethic
            .fromBigInt(
              transaction.validationStamp!.ledgerOperations!.fee,
            )
            .toDouble();
      switch (transaction.type) {
        case 'token':
          recentTransaction.typeTx = RecentTransaction.tokenCreation;
          break;
        case 'hosting':
          recentTransaction.typeTx = RecentTransaction.hosting;
          break;
        case 'transfer':
          recentTransaction.typeTx = RecentTransaction.transferOutput;
          break;
        default:
      }

      recentTransactions.add(recentTransaction);
    }

    recentTransactions.sort((a, b) {
      final compareTimestamp = b.timestamp!.compareTo(a.timestamp!);
      if (compareTimestamp != 0) {
        return compareTimestamp;
      } else {
        return b.indexInLedger.compareTo(a.indexInLedger);
      }
    });

    recentTransactions = recentTransactions.sublist(
      0,
      recentTransactions.length > 10 ? 10 : recentTransactions.length,
    );

    // Get token id
    final tokensAddresses = <String>[];
    for (final recentTransaction in recentTransactions) {
      if (recentTransaction.tokenAddress != null &&
          recentTransaction.tokenAddress!.isNotEmpty &&
          recentTransaction.tokenInformation == null) {
        tokensAddresses.add(recentTransaction.tokenAddress!);
      }
    }

    // Search token Information
    final tokensAddressMap = await defTokensRepository.getTokensFromAddresses(
      tokensAddresses.toSet().toList(),
    );

    for (final recentTransaction in recentTransactions) {
      // Get token Information
      if (recentTransaction.tokenAddress != null &&
          recentTransaction.tokenAddress!.isNotEmpty &&
          recentTransaction.tokenInformation == null &&
          recentTransaction.timestamp! >= mostRecentTimestamp) {
        final token = tokensAddressMap[recentTransaction.tokenAddress];
        if (token != null) {
          recentTransaction
            ..tokenAddress = token.address
            ..tokenInformation = TokenInformation(
              address: token.address,
              name: token.name,
              supply: archethic.fromBigInt(token.supply).toDouble(),
              symbol: token.symbol,
              type: token.type,
            );
        }
      }

      // Decrypt secrets
      switch (recentTransaction.typeTx) {
        case RecentTransaction.transferInput:
          if (recentTransaction.from != null) {
            if (recentTransaction.timestamp! > mostRecentTimestamp) {
              ownershipsAddresses.add(recentTransaction.from!);
            }
            recentTransactionLastAddresses.add(recentTransaction.from!);
          }
          break;
        case RecentTransaction.transferOutput:
          if (recentTransaction.from != null) {
            if (recentTransaction.timestamp! > mostRecentTimestamp) {
              ownershipsAddresses.add(recentTransaction.from!);
            }
            recentTransactionLastAddresses.add(recentTransaction.from!);
          }
          break;
      }
    }

    return recentTransactions;
  }
}
