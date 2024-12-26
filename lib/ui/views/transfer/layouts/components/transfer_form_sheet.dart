/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/transfer/bloc/provider.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:aewallet/ui/views/transfer/layouts/transfer_sheet.dart';
import 'package:aewallet/ui/widgets/balance/balance_indicator.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/ui/widgets/fees/fee_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TransferFormSheet extends ConsumerWidget
    implements SheetSkeletonInterface {
  const TransferFormSheet({
    this.actionButtonTitle,
    required this.title,
    super.key,
  });

  final String? actionButtonTitle;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    if (accountSelected == null) return const SizedBox();

    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final transfer = ref.watch(TransferFormProvider.transferForm);
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          actionButtonTitle ?? localizations.send,
          Dimens.buttonBottomDimens,
          key: const Key('send'),
          onPressed: () async {
            final transferNotifier =
                ref.read(TransferFormProvider.transferForm.notifier);

            final isAddressOk = transferNotifier.controlAddress(
              context,
              accountSelected!,
            );
            final isAmountOk = transferNotifier.controlAmount(
              context,
              accountSelected,
            );

            if (isAddressOk && isAmountOk) {
              transferNotifier.setTransferProcessStep(
                TransferProcessStep.confirmation,
              );
            }
          },
          disabled: !transfer.canTransfer,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    return SheetAppBar(
      title: title,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final transfer = ref.watch(TransferFormProvider.transferForm);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 25),
        const TransferTextFieldAddress(),
        if ((transfer.transferType != null &&
                transfer.transferType != TransferType.nft) ||
            transfer.transferType == null)
          const TransferTextFieldAmount(),
        if (transfer.transferType != null)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: BalanceIndicatorWidget(
              allDigits: false,
              displaySwitchButton: false,
            ),
          ),
        FeeInfos(
          asyncFeeEstimation: transfer.feeEstimation,
          estimatedFeesNote: transfer.transferType == TransferType.nft
              ? localizations.estimatedFeesNoteNFT
              : localizations.estimatedFeesNote,
        ),
        const SizedBox(height: 20),
        const TransferTextFieldMessage(),
      ],
    );
  }
}
