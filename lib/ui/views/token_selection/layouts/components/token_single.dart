import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/dex_token_icon.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/format_address_link_copy.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/verified_token_icon.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SingleToken extends StatefulWidget {
  const SingleToken({super.key, required this.token});

  final DexToken token;

  @override
  SingleTokenState createState() => SingleTokenState();
}

class SingleTokenState extends State<SingleToken>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      height: 60,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            aedappfm.AppThemeBase.sheetBackgroundTertiary.withOpacity(0.4),
            aedappfm.AppThemeBase.sheetBackgroundTertiary,
          ],
          stops: const [0, 1],
        ),
        border: GradientBoxBorder(
          gradient: LinearGradient(
            colors: [
              aedappfm.AppThemeBase.sheetBorderTertiary.withOpacity(0.4),
              aedappfm.AppThemeBase.sheetBorderTertiary,
            ],
            stops: const [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(
            context,
            widget.token,
          );
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            DexTokenIcon(
              tokenAddress: widget.token.address,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ..._getContent(
                  context,
                ),
                FormatAddressLinkCopy(
                  address: widget.token.address,
                  reduceAddress: true,
                  fontSize: Theme.of(context).textTheme.titleMedium!.fontSize!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getContent(
    BuildContext context,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.token.isLpToken == false)
            Text(
              widget.token.symbol,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          if (widget.token.isLpToken == false)
            const SizedBox(
              width: 3,
            ),
          if (widget.token.isLpToken == false)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: VerifiedTokenIcon(
                address:
                    widget.token.isUCO ? kUCOAddress : widget.token.address,
                iconSize: 12,
              ),
            ),
          if (widget.token.isLpToken && widget.token.lpTokenPair != null)
            Tooltip(
              message:
                  '${AppLocalizations.of(context)!.tokenSelectionSingleTokenLPTooltip} ${widget.token.lpTokenPair!.token1.isUCO ? kUCOAddress : widget.token.lpTokenPair!.token1.symbol}/${widget.token.lpTokenPair!.token2.isUCO ? kUCOAddress : widget.token.lpTokenPair!.token2.symbol}',
              child: Text(
                '${AppLocalizations.of(context)!.tokenSelectionSingleTokenLPTooltip} ${widget.token.lpTokenPair!.token1.isUCO ? kUCOAddress : widget.token.lpTokenPair!.token1.symbol.reduceSymbol()}/${widget.token.lpTokenPair!.token2.isUCO ? kUCOAddress : widget.token.lpTokenPair!.token2.symbol.reduceSymbol()}',
                style: AppTextStyles.bodyLarge(context),
              ),
            ),
        ],
      ),
    ];
  }
}
