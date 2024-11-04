import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/format_address_link_copy_big_icon.dart';
import 'package:aewallet/ui/views/add_custom_token/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AddCustomTokenInfoToken extends ConsumerWidget {
  const AddCustomTokenInfoToken({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addCustomToken = ref.watch(addCustomTokenFormNotifierProvider);
    if (addCustomToken.token == null) {
      return const SizedBox(
        height: 100,
      );
    }

    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (addCustomToken.token!.isLpToken)
                  SizedBox(
                    height: 50,
                    child: FormatAddressLinkCopyBigIcon(
                      header:
                          '${addCustomToken.token!.lpTokenPair!.token1.symbol.reduceSymbol()}/${addCustomToken.token!.lpTokenPair!.token2.symbol.reduceSymbol()}',
                      address: addCustomToken.token!.address!,
                      reduceAddress: true,
                      fontSize: AppTextStyles.bodyMedium(context).fontSize!,
                    ),
                  )
                else
                  SizedBox(
                    height: 50,
                    child: FormatAddressLinkCopyBigIcon(
                      header: addCustomToken.token!.symbol,
                      address: addCustomToken.token!.address!,
                      reduceAddress: true,
                      fontSize: AppTextStyles.bodyMedium(context).fontSize!,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                '${AppLocalizations.of(context)!.customTokenAddBalance}: ',
                style: AppTextStyles.bodyMedium(context),
              ),
              if (addCustomToken.token!.isLpToken)
                Text(
                  '${addCustomToken.userTokenBalance.formatNumber(precision: addCustomToken.userTokenBalance > 1 ? 4 : 8)} ${addCustomToken.userTokenBalance > 1 ? AppLocalizations.of(context)!.lpTokens : AppLocalizations.of(context)!.lpToken}',
                  style: AppTextStyles.bodyMediumSecondaryColor(context),
                )
              else
                Text(
                  '${addCustomToken.userTokenBalance.formatNumber(precision: addCustomToken.userTokenBalance > 1 ? 4 : 8)} ${addCustomToken.token!.symbol.reduceSymbol()}',
                  style: AppTextStyles.bodyMediumSecondaryColor(context),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
