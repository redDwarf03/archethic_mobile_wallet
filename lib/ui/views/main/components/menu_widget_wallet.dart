import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/refresh_in_progress.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/ui/views/receive/receive_modal.dart';
import 'package:aewallet/ui/views/sheets/buy_sheet.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:aewallet/ui/views/transfer/layouts/transfer_sheet.dart';
import 'package:aewallet/ui/widgets/components/action_button.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuWidgetWallet extends ConsumerWidget {
  const MenuWidgetWallet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref
        .watch(
          AccountProviders.accounts,
        )
        .valueOrNull
        ?.selectedAccount;
    final contact = ref.watch(ContactProviders.getSelectedContact).valueOrNull;
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    final refreshInProgress = ref.watch(refreshInProgressNotifierProvider);
    final environment = ref.watch(environmentProvider);

    if (accountSelected == null) return const SizedBox();

    final localizations = AppLocalizations.of(context)!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: Colors.transparent,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ActionButton(
              key: const Key('sendUCObutton'),
              text: localizations.send,
              icon: Symbols.call_made,
              enabled:
                  connectivityStatusProvider == ConnectivityStatus.isConnected,
              onTap: () async {
                await context.push(
                  TransferSheet.routerPage,
                  extra: {
                    'recipient': const TransferRecipient.address(
                      address: Address(address: ''),
                    ).toJson(),
                  },
                );
              },
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 200))
                .scale(duration: const Duration(milliseconds: 200)),
            if (contact != null)
              ActionButton(
                key: const Key('receiveUCObutton'),
                text: localizations.receive,
                icon: Symbols.call_received,
                onTap: () async {
                  await CupertinoScaffold.showCupertinoModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 1,
                        child: Scaffold(
                          backgroundColor: aedappfm.AppThemeBase.sheetBackground
                              .withOpacity(0.2),
                          body: const ReceiveModal(),
                        ),
                      );
                    },
                  );
                },
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 250))
                  .scale(duration: const Duration(milliseconds: 250))
            else
              ActionButton(
                text: localizations.receive,
                icon: Symbols.call_received,
                enabled: false,
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 250))
                  .scale(duration: const Duration(milliseconds: 250)),
            ActionButton(
              text: environment == aedappfm.Environment.mainnet
                  ? localizations.buy
                  : localizations.faucet,
              icon: Symbols.add,
              onTap: () async {
                if (environment == aedappfm.Environment.mainnet) {
                  await context.push(BuySheet.routerPage);
                } else {
                  await launchUrl(
                    Uri.parse(
                      '${ref.read(SettingsProviders.settings).network.getLink()}/faucet',
                    ),
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              enabled:
                  connectivityStatusProvider == ConnectivityStatus.isConnected,
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .scale(duration: const Duration(milliseconds: 300)),
            if (refreshInProgress == false)
              ActionButton(
                text: localizations.refresh,
                icon: Symbols.refresh,
                enabled: connectivityStatusProvider ==
                    ConnectivityStatus.isConnected,
                onTap: () async {
                  final _connectivityStatusProvider =
                      ref.read(connectivityStatusProviders);
                  if (_connectivityStatusProvider ==
                      ConnectivityStatus.isDisconnected) {
                    return;
                  }
                  final poolListRaw =
                      await ref.read(DexPoolProviders.getPoolListRaw.future);

                  await (await ref
                          .read(AccountProviders.accounts.notifier)
                          .selectedAccountNotifier)
                      ?.refreshRecentTransactions(poolListRaw);

                  if (context.mounted) {
                    ref.invalidate(ContactProviders.fetchContacts);
                  }
                },
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 350))
                  .scale(duration: const Duration(milliseconds: 350))
            else
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Opacity(
                      opacity: 0.5,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  ),
                  ActionButton(
                    text: localizations.refresh,
                    icon: Symbols.refresh,
                    enabled: false,
                  )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 350))
                      .scale(duration: const Duration(milliseconds: 350)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
