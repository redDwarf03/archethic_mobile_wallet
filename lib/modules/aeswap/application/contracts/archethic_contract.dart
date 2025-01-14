/// SPDX-License-Identifier: AGPL-3.0-or-later
// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:aewallet/modules/aeswap/application/factory.dart';
import 'package:aewallet/modules/aeswap/application/router_factory.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/infrastructure/pool_factory.repository.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:decimal/decimal.dart';

const blockchainTxVersion = 3;

class ArchethicContract with aedappfm.TransactionMixin {
  const ArchethicContract({
    required this.apiService,
    required this.verifiedTokensRepository,
  });
  final archethic.ApiService apiService;
  final aedappfm.VerifiedTokensRepositoryInterface verifiedTokensRepository;

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>> getAddPoolTx(
    String routerAddress,
    String factoryAddress,
    DexToken token1,
    DexToken token2,
    String poolSeed,
    String poolGenesisAddress,
    String lpTokenAddress,
  ) async {
    return aedappfm.Result.guard(() async {
      final routerFactory = RouterFactory(
        routerAddress,
        apiService,
        verifiedTokensRepository,
      );
      final poolInfosResult = await routerFactory.getPoolAddresses(
        token1.address,
        token2.address,
      );
      poolInfosResult.map(
        success: (success) {
          if (success != null && success['address'] != null) {
            throw const aedappfm.PoolAlreadyExists();
          }
        },
        failure: (failure) {
          return;
        },
      );

      String? poolCode;
      final factory = Factory(factoryAddress, apiService);
      final resultPoolCode = await factory.getPoolCode(
        token1.address,
        token2.address,
        poolGenesisAddress,
        lpTokenAddress,
      );
      resultPoolCode.map(
        success: (success) {
          if (success.isEmpty) {
            throw const aedappfm.Failure.other(
              cause: 'Pool code from smart contract is empty',
            );
          }
          poolCode = success;
        },
        failure: (failure) {
          throw failure;
        },
      );

      String? tokenDefinition;
      final resultLPTokenDefinition = await factory.getLPTokenDefinition(
        token1.address,
        token2.address,
      );
      resultLPTokenDefinition.map(
        success: (success) {
          tokenDefinition = success;
        },
        failure: (failure) {
          return;
        },
      );

      final storageNoncePublicKey = await apiService.getStorageNoncePublicKey();
      final aesKey = archethic.uint8ListToHex(
        Uint8List.fromList(
          List<int>.generate(32, (int i) => Random.secure().nextInt(256)),
        ),
      );
      final authorizedKey = archethic.AuthorizedKey(
        encryptedSecretKey: archethic
            .uint8ListToHex(archethic.ecEncrypt(aesKey, storageNoncePublicKey)),
        publicKey: storageNoncePublicKey,
      );

      final originPrivateKey = apiService.getOriginKey();

      final transactionPool = archethic.Transaction(
        type: 'token',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      )
          .setContent(tokenDefinition!)
          .setCode(poolCode!)
          .addOwnership(
            archethic.uint8ListToHex(
              archethic.aesEncrypt(poolSeed, aesKey),
            ),
            [authorizedKey],
          )
          .build(poolSeed, 0)
          .transaction
          .originSign(originPrivateKey);

      return transactionPool;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getAddPoolTxTransfer(
    archethic.Transaction transactionPool,
    String poolGenesisAddress,
  ) async {
    return aedappfm.Result.guard(() async {
      final feesToken = await calculateFees(
        transactionPool,
        apiService,
      );

      final transactionTransfer = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addUCOTransfer(poolGenesisAddress, archethic.toBigInt(feesToken));

      return transactionTransfer;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getAddPoolPlusLiquidityTx(
    String routerAddress,
    String transactionPoolAddress,
    DexToken token1,
    double token1Amount,
    DexToken token2,
    double token2Amount,
    String poolGenesisAddress,
    double slippage,
  ) async {
    return aedappfm.Result.guard(() async {
      final poolInfos = await PoolFactoryRepositoryImpl(
        poolGenesisAddress,
        apiService,
      ).getPoolInfos().valueOrThrow;

      // Sort token to match pool order
      var token1AmountSorted = 0.0;
      var token2AmountSorted = 0.0;
      DexToken? token1Sorted;
      DexToken? token2Sorted;
      if (token1.address.toUpperCase() ==
          poolInfos.token1Address.toUpperCase()) {
        token1AmountSorted = token1Amount;
        token2AmountSorted = token2Amount;
        token1Sorted = token1;
        token2Sorted = token2;
      } else {
        token2AmountSorted = token1Amount;
        token1AmountSorted = token2Amount;
        token2Sorted = token1;
        token1Sorted = token2;
      }

      final slippagePourcent =
          (Decimal.parse('100') - Decimal.parse('$slippage')) /
              Decimal.parse('100');
      final token1minAmount =
          Decimal.parse('$token1AmountSorted') * slippagePourcent.toDecimal();
      final token2minAmount =
          Decimal.parse('$token2AmountSorted') * slippagePourcent.toDecimal();

      final transactionAdd = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        poolGenesisAddress,
        action: 'add_liquidity',
        args: [
          token1minAmount.toDouble(),
          token2minAmount.toDouble(),
        ],
      ).addRecipient(
        routerAddress,
        action: 'add_pool',
        args: [
          token1Sorted.address,
          token2Sorted.address,
          transactionPoolAddress.toUpperCase(),
        ],
      );

      if (token1Sorted.isUCO) {
        transactionAdd.addUCOTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token1AmountSorted),
        );
      } else {
        transactionAdd.addTokenTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token1AmountSorted),
          token1Sorted.address,
        );
      }

      if (token2Sorted.isUCO) {
        transactionAdd.addUCOTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token2AmountSorted),
        );
      } else {
        transactionAdd.addTokenTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token2AmountSorted),
          token2Sorted.address,
        );
      }
      return transactionAdd;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getAddLiquidityTx(
    DexToken token1,
    double token1Amount,
    DexToken token2,
    double token2Amount,
    String poolGenesisAddress,
    double slippage,
  ) async {
    return aedappfm.Result.guard(() async {
      var expectedTokenLP = 0.0;
      final expectedTokenLPResult = await PoolFactoryRepositoryImpl(
        poolGenesisAddress,
        apiService,
      ).getLPTokenToMint(token1Amount, token2Amount);
      expectedTokenLPResult.map(
        success: (success) {
          if (success != null) {
            expectedTokenLP = success;
          }
        },
        failure: (failure) {},
      );

      if (expectedTokenLP == 0) {
        throw const aedappfm.Failure.other(
          cause:
              'Please increase the amount of tokens added to be eligible for receiving LP Tokens.',
        );
      }

      final poolInfos = await PoolFactoryRepositoryImpl(
        poolGenesisAddress,
        apiService,
      ).getPoolInfos().valueOrThrow;

      // Sort token to match pool order
      var token1AmountSorted = 0.0;
      var token2AmountSorted = 0.0;
      DexToken? token1Sorted;
      DexToken? token2Sorted;
      if (token1.address.toUpperCase() ==
          poolInfos.token1Address.toUpperCase()) {
        token1AmountSorted = token1Amount;
        token2AmountSorted = token2Amount;
        token1Sorted = token1;
        token2Sorted = token2;
      } else {
        token2AmountSorted = token1Amount;
        token1AmountSorted = token2Amount;
        token2Sorted = token1;
        token1Sorted = token2;
      }

      final slippagePourcent =
          (Decimal.parse('100') - Decimal.parse('$slippage')) /
              Decimal.parse('100');
      final token1minAmount =
          Decimal.parse('$token1AmountSorted') * slippagePourcent.toDecimal();
      final token2minAmount =
          Decimal.parse('$token2AmountSorted') * slippagePourcent.toDecimal();

      final transactionLiquidity = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        poolGenesisAddress,
        action: 'add_liquidity',
        args: [
          token1minAmount.toDouble(),
          token2minAmount.toDouble(),
        ],
      );

      if (token1Sorted.isUCO) {
        transactionLiquidity.addUCOTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token1AmountSorted),
        );
      } else {
        transactionLiquidity.addTokenTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token1AmountSorted),
          token1Sorted.address,
        );
      }

      if (token2Sorted.isUCO) {
        transactionLiquidity.addUCOTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token2AmountSorted),
        );
      } else {
        transactionLiquidity.addTokenTransfer(
          poolGenesisAddress,
          archethic.toBigInt(token2AmountSorted),
          token2Sorted.address,
        );
      }
      return transactionLiquidity;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getRemoveLiquidityTx(
    String lpTokenAddress,
    double lpTokenAmount,
    String poolGenesisAddress,
  ) async {
    return aedappfm.Result.guard(() async {
      const burnAddress =
          '00000000000000000000000000000000000000000000000000000000000000000000';
      final transactionLiquidity = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        poolGenesisAddress,
        action: 'remove_liquidity',
        args: [],
      ).addTokenTransfer(
        burnAddress,
        archethic.toBigInt(lpTokenAmount),
        lpTokenAddress,
      );
      return transactionLiquidity;
    });
  }

  Future<aedappfm.Result<double, aedappfm.Failure>> getOutputAmount(
    DexToken tokenToSwap,
    double tokenToSwapAmount,
    String poolGenesisAddress,
  ) async {
    return aedappfm.Result.guard(() async {
      const logName = 'ArchethicContract.getSwapInfos';

      var outputAmount = 0.0;
      final getSwapInfosResult = await PoolFactoryRepositoryImpl(
        poolGenesisAddress,
        apiService,
      ).getSwapInfosOutput(tokenToSwap.address, tokenToSwapAmount);
      getSwapInfosResult.map(
        success: (success) {
          if (success != null) {
            outputAmount = success['output_amount'];
          }
        },
        failure: (failure) {
          aedappfm.sl.get<aedappfm.LogManager>().log(
                '$failure',
                level: aedappfm.LogLevel.error,
                name: logName,
              );
        },
      );
      return outputAmount;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>> getSwapTx(
    DexToken tokenToSwap,
    double tokenToSwapAmount,
    String poolGenesisAddress,
    double slippage,
    double outputAmount,
  ) async {
    return aedappfm.Result.guard(() async {
      final minToReceive = (Decimal.parse(outputAmount.toString()) *
              (Decimal.parse('100') - Decimal.parse(slippage.toString())) /
              Decimal.parse('100'))
          .toDouble();

      final transactionSwap = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        poolGenesisAddress,
        action: 'swap',
        args: [
          minToReceive,
        ],
      );

      if (tokenToSwap.isUCO) {
        transactionSwap.addUCOTransfer(
          poolGenesisAddress,
          archethic.toBigInt(tokenToSwapAmount),
        );
      } else {
        transactionSwap.addTokenTransfer(
          poolGenesisAddress,
          archethic.toBigInt(tokenToSwapAmount),
          tokenToSwap.address,
        );
      }

      return transactionSwap;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmDepositTx(
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      )
          .addTokenTransfer(
        farmGenesisAddress,
        archethic.toBigInt(amount),
        lpTokenAddress,
      )
          .addRecipient(
        farmGenesisAddress,
        action: 'deposit',
        args: [],
      );

      return transaction;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmWithdrawTx(
    String farmGenesisAddress,
    double amount,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        farmGenesisAddress,
        action: 'withdraw',
        args: [amount],
      );

      return transaction;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmLockDepositTx(
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
    FarmLockDepositDurationType durationType,
    String level,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      )
          .addTokenTransfer(
        farmGenesisAddress,
        archethic.toBigInt(amount),
        lpTokenAddress,
      )
          .addRecipient(
        farmGenesisAddress,
        action: 'deposit',
        args: [
          if (durationType == FarmLockDepositDurationType.flexible)
            'flex'
          else if (durationType == FarmLockDepositDurationType.max)
            'max'
          else
            level,
        ],
      );

      return transaction;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmLockRelockTx(
    String farmGenesisAddress,
    String lpTokenAddress,
    double amount,
    String depositId,
    FarmLockDepositDurationType durationType,
    String level,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        farmGenesisAddress,
        action: 'relock',
        args: [
          if (durationType == FarmLockDepositDurationType.flexible)
            'flex'
          else if (durationType == FarmLockDepositDurationType.max)
            'max'
          else
            level,
          depositId,
        ],
      );

      return transaction;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmClaimTx(
    String farmGenesisAddress,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        farmGenesisAddress,
        action: 'claim',
        args: [],
      );

      return transaction;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmLockWithdrawTx(
    String farmGenesisAddress,
    double amount,
    String depositId,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        farmGenesisAddress,
        action: 'withdraw',
        args: [
          amount,
          depositId,
        ],
      );

      return transaction;
    });
  }

  Future<aedappfm.Result<archethic.Transaction, aedappfm.Failure>>
      getFarmLockClaimTx(
    String farmGenesisAddress,
    String depositId,
  ) async {
    return aedappfm.Result.guard(() async {
      final transaction = archethic.Transaction(
        type: 'transfer',
        version: blockchainTxVersion,
        data: archethic.Transaction.initData(),
      ).addRecipient(
        farmGenesisAddress,
        action: 'claim',
        args: [
          depositId,
        ],
      );

      return transaction;
    });
  }
}
