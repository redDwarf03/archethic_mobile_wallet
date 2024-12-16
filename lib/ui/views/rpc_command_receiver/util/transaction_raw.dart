import 'dart:convert';

import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionRaw extends ConsumerStatefulWidget {
  const TransactionRaw(
    this.index,
    this.address,
    this.data, {
    super.key,
  });

  final int index;
  final Data data;
  final String? address;

  @override
  TransactionRawState createState() => TransactionRawState();
}

class TransactionRawState extends ConsumerState<TransactionRaw> {
  bool _isExpanded = true;
  bool _isJsonView = false;

  @override
  Widget build(BuildContext context) {
    final transactionData = widget.data;
    final localizations = AppLocalizations.of(context)!;
    final apiService = ref.watch(apiServiceProvider);

    List<Widget> buildTransactionData() {
      final widgets = <Widget>[
        if (transactionData.code?.isNotEmpty ?? false)
          ListTile(
            title: Text(
              localizations.transactionRawCode,
              style: ArchethicThemeStyles.textStyleSize12W400Highlighted,
            ),
            subtitle: Text(
              transactionData.code!,
              style: ArchethicThemeStyles.textStyleSize12W100Primary,
            ),
          ),
        if (transactionData.content?.isNotEmpty ?? false)
          ListTile(
            title: Text(
              localizations.transactionRawContent,
              style: ArchethicThemeStyles.textStyleSize12W400Highlighted,
            ),
            subtitle: SelectableText(
              transactionData.content!,
              style: ArchethicThemeStyles.textStyleSize12W100Primary,
            ),
          ),
        if (transactionData.ledger != null) ...[
          if (transactionData.ledger!.token != null &&
              transactionData.ledger!.token!.transfers.isNotEmpty)
            ListTile(
              title: SelectableText(
                localizations.transactionRawTokenTransfers,
                style: ArchethicThemeStyles.textStyleSize12W400Highlighted,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: transactionData.ledger!.token!.transfers
                    .map(
                      (transfer) => Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectionArea(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${localizations.transactionRawTokenTransferTokenAddress}: ',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W400Highlighted,
                                    ),
                                    TextSpan(
                                      text: transfer.tokenAddress,
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SelectionArea(
                              child: FutureBuilder<Map<String, Token>>(
                                future: apiService.getToken(
                                  [transfer.tokenAddress!],
                                  request: 'symbol',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data![transfer.tokenAddress!] !=
                                          null) {
                                    return Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                '${localizations.transactionRawTokenTransferAmount}: ',
                                            style: ArchethicThemeStyles
                                                .textStyleSize12W400Highlighted,
                                          ),
                                          TextSpan(
                                            text: fromBigInt(transfer.amount)
                                                .toDouble()
                                                .formatNumber(),
                                            style: ArchethicThemeStyles
                                                .textStyleSize12W100Primary,
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${snapshot.data![transfer.tokenAddress!]!.symbol}',
                                            style: ArchethicThemeStyles
                                                .textStyleSize12W100Primary,
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${localizations.transactionRawTokenTransferAmount}: ',
                                          style: ArchethicThemeStyles
                                              .textStyleSize12W400Highlighted,
                                        ),
                                        TextSpan(
                                          text: fromBigInt(transfer.amount)
                                              .toDouble()
                                              .formatNumber(precision: 8),
                                          style: ArchethicThemeStyles
                                              .textStyleSize12W100Primary,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SelectionArea(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${localizations.transactionRawTokenTransferTo}: ',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W400Highlighted,
                                    ),
                                    TextSpan(
                                      text: '${transfer.to}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (transactionData.ledger!.uco != null &&
              transactionData.ledger!.uco!.transfers.isNotEmpty)
            ListTile(
              title: SelectableText(
                localizations.transactionRawUCOTransfers,
                style: ArchethicThemeStyles.textStyleSize12W400Highlighted,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: transactionData.ledger!.uco!.transfers
                    .map(
                      (transfer) => Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectionArea(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${localizations.transactionRawUCOTransferAmount}: ',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W400Highlighted,
                                    ),
                                    TextSpan(
                                      text:
                                          '${fromBigInt(transfer.amount).toDouble().formatNumber(
                                                precision: 8,
                                              )} UCO',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SelectionArea(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${localizations.transactionRawUCOTransferTo}: ',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W400Highlighted,
                                    ),
                                    TextSpan(
                                      text: '${transfer.to}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
        if (transactionData.ownerships.isNotEmpty)
          ListTile(
            title: SelectableText(
              localizations.transactionRawOwnerships,
              style: ArchethicThemeStyles.textStyleSize12W400Highlighted,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: transactionData.ownerships
                  .map(
                    (ownership) => Text(
                      ownership.toString(),
                      style: ArchethicThemeStyles.textStyleSize12W100Primary,
                    ),
                  )
                  .toList(),
            ),
          ),
        if (transactionData.recipients.isNotEmpty)
          ListTile(
            title: SelectableText(
              localizations.transactionRawSmartContractCalls,
              style: ArchethicThemeStyles.textStyleSize12W400Highlighted,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: transactionData.recipients
                  .map(
                    (actionRecipient) => Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectionArea(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${localizations.transactionRawSmartContractCallAction}: ',
                                    style: ArchethicThemeStyles
                                        .textStyleSize12W400Highlighted,
                                  ),
                                  TextSpan(
                                    text: actionRecipient.action
                                            ?.replaceAll('_', ' ') ??
                                        '',
                                    style: ArchethicThemeStyles
                                        .textStyleSize12W100Primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SelectionArea(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${localizations.transactionRawSmartContractCallAddress}: ',
                                    style: ArchethicThemeStyles
                                        .textStyleSize12W400Highlighted,
                                  ),
                                  TextSpan(
                                    text: actionRecipient.address ?? '',
                                    style: ArchethicThemeStyles
                                        .textStyleSize12W100Primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (actionRecipient.args != null &&
                              actionRecipient.args!.isNotEmpty)
                            SelectionArea(
                              child: FutureBuilder<Map<String, Transaction>>(
                                future: apiService.getLastTransaction(
                                  [actionRecipient.address!],
                                  request: 'data { code }',
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data![
                                              actionRecipient.address!] !=
                                          null) {
                                    final transaction = snapshot
                                        .data![actionRecipient.address!];
                                    final code = transaction?.data?.code ?? '';
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${localizations.transactionRawSmartContractCallArguments}: ',
                                          style: ArchethicThemeStyles
                                              .textStyleSize12W400Highlighted,
                                        ),
                                        ...actionRecipient.args!
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final arg = entry.value;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              '${_getSmartContractCallArgName(code, actionRecipient.action ?? '', index)}: $arg',
                                              style: ArchethicThemeStyles
                                                  .textStyleSize12W100Primary,
                                            ),
                                          );
                                        }),
                                      ],
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${localizations.transactionRawSmartContractCallArguments}: ',
                                        style: ArchethicThemeStyles
                                            .textStyleSize12W400Highlighted,
                                      ),
                                      ...actionRecipient.args!.map((arg) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            arg.toString(),
                                            style: ArchethicThemeStyles
                                                .textStyleSize12W100Primary,
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ];

      return widgets;
    }

    Widget buildJsonView() {
      final jsonData = const JsonEncoder.withIndent('  ').convert(
        widget.data,
      );
      return SelectableText(
        jsonData,
        style: ArchethicThemeStyles.textStyleSize12W100Primary,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${localizations.transactionRaw} ${widget.index + 1}',
                style: ArchethicThemeStyles.textStyleSize14W600Primary,
              ),
              Row(
                children: [
                  Text(
                    localizations.transactionRawFormattedOption,
                    style: ArchethicThemeStyles.textStyleSize10W100Primary,
                  ),
                  Radio(
                    value: false,
                    groupValue: _isJsonView,
                    onChanged: (value) {
                      setState(() {
                        _isJsonView = value!;
                      });
                    },
                  ),
                  Text(
                    localizations.transactionRawRawOption,
                    style: ArchethicThemeStyles.textStyleSize10W100Primary,
                  ),
                  Radio(
                    value: true,
                    groupValue: _isJsonView,
                    onChanged: (value) {
                      setState(() {
                        _isJsonView = value!;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          if (_isExpanded)
            (_isJsonView
                ? buildJsonView()
                : Column(children: buildTransactionData())),
        ],
      ),
    );
  }

  String _getSmartContractCallArgName(
    String content,
    String methodName,
    int index,
  ) {
    final actionRegex =
        RegExp(r'actions triggered_by: transaction, on: (\w+)\(([^)]*)\) do');
    final matches = actionRegex.allMatches(content);

    for (final match in matches) {
      final matchedMethodName = match.group(1);
      if (matchedMethodName == methodName) {
        final params =
            match.group(2)?.split(',').map((param) => param.trim()).toList() ??
                [];

        if (index < params.length) {
          if (params[index].trim().isEmpty) {
            return '';
          }
          final argumentName = params[index].replaceAll('_', ' ');

          return argumentName[0].toUpperCase() +
              argumentName.substring(1).toLowerCase();
        }
      }
    }
    return '';
  }
}
