/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/account/account_notifier.dart';
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/util/service_type_formatters.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/accounts/layouts/components/account_list_item_token_info.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:aewallet/util/case_converter.dart';
import 'package:aewallet/util/keychain_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountListItem extends ConsumerStatefulWidget {
  const AccountListItem({
    super.key,
    required this.account,
    this.selectedAccount,
  });
  final Account account;
  final Account? selectedAccount;

  @override
  ConsumerState<AccountListItem> createState() => _AccountListItemState();
}

class _AccountListItemState extends ConsumerState<AccountListItem>
    with AutomaticKeepAliveClientMixin, KeychainServiceMixin {
  StreamSubscription<TransactionSendEvent>? _sendTxSub;
  @override
  bool get wantKeepAlive => true;

  void _registerBus() {
    _sendTxSub = EventTaxiImpl.singleton()
        .registerTo<TransactionSendEvent>()
        .listen((TransactionSendEvent event) async {
      if (event.response != 'ok' && event.nbConfirmations == 0) {
        // Send failed
        _showSendFailed(event);
        return;
      }

      if (event.response == 'ok') {
        await _showSendSucceed(event);
        return;
      }

      _showNotEnoughConfirmation();
    });
  }

  void _showNotEnoughConfirmation() {
    UIUtil.showSnackbar(
      AppLocalizations.of(context)!.notEnoughConfirmations,
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      icon: Symbols.info,
    );
    context.loadingOverlay.hide();
    context.pop();
  }

  Future<void> _showSendSucceed(
    TransactionSendEvent event,
  ) async {
    UIUtil.showSnackbar(
      event.nbConfirmations == 1
          ? AppLocalizations.of(context)!
              .retireAccountConfirmed1
              .replaceAll('%1', event.nbConfirmations.toString())
              .replaceAll('%2', event.maxConfirmations.toString())
          : AppLocalizations.of(context)!
              .retireAccountConfirmed
              .replaceAll('%1', event.nbConfirmations.toString())
              .replaceAll('%2', event.maxConfirmations.toString()),
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(milliseconds: 5000),
      icon: Symbols.info,
    );
    await ref.read(sessionNotifierProvider.notifier).refresh();
    await (await ref
            .read(accountsNotifierProvider.notifier)
            .selectedAccountNotifier)
        ?.refreshRecentTransactions();
    context.loadingOverlay.hide();
    if (mounted) {
      context.pop();
    }
  }

  void _showSendFailed(
    TransactionSendEvent event,
  ) {
    UIUtil.showSnackbar(
      event.response!,
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(seconds: 5),
    );
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    _registerBus();
  }

  @override
  void dispose() {
    _sendTxSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizations = AppLocalizations.of(context)!;
    final settings = ref.watch(SettingsProviders.settings);
    final balanceTotalFiat = ref
        .watch(addressBalanceTotalFiatProvider(widget.account.genesisAddress));
    final selectedAccount = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    final apiService = ref.watch(apiServiceProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: () async {
          if (widget.account.serviceType != 'archethicWallet') return;

          if (widget.selectedAccount?.nameDisplayed ==
              widget.account.nameDisplayed) {
            Navigator.of(context).pop();
            return;
          }
          context.loadingOverlay.show();
          await ref
              .read(accountsNotifierProvider.notifier)
              .selectAccount(widget.account);

          await ref
              .read(
                accountNotifierProvider(widget.account.name).notifier,
              )
              .refreshAll();

          context.loadingOverlay.hide();
          context.pop();
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.account.serviceType == 'archethicWallet'
                ? aedappfm.AppThemeBase.sheetBackground
                : aedappfm.AppThemeBase.sheetBackgroundSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.account.serviceType == 'archethicWallet'
                  ? aedappfm.AppThemeBase.sheetBorder
                  : aedappfm.AppThemeBase.sheetBorderSecondary,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: widget.account.selected!
                  ? ArchethicTheme.backgroundAccountsListCardSelected
                  : ArchethicTheme.backgroundAccountsListCard,
            ),
            height: 120,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 17,
                        child: AutoSizeText(
                          widget.account.nameDisplayed,
                          style: ArchethicThemeStyles.textStyleSize12W600Primary
                              .copyWith(
                            color: aedappfm.AppThemeBase.secondaryColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            AddressFormatters(
                              widget.account.genesisAddress,
                            ).getShortString4().toLowerCase(),
                            style:
                                ArchethicThemeStyles.textStyleSize12W100Primary,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: widget.account.genesisAddress
                                      .toLowerCase(),
                                ),
                              );
                              UIUtil.showSnackbar(
                                '${localizations.addressCopied}\n${widget.account.genesisAddress.toLowerCase()}',
                                context,
                                ref,
                                ArchethicTheme.text,
                                ArchethicTheme.snackBarShadow,
                                icon: Symbols.info,
                              );
                            },
                            child: const Icon(
                              Symbols.content_copy,
                              weight: IconSize.weightM,
                              opticalSize: IconSize.opticalSizeM,
                              grade: IconSize.gradeM,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      if (widget.account.serviceType != null)
                        Row(
                          children: [
                            Icon(
                              ServiceTypeFormatters(
                                widget.account.serviceType!,
                              ).getIcon(),
                              size: 15,
                            ),
                            const SizedBox(width: 3),
                            AutoSizeText(
                              ServiceTypeFormatters(widget.account.serviceType!)
                                  .getLabel(context),
                              style: ArchethicThemeStyles
                                  .textStyleSize12W100Primary,
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ArchethicTheme.backgroundDark
                                    .withOpacity(0.3),
                                border: Border.all(
                                  color: ArchethicTheme.backgroundDarkest
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Symbols.open_in_new,
                                color: ArchethicTheme.backgroundDarkest,
                                size: 20,
                              ),
                            ),
                            onTap: () async {
                              await launchUrl(
                                Uri.parse(
                                  '${ref.read(SettingsProviders.settings).environment.endpoint}/explorer/chain?address=${widget.account.genesisAddress}',
                                ),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (selectedAccount != null &&
                              widget.account.genesisAddress.toUpperCase() !=
                                  selectedAccount.genesisAddress.toUpperCase())
                            InkWell(
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ArchethicTheme.backgroundDark
                                      .withOpacity(0.3),
                                  border: Border.all(
                                    color: ArchethicTheme.backgroundDarkest
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Symbols.delete,
                                  color: ArchethicTheme.backgroundDarkest,
                                  size: 20,
                                ),
                              ),
                              onTap: () async {
                                final session =
                                    ref.read(sessionNotifierProvider).loggedIn;
                                final keychain = await apiService
                                    .getKeychain(session!.wallet.seed);

                                var nbOfAccounts = 0;
                                keychain.services.forEach((key, value) {
                                  if (key.startsWith('archethic-wallet')) {
                                    nbOfAccounts++;
                                  }
                                });
                                if (nbOfAccounts <= 1 &&
                                    widget.account.name
                                        .startsWith('archethic-wallet')) {
                                  UIUtil.showSnackbar(
                                    AppLocalizations.of(context)!
                                        .removeKeychainAtLeast1,
                                    context,
                                    ref,
                                    ArchethicTheme.text,
                                    ArchethicTheme.snackBarShadow,
                                    icon: Symbols.info,
                                  );
                                  return;
                                }

                                final language = ref.read(
                                  LanguageProviders.selectedLanguage,
                                );

                                unawaited(
                                  AppDialogs.showConfirmDialog(
                                      context,
                                      ref,
                                      CaseChange.toUpperCase(
                                        localizations.warning,
                                        language.getLocaleString(),
                                      ),
                                      localizations.removeKeychainDetail
                                          .replaceAll(
                                        '%1',
                                        widget.account.nameDisplayed,
                                      ),
                                      localizations.removeKeychainAction, () {
                                    // Show another confirm dialog
                                    AppDialogs.showConfirmDialog(
                                      context,
                                      ref,
                                      localizations.areYouSure,
                                      localizations.removeKeychainLater,
                                      localizations.yes,
                                      () async {
                                        context.loadingOverlay.show();

                                        await removeService(
                                          widget.account.name,
                                          keychain,
                                          apiService,
                                        );
                                      },
                                    );
                                  }),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.account.serviceType != 'aeweb')
                  if (settings.showBalances)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 17,
                          child: balanceTotalFiat.when(
                            data: (data) => AutoSizeText(
                              '\$${data.formatNumber(precision: 2)}',
                              style: ArchethicThemeStyles
                                  .textStyleSize12W100Primary,
                              textAlign: TextAlign.end,
                            ),
                            error: (_, __) => AutoSizeText(
                              '\$${widget.account.balance!.totalUSD.formatNumber(precision: 2)}',
                              style: ArchethicThemeStyles
                                  .textStyleSize12W100Primary,
                              textAlign: TextAlign.end,
                            ),
                            loading: () => const SizedBox(
                              width: 15,
                              height: 5,
                              child: CircularProgressIndicator(
                                strokeWidth: 0.5,
                              ),
                            ),
                          ),
                        ),
                        AccountListItemTokenInfo(account: widget.account),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        AutoSizeText(
                          '···········',
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary60,
                        ),
                        if (widget.account.serviceType != 'aeweb')
                          AutoSizeText(
                            '···········',
                            style: ArchethicThemeStyles
                                .textStyleSize12W100Primary60,
                          ),
                        if (widget.account.serviceType != 'aeweb')
                          AutoSizeText(
                            '···········',
                            style: ArchethicThemeStyles
                                .textStyleSize12W100Primary60,
                          ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
