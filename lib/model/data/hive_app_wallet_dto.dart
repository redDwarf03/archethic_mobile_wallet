import 'package:aewallet/domain/models/app_wallet.dart';
import 'package:aewallet/infrastructure/datasources/account.hive.dart';
import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/infrastructure/datasources/appwallet.hive.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/app_keychain.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:hive/hive.dart';

part 'hive_app_wallet_dto.g.dart';

/// Next field available : 2
@HiveType(typeId: HiveTypeIds.appWallet)
class HiveAppWalletDTO extends HiveObject {
  HiveAppWalletDTO({
    required this.appKeychain,
  });

  factory HiveAppWalletDTO.fromModel(AppWallet appWallet) => HiveAppWalletDTO(
        appKeychain: appWallet.appKeychain,
      );

  AppWallet toModel({
    required String seed,
    required KeychainSecuredInfos keychainSecuredInfos,
  }) =>
      AppWallet(
        appKeychain: appKeychain,
        seed: seed,
        keychainSecuredInfos: keychainSecuredInfos,
      );

  /// Keychain
  @HiveField(1)
  AppKeychain appKeychain;

  static Future<HiveAppWalletDTO> createNewAppWallet(
    String keychainAddress,
    Keychain keychain,
    String name,
  ) async {
    Account? selectedAcct;

    await AppWalletHiveDatasource.instance().createAppWallet(keychainAddress);

    final kServiceName = Uri.encodeFull(name);

    final genesisAddress = keychain.deriveAddress(kServiceName);
    selectedAcct = Account(
      lastLoadingTransactionInputs: 0,
      genesisAddress: uint8ListToHex(genesisAddress),
      name: kServiceName,
      balance: AccountBalance(
        nativeTokenName: AccountBalance.cryptoCurrencyLabel,
        nativeTokenValue: 0,
      ),
      selected: true,
      serviceType: 'archethicWallet',
      recentTransactions: [],
    );
    return AccountHiveDatasource.instance().addAccount(selectedAcct);
  }

  HiveAppWalletDTO copyWith({
    AppKeychain? appKeychain,
  }) =>
      HiveAppWalletDTO(
        appKeychain: appKeychain ?? this.appKeychain,
      );
}
