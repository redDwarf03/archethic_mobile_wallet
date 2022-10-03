/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:convert';
import 'dart:typed_data';

// Project imports:
import 'package:aewallet/model/data/token_informations.dart';
import 'package:aewallet/model/data/token_informations_property.dart';
// Package imports:
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

class TokenInformationsService {
  static TokenInformations tokenToTokenInformations(Token token) {
    final tokenInformations = TokenInformations();

    tokenInformations.address = token.address;
    tokenInformations.name = token.name;
    tokenInformations.id = token.id;
    tokenInformations.supply = fromBigInt(token.supply).toDouble();
    tokenInformations.type = token.type;
    tokenInformations.symbol = token.symbol;
    token.tokenProperties!.forEach((key, value) {
      final tokenInformationsProperty =
          TokenInformationsProperty(name: key, value: value);
      tokenInformations.tokenProperties!.add(tokenInformationsProperty);
    });
    return tokenInformations;
  }

  Uint8List? getImage(TokenInformations tokenInformations) {
    Uint8List? imageDecoded;
    if (tokenInformations.tokenProperties != null) {
      for (final tokenInformationsProperty
          in tokenInformations.tokenProperties!) {
        if (tokenInformationsProperty.name == 'file') {
          return imageDecoded = base64Decode(tokenInformationsProperty.value!);
        }
      }
    }
    return imageDecoded;
  }
}
