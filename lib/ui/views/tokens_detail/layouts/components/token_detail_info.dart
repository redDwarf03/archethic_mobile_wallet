import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/widgets/tokens/verified_token_icon.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TokenDetailInfo extends ConsumerWidget {
  const TokenDetailInfo({
    super.key,
    required this.aeToken,
  });

  final AEToken aeToken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(SettingsProviders.settings);
    final priceToken = aeToken.isLpToken && aeToken.lpTokenPair != null
        ? ref
                .watch(
                  DexTokensProviders.estimateLPTokenInFiat(
                    aeToken.lpTokenPair!.token1.address!,
                    aeToken.lpTokenPair!.token2.address!,
                    aeToken.balance,
                    aeToken.address!,
                  ),
                )
                .valueOrNull ??
            0
        : ((ref
                    .watch(
                      aedappfm.AETokensProviders.estimateTokenInFiat(
                        aeToken,
                      ),
                    )
                    .valueOrNull ??
                0) *
            aeToken.balance);
    return Column(
      children: [
        if (aeToken.isLpToken)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (aeToken.lpTokenPair != null &&
                  aeToken.lpTokenPair!.token1.icon != null &&
                  aeToken.lpTokenPair!.token1.icon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Stack(
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
                        'assets/bc-logos/${aeToken.lpTokenPair!.token1.icon}',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              if (aeToken.lpTokenPair != null)
                Text(
                  aeToken.lpTokenPair!.token1.symbol.reduceSymbol(),
                  style: ArchethicThemeStyles.textStyleSize20W700Primary,
                ),
              if (aeToken.isLpToken &&
                  aeToken.lpTokenPair != null &&
                  aeToken.lpTokenPair!.token1.address != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: VerifiedTokenIcon(
                    address: aeToken.lpTokenPair!.token1.isUCO
                        ? kUCOAddress
                        : aeToken.lpTokenPair!.token1.address!,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  '/',
                  style: ArchethicThemeStyles.textStyleSize14W700Primary,
                ),
              ),
              if (aeToken.lpTokenPair != null &&
                  aeToken.lpTokenPair!.token2.icon != null &&
                  aeToken.lpTokenPair!.token2.icon!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Stack(
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
                        'assets/bc-logos/${aeToken.lpTokenPair!.token2.icon}',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
              if (aeToken.lpTokenPair != null)
                Text(
                  aeToken.lpTokenPair!.token2.symbol.reduceSymbol(),
                  style: ArchethicThemeStyles.textStyleSize20W700Primary,
                ),
              if (aeToken.isLpToken &&
                  aeToken.lpTokenPair != null &&
                  aeToken.lpTokenPair!.token2.address != null)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: VerifiedTokenIcon(
                    address: aeToken.lpTokenPair!.token2.isUCO
                        ? kUCOAddress
                        : aeToken.lpTokenPair!.token2.address!,
                  ),
                ),
            ],
          ),
        if (aeToken.icon != null && aeToken.icon!.isNotEmpty)
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
                'assets/bc-logos/${aeToken.icon}',
                width: 20,
                height: 20,
              ),
            ],
          ),
        const SizedBox(
          height: 10,
        ),
        if (settings.showBalances == true)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${aeToken.balance.formatNumber(precision: 8)} ${aeToken.symbol}',
                style: ArchethicThemeStyles.textStyleSize16W600Primary,
              ),
              const SizedBox(width: 5),
              AutoSizeText(
                '\$${priceToken.formatNumber(precision: 2)}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
            ],
          )
        else
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '···········',
                style: ArchethicThemeStyles.textStyleSize16W400Primary60,
              ),
              const SizedBox(width: 5),
              AutoSizeText(
                '···········',
                style: ArchethicThemeStyles.textStyleSize12W100Primary60,
              ),
            ],
          ),
      ],
    );
  }
}
