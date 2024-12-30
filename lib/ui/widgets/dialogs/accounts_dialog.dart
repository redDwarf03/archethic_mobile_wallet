/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:aewallet/application/account/account_notifier.dart';
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/account_formatters.dart';
import 'package:aewallet/ui/util/formatters.dart';
import 'package:aewallet/ui/widgets/components/app_text_field.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountsDialog {
  static Future<Account?> getDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog<Account>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AccountsDialogWidget(ref: ref);
      },
    );
  }
}

class AccountsDialogWidget extends StatefulWidget {
  const AccountsDialogWidget({super.key, required this.ref});
  final WidgetRef ref;

  @override
  AccountsDialogWidgetState createState() => AccountsDialogWidgetState();
}

class AccountsDialogWidgetState extends State<AccountsDialogWidget> {
  late final FocusNode _searchNameFocusNode;
  late final TextEditingController _searchNameController;

  List<PickerItem> pickerItemsList = [];
  late List<Account> accounts;
  Account? accountSelected;

  @override
  void initState() {
    super.initState();
    _searchNameFocusNode = FocusNode();
    _searchNameController = TextEditingController();
    _initializeAccounts();
  }

  Future<void> _initializeAccounts() async {
    accounts = await widget.ref.read(accountsNotifierProvider.future);
    accountSelected =
        await widget.ref.read(accountsNotifierProvider.future).selectedAccount;
    _filterAccounts('', accounts, accountSelected);
  }

  @override
  void dispose() {
    _searchNameFocusNode.dispose();
    _searchNameController.dispose();
    super.dispose();
  }

  void _filterAccounts(
    String text,
    List<Account> accounts,
    Account? accountSelected,
  ) {
    final filteredAccounts = accounts
      ..removeWhere(
        (element) =>
            element.format.toUpperCase() ==
            accountSelected?.nameDisplayed.toUpperCase(),
      );

    setState(() {
      final matchingAccounts = filteredAccounts.where((account) {
        return account.format.toUpperCase().contains(text.toUpperCase());
      }).toList();

      pickerItemsList
        ..clear()
        ..addAll(
          matchingAccounts.map(
            (account) => PickerItem(
              account.format,
              null,
              null,
              null,
              account,
              true,
            ),
          ),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.only(
        top: 100,
        bottom: 100,
      ),
      alignment: Alignment.topCenter,
      content: ClipRRect(
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
              children: [
                Text(
                  localizations.accountsHeader,
                  style: ArchethicThemeStyles.textStyleSize24W700Primary,
                ),
                AppTextField(
                  focusNode: _searchNameFocusNode,
                  controller: _searchNameController,
                  autofocus: true,
                  autocorrect: false,
                  labelText: localizations.searchField,
                  keyboardType: TextInputType.text,
                  style: ArchethicThemeStyles.textStyleSize16W600Primary,
                  inputFormatters: <TextInputFormatter>[
                    UpperCaseTextFormatter(),
                    LengthLimitingTextInputFormatter(20),
                  ],
                  onChanged: (text) {
                    _filterAccounts(text, accounts, accountSelected);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: PickerWidget(
                      pickerItems: pickerItemsList,
                      onSelected: (value) {
                        context.pop(value.value);
                      },
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
