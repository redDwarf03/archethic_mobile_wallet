/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'account_token.g.dart';

class AccountTokenConverter
    implements JsonConverter<AccountToken, Map<String, dynamic>> {
  const AccountTokenConverter();

  @override
  AccountToken fromJson(Map<String, dynamic> json) {
    return AccountToken(
      tokenInformation: json['tokenInformation'] != null
          ? TokenInformation.fromJson(
              json['tokenInformation'] as Map<String, dynamic>,
            )
          : null,
      amount: json['amount'] as double,
    );
  }

  @override
  Map<String, dynamic> toJson(AccountToken accountToken) {
    return {
      'tokenInformation': accountToken.tokenInformation?.toJson(),
      'amount': accountToken.amount,
    };
  }
}

/// Next field available : 9
@HiveType(typeId: HiveTypeIds.accountToken)
class AccountToken extends HiveObject {
  AccountToken({
    this.tokenInformation,
    this.amount,
  });

  /// Token Information
  @HiveField(7)
  TokenInformation? tokenInformation;

  /// Amount
  @HiveField(8)
  double? amount;
}
