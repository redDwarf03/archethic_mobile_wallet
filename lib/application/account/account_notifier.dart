/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/application/nft/nft.dart';
import 'package:aewallet/application/recent_transactions.dart';
import 'package:aewallet/application/refresh_in_progress.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/infrastructure/datasources/account.hive.dart';
import 'package:aewallet/infrastructure/repositories/local_account.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:decimal/decimal.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifier.g.dart';

@riverpod
class AccountNotifier extends _$AccountNotifier {
  final _logger = Logger('AccountNotifier');

  @override
  FutureOr<Account?> build(String accountName) async {
    return await AccountLocalRepository().getAccount(accountName);
  }

  /// Updates the account in Hive and handles errors consistently
  Future<void> _updateAccount() async {
    if (state.value == null) return;

    try {
      await AccountHiveDatasource.instance().updateAccount(state.value!);
      _logger.fine('Account updated successfully');
    } catch (error, stack) {
      _logger.severe('Failed to update account', error, stack);
    }
  }

  /// Executes a refresh operation with proper error handling and state management
  Future<void> _performOperation(
    String operationName,
    Future<void> Function(Account account) operation,
  ) async {
    final account = state.value;
    if (account == null) {
      _logger.warning('$operationName: No account available');
      return;
    }

    _logger.fine('Starting $operationName');
    try {
      ref.read(refreshInProgressNotifierProvider.notifier).refreshInProgress =
          true;
      await operation(account);
      await _updateAccount();

      _logger.fine('$operationName completed successfully');
    } catch (e, stack) {
      _logger.severe('$operationName failed', e, stack);
    } finally {
      ref.read(refreshInProgressNotifierProvider.notifier).refreshInProgress =
          false;
    }
  }

  Future<void> refreshRecentTransactions() async {
    await _performOperation(
      'Recent Transactions',
      updateRecentTransactions,
    );
  }

  Future<void> refreshFungibleTokens() =>
      _performOperation('Refresh Fungible Tokens', updateFungibleTokens);

  Future<void> refreshNFT() => _performOperation('Refresh NFT', updateNFT);

  Future<void> refreshBalance() =>
      _performOperation('Refresh Balance', updateBalance);

  Future<void> refreshAll() async {
    final operations = [
      updateBalance,
      updateFungibleTokens,
      updateNFT,
    ];

    for (final operation in operations) {
      await _performOperation('Refresh All', operation);
    }
  }

  Future<void> updateBalance(Account account) async {
    _logger.fine('Starting balance update');

    final balanceGetResponseMap = await ref
        .read(appServiceProvider)
        .getBalanceGetResponse([account.genesisAddress]);

    if (balanceGetResponseMap[account.genesisAddress] == null) {
      _logger.warning(
        'No balance response for address: ${account.genesisAddress}',
      );
      return;
    }

    try {
      final ucidsTokens = await ref.read(
        aedappfm.UcidsTokensProviders.ucidsTokens(
          environment: ref.read(environmentProvider),
        ).future,
      );

      final cryptoPrice = ref.read(aedappfm.CoinPriceProviders.coinPrices);
      final balanceGetResponse = balanceGetResponseMap[account.genesisAddress]!;

      final accountBalance = await _calculateAccountBalance(
        balanceGetResponse,
        ucidsTokens,
        cryptoPrice,
      );

      state = AsyncData(account.copyWith(balance: accountBalance));

      _logger.fine('Balance update completed successfully');
      return;
    } catch (e, stack) {
      _logger.severe('Failed to update balance', e, stack);
    }
  }

  Future<AccountBalance> _calculateAccountBalance(
    Balance balanceGetResponse,
    Map<String, int> ucidsTokens,
    aedappfm.CryptoPrice cryptoPrice,
  ) async {
    final ucoAmount = fromBigInt(balanceGetResponse.uco).toDouble();
    final accountBalance = AccountBalance(
      nativeTokenName: AccountBalance.cryptoCurrencyLabel,
      nativeTokenValue: ucoAmount,
    );

    var totalUSD = 0.0;

    if (balanceGetResponse.uco > 0) {
      accountBalance.tokensFungiblesNb++;

      final archethicOracleUCO = await ref.read(
        aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.future,
      );
      totalUSD = (Decimal.parse(totalUSD.toString()) +
              Decimal.parse(ucoAmount.toString()) *
                  Decimal.parse(archethicOracleUCO.usd.toString()))
          .toDouble();
    }

    totalUSD += await _calculateTokensValue(
      balanceGetResponse.token,
      accountBalance,
      ucidsTokens,
      cryptoPrice,
    );

    accountBalance.totalUSD = totalUSD;
    return accountBalance;
  }

  Future<double> _calculateTokensValue(
    List<TokenBalance> tokens,
    AccountBalance accountBalance,
    Map<String, int> ucidsTokens,
    aedappfm.CryptoPrice cryptoPrice,
  ) async {
    var totalUSD = 0.0;

    for (final token in tokens) {
      if (token.tokenId != null) {
        if (token.tokenId == 0) {
          accountBalance.tokensFungiblesNb++;

          final ucidsToken = ucidsTokens[token.address];
          if (ucidsToken != null && ucidsToken != 0) {
            final amountTokenUSD =
                (Decimal.parse(fromBigInt(token.amount).toString()) *
                        Decimal.parse(
                          aedappfm.CoinPriceRepositoryImpl()
                              .getPriceFromUcid(ucidsToken, cryptoPrice)
                              .toString(),
                        ))
                    .toDouble();
            totalUSD += amountTokenUSD;
          }
        } else {
          accountBalance.nftNb++;
        }
      }
    }

    return totalUSD;
  }

  Future<void> updateFungibleTokens(Account account) async {
    _logger.fine('Starting fungible tokens update');
    try {
      final appService = ref.read(appServiceProvider);
      final poolsListRaw =
          await ref.read(DexPoolProviders.getPoolListRaw.future);

      final fungiblesTokensList = await appService.getFungiblesTokensList(
        account.genesisAddress,
        poolsListRaw,
      );

      state = AsyncData(account.copyWith(accountTokens: fungiblesTokensList));
      _logger.fine('Fungible tokens update completed successfully');
      return;
    } catch (e, stack) {
      _logger.severe('Failed to update fungible tokens', e, stack);
    }
  }

  Future<void> updateRecentTransactions(Account account) async {
    _logger.fine('Starting recent transactions update');
    try {
      ref.invalidate(
        recentTransactionsProvider(
          account.genesisAddress,
        ),
      );
      _logger.fine('Recent transactions update completed successfully');
      return;
    } catch (e, stack) {
      _logger.severe('Failed to update recent transactions', e, stack);
    }
  }

  Future<void> updateNFT(Account account) async {
    _logger.fine('Starting NFT update');
    try {
      final session = ref.read(sessionNotifierProvider).loggedIn!;
      final tokenInformation = await ref.read(
        NFTProviders.getNFTList(
          account.genesisAddress,
          account.name,
          session.wallet.keychainSecuredInfos,
        ).future,
      );

      state = AsyncData(
        account.copyWith(
          accountNFT: tokenInformation.$1,
          accountNFTCollections: tokenInformation.$2,
        ),
      );
      _logger.fine('NFT update completed successfully');
      return;
    } catch (e, stack) {
      _logger.severe('Failed to update NFT', e, stack);
    }
  }

  Future<void> addCustomTokenAddress(
    Account account,
    String tokenAddress,
  ) async {
    _logger.fine('Adding custom token address');
    try {
      if (Address(address: tokenAddress).isValid() == false) {
        _logger.warning('Invalid token address: $tokenAddress');
        return;
      }

      state = AsyncData(
        account.copyWith(
          customTokenAddressList: [
            ...account.customTokenAddressList ?? [],
            tokenAddress.toUpperCase(),
          ],
        ),
      );
      await _updateAccount();

      _logger.fine('Custom token address added successfully');
    } catch (e, stack) {
      _logger.severe('Failed to add custom token address', e, stack);
    }
  }

  Future<void> removeCustomTokenAddress(
    Account account,
    String tokenAddress,
  ) async {
    _logger.fine('Removing custom token address');
    try {
      if (Address(address: tokenAddress).isValid() == false) {
        _logger.warning('Invalid token address: $tokenAddress');
        return;
      }

      final customTokenAddressList = account.customTokenAddressList;
      if (customTokenAddressList == null) {
        _logger.warning('No custom token addresses found');
        return;
      }

      state = AsyncData(
        account.copyWith(
          customTokenAddressList: customTokenAddressList
              .where(
                (element) => element != tokenAddress.toUpperCase(),
              )
              .toList(),
        ),
      );
      await _updateAccount();

      _logger.fine('Custom token address removed successfully');
    } catch (e, stack) {
      _logger.severe('Failed to remove custom token address', e, stack);
    }
  }

  Future<bool> checkCustomTokenAddress(String tokenAddress) async {
    try {
      final account = await future;
      if (account == null) {
        _logger.warning('Account not found for token address check');
        return false;
      }

      if (Address(address: tokenAddress).isValid() == false) {
        _logger.warning('Invalid token address: $tokenAddress');
        return false;
      }

      return (account.customTokenAddressList ?? [])
          .contains(tokenAddress.toUpperCase());
    } catch (e, stack) {
      _logger.severe('Failed to check custom token address', e, stack);
      return false;
    }
  }
}
