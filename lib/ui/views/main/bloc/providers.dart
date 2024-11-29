import 'dart:async';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/market_price.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/application/verified_tokens.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

/// Eagerly initializes providers (https://riverpod.dev/docs/essentials/eager_initialization).
///
/// Add Watch here for any provider you want to init when app is displayed.
/// Those providers will be kept alive during application lifetime.
@riverpod
Future<void> homePage(Ref ref) async {
  ref
    ..onCancel(() {
      ref
          .read(
            aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.notifier,
          )
          .stopSubscription();
      ref
          .read(
            aedappfm.CoinPriceProviders.coinPrices.notifier,
          )
          .stopTimer();
    })
    ..watch(DexPoolProviders.getPoolList)
    ..watch(DexPoolProviders.getPoolListRaw)
    ..watch(DexTokensProviders.tokensCommonBases)
    ..watch(verifiedTokensProvider)
    ..watch(DexTokensProviders.tokensFromAccount)
    ..watch(farmLockFormFarmLockProvider)
    ..watch(
      aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.notifier,
    )
    ..watch(aedappfm.CoinPriceProviders.coinPrices)
    ..listen(
      connectivityStatusProviders,
      (previous, next) async {
        if (previous != next && next == ConnectivityStatus.isConnected) {
          ref
            ..invalidate(environmentProvider)
            ..invalidate(ContactProviders.fetchContacts)
            ..invalidate(MarketPriceProviders.currencyMarketPrice);

          final poolListRaw =
              await ref.read(DexPoolProviders.getPoolListRaw.future);

          await (await ref
                  .read(AccountProviders.accounts.notifier)
                  .selectedAccountNotifier)
              ?.refreshRecentTransactions(poolListRaw);
        }
        if (next == ConnectivityStatus.isDisconnected) {
          /// When network becomes offline, start the subscriptions again

          // TODO(Chralu): Uncomment when https://github.com/archethic-foundation/libdart/issues/155 is fixed
          // ref
          //     .read(
          //       aedappfm
          //           .ArchethicOracleUCOProviders.archethicOracleUCO.notifier,
          //     )
          //     .stopSubscription();

          await ref
              .read(
                aedappfm.CoinPriceProviders.coinPrices.notifier,
              )
              .stopTimer();

          return;
        }

        /// When network becomes online, start the subscriptions again
        await ref
            .read(
              aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.notifier,
            )
            .startSubscription();

        ref.invalidate(aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO);

        await ref
            .read(
              aedappfm.CoinPriceProviders.coinPrices.notifier,
            )
            .startTimer();

        ref.invalidate(aedappfm.CoinPriceProviders.coinPrices);
      },
    );
}

final mainTabControllerProvider =
    StateNotifierProvider.autoDispose<TabControllerNotifier, TabController?>(
        (ref) {
  return TabControllerNotifier();
});

class TabControllerNotifier extends StateNotifier<TabController?> {
  TabControllerNotifier() : super(null);

  int tabCount = 5;

  void initState(TickerProvider tickerProvider) {
    state = TabController(
      length: tabCount,
      vsync: tickerProvider,
    );
  }

  @override
  void dispose() {
    state?.dispose();
    super.dispose();
  }
}

final listenAddressesProvider =
    StateNotifierProvider.autoDispose<ListenAddressesNotifier, List<String>>(
        (ref) {
  return ListenAddressesNotifier();
});

class ListenAddressesNotifier extends StateNotifier<List<String>> {
  ListenAddressesNotifier() : super([]);

  void addListenAddresses(List<String> listenAddresses) {
    state = [
      ...state,
      ...listenAddresses,
    ];
  }

  void removeListenAddresses(List<String> listenAddresses) {
    // https://stackoverflow.com/questions/59423310/remove-list-from-another-list-in-dart
    final set1 = Set.from(state);
    final set2 = Set.from(listenAddresses);

    state = [
      ...List.from(set1.difference(set2)),
    ];
  }
}
