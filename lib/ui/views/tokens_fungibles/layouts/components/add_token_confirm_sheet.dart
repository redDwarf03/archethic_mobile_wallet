/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/provider.dart';
import 'package:aewallet/ui/views/tokens_fungibles/bloc/state.dart';
import 'package:aewallet/ui/views/tokens_fungibles/layouts/components/add_token_detail.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddTokenConfirmSheet extends ConsumerStatefulWidget {
  const AddTokenConfirmSheet({
    super.key,
  });

  @override
  ConsumerState<AddTokenConfirmSheet> createState() => _AddTokenConfirmState();
}

class _AddTokenConfirmState extends ConsumerState<AddTokenConfirmSheet>
    implements SheetSkeletonInterface {
  bool? animationOpen;

  StreamSubscription<TransactionSendEvent>? _sendTxSub;

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
              .addTokenConfirmed1
              .replaceAll('%1', event.nbConfirmations.toString())
              .replaceAll('%2', event.maxConfirmations.toString())
          : AppLocalizations.of(context)!
              .addTokenConfirmed
              .replaceAll('%1', event.nbConfirmations.toString())
              .replaceAll('%2', event.maxConfirmations.toString()),
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(milliseconds: 5000),
      icon: Symbols.info,
    );
    unawaited(
      (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshRecentTransactions(),
    );
    unawaited(
      (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshFungibleTokens(),
    );
    unawaited(
      (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshBalance(),
    );

    context.loadingOverlay.hide();
    context.pop();
  }

  void _showSendFailed(
    TransactionSendEvent event,
  ) {
    // Send failed
    if (animationOpen!) {
      context.pop();
    }
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
    animationOpen = false;
  }

  @override
  void dispose() {
    _sendTxSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.confirm,
          Dimens.buttonBottomDimens,
          key: const Key('confirm'),
          onPressed: () async {
            context.loadingOverlay.show(
              title: AppLocalizations.of(context)!.pleaseWait,
            );

            await ref
                .read(AddTokenFormProvider.addTokenForm.notifier)
                .send(context);
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final addTokenNotifier =
        ref.watch(AddTokenFormProvider.addTokenForm.notifier);
    return SheetAppBar(
      title: localizations.createToken,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          addTokenNotifier.setAddTokenProcessStep(
            AddTokenProcessStep.form,
          );
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: <Widget>[
        const SizedBox(height: 30),
        Text(
          localizations.addTokenConfirmationMessage,
          style: ArchethicThemeStyles.textStyleSize14W600Primary,
        ),
        const SizedBox(
          height: 20,
        ),
        const AddTokenDetail(),
      ],
    );
  }
}
