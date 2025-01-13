import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/verified_token_icon.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';

class TokenSelectionCommonBases extends ConsumerWidget {
  const TokenSelectionCommonBases({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(DexTokensProviders.tokensCommonBases).value;

    if (tokens == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            AppLocalizations.of(context)!.token_selection_common_bases_title,
            style: AppTextStyles.bodyLarge(context),
          ),
        ),
        Wrap(
          spacing: 10,
          children: tokens.map((token) {
            return _TokenSelector(key: ValueKey(token.address), token: token);
          }).toList(),
        ),
      ],
    );
  }
}

class _TokenSelector extends StatelessWidget {
  const _TokenSelector({
    super.key,
    required this.token,
  });

  final DexToken token;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: 150,
      height: 35,
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
          context.pop(token);
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            if (token.icon != '')
              SvgPicture.string(
                token.icon!,
                width: 20,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    token.symbol,
                    style: AppTextStyles.bodyLarge(context),
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: VerifiedTokenIcon(
                    address: token.isUCO ? kUCOAddress : token.address,
                    iconSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
