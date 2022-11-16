/// SPDX-License-Identifier: AGPL-3.0-or-later
// Project imports:
import 'package:hive/hive.dart';

part 'token_informations.g.dart';

@HiveType(typeId: 9)
class TokenInformations extends HiveObject {
  TokenInformations({
    this.address,
    this.name,
    this.id,
    this.supply,
    this.type,
    this.symbol,
    this.tokenProperties,
  });

  /// Address of token
  @HiveField(0)
  String? address;

  /// Name of token
  @HiveField(1)
  String? name;

  /// Type
  @HiveField(3)
  String? type;

  /// Symbol
  @HiveField(4)
  String? symbol;

  /// Token on chain or in creation
  @Deprecated('Unused')
  @HiveField(7)
  bool? onChain;

  /// Supply
  @HiveField(9)
  double? supply;

  /// Token's Id
  @HiveField(10)
  String? id;

  /// Token Properties
  @HiveField(12)
  Map<String, dynamic>? tokenProperties;
}
