import 'package:aewallet/infrastructure/datasources/dapp_dto.hive.dart';
import 'package:aewallet/infrastructure/datasources/wallet_token_dto.hive.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/model/data/app_keychain.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:aewallet/model/data/hive_app_wallet_dto.dart';
import 'package:aewallet/model/data/nft_infos_off_chain.dart';
import 'package:aewallet/util/cache_manager_hive.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveTypeIds {
  static const contact = 0;
  static const account = 1;
  static const appKeychain = 3;
  static const appWallet = 4;
  static const accountBalance = 5;
  static const recentTransactions = 6;
  static const price = 7;
  static const accountToken = 8;
  static const tokenInformation = 9;
  static const nftInfosOffChain = 11;
  static const pubKeyAccessRecipient = 13;
  static const contactAccessRecipient = 14;
  static const notificationsSetup = 16;
  static const cacheItem = 17;
  static const tokenCollection = 18;
  static const walletToken = 19;
  static const walletTokenOwnership = 20;
  static const walletTokenOwnershipAuthorizedKey = 21;
  static const myDApps = 22;
}

class DBHelper {
  static Future<void> setupDatabase() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final suppDir = await getApplicationSupportDirectory();
      Hive.init(suppDir.path);
    }

    Hive
      ..ignoreTypeId(HiveTypeIds.notificationsSetup)
      ..ignoreTypeId(HiveTypeIds.pubKeyAccessRecipient)
      ..ignoreTypeId(HiveTypeIds.contactAccessRecipient)
      ..ignoreTypeId(HiveTypeIds.tokenCollection)
      ..ignoreTypeId(HiveTypeIds.price)
      ..registerAdapter(ContactAdapter())
      ..registerAdapter(HiveAppWalletDTOAdapter())
      ..registerAdapter(AccountBalanceAdapter())
      ..registerAdapter(AccountAdapter())
      ..registerAdapter(AppKeychainAdapter())
      ..registerAdapter(RecentTransactionAdapter())
      ..registerAdapter(AccountTokenAdapter())
      ..registerAdapter(TokenInformationAdapter())
      ..registerAdapter(NftInfosOffChainAdapter())
      ..registerAdapter(CacheItemHiveAdapter())
      ..registerAdapter(WalletTokenHiveDtoAdapter())
      ..registerAdapter(WalletTokenOwnershipHiveDtoAdapter())
      ..registerAdapter(WalletTokenOwnershipAuthorizedKeyHiveDtoAdapter())
      ..registerAdapter(DAppHiveDtoAdapter());
  }
}
