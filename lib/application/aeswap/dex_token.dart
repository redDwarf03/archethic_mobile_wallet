import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/infrastructure/dex_token.repository.dart';
import 'package:aewallet/modules/aeswap/infrastructure/pool_factory.repository.dart';
import 'package:aewallet/modules/aeswap/util/riverpod.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_token.g.dart';

@riverpod
DexTokenRepositoryImpl _dexTokenRepository(Ref ref) =>
    DexTokenRepositoryImpl(apiService: ref.watch(apiServiceProvider));

@riverpod
Future<DexToken?> _getTokenFromAddress(
  Ref ref,
  address,
) async {
  final environment = ref.read(environmentProvider);
  return ref.watch(_dexTokenRepositoryProvider).getToken(address, environment);
}

@riverpod
Future<List<DexToken>> _tokensFromAccount(
  Ref ref,
) async {
  final accountSelected = ref.watch(
    AccountProviders.accounts.select(
      (accounts) => accounts.valueOrNull?.selectedAccount,
    ),
  );
  if (accountSelected == null || accountSelected.genesisAddress.isEmpty) {
    return const [];
  }

  return ref
      .watch(_dexTokenRepositoryProvider)
      .getTokensFromAccount(accountSelected.genesisAddress);
}

@riverpod
Future<List<DexToken>> _dexTokenBases(
  Ref ref,
) async {
  final repository = ref.watch(_dexTokenRepositoryProvider);
  final environment = ref.read(environmentProvider);
  return repository.getLocalTokensDescriptions(environment);
}

@riverpod
Future<DexToken?> _dexTokenBase(
  Ref ref,
  String address,
) async {
  final dexTokens = await ref.watch(_dexTokenBasesProvider.future);
  return dexTokens.firstWhereOrNull(
    (token) => token.address.toUpperCase() == address.toUpperCase(),
  );
}

@riverpod
Future<String?> _getTokenIcon(
  Ref ref,
  address,
) async {
  final tokenDescription =
      await ref.watch(_dexTokenBaseProvider(address).future);

  return tokenDescription?.icon;
}

// TODO(reddwarf03): Doublon with ae_token.dart in aedappfm (ae_token is perhaps obsolete now)
@riverpod
Future<double> _estimateTokenInFiat(
  Ref ref,
  String tokenAddress,
) async {
  if (tokenAddress.isUCO) {
    return ref.watch(
      aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO
          .select((value) => value.usd),
    );
  } else {
    final environment = ref.watch(environmentProvider);
    return await ref.watch(
      aedappfm.CoinPriceProviders.coinPrice(
        address: tokenAddress,
        environment: environment,
      ).future,
    );
  }
}

/// This provider is used to cache request result
/// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
/// if `lpTokenAmount` hasn't changed.
@riverpod
Future<({double token1, double token2})> _getRemoveAmounts(
  Ref ref,
  String poolAddress,
  double lpTokenAmount,
) async {
  ref.periodicReload(
    const Duration(minutes: 1),
    shouldReload: () {
      return ref.read(connectivityStatusProviders) ==
          ConnectivityStatus.isConnected;
    },
  );

  final apiService = ref.watch(apiServiceProvider);
  final amounts = await PoolFactoryRepositoryImpl(poolAddress, apiService)
      .getRemoveAmounts(lpTokenAmount);
  if (amounts == null) return (token1: 0.0, token2: 0.0);

  return (
    token1: amounts['token1'] as double? ?? 0.0,
    token2: amounts['token2'] as double? ?? 0.0,
  );
}

@riverpod
Future<double> _estimateLPTokenInFiat(
  Ref ref,
  String token1Address,
  String token2Address,
  double lpTokenAmount,
  String poolAddress,
) async {
  if (lpTokenAmount <= 0) {
    return 0;
  }

  var fiatValueToken1 = 0.0;
  var fiatValueToken2 = 0.0;

  fiatValueToken1 = await ref
      .watch(DexTokensProviders.estimateTokenInFiat(token1Address).future);
  fiatValueToken2 = await ref
      .watch(DexTokensProviders.estimateTokenInFiat(token2Address).future);

  if (fiatValueToken1 == 0 && fiatValueToken2 == 0) {
    return 0;
  }

  final amounts = await ref.watch(
    DexTokensProviders.getRemoveAmounts(poolAddress, lpTokenAmount).future,
  );

  if (fiatValueToken1 > 0 && fiatValueToken2 > 0) {
    return amounts.token1 * fiatValueToken1 + amounts.token2 * fiatValueToken2;
  }

  if (fiatValueToken1 > 0 && fiatValueToken2 == 0) {
    return (2 * amounts.token1) * fiatValueToken1;
  }

  if (fiatValueToken1 == 0 && fiatValueToken2 > 0) {
    return (2 * amounts.token2) * fiatValueToken2;
  }

  return 0;
}

abstract class DexTokensProviders {
  static final tokensCommonBases = _dexTokenBasesProvider;
  static const getTokenFromAddress = _getTokenFromAddressProvider;
  static final tokensFromAccount = _tokensFromAccountProvider;
  static const getTokenIcon = _getTokenIconProvider;
  static const estimateTokenInFiat = _estimateTokenInFiatProvider;
  static const estimateLPTokenInFiat = _estimateLPTokenInFiatProvider;
  static const getRemoveAmounts = _getRemoveAmountsProvider;
}
