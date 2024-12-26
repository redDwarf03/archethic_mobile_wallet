/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/main/components/menu_widget_wallet.dart';
import 'package:aewallet/ui/views/transactions/transactions_list.dart';
import 'package:aewallet/ui/widgets/balance/balance_infos.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/refresh_indicator.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionsTab extends ConsumerWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTransactions = ref.watch(
      AccountProviders.accounts.select(
        (accounts) => accounts.valueOrNull?.selectedAccount?.recentTransactions,
      ),
    );

    final accountSelected = ref.watch(
      AccountProviders.accounts.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            key: const Key('recentTransactions'),
            children: [
              if (recentTransactions != null)
                _TransactionsList(recentTransactions: recentTransactions),
            ],
          ),
        ),
        if (accountSelected != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Row(
                children: [
                  AppButtonTinyConnectivity(
                    AppLocalizations.of(context)!.viewExplorer,
                    Dimens.buttonBottomDimens,
                    key: const Key('viewExplorer'),
                    onPressed: () async {
                      await launchUrl(
                        Uri.parse(
                          '${ref.read(SettingsProviders.settings).network.getLink()}/explorer/chain?address=${accountSelected.genesisAddress}',
                        ),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _TransactionsList extends ConsumerWidget {
  const _TransactionsList({
    required this.recentTransactions,
  });

  final List<RecentTransaction> recentTransactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ArchethicRefreshIndicator(
      onRefresh: () => Future<void>.sync(() async {
        final _connectivityStatusProvider =
            ref.read(connectivityStatusProviders);
        if (_connectivityStatusProvider == ConnectivityStatus.isDisconnected) {
          return;
        }
        final poolListRaw =
            await ref.watch(DexPoolProviders.getPoolListRaw.future);

        await (await ref
                .read(AccountProviders.accounts.notifier)
                .selectedAccountNotifier)
            ?.refreshRecentTransactions(poolListRaw);
        ref.invalidate(ContactProviders.fetchContacts);
      }),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
            PointerDeviceKind.trackpad,
          },
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: <Widget>[
                ArchethicScrollbar(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10,
                      bottom: 160,
                    ),
                    child: Column(
                      children: <Widget>[
                        const BalanceInfos(),
                        const SizedBox(
                          height: 10,
                        ),
                        const MenuWidgetWallet(),
                        if (recentTransactions.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: ArchethicTheme
                                      .backgroundFungiblesTokensListCard,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              color: ArchethicTheme
                                  .backgroundFungiblesTokensListCard,
                              child: Container(
                                padding: const EdgeInsets.all(9.5),
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Symbols.info,
                                      size: 18,
                                      weight: IconSize.weightM,
                                      opticalSize: IconSize.opticalSizeM,
                                      grade: IconSize.gradeM,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .recentTransactionsNoTransactionYet,
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          TransactionsList(
                            transactionsList: recentTransactions,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
