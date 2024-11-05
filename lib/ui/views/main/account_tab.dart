import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/market_price.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/main/components/app_update_button.dart';
import 'package:aewallet/ui/views/main/components/menu_widget_wallet.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/views/nft/layouts/components/nft_list.dart';
import 'package:aewallet/ui/views/nft_search/layouts/nft_search_bar.dart';
import 'package:aewallet/ui/views/tokens_list/layouts/tokens_list_sheet.dart';
import 'package:aewallet/ui/widgets/balance/balance_infos.dart';
import 'package:aewallet/ui/widgets/components/refresh_indicator.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class AccountTab extends ConsumerWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref
        .watch(
          AccountProviders.accounts,
        )
        .valueOrNull
        ?.selectedAccount;
    final localizations = AppLocalizations.of(context)!;
    return ArchethicRefreshIndicator(
      onRefresh: () => Future<void>.sync(() async {
        final _connectivityStatusProvider =
            ref.read(connectivityStatusProviders);
        if (_connectivityStatusProvider == ConnectivityStatus.isDisconnected) {
          return;
        }
        final poolListRaw =
            await ref.read(DexPoolProviders.getPoolListRaw.future);

        await (await ref
                .read(AccountProviders.accounts.notifier)
                .selectedAccountNotifier)
            ?.refreshRecentTransactions(poolListRaw);
        ref
          ..invalidate(ContactProviders.fetchContacts)
          ..invalidate(MarketPriceProviders.currencyMarketPrice);
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
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    ArchethicScrollbar(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 10,
                          bottom: 80,
                        ),
                        child: Column(
                          children: <Widget>[
                            const BalanceInfos(),
                            InkWell(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: selectedAccount?.genesisAddress
                                            .toLowerCase() ??
                                        '',
                                  ),
                                );
                                UIUtil.showSnackbar(
                                  '${localizations.addressCopied}\n${selectedAccount?.genesisAddress.toUpperCase()}',
                                  context,
                                  ref,
                                  ArchethicTheme.text,
                                  ArchethicTheme.snackBarShadow,
                                  icon: Symbols.info,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      AddressFormatters(
                                        selectedAccount?.genesisAddress ?? '',
                                      ).getShortString().toUpperCase(),
                                      style: ArchethicThemeStyles
                                          .textStyleSize14W600Primary,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Symbols.content_copy,
                                      color: Colors.white,
                                      weight: IconSize.weightM,
                                      opticalSize: IconSize.opticalSizeM,
                                      grade: IconSize.gradeM,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const MenuWidgetWallet(),
                            const ExpandablePageView(
                              children: [
                                TokensList(),
                                Column(
                                  children: [
                                    NFTSearchBar(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    NFTList(),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (UniversalPlatform.isMobile) const AppUpdateButton(),
            ],
          ),
        ),
      ),
    );
  }
}
