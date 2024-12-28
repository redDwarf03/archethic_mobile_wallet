/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:hive/hive.dart';

part 'contact.g.dart';

enum ContactType { keychainService, externalContact }

/// Next field available : 9
@HiveType(typeId: HiveTypeIds.contact)
@AccountBalanceConverter()
class Contact extends HiveObject {
  @Deprecated('Thanks to hive, we should keep this unused class...')
  Contact({
    required this.name,
    required this.address,
    required this.type,
    required this.publicKey,
    required this.genesisAddress,
    this.balance,
    this.favorite,
  });

  /// Name
  @HiveField(0)
  String name;

  /// Address
  @HiveField(1)
  String address;

  /// Type contact - Keychain Service / External contact
  @HiveField(4)
  String type;

  /// Public Key
  @HiveField(5, defaultValue: '')
  String publicKey;

  /// Favorite
  @HiveField(6)
  bool? favorite;

  /// Balance
  @HiveField(7)
  AccountBalance? balance;

  /// Genesis Address
  @HiveField(8)
  String? genesisAddress;
}
