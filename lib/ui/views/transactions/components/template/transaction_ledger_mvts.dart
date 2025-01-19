import 'package:aewallet/application/formated_name.dart';
import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_hidden_value.dart';
import 'package:aewallet/ui/widgets/tokens/verified_token_icon.dart';
import 'package:aewallet/util/number_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionLedgerMvts extends ConsumerWidget {
  const TransactionLedgerMvts({super.key, required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transaction.ledgerOperationMvtInfo == null ||
        transaction.ledgerOperationMvtInfo!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transaction.ledgerOperationMvtInfo!.map((mvtInfo) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _recipient(context, ref, mvtInfo),
            _amount(
              context,
              ref,
              transaction.typeTx == RecentTransaction.transferInput,
              mvtInfo,
            ),
          ],
        );
      }).toList(),
    );
  }
}

Widget _amount(
  BuildContext context,
  WidgetRef ref,
  bool isInput,
  LedgerOperationMvt mvtInfo,
) {
  final amount = mvtInfo.amount;
  final amountPrefix = isInput ? '' : '-';
  final hasTransactionInfo = mvtInfo.tokenInformation != null;
  final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);
  final localizations = AppLocalizations.of(context)!;
  final settings = ref.watch(SettingsProviders.settings);

  if (amount != null) {
    final amountFormatted =
        NumberUtil.formatThousandsStr(amount.formatNumber());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localizations.txListAmount} ',
          style: ArchethicThemeStyles.textStyleSize12W100Primary60,
        ),
        if (settings.showBalances == true)
          Row(
            children: [
              Text(
                hasTransactionInfo
                    ? '$amountPrefix$amountFormatted ${primaryCurrency.primaryCurrency == AvailablePrimaryCurrencyEnum.native ? (mvtInfo.tokenInformation!.symbol != null && mvtInfo.tokenInformation!.symbol! == '' ? 'NFT' : mvtInfo.tokenInformation!.symbol!) : mvtInfo.tokenInformation!.symbol!}'
                    : '$amountPrefix$amountFormatted ${AccountBalance.cryptoCurrencyLabel}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          )
        else
          const TransactionHiddenValue(),
        if (mvtInfo.tokenInformation != null &&
            (mvtInfo.tokenInformation!.type == 'fungible' ||
                mvtInfo.tokenInformation!.type == 'UCO') &&
            mvtInfo.tokenInformation!.address != null)
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              VerifiedTokenIcon(
                address: mvtInfo.tokenInformation!.address!,
                iconSize: 12,
                paddingBottom: 0,
                paddingTop: 3,
              ),
            ],
          ),
        const SizedBox(
          width: 2,
        ),
      ],
    );
  } else {
    return const SizedBox.shrink();
  }
}

Widget _recipient(
  BuildContext context,
  WidgetRef ref,
  LedgerOperationMvt mvtInfo,
) {
  if (mvtInfo.to == null || mvtInfo.to!.isEmpty) {
    return const SizedBox.shrink();
  }
  final localizations = AppLocalizations.of(context)!;

  final formatedName = ref
          .watch(
            formatedNameFromAddressProvider(context, mvtInfo.to!),
          )
          .value ??
      AddressFormatters(mvtInfo.to!).getShortString4();

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '${localizations.txListTo} ',
        style: ArchethicThemeStyles.textStyleSize12W100Primary60,
      ),
      Text(
        formatedName,
        style: ArchethicThemeStyles.textStyleSize12W100Primary,
      ),
    ],
  );
}
