/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/ui/views/nft/layouts/components/thumbnail/nft_thumbnail_error.dart';
import 'package:aewallet/ui/views/nft/layouts/components/thumbnail/nft_thumbnail_loading.dart';
import 'package:aewallet/ui/widgets/components/image_network_widgeted.dart';
import 'package:aewallet/util/token_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NFTThumbnailHTTP extends ConsumerWidget {
  const NFTThumbnailHTTP({
    super.key,
    required this.token,
    this.roundBorder = false,
  });

  final Token token;
  final bool roundBorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final raw = TokenUtil.getHTTPUrlFromToken(
      token,
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
                    url: raw,
                    errorMessage: localizations.nftURLEmpty,
                  ),
                )
              : ImageNetworkWidgeted(
                  url: raw,
                  errorMessage: localizations.nftURLEmpty,
                ),
      ],
    );
  }
}
