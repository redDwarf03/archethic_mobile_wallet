import 'package:aewallet/domain/repositories/account.dart';
import 'package:aewallet/infrastructure/datasources/account.hive.dart';
import 'package:aewallet/model/data/account.dart';

class AccountLocalRepository implements AccountLocalRepositoryInterface {
  final _accountDatasource = AccountHiveDatasource.instance();

  @override
  Future<List<String>> accountNames() async {
    final accounts = await _accountDatasource.getAccounts();
    return accounts
        .map(
          (account) => account.name,
        )
        .toList();
  }

  @override
  Future<void> saveAccount(Account account) async {
    await _accountDatasource.updateAccount(account);
  }

  @override
  Future<Account?> getAccount(String name) async {
    return _accountDatasource.getAccount(name);
  }

  @override
  Future<Account?> getSelectedAccount() async {
    final accounts = await _accountDatasource.getAccounts();

    for (final account in accounts) {
      if (account.selected == true) return account;
    }
    return null;
  }

  @override
  Future<void> selectAccount(String name) async {
    await _accountDatasource.selectAccount(name);
  }
}
