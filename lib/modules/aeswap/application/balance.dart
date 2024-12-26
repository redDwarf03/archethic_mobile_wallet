import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/infrastructure/balance.repository.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'balance.g.dart';

@riverpod
Future<archethic.Balance> userBalance(Ref ref) async {
  final apiService = ref.watch(apiServiceProvider);
  final selectedAccount = await ref
      .watch(
        accountsNotifierProvider.future,
      )
      .selectedAccount;
  final genesisAddress = selectedAccount?.genesisAddress ?? '';

  if (genesisAddress.isEmpty) return const archethic.Balance();

  try {
    return await BalanceRepositoryImpl(
          apiService: apiService,
        ).getUserTokensBalance(
          genesisAddress,
        ) ??
        const archethic.Balance();
  } catch (e) {
    return const archethic.Balance();
  }
}

@riverpod
Future<archethic.Balance> addressBalance(
  Ref ref,
  String address,
) async {
  final apiService = ref.watch(apiServiceProvider);

  try {
    return await BalanceRepositoryImpl(
          apiService: apiService,
        ).getUserTokensBalance(
          address,
        ) ??
        const archethic.Balance();
  } catch (e) {
    return const archethic.Balance();
  }
}

@riverpod
Future<double> addressBalanceTotalFiat(
  Ref ref,
  String address,
) async {
  try {
    var total = 0.0;
    final balanceAsync = ref.watch(
      addressBalanceProvider(address),
    );
    final poolsListRaw =
        await ref.watch(DexPoolProviders.getPoolListRaw.future);

    // ignore: cascade_invocations
    await balanceAsync.when(
      data: (balance) async {
        if (balance.uco > 0) {
          final fiatValueUCO = await ref.watch(
            DexTokensProviders.estimateTokenInFiat(kUCOAddress).future,
          );
          total = (Decimal.parse('${archethic.fromBigInt(balance.uco)}') *
                  Decimal.parse(fiatValueUCO.toString()))
              .toDouble();
        }

        for (final balanceToken in balance.token) {
          if (balanceToken.tokenId == 0 &&
              balanceToken.address != null &&
              balanceToken.amount != null &&
              balanceToken.amount! > 0) {
            final isLPToken = poolsListRaw
                .any((item) => item.lpTokenAddress == balanceToken.address);

            var fiatValueToken = 0.0;
            if (isLPToken) {
              String? token1Address;
              String? token2Address;
              final poolRaw = poolsListRaw.firstWhereOrNull(
                (item) => item.lpTokenAddress == balanceToken.address!,
              );
              if (poolRaw != null) {
                token1Address = poolRaw.concatenatedTokensAddresses
                    .split('/')[0]
                    .toUpperCase();
                token2Address = poolRaw.concatenatedTokensAddresses
                    .split('/')[1]
                    .toUpperCase();

                fiatValueToken = await ref.watch(
                  DexTokensProviders.estimateLPTokenInFiat(
                    token1Address,
                    token2Address,
                    archethic.fromBigInt(balanceToken.amount).toDouble(),
                    balanceToken.address!,
                  ).future,
                );
              }
            } else {
              fiatValueToken = await ref.watch(
                    DexTokensProviders.estimateTokenInFiat(
                      balanceToken.address!,
                    ).future,
                  ) *
                  archethic.fromBigInt(balanceToken.amount);
            }

            total += fiatValueToken;
          }
        }
      },
      error: (e, _) => throw Exception('Balance Total Fiat not retrieved: $e'),
      loading: () {},
    );

    return total;
  } catch (e) {
    throw Exception('Balance Total Fiat not retrieved: $e');
  }
}

@riverpod
Future<double> getBalance(
  Ref ref,
  String tokenAddress,
) async {
  final userBalance = await ref.watch(userBalanceProvider.future);
  if (tokenAddress.isUCO) {
    return archethic.fromBigInt(userBalance.uco).toDouble();
  }

  final tokenAmount = userBalance.token
          .firstWhereOrNull(
            (token) =>
                token.address!.toUpperCase() == tokenAddress.toUpperCase(),
          )
          ?.amount ??
      0;

  return archethic.fromBigInt(tokenAmount).toDouble();
}
