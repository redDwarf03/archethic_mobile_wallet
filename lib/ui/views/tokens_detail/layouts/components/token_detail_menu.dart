import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_swap/layouts/swap_tab.dart';
import 'package:aewallet/ui/views/main/bloc/providers.dart';
import 'package:aewallet/ui/views/receive/receive_modal.dart';
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

class TokenDetailMenu extends ConsumerWidget {
  const TokenDetailMenu({
    super.key,
    required this.aeToken,
  });

  final aedappfm.AEToken aeToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref
        .watch(
          accountsNotifierProvider,
        )
        .valueOrNull
        ?.selectedAccount;
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    final farmLock = ref.watch(farmLockFormFarmLockProvider).value;
    final pool = ref.watch(farmLockFormPoolProvider).value;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: constraints.maxWidth * 0.25,
                  child: accountSelected.balance!
                              .isNativeTokenValuePositive() &&
                          connectivityStatusProvider ==
                              ConnectivityStatus.isConnected
                      ? ActionButton(
                          key: const Key('sendButton'),
                          text: localizations.send,
                          icon: Symbols.call_made,
                          onTap: () async {
                            await context.push(
                              TransferSheet.routerPage,
                              extra: {
                                'transferType': aeToken.isUCO
                                    ? TransferType.uco.name
                                    : TransferType.token.name,
                                'recipient': const TransferRecipient.address(
                                  address: Address(address: ''),
                                ).toJson(),
                                'aeToken': aeToken.toJson(),
                              },
                            );
                          },
                        )
                          .animate()
                          .fade(duration: const Duration(milliseconds: 200))
                          .scale(duration: const Duration(milliseconds: 200))
                      : ActionButton(
                          text: localizations.send,
                          icon: Symbols.call_made,
                          enabled: false,
                        )
                          .animate()
                          .fade(duration: const Duration(milliseconds: 200))
                          .scale(duration: const Duration(milliseconds: 200)),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.25,
                  child: ActionButton(
                    key: const Key('receivebutton'),
                    text: localizations.receive,
                    icon: Symbols.call_received,
                    onTap: () {
                      CupertinoScaffold.showCupertinoModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            heightFactor: 1,
                            child: Scaffold(
                              backgroundColor: aedappfm
                                  .AppThemeBase.sheetBackground
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
                      .scale(duration: const Duration(milliseconds: 250)),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.25,
                  child: ActionButton(
                    key: const Key('swapButton'),
                    text: localizations.swapHeader,
                    icon: aedappfm.Iconsax.arrange_circle_2,
                    onTap: () async {
                      final params = {
                        'from': aeToken.isUCO ? kUCOAddress : aeToken.address,
                      };

                      ref.read(swapParametersProvider.notifier).state = params;

                      ref.read(mainTabControllerProvider)!.animateTo(
                            2,
                            duration: Duration.zero,
                          );

                      await ref
                          .read(SettingsProviders.settings.notifier)
                          .setMainScreenCurrentPage(2);

                      context.pop();
                    },
                  )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 250))
                      .scale(duration: const Duration(milliseconds: 250)),
                ),
                SizedBox(
                  width: constraints.maxWidth * 0.25,
                  child: aeToken.isUCO == false
                      ? connectivityStatusProvider ==
                              ConnectivityStatus.isConnected
                          ? ActionButton(
                              text: localizations.explorer,
                              icon: Symbols.manage_search,
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse(
                                    '${ref.read(SettingsProviders.settings).network.getLink()}/explorer/transaction/${aeToken.address}',
                                  ),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                            )
                              .animate()
                              .fade(
                                duration: const Duration(milliseconds: 300),
                              )
                              .scale(
                                duration: const Duration(milliseconds: 300),
                              )
                          : ActionButton(
                              text: localizations.explorer,
                              icon: Symbols.manage_search,
                              enabled: false,
                            )
                              .animate()
                              .fade(
                                duration: const Duration(milliseconds: 300),
                              )
                              .scale(
                                duration: const Duration(milliseconds: 300),
                              )
                      : connectivityStatusProvider ==
                              ConnectivityStatus.isConnected
                          ? ActionButton(
                              text: farmLock != null
                                  ? '${localizations.tokenDetailMenuEarn}\nAPR\n${(farmLock.apr3years * 100).formatNumber(precision: 2)}%'
                                  : '${localizations.tokenDetailMenuEarn}\nUCO',
                              icon: aedappfm.Iconsax.wallet_add,
                              enabled: pool != null && farmLock != null,
                              onTap: () async {
                                ref.read(mainTabControllerProvider)!.animateTo(
                                      3,
                                      duration: Duration.zero,
                                    );
                                await ref
                                    .read(SettingsProviders.settings.notifier)
                                    .setMainScreenCurrentPage(3);

                                context.pop();
                              },
                            )
                              .animate()
                              .fade(
                                duration: const Duration(milliseconds: 300),
                              )
                              .scale(
                                duration: const Duration(milliseconds: 300),
                              )
                          : ActionButton(
                              text: farmLock != null
                                  ? '${localizations.tokenDetailMenuEarn}\nAPR\n${(farmLock.apr3years * 100).formatNumber(precision: 2)}%'
                                  : '${localizations.tokenDetailMenuEarn}\nUCO',
                              icon: aedappfm.Iconsax.wallet_add,
                              enabled: false,
                            )
                              .animate()
                              .fade(
                                duration: const Duration(milliseconds: 300),
                              )
                              .scale(
                                duration: const Duration(milliseconds: 300),
                              ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
