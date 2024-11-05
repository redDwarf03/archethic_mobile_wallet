import 'dart:developer';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/infrastructure/repositories/tokens/tokens.repository.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tokens.g.dart';

@riverpod
TokensRepositoryImpl tokensRepositoryImpl(
  Ref ref,
) =>
    TokensRepositoryImpl();

@riverpod
Future<Map<String, archethic.Token>> tokensFromAddresses(
  Ref ref,
  List<String> addresses,
) async {
  final apiService = ref.watch(apiServiceProvider);

  return ref
      .watch(
        tokensRepositoryImplProvider,
      )
      .getTokensFromAddresses(
        addresses,
        apiService,
      );
}

@riverpod
Future<List<aedappfm.AEToken>> tokensFromUserBalance(
  Ref ref, {
  bool withUCO = true,
  bool withVerified = true,
  bool withLPToken = true,
  bool withNotVerified = true,
  bool withCustomToken = true,
}) async {
  final apiService = ref.watch(apiServiceProvider);

  final environment = ref.watch(environmentProvider);
  final poolListRaw = await ref.watch(DexPoolProviders.getPoolListRaw.future);
  final selectedAccount =
      await ref.watch(AccountProviders.accounts.future).selectedAccount;

  if (selectedAccount == null) return [];

  final tokensRepository = ref.watch(tokensRepositoryImplProvider);
  final defTokensRepository =
      ref.watch(aedappfm.defTokensRepositoryImplProvider);

  return ref
      .watch(
        tokensRepositoryImplProvider,
      )
      .getTokensFromUserBalance(
        selectedAccount.genesisAddress,
        selectedAccount.customTokenAddressList ?? [],
        apiService,
        poolListRaw,
        environment,
        withUCO: withUCO,
        withVerified: withVerified,
        withLPToken: withLPToken,
        withNotVerified: withNotVerified,
        withCustomToken: withCustomToken,
        defTokensRepository,
        tokensRepository,
      );
}

@riverpod
Future<double> tokensTotalUSD(
  Ref ref,
) async {
  var total = 0.0;
  const _logName = 'tokensTotalUSD';
  final selectedAccount =
      await ref.watch(AccountProviders.accounts.future).selectedAccount;

  if (selectedAccount == null) return 0.0;

  final tokensList = await ref.watch(
    tokensFromUserBalanceProvider(
      withLPToken: false,
      withNotVerified: false,
      withVerified: false,
    ).future,
  );

  for (final token in tokensList) {
    log(
      '${token.address} : ${token.symbol} (${token.isLpToken})',
      name: _logName,
    );
    final priceToken = token.isLpToken && token.lpTokenPair != null
        ? await ref.watch(
            DexTokensProviders.estimateLPTokenInFiat(
              token.lpTokenPair!.token1.address!,
              token.lpTokenPair!.token2.address!,
              token.balance,
              token.address!,
            ).future,
          )
        : (await ref.watch(
              DexTokensProviders.estimateTokenInFiat(
                token.address != null ? token.address! : kUCOAddress,
              ).future,
            ) *
            token.balance);

    total += priceToken;
  }

  return total;
}
