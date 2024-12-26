/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/infrastructure/datasources/account.hive.dart';
import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:hive/hive.dart';

part 'app_keychain.g.dart';

@HiveType(typeId: HiveTypeIds.appKeychain)

/// Next field available : 3
class AppKeychain extends HiveObject {
  AppKeychain({
    required this.address,
    required this.accounts,
  });

  /// Address
  @HiveField(0)
  String address;

  /// Accounts
  @HiveField(2, defaultValue: [])
  List<Account> accounts;

  Future<Account?> getAccountSelected() async {
    for (final account in accounts) {
      if (account.selected!) {
        return account;
      }
    }

    // To manage the migration of https://github.com/archethic-foundation/archethic-wallet/pull/759
    for (final account in accounts) {
      if (account.serviceType == 'archethicWallet') {
        await AccountHiveDatasource.instance().changeAccount(account.name);
        return account;
      }
    }

    return null;
  }
}
