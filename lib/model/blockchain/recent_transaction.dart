import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'recent_transaction.freezed.dart';
part 'recent_transaction.g.dart';

class RecentTransactionConverter
    implements JsonConverter<RecentTransaction, Map<String, dynamic>> {
  const RecentTransactionConverter();

  @override
  RecentTransaction fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      address: json['address'] as String?,
      typeTx: json['typeTx'] as int?,
      timestamp: json['timestamp'] as int?,
      fee: (json['fee'] as num?)?.toDouble(),
      from: json['from'] as String?,
      content: json['content'] as String?,
      type: json['type'] as String?,
      decryptedSecret: (json['decryptedSecret'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      action: json['action'] as String?,
      ledgerOperationMvtInfo: (json['ledgerOperationMvtInfo'] as List<dynamic>?)
          ?.map((e) => _ledgerOperationMvtFromJson(e as Map<String, dynamic>))
          .toList(),
      ownerships: (json['ownerships'] as List<dynamic>?)
          ?.map((e) => Ownership.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson(RecentTransaction recentTransaction) {
    return {
      'address': recentTransaction.address,
      'typeTx': recentTransaction.typeTx,
      'timestamp': recentTransaction.timestamp,
      'fee': recentTransaction.fee,
      'from': recentTransaction.from,
      'content': recentTransaction.content,
      'type': recentTransaction.type,
      'decryptedSecret': recentTransaction.decryptedSecret,
      'action': recentTransaction.action,
      'ledgerOperationMvtInfo': recentTransaction.ledgerOperationMvtInfo
          ?.map(_ledgerOperationMvtToJson)
          .toList(),
      'ownerships': recentTransaction.ownerships
          ?.map((ownership) => ownership.toJson())
          .toList(),
    };
  }

  // Helper to deserialize `LedgerOperationMvt`
  LedgerOperationMvt _ledgerOperationMvtFromJson(Map<String, dynamic> json) {
    return (
      amount: (json['amount'] as num?)?.toDouble(),
      to: json['to'] as String?,
      type: json['type'] as String?,
      tokenInformation: json['tokenInformation'] != null
          ? TokenInformation.fromJson(
              json['tokenInformation'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  // Helper to serialize `LedgerOperationMvt`
  Map<String, dynamic> _ledgerOperationMvtToJson(LedgerOperationMvt mvt) {
    return {
      'amount': mvt.amount,
      'to': mvt.to,
      'type': mvt.type,
      'tokenInformation': mvt.tokenInformation?.toJson(),
    };
  }
}

/// Next field available : 17
@HiveType(typeId: HiveTypeIds.recentTransactions)
@RecentTransactionConverter()
@freezed
class RecentTransaction extends HiveObject with _$RecentTransaction {
  factory RecentTransaction({
    /// Address of transaction
    @HiveField(0) String? address,

    /// Type of transaction : 1=Transfer/Input, 2=Transfer/Output, 3=Token creation
    @HiveField(1) int? typeTx,

    /// Amount: asset amount
    //@HiveField(2) double? amount,

    /// Recipients: For non asset transfers, the list of recipients
    /// of the transaction (e.g Smart contract interactions)
    //@HiveField(3) String? recipient,

    /// Timestamp: Date time when the transaction was generated
    @HiveField(4) int? timestamp,

    /// Fee: transaction fee (distributed over the node rewards)
    @HiveField(5) double? fee,

    /// From: transaction which send the amount of assets
    @HiveField(6) String? from,

    /// Content: free zone for data hosting (string or hexadecimal)
    @HiveField(9) String? content,

    /// Type: UCO/tokens/Call
    @HiveField(10) String? type,

    /// Token Information
    //@HiveField(11) TokenInformation? tokenInformation,

    /// Contact Information
    @HiveField(12)
    @Deprecated('Thanks to hive, we should keep this unused property...')
    Contact? contactInformation,

    /// Decrypted Secret
    @HiveField(14) List<String>? decryptedSecret,

    /// Action
    @HiveField(15) String? action,

    /// Ledger operations movements
    @HiveField(16) LedgerOperationMvtInfo? ledgerOperationMvtInfo,
    List<Ownership>? ownerships,
  }) = _RecentTransaction;

  RecentTransaction._();

  /// Types of transaction
  static const int transferInput = 1;
  static const int transferOutput = 2;
  static const int tokenCreation = 3;
  static const int hosting = 4;
}

typedef LedgerOperationMvt = ({
  double? amount,
  String? to,
  String? type,
  TokenInformation? tokenInformation,
});

typedef LedgerOperationMvtInfo = List<LedgerOperationMvt>;
