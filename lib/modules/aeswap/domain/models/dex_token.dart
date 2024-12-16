/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/modules/aeswap/domain/models/dex_pair.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dex_token.freezed.dart';
part 'dex_token.g.dart';

@freezed
class DexToken with _$DexToken {
  const factory DexToken({
    required String address,
    @Default('') String name,
    String? icon,
    @Default('') String symbol,
    @Default(0.0) double balance,
    @Default(0.0) double reserve,
    @Default(0.0) double supply,
    @Default(false) bool isVerified,
    @Default(false) bool isLpToken,
    DexPair? lpTokenPair,
  }) = _DexToken;

  factory DexToken.uco({
    double? balance,
    double? reserve,
    double? supply,
  }) =>
      DexToken(
        name: 'Universal Coin',
        symbol: 'UCO',
        address: kUCOAddress,
        icon: 'Archethic.svg',
        isVerified: true,
        balance: balance ?? 0,
        reserve: reserve ?? 0,
        supply: supply ?? 0,
      );
  const DexToken._();

  factory DexToken.fromJson(Map<String, dynamic> json) =>
      _$DexTokenFromJson(json);

  bool get isUCO => symbol == kUCOAddress && (address == kUCOAddress);
}

const kUCOAddress = 'UCO';
const tokenFungibleType = 'fungible';
const tokenNonFungibleType = 'non-fungible';

extension DexTokenAddressExtension on String {
  bool get isUCO => this == kUCOAddress;
  bool get isNotUCO => !isUCO;
}

extension TokenExtension on String {
  bool get isFungible => this == tokenFungibleType;
  bool get isNonFungible => this == tokenNonFungibleType;
}
