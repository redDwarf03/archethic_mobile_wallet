/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts.dart';
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/transaction_infos.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/account_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/icon_widget.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionInfosSheet extends ConsumerStatefulWidget {
  const TransactionInfosSheet(this.notificationRecipientAddress, {super.key});

  final String notificationRecipientAddress;

  static const routerPage = '/transaction_info';

  @override
  ConsumerState<TransactionInfosSheet> createState() =>
      _TransactionInfosSheetState();
}

class _TransactionInfosSheetState extends ConsumerState<TransactionInfosSheet>
    implements SheetSkeletonInterface {
  @override
  Widget build(BuildContext context) {
    final selectedAccount = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    if (selectedAccount == null) return const SizedBox();

    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      thumbVisibility: false,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.viewExplorer,
          Dimens.buttonBottomDimens,
          key: const Key('viewExplorer'),
          onPressed: () async {
            await launchUrl(
              Uri.parse(
                '${ref.read(environmentProvider).endpoint}/explorer/transaction/${widget.notificationRecipientAddress}',
              ),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.transactionInfosHeader,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.go(HomePage.routerPage);
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionNotifierProvider).loggedIn!;
    final selectedAccount = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    final appService = ref.watch(appServiceProvider);
    return FutureBuilder<List<TransactionInfos>>(
      future: appService.getTransactionAllInfos(
        widget.notificationRecipientAddress,
        DateFormat.yMEd(Localizations.localeOf(context).languageCode),
        AccountBalance.cryptoCurrencyLabel,
        context,
        session.wallet.keychainSecuredInfos.services[selectedAccount!.name]!
            .keyPair!,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<TransactionInfos>> list,
      ) {
        return list.hasData
            ? _TransactionInfos(
                list: list,
                notificationRecipientAddress:
                    widget.notificationRecipientAddress,
              )
            : _TransactionLoading();
      },
    );
  }
}

class _TransactionLoading extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: CircularProgressIndicator(
        color: ArchethicTheme.text,
        strokeWidth: 1,
      ),
    );
  }
}

class _TransactionInfos extends ConsumerWidget {
  const _TransactionInfos({
    required this.list,
    required this.notificationRecipientAddress,
  });

  final AsyncSnapshot<List<TransactionInfos>> list;
  final String notificationRecipientAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(bottom: 80),
      child: ListView.builder(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 200,
        ),
        itemCount: list.data == null ? 0 : list.data!.length,
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: _TransactionBuildInfos(
              transactionInfo: list.data![index],
            ),
          );
        },
      ),
    );
  }
}

class _TransactionBuildInfos extends ConsumerWidget {
  const _TransactionBuildInfos({required this.transactionInfo});

  final TransactionInfos transactionInfo;

  static final _logger = Logger('TransactionBuildInfos');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(SettingsProviders.settings);
    return (preferences.showBalances == true ||
            (preferences.showBalances == false &&
                transactionInfo.titleInfo != 'Amount'))
        ? Row(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    if (transactionInfo.titleInfo == '')
                      const SizedBox()
                    else
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 20),
                        width: 50,
                        height: 50,
                        child: IconWidget(
                          icon:
                              'assets/icons/txInfos/${transactionInfo.titleInfo}.png',
                          width: 50,
                          height: 50,
                        ),
                      ),
                    if (transactionInfo.titleInfo == '')
                      ColoredBox(
                        color: ArchethicTheme.text05,
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          child: Column(
                            children: <Widget>[
                              // Main Container
                              Container(
                                padding: const EdgeInsets.only(
                                  bottom: 15,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AutoSizeText(
                                            TransactionInfos.getDisplayName(
                                              context,
                                              transactionInfo.domain,
                                            ),
                                            style: ArchethicThemeStyles
                                                .textStyleSize16W600Primary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Column(
                          children: <Widget>[
                            // Main Container
                            Container(
                              padding: const EdgeInsets.only(
                                left: 45,
                                right: 5,
                                bottom: 15,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        AutoSizeText(
                                          TransactionInfos.getDisplayName(
                                            context,
                                            transactionInfo.titleInfo,
                                          ),
                                          style: ArchethicThemeStyles
                                              .textStyleSize14W600Primary,
                                        ),
                                        _transactionInfoValue(
                                          ref,
                                          transactionInfo,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Divider(
                      height: 2,
                      color: ArchethicTheme.text15,
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _transactionInfoValue(
    WidgetRef ref,
    TransactionInfos transactionInfo,
  ) {
    if (transactionInfo.domain == 'UCOLedger' &&
        transactionInfo.titleInfo == 'To') {
      _logger.info('transactionInfo.valueInfo: ${transactionInfo.valueInfo}');
      return ref
          .watch(
            accountWithGenesisAddressProvider(transactionInfo.valueInfo),
          )
          .when(
            data: (data) {
              if (data == null) {
                _logger.info(
                  'transactionInfo.valueInfo: ${transactionInfo.valueInfo} : data null',
                );
                return SelectableText(
                  transactionInfo.valueInfo,
                  style: ArchethicThemeStyles.textStyleSize14W200Primary,
                );
              } else {
                _logger.info(
                  'transactionInfo.valueInfo: ${transactionInfo.valueInfo} : data not null',
                );
                return SelectableText(
                  data.format,
                  style: ArchethicThemeStyles.textStyleSize14W200Primary,
                );
              }
            },
            error: (error, stacktrace) => SelectableText(
              transactionInfo.valueInfo,
              style: ArchethicThemeStyles.textStyleSize14W200Primary,
            ),
            loading: () => SelectableText(
              transactionInfo.valueInfo,
              style: ArchethicThemeStyles.textStyleSize14W200Primary,
            ),
          );
    } else {
      return SelectableText(
        transactionInfo.valueInfo,
        style: ArchethicThemeStyles.textStyleSize14W200Primary,
      );
    }
  }
}
