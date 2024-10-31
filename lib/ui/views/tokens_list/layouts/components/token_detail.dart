import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/price_history/providers.dart';
import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/tokens_detail/layouts/token_detail_sheet.dart';
import 'package:aewallet/ui/widgets/balance/balance_infos.dart';
import 'package:aewallet/ui/widgets/tokens/verified_token_icon.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class TokenDetail extends ConsumerStatefulWidget {
  const TokenDetail({
    super.key,
    required this.aeToken,
  });

  final aedappfm.AEToken aeToken;

  @override
  ConsumerState<TokenDetail> createState() => _TokenDetailState();
}

class _TokenDetailState extends ConsumerState<TokenDetail> {
  @override
  Widget build(BuildContext context) {
    final farmLock = ref.watch(farmLockFormFarmLockProvider).valueOrNull;
    final settings = ref.watch(SettingsProviders.settings);
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    final primaryCurrency =
        ref.watch(PrimaryCurrencyProviders.selectedPrimaryCurrency);
    final priceToken =
        widget.aeToken.isLpToken && widget.aeToken.lpTokenPair != null
            ? ref
                    .watch(
                      DexTokensProviders.estimateLPTokenInFiat(
                        widget.aeToken.lpTokenPair!.token1.address!,
                        widget.aeToken.lpTokenPair!.token2.address!,
                        widget.aeToken.balance,
                        widget.aeToken.address!,
                      ),
                    )
                    .valueOrNull ??
                0
            : ((ref
                        .watch(
                          aedappfm.AETokensProviders.estimateTokenInFiat(
                            widget.aeToken,
                          ),
                        )
                        .valueOrNull ??
                    0) *
                widget.aeToken.balance);

    final priceHistory = widget.aeToken.ucid != null && widget.aeToken.ucid != 0
        ? ref
            .watch(
              PriceHistoryProviders.priceHistory(ucid: widget.aeToken.ucid),
            )
            .valueOrNull
        : null;
    return InkWell(
      onTap: () async {
        await context.push(
          TokenDetailSheet.routerPage,
          extra: {
            'aeToken': widget.aeToken.toJson(),
          },
        );
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          aedappfm.BlockInfo(
            width: MediaQuery.of(context).size.width,
            height: widget.aeToken.isUCO
                ? 115
                : widget.aeToken.isLpToken
                    ? 120
                    : 85,
            borderWith: widget.aeToken.isUCO ? 2 : 1,
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
                      else if (widget.aeToken.isLpToken &&
                          widget.aeToken.lpTokenPair != null)
                        if ((widget.aeToken.lpTokenPair!.token1.icon == null ||
                                widget.aeToken.lpTokenPair!.token1.icon!
                                    .isEmpty) &&
                            (widget.aeToken.lpTokenPair!.token2.icon == null ||
                                widget
                                    .aeToken.lpTokenPair!.token2.icon!.isEmpty))
                          const SizedBox(
                            width: 30,
                          )
                        else
                          SizedBox(
                            width: 30,
                            child: Row(
                              children: [
                                if (widget.aeToken.lpTokenPair!.token1.icon !=
                                        null &&
                                    widget.aeToken.lpTokenPair!.token1.icon!
                                        .isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/bc-logos/${widget.aeToken.lpTokenPair!.token1.icon}',
                                          width: 10,
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                if (widget.aeToken.lpTokenPair!.token2.icon !=
                                        null &&
                                    widget.aeToken.lpTokenPair!.token2.icon!
                                        .isNotEmpty)
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'assets/bc-logos/${widget.aeToken.lpTokenPair!.token2.icon}',
                                        width: 10,
                                        height: 10,
                                      ),
                                    ],
                                  )
                                else
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                              ],
                            ),
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
                                Expanded(
                                  child: AutoSizeText(
                                    minFontSize: 5,
                                    wrapWords: false,
                                    widget.aeToken.symbol,
                                    style: ArchethicThemeStyles
                                        .textStyleSize18W600MainButtonLabel,
                                  ),
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              AutoSizeText(
                                                minFontSize: 5,
                                                widget.aeToken.lpTokenPair!
                                                    .token1.symbol
                                                    .reduceSymbol(),
                                                style: AppTextStyles.bodyMedium(
                                                  context,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                  top: 2,
                                                  right: 4,
                                                ),
                                                child: VerifiedTokenIcon(
                                                  iconSize: 12,
                                                  address: widget
                                                          .aeToken
                                                          .lpTokenPair!
                                                          .token1
                                                          .isUCO
                                                      ? 'UCO'
                                                      : widget
                                                          .aeToken
                                                          .lpTokenPair!
                                                          .token1
                                                          .address!,
                                                ),
                                              ),
                                              AutoSizeText(
                                                minFontSize: 5,
                                                wrapWords: false,
                                                '/ ',
                                                style: ArchethicThemeStyles
                                                    .textStyleSize12W100Primary,
                                              ),
                                              AutoSizeText(
                                                minFontSize: 5,
                                                wrapWords: false,
                                                widget.aeToken.lpTokenPair!
                                                    .token2.symbol
                                                    .reduceSymbol(),
                                                style: AppTextStyles.bodyMedium(
                                                  context,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 4,
                                                  top: 2,
                                                ),
                                                child: VerifiedTokenIcon(
                                                  iconSize: 12,
                                                  address: widget
                                                          .aeToken
                                                          .lpTokenPair!
                                                          .token2
                                                          .isUCO
                                                      ? 'UCO'
                                                      : widget
                                                          .aeToken
                                                          .lpTokenPair!
                                                          .token2
                                                          .address!,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                124,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  minFontSize: 5,
                                                  wrapWords: false,
                                                  '${widget.aeToken.balance.formatNumber(precision: widget.aeToken.balance > 1 ? 4 : 8)} ${widget.aeToken.balance > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
                                                  style:
                                                      AppTextStyles.bodyMedium(
                                                    context,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                AutoSizeText(
                                                  minFontSize: 5,
                                                  wrapWords: false,
                                                  '\$${priceToken.formatNumber(precision: 2)}',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppTextStyles.bodyMedium(
                                                    context,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                124,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              minFontSize: 5,
                                              overflow: TextOverflow.ellipsis,
                                              '${widget.aeToken.balance.formatNumber(precision: widget.aeToken.balance > 1 ? 4 : 8)} ${widget.aeToken.symbol.reduceSymbol(lengthMax: 6)}',
                                              style: AppTextStyles.bodyMedium(
                                                context,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            AutoSizeText(
                                              minFontSize: 5,
                                              wrapWords: false,
                                              '\$${priceToken.formatNumber(precision: 2)}',
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.bodyMedium(
                                                context,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    AutoSizeText(
                                      minFontSize: 5,
                                      wrapWords: false,
                                      '\$${priceToken.formatNumber(precision: 2)}',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.bodyMedium(context),
                                    ),
                                    const SizedBox(width: 5),
                                    if (widget.aeToken.isLpToken)
                                      AutoSizeText(
                                        minFontSize: 5,
                                        wrapWords: false,
                                        '${widget.aeToken.balance.formatNumber(precision: widget.aeToken.balance > 1 ? 4 : 8)} ${widget.aeToken.lpTokenPair!.token1.symbol.reduceSymbol()}/${widget.aeToken.lpTokenPair!.token2.symbol.reduceSymbol()}',
                                        style:
                                            AppTextStyles.bodyMedium(context),
                                      )
                                    else
                                      AutoSizeText(
                                        minFontSize: 5,
                                        wrapWords: false,
                                        '${widget.aeToken.balance.formatNumber(precision: widget.aeToken.balance > 1 ? 4 : 8)} ${widget.aeToken.symbol.reduceSymbol(lengthMax: 10)}',
                                        style:
                                            AppTextStyles.bodyMedium(context),
                                      ),
                                  ],
                                )
                            else
                              Row(
                                children: [
                                  Text(
                                    '···········',
                                    style: AppTextStyles.bodyMedium(context),
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                            if (widget.aeToken.isVerified == false)
                              AutoSizeText(
                                AddressFormatters(
                                  widget.aeToken.address ?? '',
                                ).getShortString4(),
                                style: ArchethicThemeStyles
                                    .textStyleSize12W100Primary,
                              ),

                            /// KPI
                            if (settings.showPriceChart &&
                                priceHistory != null &&
                                widget.aeToken.isVerified &&
                                widget.aeToken.ucid != null &&
                                connectivityStatusProvider ==
                                    ConnectivityStatus.isConnected)
                              BalanceInfosKpi(
                                chartInfos: priceHistory,
                                aeToken: widget.aeToken,
                              ),

                            if (widget.aeToken.isUCO &&
                                farmLock != null &&
                                farmLock.apr3years > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .earnValueLbl,
                                      style: ArchethicThemeStyles
                                          .textStyleSize14W200Primary,
                                    ),
                                    Text(
                                      ' ${(farmLock.apr3years * 100).formatNumber(precision: 2)}% ',
                                      style: ArchethicThemeStyles
                                          .textStyleSize14W200PrimaryPositiveValue,
                                    ),
                                    Text(
                                      'APR',
                                      style: ArchethicThemeStyles
                                          .textStyleSize14W200Primary,
                                    ),
                                  ],
                                ),
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

          const Positioned(
            right: 5,
            top: 30,
            child: Icon(
              Symbols.keyboard_arrow_right,
              weight: IconSize.weightM,
              opticalSize: IconSize.opticalSizeM,
              grade: IconSize.gradeM,
              size: 16,
            ),
          ),

          /// PRICE CHART
          if (settings.showPriceChart &&
              priceHistory != null &&
              widget.aeToken.isVerified &&
              widget.aeToken.ucid != null)
            Positioned(
              child: Column(
                children: [
                  BalanceInfosChart(
                    chartInfos: priceHistory,
                  ),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: ArchethicTheme.text.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
