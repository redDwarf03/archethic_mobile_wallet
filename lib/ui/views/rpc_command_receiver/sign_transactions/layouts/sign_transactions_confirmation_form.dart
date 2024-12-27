import 'dart:ui';

import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/sign_transactions/bloc/provider.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/util/transaction_raw.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/util/currency_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignTransactionsConfirmationForm extends ConsumerWidget
    implements SheetSkeletonInterface {
  const SignTransactionsConfirmationForm(
    this.addresses,
    this.command,
    this.estimatedFees,
    this.description, {
    super.key,
  });

  final RPCCommand<awc.SignTransactionRequest> command;
  final double estimatedFees;
  final List<String?> addresses;
  final Map<String, dynamic> description;

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
            Navigator.of(context).pop(false);
          },
        ),
        AppButtonTiny(
          AppButtonTinyType.primary,
          localizations.confirm,
          Dimens.buttonBottomDimens,
          onPressed: () {
            Navigator.of(context).pop(true);
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
    final locale = ref.read(LanguageProviders.selectedLocale);
    final descriptionLocale =
        description[locale.languageCode] ?? description['en'] ?? '';
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(
      SignTransactionsConfirmationProviders.form(command),
    );

    final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);

    final archethicOracleUCO = ref
        .watch(aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO)
        .valueOrNull;

    final amountInFiat = archethicOracleUCO == null
        ? 0
        : CurrencyUtil.convertAmountFormatedWithNumberOfDigits(
            archethicOracleUCO.usd,
            estimatedFees,
            3,
          );

    return formState.map(
      error: (error) => const SizedBox(),
      loading: (loading) => const SizedBox(),
      data: (formData) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad,
            },
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (primaryCurrency.primaryCurrency ==
                    AvailablePrimaryCurrencyEnum.native)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: command.data.transactions.length == 1
                              ? localizations
                                  .sign1TransactionCommandReceivedNotification
                                  .replaceAll(
                                    '%1',
                                    formData.value.signTransactionCommand.origin
                                        .name,
                                  )
                                  .replaceAll(
                                    '%2',
                                    _getShortName(
                                      formData.value.signTransactionCommand.data
                                          .serviceName,
                                    ),
                                  )
                              : localizations
                                  .signXTransactionsCommandReceivedNotification
                                  .replaceAll(
                                    '%1',
                                    formData.value.signTransactionCommand.origin
                                        .name,
                                  )
                                  .replaceAll(
                                    '%2',
                                    command.data.transactions.length.toString(),
                                  )
                                  .replaceAll(
                                    '%3',
                                    _getShortName(
                                      formData.value.signTransactionCommand.data
                                          .serviceName,
                                    ),
                                  ),
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary,
                        ),
                        TextSpan(
                          text:
                              ' ${estimatedFees.formatNumber(precision: 4)} UCO',
                          style: ArchethicThemeStyles
                              .textStyleSize12W400Highlighted,
                        ),
                        TextSpan(
                          text: ' ($amountInFiat)',
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary,
                        ),
                      ],
                    ),
                  )
                else
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: command.data.transactions.length == 1
                              ? localizations
                                  .sign1TransactionCommandReceivedNotification
                                  .replaceAll(
                                    '%1',
                                    formData.value.signTransactionCommand.origin
                                        .name,
                                  )
                                  .replaceAll(
                                    '%2',
                                    _getShortName(
                                      formData.value.signTransactionCommand.data
                                          .serviceName,
                                    ),
                                  )
                              : localizations
                                  .signXTransactionsCommandReceivedNotification
                                  .replaceAll(
                                    '%1',
                                    formData.value.signTransactionCommand.origin
                                        .name,
                                  )
                                  .replaceAll(
                                    '%2',
                                    command.data.transactions.length.toString(),
                                  )
                                  .replaceAll(
                                    '%3',
                                    _getShortName(
                                      formData.value.signTransactionCommand.data
                                          .serviceName,
                                    ),
                                  ),
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary,
                        ),
                        TextSpan(
                          text: ' $amountInFiat',
                          style: ArchethicThemeStyles
                              .textStyleSize12W400Highlighted,
                        ),
                        TextSpan(
                          text:
                              ' (${estimatedFees.formatNumber(precision: 4)} UCO)',
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary,
                        ),
                      ],
                    ),
                  ),
                if (descriptionLocale.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        descriptionLocale,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                    ),
                  ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: command.data.transactions.length,
                  itemBuilder: (context, index) {
                    final rpcSignTransactionCommandData =
                        command.data.transactions[index];
                    return TransactionRaw(
                      index,
                      addresses[index],
                      rpcSignTransactionCommandData.data,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getShortName(String name) {
    var result = name;
    if (name.startsWith('archethic-wallet-')) {
      result = result.replaceFirst('archethic-wallet-', '');
    }
    if (name.startsWith('aeweb-')) {
      result = result.replaceFirst('aeweb-', '');
    }

    return Uri.decodeFull(
      result,
    );
  }
}
