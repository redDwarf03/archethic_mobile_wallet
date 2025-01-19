/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

// Project imports:
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/service/app_service.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/views/transfer/bloc/provider.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:aewallet/ui/views/transfer/layouts/components/token_transfer_detail.dart';
import 'package:aewallet/ui/views/transfer/layouts/components/uco_transfer_detail.dart';
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

class TransferConfirmSheet extends ConsumerStatefulWidget {
  const TransferConfirmSheet({
    super.key,
    this.title,
    this.tokenId,
  });

  final String? title;
  final String? tokenId;

  @override
  ConsumerState<TransferConfirmSheet> createState() =>
      _TransferConfirmSheetState();
}

class _TransferConfirmSheetState extends ConsumerState<TransferConfirmSheet>
    implements SheetSkeletonInterface {
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
        final appService = ref.read(appServiceProvider);
        await _showSendSucceed(event, appService);
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
    context.pop();
    context.loadingOverlay.hide();
  }

  Future<void> _showSendSucceed(
    TransactionSendEvent event,
    AppService appService,
  ) async {
    UIUtil.showSnackbar(
      event.nbConfirmations == 1
          ? AppLocalizations.of(context)!
              .transferConfirmed1
              .replaceAll('%1', event.nbConfirmations.toString())
              .replaceAll('%2', event.maxConfirmations.toString())
          : AppLocalizations.of(context)!
              .transferConfirmed
              .replaceAll('%1', event.nbConfirmations.toString())
              .replaceAll('%2', event.maxConfirmations.toString()),
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(milliseconds: 5000),
      icon: Symbols.info,
    );

    try {
      final transfer = ref.read(TransferFormProvider.transferForm);
      final accountSelected = ref.read(
        accountsNotifierProvider.select(
          (accounts) => accounts.valueOrNull?.selectedAccount,
        ),
      );
      if (transfer.transferType == TransferType.nft) {
        unawaited(
          (await ref
                  .read(accountsNotifierProvider.notifier)
                  .selectedAccountNotifier)
              ?.updateNFT(accountSelected!),
        );
      }
      unawaited(
        (await ref
                .read(accountsNotifierProvider.notifier)
                .selectedAccountNotifier)
            ?.refreshRecentTransactions(),
      );
      if (transfer.transferType == TransferType.token) {
        unawaited(
          (await ref
                  .read(accountsNotifierProvider.notifier)
                  .selectedAccountNotifier)
              ?.refreshFungibleTokens(),
        );
      }
      unawaited(
        (await ref
                .read(accountsNotifierProvider.notifier)
                .selectedAccountNotifier)
            ?.refreshBalance(),
      );
    } finally {
      context.go(HomePage.routerPage);
      context.loadingOverlay.hide();
    }
  }

  void _showSendFailed(
    TransactionSendEvent event,
  ) {
    // Send failed
    UIUtil.showSnackbar(
      event.response!,
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(seconds: 5),
    );
    context.pop();
    context.loadingOverlay.hide();
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
                .read(
                  TransferFormProvider.transferForm.notifier,
                )
                .send(context);
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final transferNotifier =
        ref.watch(TransferFormProvider.transferForm.notifier);

    return SheetAppBar(
      title: widget.title ?? localizations.transfering,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          transferNotifier.setTransferProcessStep(
            TransferProcessStep.form,
          );
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final transfer = ref.watch(TransferFormProvider.transferForm);
    return SizedBox(
      child: transfer.transferType == TransferType.uco
          ? const UCOTransferDetail()
          : transfer.transferType == TransferType.token ||
                  transfer.transferType == TransferType.nft
              ? TokenTransferDetail(
                  tokenId: widget.tokenId,
                )
              : const SizedBox(),
    );
  }
}
