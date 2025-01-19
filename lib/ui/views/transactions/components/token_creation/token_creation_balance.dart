import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/transactions/components/template/transaction_hidden_value.dart';
import 'package:aewallet/util/number_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenCreationBalance extends ConsumerWidget {
  const TokenCreationBalance({super.key, required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (transaction.ledgerOperationMvtInfo == null ||
        transaction.ledgerOperationMvtInfo!.isEmpty ||
        transaction.ledgerOperationMvtInfo!.first.tokenInformation == null) {
      return const SizedBox.shrink();
    }

    final settings = ref.watch(SettingsProviders.settings);
    final tokenInformation =
        transaction.ledgerOperationMvtInfo!.first.tokenInformation;

    var currency = '';
    if (tokenInformation != null && tokenInformation.supply != null) {
      if (tokenInformation.type == 'fungible') {
        currency = NumberUtil.formatThousandsStr(
          tokenInformation.supply!.formatNumber(),
        );
      } else {
        currency = NumberUtil.formatThousandsStr(
          tokenInformation.supply!.toString(),
        );
      }
    }

    final symbol =
        tokenInformation?.symbol! == '' ? 'NFT' : tokenInformation?.symbol!;

    return Row(
      children: [
        AutoSizeText(
          '${AppLocalizations.of(context)!.tokenInitialSupply} ',
          style: ArchethicThemeStyles.textStyleSize12W100Primary60,
        ),
        if (settings.showBalances)
          Row(
            children: [
              AutoSizeText(
                ' $currency $symbol',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          )
        else
          const TransactionHiddenValue(),
      ],
    );
  }
}
