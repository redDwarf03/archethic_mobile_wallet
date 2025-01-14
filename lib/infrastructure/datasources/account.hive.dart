import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/hive_app_wallet_dto.dart';
import 'package:hive/hive.dart';

class AccountHiveDatasource {
  AccountHiveDatasource._();

  factory AccountHiveDatasource.instance() {
    return _instance ?? (_instance = AccountHiveDatasource._());
  }

  static AccountHiveDatasource? _instance;

  static const String appWalletTable = 'appWallet';

  Future<Box<HiveAppWalletDTO>> get _box =>
      Hive.openBox<HiveAppWalletDTO>(appWalletTable);

  Future<HiveAppWalletDTO> _readAppWallet() async {
    final box = await _box;
    return box.get(0)!;
  }

  Future<HiveAppWalletDTO> _writeAppWallet(HiveAppWalletDTO appWallet) async {
    final box = await _box;
    await box.putAt(0, appWallet);
    return appWallet;
  }

  Future<List<Account>> getAccounts() async {
    final appWallet = await _readAppWallet();
    return appWallet.appKeychain.accounts;
  }

  Future<Account?> getAccount(String name) async {
    final appWallet = await _readAppWallet();
    for (final account in appWallet.appKeychain.accounts) {
      if (account.name == name) return account;
    }
    return null;
  }

  Future<HiveAppWalletDTO> addAccount(Account account) async {
    final appWallet = await _readAppWallet();
    appWallet.appKeychain.accounts.add(account);
    return _writeAppWallet(appWallet);
  }

  Future<HiveAppWalletDTO> selectAccount(String accountName) async {
    final appWallet = await _readAppWallet();
    for (var i = 0; i < appWallet.appKeychain.accounts.length; i++) {
      final account = appWallet.appKeychain.accounts[i];
      final updatedAccount = account.copyWith(
        selected: account.name == accountName,
      );
      appWallet.appKeychain.accounts[i] = updatedAccount;
    }
    return _writeAppWallet(appWallet);
  }

  Future<void> updateAccount(Account updatedAccount) async {
    final appWallet = await _readAppWallet();
    appWallet.appKeychain.accounts = appWallet.appKeychain.accounts.map(
      (account) {
        if (account.name == updatedAccount.name) return updatedAccount;
        return account;
      },
    ).toList();
    await _writeAppWallet(appWallet);
  }
}
