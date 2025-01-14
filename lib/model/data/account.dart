import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/model/data/nft_infos_off_chain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'account.freezed.dart';
part 'account.g.dart';

class AccountConverter implements JsonConverter<Account, Map<String, dynamic>> {
  const AccountConverter();

  @override
  Account fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'] as String,
      genesisAddress: json['genesisAddress'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(Account account) {
    return {
      'name': account.name,
      'genesisAddress': account.genesisAddress,
    };
  }
}

/// Next field available : 16
@freezed
class Account extends HiveObject with _$Account {
  @HiveType(typeId: HiveTypeIds.account)
  factory Account({
    /// Account name - Primary Key
    @HiveField(0) required String name,

    /// Genesis Address
    @HiveField(1) required String genesisAddress,

    /// Last loading of transaction inputs
    @HiveField(2) int? lastLoadingTransactionInputs,

    /// Whether this is the currently selected account
    @HiveField(3) bool? selected,

    /// Last address

    @HiveField(4)
    @Deprecated(
      'Genesis address should be preferred instead of last address after AEIP21',
    )
    String? lastAddress,

    /// Balance
    @HiveField(5) AccountBalance? balance,

    /// Recent transactions
    @HiveField(6) List<RecentTransaction>? recentTransactions,

    /// Tokens
    @HiveField(7) List<AccountToken>? accountTokens,

    /// NFT
    @HiveField(8) List<AccountToken>? accountNFT,

    /// NFT Info Off Chain
    @Deprecated('Thanks to hive, we should keep this unused property...')
    @HiveField(10)
    List<NftInfosOffChain>? nftInfosOffChainList,

    /// Service Type
    @HiveField(13) String? serviceType,

    /// NFT Collections
    @HiveField(14) List<AccountToken>? accountNFTCollections,

    /// Custom Token Addresses
    @HiveField(15) List<String>? customTokenAddressList,
  }) = _Account;

  Account._();
}
