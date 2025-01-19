import 'package:aewallet/application/formated_name.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionInputInformation extends ConsumerWidget {
  const TransactionInputInformation({super.key, required this.transaction});

  final RecentTransaction transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    if (transaction.from == null || transaction.from!.isEmpty) {
      return const SizedBox.shrink();
    }

    final formatedName = ref
            .watch(
              formatedNameFromAddressProvider(context, transaction.from!),
            )
            .value ??
        AddressFormatters(transaction.from!).getShortString4();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${localizations.txListFrom} ',
          style: ArchethicThemeStyles.textStyleSize12W100Primary60,
        ),
        Text(
          formatedName,
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        ),
      ],
    );
  }
}
