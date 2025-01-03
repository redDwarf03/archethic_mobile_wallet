/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/transfer_recipient_formatters.dart';
import 'package:aewallet/ui/views/transfer/bloc/provider.dart';
import 'package:aewallet/ui/views/transfer/bloc/state.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenTransferDetail extends ConsumerStatefulWidget {
  const TokenTransferDetail({
    this.tokenId,
    super.key,
  });

  final String? tokenId;

  @override
  ConsumerState<TokenTransferDetail> createState() =>
      _TokenTransferDetailState();
}

class _TokenTransferDetailState extends ConsumerState<TokenTransferDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(TransferFormProvider.transferForm.notifier)
          .setTokenId(tokenId: widget.tokenId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final transfer = ref.watch(TransferFormProvider.transferForm);
    final accountSelected = ref
        .watch(
          accountsNotifierProvider,
        )
        .valueOrNull
        ?.selectedAccount;

    var nftName = '';
    if (transfer.transferType == TransferType.nft) {
      // Single token from a collection selected
      if (transfer.accountToken!.tokenInformation!.tokenCollection!
          .any((element) => element['id'] == widget.tokenId)) {
        nftName = transfer.accountToken!.tokenInformation!.tokenCollection!
            .firstWhere((element) => element['id'] == widget.tokenId)['name'];
      }
      // Other token (single or collection token)
      else {
        nftName = transfer.accountToken!.tokenInformation!.name!;
      }
    }

    if (accountSelected == null) return const SizedBox();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              child: transfer.transferType != TransferType.nft
                  ? AutoSizeText(
                      AmountFormatters.standard(
                        transfer.amount,
                        transfer.symbol(context),
                      ),
                      style: ArchethicThemeStyles.textStyleSize28W700Primary,
                    )
                  : const SizedBox(
                      height: 28,
                    ),
            ),
          ),
          SheetDetailCard(
            children: [
              Text(
                '${localizations.txListFrom} ${accountSelected.nameDisplayed}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                '${localizations.txListTo} ${transfer.recipient.format(localizations)}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              if (transfer.transferType != TransferType.nft)
                Text(
                  AmountFormatters.standard(
                    transfer.amount,
                    transfer.symbol(context),
                  ),
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                )
              else
                Expanded(
                  child: Text(
                    AmountFormatters.standard(
                      transfer.amount,
                      'NFT "$nftName"',
                    ),
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
                AmountFormatters.standardSmallValue(
                  transfer.feeEstimation.valueOrNull ?? 0,
                  AccountBalance.cryptoCurrencyLabel,
                ),
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          ),
          SheetDetailCard(
            children: [
              Text(
                localizations.availableAfterTransfer,
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              if (transfer.transferType != TransferType.nft)
                Text(
                  AmountFormatters.standard(
                    transfer.aeToken!.balance - transfer.amount,
                    transfer.symbol(context),
                  ),
                  style: ArchethicThemeStyles.textStyleSize12W100Primary,
                )
              else
                Expanded(
                  child: Text(
                    AmountFormatters.standard(
                      transfer.accountToken!.amount! - transfer.amount,
                      'NFT "$nftName"',
                    ),
                    style: ArchethicThemeStyles.textStyleSize12W100Primary,
                    textAlign: TextAlign.end,
                  ),
                ),
            ],
          ),
          if (transfer.message.isNotEmpty)
            SheetDetailCard(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.sendMessageConfirmHeader,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          transfer.message,
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
