import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/blockchain/recent_transaction.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/model/data/nft_infos_off_chain.dart';
import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: HiveTypeIds.account)

/// Next field available : 16
class Account extends HiveObject {
  Account({
    required this.name,
    required this.genesisAddress,
    this.lastLoadingTransactionInputs,
    this.selected = false,
    this.lastAddress,
    this.balance,
    this.recentTransactions,
    this.accountTokens,
    this.accountNFT,
    this.accountNFTCollections,
    this.serviceType,
    this.customTokenAddressList,
  });

  Account copyWith({
    String? name,
    String? genesisAddress,
    int? lastLoadingTransactionInputs,
    bool? selected,
    String? lastAddress,
    String? serviceType,
    AccountBalance? balance,
    List<RecentTransaction>? recentTransactions,
    List<AccountToken>? accountTokens,
    List<AccountToken>? accountNFT,
    List<AccountToken>? accountNFTCollections,
    List<int>? nftCategoryList,
    List<String>? customTokenAddressList,
  }) =>
      Account(
        name: name ?? this.name,
        genesisAddress: genesisAddress ?? this.genesisAddress,
        lastLoadingTransactionInputs:
            lastLoadingTransactionInputs ?? this.lastLoadingTransactionInputs,
        selected: selected ?? this.selected,
        lastAddress: lastAddress ?? this.lastAddress,
        serviceType: serviceType ?? this.serviceType,
        balance: balance ?? this.balance,
        recentTransactions: recentTransactions ?? this.recentTransactions,
        accountTokens: accountTokens ?? this.accountTokens,
        accountNFT: accountNFT ?? this.accountNFT,
        accountNFTCollections:
            accountNFTCollections ?? this.accountNFTCollections,
        customTokenAddressList:
            customTokenAddressList ?? this.customTokenAddressList,
      );

  /// Account name - Primary Key
  @HiveField(0)
  final String name;

  /// Genesis Address
  @HiveField(1)
  final String genesisAddress;

  /// Last loading of transaction inputs
  @HiveField(2)
  int? lastLoadingTransactionInputs;

  /// Whether this is the currently selected account
  @HiveField(3)
  bool? selected;

  /// Last address
  @HiveField(4)
  String? lastAddress;

  /// Balance
  @HiveField(5)
  AccountBalance? balance;

  /// Recent transactions
  @HiveField(6)
  List<RecentTransaction>? recentTransactions;

  /// Tokens
  @HiveField(7)
  List<AccountToken>? accountTokens;

  /// NFT
  @HiveField(8)
  List<AccountToken>? accountNFT;

  /// NFT Info Off Chain
  @Deprecated('Thanks to hive, we should keep this unused property...')
  @HiveField(10)
  List<NftInfosOffChain>? nftInfosOffChainList;

  /// Service Type
  @HiveField(13)
  String? serviceType;

  /// NFT Collections
  @HiveField(14)
  List<AccountToken>? accountNFTCollections;

  /// Custom Token Addresses
  @HiveField(15)
  List<String>? customTokenAddressList;
}
