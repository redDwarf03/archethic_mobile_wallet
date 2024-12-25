import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/nft/layouts/components/nft_detail.dart';
import 'package:aewallet/ui/views/nft/layouts/components/thumbnail/nft_thumbnail.dart';
import 'package:aewallet/ui/views/nft/layouts/components/thumbnail_collection/nft_thumbnail_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NFTListDetail extends ConsumerWidget {
  const NFTListDetail({
    super.key,
    required this.name,
    required this.address,
    required this.properties,
    required this.tokenId,
    required this.index,
    required this.symbol,
    required this.collection,
    this.roundBorder = false,
  });

  final String name;
  final String address;
  final String tokenId;
  final String symbol;
  final Map<String, dynamic> properties;
  final List<Map<String, dynamic>> collection;
  final int index;
  final bool roundBorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var propertiesToCount = 0;

    properties.forEach((key, value) {
      if (key != 'name' &&
          key != 'content' &&
          key != 'type_mime' &&
          key != 'description') {
        propertiesToCount++;
      }
    });

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Text(
            name,
            style: ArchethicThemeStyles.textStyleSize12W600Primary,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _NFTLabelProperties(propertiesToCount: propertiesToCount),
          ),
          GestureDetector(
            onTap: () {
              context.push(
                NFTDetail.routerPage,
                extra: {
                  'address': address,
                  'name': name,
                  'properties': properties,
                  'collection': collection,
                  'symbol': symbol,
                  'tokenId': tokenId,
                  'detailCollection': collection.isNotEmpty,
                },
              );
            },
            child: Card(
              elevation: 5,
              shadowColor: Colors.black,
              margin: const EdgeInsets.only(left: 8, right: 8),
              color: ArchethicTheme.backgroundDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: const BorderSide(color: Colors.white10),
              ),
              child: collection.isNotEmpty
                  ? NFTThumbnailCollection(
                      address: address,
                      collection: collection,
                      roundBorder: roundBorder,
                    )
                  : NFTThumbnail(
                      address: address,
                      properties: properties,
                      roundBorder: roundBorder,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NFTLabelProperties extends ConsumerWidget {
  const _NFTLabelProperties({
    required this.propertiesToCount,
  });

  final int propertiesToCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return propertiesToCount == 0
        ? Text(
            localizations.noProperty,
            style: ArchethicThemeStyles.textStyleSize12W100Primary,
          )
        : propertiesToCount == 1
            ? Text(
                '$propertiesToCount ${localizations.property}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              )
            : Text(
                '$propertiesToCount ${localizations.properties}',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              );
  }
}
