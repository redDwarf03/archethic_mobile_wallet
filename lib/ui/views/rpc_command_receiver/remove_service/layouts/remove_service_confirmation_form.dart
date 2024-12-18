import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/domain/usecases/usecase.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/remove_service/bloc/provider.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/rpc_failure_message.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class RemoveServiceConfirmationForm extends ConsumerWidget
    implements SheetSkeletonInterface {
  const RemoveServiceConfirmationForm(
    this.serviceName,
    this.command, {
    super.key,
  });

  final RPCCommand<awc.SendTransactionRequest> command;
  final String serviceName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        AppButtonTiny(
          AppButtonTinyType.primary,
          localizations.cancel,
          Dimens.buttonBottomDimens,
          onPressed: () {
            Navigator.of(context).pop(
              const Result<TransactionConfirmation, TransactionError>.failure(
                TransactionError.userRejected(),
              ),
            );
          },
        ),
        AppButtonTiny(
          AppButtonTinyType.primary,
          localizations.confirm,
          Dimens.buttonBottomDimens,
          onPressed: () async {
            context.loadingOverlay.show(
              title: AppLocalizations.of(context)!.pleaseWait,
            );

            final formNotifier = ref.read(
              RemoveServiceConfirmationProviders.form(command).notifier,
            );

            final result = await formNotifier.send(
              (progress) {
                _showSendProgress(
                  context,
                  ref,
                  progress,
                );
              },
            );
            result.map(
              success: (success) {},
              failure: (failure) {
                _showSendFailed(
                  context,
                  ref,
                  failure,
                );
              },
            );

            context.loadingOverlay.hide();
            Navigator.of(context).pop(result);
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.transactionConfirmationFormHeader,
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final accountSelected =
        ref.watch(AccountProviders.accounts).valueOrNull?.selectedAccount;

    final formState = ref.watch(
      RemoveServiceConfirmationProviders.form(command),
    );

    return formState.map(
      error: (error) {
        return Text(
          '${error.error}',
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        );
      },
      loading: (loading) => const SizedBox(),
      data: (formData) {
        return Column(
          children: <Widget>[
            Text(
              localizations.removeServiceCommandReceivedNotification
                  .replaceAll(
                    '%1',
                    formData.value.signTransactionCommand.origin.name,
                  )
                  .replaceAll(
                    '%2',
                    accountSelected!.nameDisplayed,
                  ),
              style: ArchethicThemeStyles.textStyleSize12W100Primary,
            ),
            const SizedBox(
              height: 30,
            ),
            displayInfoDetail(context, ref),
          ],
        );
      },
    );
  }

  Widget displayInfoDetail(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final accountSelected =
        ref.watch(AccountProviders.accounts).valueOrNull?.selectedAccount;

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          SheetDetailCard(
            children: [
              Text(
                localizations.serviceName,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Expanded(
                child: Text(
                  serviceName,
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.estimatedFees,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Text(
                '0 ${AccountBalance.cryptoCurrencyLabel}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.availableAfterCreation,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              Text(
                AmountFormatters.standard(
                  accountSelected!.balance!.nativeTokenValue,
                  AccountBalance.cryptoCurrencyLabel,
                ),
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSendProgress(
    BuildContext context,
    WidgetRef ref,
    UseCaseProgress event,
  ) {
    UIUtil.showSnackbar(
      event.progress == 1
          ? AppLocalizations.of(context)!
              .transactionConfirmed1
              .replaceAll('%1', event.progress.toString())
              .replaceAll('%2', event.total.toString())
          : AppLocalizations.of(context)!
              .transactionConfirmed
              .replaceAll('%1', event.progress.toString())
              .replaceAll('%2', event.total.toString()),
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(milliseconds: 5000),
      icon: Symbols.info,
    );
  }

  void _showSendFailed(
    BuildContext context,
    WidgetRef ref,
    TransactionError error,
  ) {
    UIUtil.showSnackbar(
      error.localizedMessage(AppLocalizations.of(context)!),
      context,
      ref,
      ArchethicTheme.text,
      ArchethicTheme.snackBarShadow,
      duration: const Duration(seconds: 5),
    );
  }
}
