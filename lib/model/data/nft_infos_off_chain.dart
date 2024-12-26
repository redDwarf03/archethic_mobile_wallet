/// SPDX-License-Identifier: AGPL-3.0-or-later

// Package imports:
import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:hive/hive.dart';

part 'nft_infos_off_chain.g.dart';

@HiveType(typeId: HiveTypeIds.nftInfosOffChain)
class NftInfosOffChain extends HiveObject {
  @Deprecated('Thanks to hive, we should keep this unsused class...')
  NftInfosOffChain({this.id, this.categoryNftIndex, this.favorite});

  /// Token's Id
  @HiveField(0)
  String? id;

  /// Category Nft
  @HiveField(3)
  int? categoryNftIndex;

  /// Favorite
  @HiveField(4)
  bool? favorite;
}
