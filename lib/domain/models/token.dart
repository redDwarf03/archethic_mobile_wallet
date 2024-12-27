/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/domain/models/token_property.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';

const kTokenFordiddenName = ['UCO', 'MUCO'];

/// Represents a token, blockchain agnostic.
@freezed
class Token with _$Token {
  const factory Token({
    required KeychainSecuredInfos keychainSecuredInfos,
    required String genesisAddress,
    required String accountSelectedName,
    required String name,
    required String symbol,
    required double initialSupply,
    required String type,
    required List<TokenProperty> properties,
    required List<int> aeip,
  }) = _Token;
  const Token._();
}
