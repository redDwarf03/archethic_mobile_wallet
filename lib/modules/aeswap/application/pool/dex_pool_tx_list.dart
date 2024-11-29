/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'dex_pool.dart';

@riverpod
Future<List<DexPoolTx>> _getPoolTxList(
  Ref ref,
  DexPool pool,
  String lastTransactionAddress,
) async {
  const kProtocolFeeAddress =
      '0000CC1FADBD31B043947C016E09CCD59BC3C81E55AB8A4932A046236D5E0FEE9E45';

  final fiatValueToken1 = await ref.watch(
    DexTokensProviders.estimateTokenInFiat(pool.pair.token1.address).future,
  );
  final fiatValueToken2 = await ref.watch(
    DexTokensProviders.estimateTokenInFiat(pool.pair.token2.address).future,
  );

  final apiService = ref.watch(apiServiceProvider);
  final dexPoolTxList = <DexPoolTx>[];
  final transactionChainResult = await apiService.getTransactionChain(
    {pool.poolAddress: lastTransactionAddress},
    orderAsc: false,
    request:
        ' address, validationStamp {timestamp ledgerOperations { transactionMovements { amount to tokenAddress type } consumedInputs { from, type } } }',
  );

  final transactionsMap = <String, Transaction>{};
  if (transactionChainResult[pool.poolAddress] != null) {
    final transactions = transactionChainResult[pool.poolAddress];

    var transactionsActionMap = <String, Transaction>{};
    for (final transaction in transactions!) {
      if (transaction.validationStamp != null &&
          transaction.validationStamp!.ledgerOperations != null &&
          transaction
              .validationStamp!.ledgerOperations!.consumedInputs.isNotEmpty) {
        for (final consumedInput
            in transaction.validationStamp!.ledgerOperations!.consumedInputs) {
          if (consumedInput.type == 'call' && consumedInput.from != null) {
            transactionsMap[consumedInput.from!] = transaction;
          }
        }
      }
    }

    if (transactionsMap.isNotEmpty) {
      transactionsActionMap = await apiService.getTransaction(
        transactionsMap.keys.toList(),
        request:
            ' address validationStamp {ledgerOperations { transactionMovements { amount to tokenAddress type } consumedInputs { from, type } } } data { actionRecipients { action address }} ',
      );
    }

    transactionsMap.forEach((txAddress, transaction) {
      final transactionAction = transactionsActionMap[txAddress];

      if (transactionAction != null &&
          transactionAction.data != null &&
          transactionAction.data!.actionRecipients.isNotEmpty &&
          transactionAction.data!.actionRecipients[0].action != null) {
        var token1Amount = 0.0;
        var token2Amount = 0.0;
        double? totalValue;
        double? totalValueToken1;
        double? totalValueToken2;
        DexToken? token1;
        DexToken? token2;
        DexActionType? typeTx;
        switch (transactionAction.data!.actionRecipients[0].action) {
          case 'swap':
            for (final transactionMovement in transactionAction
                .validationStamp!.ledgerOperations!.transactionMovements) {
              if ((transactionMovement.tokenAddress != null &&
                      transactionMovement.tokenAddress!.toUpperCase() ==
                          pool.pair.token1.address.toUpperCase()) ||
                  (transactionMovement.type!.toUpperCase().isUCO &&
                      pool.pair.token1.isUCO)) {
                token1Amount = fromBigInt(
                  transactionMovement.amount,
                ).toDouble();
                token1 = pool.pair.token1;
                if (fiatValueToken1 > 0) {
                  totalValueToken1 = fiatValueToken1 * token1Amount;
                }
              }

              if ((transactionMovement.tokenAddress != null &&
                      transactionMovement.tokenAddress!.toUpperCase() ==
                          pool.pair.token2.address.toUpperCase()) ||
                  (transactionMovement.type!.toUpperCase().isUCO &&
                      pool.pair.token2.isUCO)) {
                token1Amount = fromBigInt(
                  transactionMovement.amount,
                ).toDouble();
                token1 = pool.pair.token2;
                if (fiatValueToken2 > 0) {
                  totalValueToken1 = fiatValueToken2 * token1Amount;
                }
              }
            }

            for (final transactionMovement in transaction
                .validationStamp!.ledgerOperations!.transactionMovements) {
              if (transactionMovement.to!.toUpperCase() !=
                  kProtocolFeeAddress) {
                if ((transactionMovement.tokenAddress != null &&
                        transactionMovement.tokenAddress!.toUpperCase() ==
                            pool.pair.token1.address.toUpperCase()) ||
                    (transactionMovement.type!.toUpperCase().isUCO &&
                        pool.pair.token1.isUCO)) {
                  token2Amount = fromBigInt(
                    transactionMovement.amount,
                  ).toDouble();
                  token2 = pool.pair.token1;
                  if (fiatValueToken1 > 0) {
                    totalValueToken2 = fiatValueToken1 * token2Amount;
                  }
                }

                if ((transactionMovement.tokenAddress != null &&
                        transactionMovement.tokenAddress!.toUpperCase() ==
                            pool.pair.token2.address.toUpperCase()) ||
                    (transactionMovement.type!.toUpperCase().isUCO &&
                        pool.pair.token2.isUCO)) {
                  token2Amount = fromBigInt(
                    transactionMovement.amount,
                  ).toDouble();
                  token2 = pool.pair.token2;
                  if (fiatValueToken2 > 0) {
                    totalValueToken2 = fiatValueToken2 * token2Amount;
                  }
                }
              }
            }
            typeTx = DexActionType.swap;
            break;
          case 'remove_liquidity':
            for (final transactionMovement in transaction
                .validationStamp!.ledgerOperations!.transactionMovements) {
              if ((transactionMovement.tokenAddress != null &&
                      transactionMovement.tokenAddress!.toUpperCase() ==
                          pool.pair.token1.address.toUpperCase()) ||
                  (transactionMovement.type!.toUpperCase().isUCO &&
                      pool.pair.token1.isUCO)) {
                token1Amount = fromBigInt(
                  transactionMovement.amount,
                ).toDouble();
                token1 = pool.pair.token1;
                if (fiatValueToken1 > 0) {
                  totalValueToken1 = fiatValueToken1 * token1Amount;
                }
              }

              if ((transactionMovement.tokenAddress != null &&
                      transactionMovement.tokenAddress!.toUpperCase() ==
                          pool.pair.token2.address.toUpperCase()) ||
                  (transactionMovement.type!.toUpperCase().isUCO &&
                      pool.pair.token2.isUCO)) {
                token2Amount = fromBigInt(
                  transactionMovement.amount,
                ).toDouble();
                token2 = pool.pair.token2;
                if (fiatValueToken2 > 0) {
                  totalValueToken2 = fiatValueToken2 * token2Amount;
                }
              }
            }

            typeTx = DexActionType.removeLiquidity;
            break;
          case 'add_liquidity':
            for (final transactionMovement in transactionAction
                .validationStamp!.ledgerOperations!.transactionMovements) {
              if ((transactionMovement.tokenAddress != null &&
                      transactionMovement.tokenAddress!.toUpperCase() ==
                          pool.pair.token1.address.toUpperCase()) ||
                  (transactionMovement.type!.toUpperCase().isUCO &&
                      pool.pair.token1.isUCO)) {
                token1Amount = fromBigInt(
                  transactionMovement.amount,
                ).toDouble();
                token1 = pool.pair.token1;
                if (fiatValueToken1 > 0) {
                  totalValueToken1 = fiatValueToken1 * token1Amount;
                }
              }

              if ((transactionMovement.tokenAddress != null &&
                      transactionMovement.tokenAddress!.toUpperCase() ==
                          pool.pair.token2.address.toUpperCase()) ||
                  (transactionMovement.type!.toUpperCase().isUCO &&
                      pool.pair.token2.isUCO)) {
                token2Amount = fromBigInt(
                  transactionMovement.amount,
                ).toDouble();
                token2 = pool.pair.token2;
                if (fiatValueToken2 > 0) {
                  totalValueToken2 = fiatValueToken2 * token2Amount;
                }
              }
            }

            typeTx = DexActionType.addLiquidity;
            break;
          default:
        }

        if (typeTx != null) {
          if (totalValueToken1 != null) {
            totalValue = totalValueToken1;
          }
          if (totalValueToken2 != null) {
            if (totalValue != null) {
              totalValue = totalValue + totalValueToken2;
            } else {
              totalValue = totalValueToken2;
            }
          }
          dexPoolTxList.add(
            DexPoolTx(
              addressTx: transaction.address!.address,
              typeTx: typeTx,
              time: DateTime.fromMillisecondsSinceEpoch(
                transaction.validationStamp!.timestamp! * 1000,
              ),
              addressAccount: transaction.validationStamp!.ledgerOperations!
                  .transactionMovements[0].to,
              token1Amount: token1Amount,
              token2Amount: token2Amount,
              token1: token1,
              token2: token2,
              totalValue: totalValue,
            ),
          );
        }
      }
    });
  }

  return dexPoolTxList;
}
