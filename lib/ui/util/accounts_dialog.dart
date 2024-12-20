/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:ui';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AccountsDialog {
  static Future<Account?> selectSingleAccount({
    required BuildContext context,
    required WidgetRef ref,
    required List<Account> accounts,
    String? dialogTitle,
    Widget? header,
    bool? isModal = false,
  }) async {
    final selection = await _showAccountsDialog(
      context: context,
      accounts: accounts,
      multipleSelectionsAllowed: false,
      dialogTitle: dialogTitle,
      header: header,
      isModal: isModal,
    ) as Account?;
    if (selection != null) {
      await ref
          .read(AccountProviders.accounts.notifier)
          .selectAccount(selection);
    }
    return selection;
  }

  static Future<List<Account>?> selectMultipleAccounts({
    required BuildContext context,
    required List<Account> accounts,
    String? confirmBtnLabel,
    String? dialogTitle,
    Widget? header,
    bool? isModal = false,
  }) async {
    return await _showAccountsDialog(
      context: context,
      accounts: accounts,
      multipleSelectionsAllowed: true,
      confirmBtnLabel: confirmBtnLabel,
      dialogTitle: dialogTitle,
      header: header,
      isModal: isModal,
    ) as List<Account>?;
  }

  static Future<dynamic> _showAccountsDialog({
    required BuildContext context,
    required List<Account> accounts,
    required bool multipleSelectionsAllowed,
    String? confirmBtnLabel,
    String? dialogTitle,
    Widget? header,
    bool? isModal = false,
  }) async {
    final pickerItemsList = <PickerItem<Account>>[];

    for (final account in accounts) {
      pickerItemsList.add(
        PickerItem(
          account.nameDisplayed,
          null,
          null,
          null,
          account,
          true,
          key: Key('accountName${account.nameDisplayed}'),
        ),
      );
    }

    if (isModal == false) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: ArchethicTheme.backgroundPopupColor,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: AccountsDialogContent(
              accounts: accounts,
              multipleSelectionsAllowed: multipleSelectionsAllowed,
              pickerItemsList: pickerItemsList,
              confirmBtnLabel: confirmBtnLabel,
              dialogTitle: dialogTitle,
              header: header,
            ),
          );
        },
      );
    }

    await showCupertinoModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: Scaffold(
            backgroundColor:
                aedappfm.AppThemeBase.sheetBackground.withOpacity(0.2),
            body: AccountsDialogContent(
              accounts: accounts,
              multipleSelectionsAllowed: multipleSelectionsAllowed,
              pickerItemsList: pickerItemsList,
              confirmBtnLabel: confirmBtnLabel,
              dialogTitle: dialogTitle,
              header: header,
            ),
          ),
        );
      },
    );
    return;
  }
}

class AccountsDialogContent extends ConsumerWidget {
  const AccountsDialogContent({
    required this.accounts,
    required this.multipleSelectionsAllowed,
    required this.pickerItemsList,
    this.confirmBtnLabel,
    this.dialogTitle,
    this.header,
    super.key,
  });

  final List<Account> accounts;
  final bool multipleSelectionsAllowed;
  final String? confirmBtnLabel;
  final String? dialogTitle;
  final Widget? header;
  final List<PickerItem<Account>> pickerItemsList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final pickerItemsListSelected = <PickerItem<Account>>[];
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ArchethicTheme.sheetBackground.withOpacity(0.2),
                border: Border.all(
                  color: ArchethicTheme.sheetBorder,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      dialogTitle ?? localizations.accountsHeader,
                      style: ArchethicThemeStyles.textStyleSize24W700Primary,
                    ),
                  ),
                  header ?? const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: multipleSelectionsAllowed
                          ? const EdgeInsets.only(bottom: 130)
                          : EdgeInsets.zero,
                      child: PickerWidget(
                        pickerItems: pickerItemsList,
                        multipleSelectionsAllowed: multipleSelectionsAllowed,
                        scrollable: true,
                        onSelected: (pickerItem) {
                          if (!multipleSelectionsAllowed) {
                            Navigator.of(context).pop(pickerItem.value);
                          }
                        },
                        onUnselected: (_) {},
                        selectedIndexes: const [],
                        getSelectedIndexes: (selectedIndexes) {
                          if (selectedIndexes != null) {
                            pickerItemsListSelected
                              ..clear()
                              ..addAll(
                                selectedIndexes
                                    .map((index) => pickerItemsList[index]),
                              );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (multipleSelectionsAllowed)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: [
                      AppButtonTinyConnectivity(
                        confirmBtnLabel ?? localizations.ok,
                        Dimens.buttonTopDimens,
                        onPressed: () {
                          final _accountsList = pickerItemsListSelected
                              .map((item) => item.value)
                              .toList();

                          Navigator.of(context).pop(_accountsList);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      AppButtonTinyConnectivity(
                        localizations.cancel,
                        Dimens.buttonBottomDimens,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
