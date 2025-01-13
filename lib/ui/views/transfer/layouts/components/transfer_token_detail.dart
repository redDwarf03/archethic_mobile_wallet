import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransferTokenDetail extends ConsumerStatefulWidget {
  const TransferTokenDetail({
    super.key,
    required this.aeToken,
  });

  final aedappfm.AEToken aeToken;

  @override
  ConsumerState<TransferTokenDetail> createState() =>
      _TransferTokenDetailState();
}

class _TransferTokenDetailState extends ConsumerState<TransferTokenDetail> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(SettingsProviders.settings);
    final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);
    final price = widget.aeToken.isVerified
        ? ref
            .watch(
              aedappfm.AETokensProviders.estimateTokenInFiat(
                widget.aeToken,
              ),
            )
            .valueOrNull
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () async {
          context.pop(widget.aeToken);
        },
        child: aedappfm.BlockInfo(
          width: MediaQuery.of(context).size.width,
          height: 80,
          paddingEdgeInsetsClipRRect: EdgeInsets.zero,
          info: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (widget.aeToken.icon != null &&
                        widget.aeToken.icon!.isNotEmpty)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/bc-logos/${widget.aeToken.icon}',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      )
                    else
                      const SizedBox(
                        width: 30,
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AutoSizeText(
                                minFontSize: 5,
                                wrapWords: false,
                                widget.aeToken.symbol,
                                style: ArchethicThemeStyles
                                    .textStyleSize18W600MainButtonLabel,
                              ),
                              if (widget.aeToken.isVerified)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    bottom: 1,
                                  ),
                                  child: Icon(
                                    Symbols.verified,
                                    color: ArchethicTheme.activeColorSwitch,
                                    size: 15,
                                  ),
                                ),
                            ],
                          ),
                          if (settings.showBalances == true)
                            if (primaryCurrency.primaryCurrency ==
                                AvailablePrimaryCurrencyEnum.native)
                              Row(
                                children: [
                                  if (widget.aeToken.isLpToken)
                                    AutoSizeText(
                                      minFontSize: 5,
                                      wrapWords: false,
                                      '${widget.aeToken.balance.formatNumber(precision: 8)} ${widget.aeToken.lpTokenPair!.token1.symbol.reduceSymbol()}/${widget.aeToken.lpTokenPair!.token2.symbol.reduceSymbol()}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    )
                                  else
                                    AutoSizeText(
                                      minFontSize: 5,
                                      wrapWords: false,
                                      '${widget.aeToken.balance.formatNumber(precision: 8)} ${widget.aeToken.symbol.reduceSymbol(lengthMax: 10)}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                  const SizedBox(width: 5),
                                  if (price != null && price > 0)
                                    AutoSizeText(
                                      minFontSize: 5,
                                      wrapWords: false,
                                      '\$${(widget.aeToken.balance * price).formatNumber(precision: 2)}',
                                      textAlign: TextAlign.center,
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  if (price != null && price > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: AutoSizeText(
                                        minFontSize: 5,
                                        wrapWords: false,
                                        '\$${(widget.aeToken.balance * price).formatNumber(precision: 2)}',
                                        textAlign: TextAlign.center,
                                        style: ArchethicThemeStyles
                                            .textStyleSize12W100Primary,
                                      ),
                                    ),
                                  if (widget.aeToken.isLpToken)
                                    AutoSizeText(
                                      minFontSize: 5,
                                      wrapWords: false,
                                      '${widget.aeToken.balance.formatNumber(precision: 8)} ${widget.aeToken.lpTokenPair!.token1.symbol.reduceSymbol()}/${widget.aeToken.lpTokenPair!.token2.symbol.reduceSymbol()}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    )
                                  else
                                    AutoSizeText(
                                      minFontSize: 5,
                                      wrapWords: false,
                                      '${widget.aeToken.balance.formatNumber(precision: 8)} ${widget.aeToken.symbol.reduceSymbol(lengthMax: 10)}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                ],
                              )
                          else
                            Row(
                              children: [
                                Text(
                                  '···········',
                                  style: ArchethicThemeStyles
                                      .textStyleSize12W100Primary60,
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                          AutoSizeText(
                            AddressFormatters(
                              widget.aeToken.address ?? '',
                            ).getShortString4(),
                            style:
                                ArchethicThemeStyles.textStyleSize12W100Primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          blockInfoColor: widget.aeToken.isUCO
              ? aedappfm.BlockInfoColor.purple
              : widget.aeToken.isLpToken
                  ? aedappfm.BlockInfoColor.neutral
                  : aedappfm.BlockInfoColor.blue,
        ),
      ),
    );
  }
}
