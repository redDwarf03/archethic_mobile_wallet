part of 'providers.dart';

@riverpod
class _AccountNotifier extends _$AccountNotifier {
  final _logger = Logger('AccountNotifier');

  @override
  FutureOr<Account?> build(String accountName) async {
    final repository = ref.read(AccountProviders.accountsRepository);
    final account = await repository.getAccount(accountName);

    return account;
  }

  Future<void> _refresh(
    List<Future<void> Function(Account account)> doRefreshes,
  ) async {
    try {
      final account = await future;
      if (account == null) return;
      final addressService = ref.read(addressServiceProvider);
      await account.updateLastAddress(
        addressService,
      );

      ref.read(refreshInProgressNotifierProvider.notifier).refreshInProgress =
          true;
      for (final doRefresh in doRefreshes) {
        await doRefresh(account);

        final newAccountData = account.copyWith();
        state = AsyncData(newAccountData);
      }
    } catch (e, stack) {
      _logger.severe('Refresh failed', e, stack);
    } finally {
      ref.read(refreshInProgressNotifierProvider.notifier).refreshInProgress =
          false;
    }
  }

  Future<void> _refreshRecentTransactions(Account account) async {
    final session = ref.read(sessionNotifierProvider).loggedIn!;
    final appService = ref.read(appServiceProvider);
    await account.updateRecentTransactions(
      account.name,
      session.wallet.keychainSecuredInfos,
      appService,
    );
  }

  Future<void> _refreshBalance(Account account) async {
    final environment = ref.read(environmentProvider);
    final appService = ref.read(appServiceProvider);
    final oracleService = ref.read(aedappfm.oracleServiceProvider);

    return account.updateBalance(
      environment,
      appService,
      oracleService,
    );
  }

  Future<void> refreshRecentTransactions(
    List<GetPoolListResponse> poolsListRaw,
  ) =>
      _refresh([
        (account) async {
          _logger.fine(
            'Start method refreshRecentTransactions for ${account.nameDisplayed}',
          );
          final appService = ref.read(appServiceProvider);
          await _refreshRecentTransactions(account);
          await _refreshBalance(account);
          await account.updateFungiblesTokens(
            poolsListRaw,
            appService,
          );
          await refreshNFTs();
          _logger.fine(
            'End method refreshRecentTransactions for ${account.nameDisplayed}',
          );

          ref
            ..invalidate(userBalanceProvider)
            ..invalidate(
              tokensFromUserBalanceProvider,
            );
        },
      ]);

  Future<void> refreshFungibleTokens(
    List<GetPoolListResponse> poolsListRaw,
  ) =>
      _refresh([
        (account) async {
          final appService = ref.read(appServiceProvider);
          await account.updateFungiblesTokens(
            poolsListRaw,
            appService,
          );
          ref.invalidate(userBalanceProvider);
        },
      ]);

  Future<void> refreshNFTs() => _refresh([
        (account) async {
          final session = ref.read(sessionNotifierProvider).loggedIn!;
          final tokenInformation = await ref.read(
            NFTProviders.getNFTList(
              account.lastAddress!,
              account.name,
              session.wallet.keychainSecuredInfos,
            ).future,
          );

          await account.updateNFT(
            session.wallet.keychainSecuredInfos,
            tokenInformation.$1,
            tokenInformation.$2,
          );
        },
      ]);

  Future<void> refreshBalance() => _refresh([_refreshBalance]);

  Future<void> refreshAll(
    List<GetPoolListResponse> poolsListRaw,
  ) {
    final appService = ref.read(appServiceProvider);
    return _refresh(
      [
        (account) async {
          _logger.fine('RefreshAll - Start Balance refresh');
          await _refreshBalance(account);
          _logger.fine('RefreshAll - End Balance refresh');
        },
        (account) async {
          _logger.fine('RefreshAll - Start recent transactions refresh');
          await _refreshRecentTransactions(account);
          _logger.fine('RefreshAll - End recent transactions refresh');
        },
        (account) async {
          _logger.fine('RefreshAll - Start Fungible Tokens refresh');
          await account.updateFungiblesTokens(poolsListRaw, appService);
          _logger.fine('RefreshAll - End Fungible Tokens refresh');
        },
        (account) async {
          _logger.fine('RefreshAll - Start NFT refresh');
          await refreshNFTs();
          _logger.fine('RefreshAll - End NFT refresh');
        },
      ],
    );
  }
}
