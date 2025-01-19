/// SPDX-License-Identifier: AGPL-3.0-or-later

// Project imports:
import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'token_information.freezed.dart';
part 'token_information.g.dart';

/// Next field available : 18
@HiveType(typeId: HiveTypeIds.tokenInformation)
@freezed
class TokenInformation with _$TokenInformation {
  const factory TokenInformation({
    @HiveField(0) String? address,
    @HiveField(1) String? name,
    @HiveField(3) String? type,
    @HiveField(4) String? symbol,
    @HiveField(9) double? supply,
    @HiveField(10) String? id,
    @HiveField(12) Map<String, dynamic>? tokenProperties,
    @HiveField(13) List<int>? aeip,
    @HiveField(14) List<Map<String, dynamic>>? tokenCollection,
    @HiveField(15) int? decimals,
    @HiveField(16) bool? isLPToken,
    @HiveField(17) bool? isVerified,
  }) = _TokenInformation;

  factory TokenInformation.fromJson(Map<String, dynamic> json) =>
      _$TokenInformationFromJson(json);
}
