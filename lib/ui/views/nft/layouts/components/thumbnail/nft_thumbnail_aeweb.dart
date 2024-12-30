/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/nft/layouts/components/thumbnail/nft_thumbnail_error.dart';
import 'package:aewallet/ui/widgets/components/image_network_widgeted.dart';
import 'package:aewallet/util/token_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class NFTThumbnailAEWEB extends ConsumerWidget {
  const NFTThumbnailAEWEB({
    super.key,
    required this.properties,
    this.roundBorder = false,
    this.withContentInfo = false,
  });

  final Map<String, dynamic> properties;
  final bool roundBorder;
  final bool withContentInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final raw = TokenUtil.getAEWebUrlFromToken(
      properties,
    );
    final environment = ref.watch(
      environmentProvider,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (raw == null)
          NFTThumbnailError(
            message: localizations.previewNotAvailable,
          )
        else
          roundBorder == true
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ImageNetworkWidgeted(
                    url: environment.aeHostingUri + raw,
                    errorMessage: localizations.nftURLEmpty,
                  ),
                )
              : ImageNetworkWidgeted(
                  url: environment.aeHostingUri + raw,
                  errorMessage: localizations.nftURLEmpty,
                ),
        if (withContentInfo)
          Padding(
            padding: const EdgeInsets.all(10),
            child: SelectableText(
              '${localizations.nftAEWebFrom}\n${environment.aeHostingUri}${raw!}',
              style: ArchethicThemeStyles.textStyleSize12W100Primary,
            ),
          ),
        if (withContentInfo)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Symbols.warning,
                    color: ArchethicTheme.warning,
                    size: 12,
                    weight: IconSize.weightM,
                    opticalSize: IconSize.opticalSizeM,
                    grade: IconSize.gradeM,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localizations.nftAEWebLinkDisclaimer,
                    style:
                        ArchethicThemeStyles.textStyleSize12W100PrimaryWarning,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
