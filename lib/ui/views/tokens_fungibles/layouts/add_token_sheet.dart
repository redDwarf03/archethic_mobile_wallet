/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';

import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/provider.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/state.dart';
import 'package:aewallet/ui/views/tokens_fungibles/layouts/components/add_token_confirm_sheet.dart';
import 'package:aewallet/ui/views/tokens_fungibles/layouts/components/add_token_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTokenSheet extends ConsumerWidget {
  const AddTokenSheet({
    super.key,
  });

  static const String routerPage = '/add_token';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref
        .watch(
          accountsNotifierProvider,
        )
        .valueOrNull
        ?.selectedAccount;

    if (selectedAccount == null) return const SizedBox();

    return ProviderScope(
      overrides: [
        AddTokenFormProvider.initialAddTokenForm.overrideWithValue(
          AddTokenFormState(
            feeEstimation: const AsyncValue.data(0),
            accountBalance: selectedAccount.balance!,
          ),
        ),
      ],
      child: const AddTokenSheetBody(),
    );
  }
}

class AddTokenSheetBody extends ConsumerWidget {
  const AddTokenSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addToken = ref.watch(AddTokenFormProvider.addTokenForm);

    ref.listen<AddTokenFormState>(
      AddTokenFormProvider.addTokenForm,
      (_, addToken) {
        if (addToken.isControlsOk) return;

        final errorMessages = <String>[];
        if (addToken.errorNameText.isNotEmpty) {
          errorMessages.add(addToken.errorNameText);
        }
        if (addToken.errorSymbolText.isNotEmpty) {
          errorMessages.add(addToken.errorSymbolText);
        }
        if (addToken.errorInitialSupplyText.isNotEmpty) {
          errorMessages.add(addToken.errorInitialSupplyText);
        }
        if (addToken.errorAmountText.isNotEmpty) {
          errorMessages.add(addToken.errorAmountText);
        }

        UIUtil.showSnackbar(
          errorMessages.join('\n'),
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
          duration: const Duration(seconds: 5),
        );
      },
    );

    if (addToken.addTokenProcessStep == AddTokenProcessStep.form) {
      return const AddTokenFormSheet();
    } else {
      return const AddTokenConfirmSheet();
    }
  }
}
