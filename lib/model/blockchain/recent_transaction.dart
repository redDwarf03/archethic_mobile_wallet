import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:hive/hive.dart';

part 'recent_transaction.g.dart';

/// [TransactionInput] represents the inputs from the transaction.

/// Next field available : 15
@HiveType(typeId: HiveTypeIds.recentTransactions)
class RecentTransaction extends HiveObject {
  RecentTransaction({
    this.address,
    this.typeTx,
    this.amount,
    this.recipient,
    this.from,
    this.fee,
    this.content,
    this.timestamp,
    this.type,
    this.decryptedSecret,
    this.ownerships,
    this.indexInLedger = 0,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      RecentTransaction(
        address: json['address'],
        typeTx: json['typeTx']?.toInt(),
        recipient: json['recipient'],
        amount: json['amount']?.toDouble(),
        fee: json['fee']?.toDouble(),
        from: json['from'],
        content: json['content'],
        timestamp: json['timestamp'],
        type: json['type'],
        decryptedSecret: json['decryptedSecret'],
      );

  /// Types of transaction
  static const int transferInput = 1;
  static const int transferOutput = 2;
  static const int tokenCreation = 3;
  static const int hosting = 4;

  /// Address of transaction
  @HiveField(0)
  String? address;

  /// Type of transaction : 1=Transfer/Input, 2=Transfer/Output, 3=Token creation
  @HiveField(1)
  int? typeTx;

  /// Amount: asset amount
  @HiveField(2)
  double? amount;

  /// Recipients: For non asset transfers, the list of recipients
  /// of the transaction (e.g Smart contract interactions)
  @HiveField(3)
  String? recipient;

  /// Timestamp: Date time when the transaction was generated
  @HiveField(4)
  int? timestamp;

  /// Fee: transaction fee (distributed over the node rewards)
  @HiveField(5)
  double? fee;

  /// From: transaction which send the amount of assets
  @HiveField(6)
  String? from;

  /// Content: free zone for data hosting (string or hexadecimal)
  @HiveField(9)
  String? content;

  /// Type: UCO/tokens/Call
  @HiveField(10)
  String? type;

  /// Token Information
  @HiveField(11)
  TokenInformation? tokenInformation;

  /// Contact Information
  @HiveField(12)
  @Deprecated('Thanks to hive, we should keep this unused property...')
  Contact? contactInformation;

  /// Decrypted Secret
  @HiveField(14)
  List<String>? decryptedSecret;

  List<Ownership>? ownerships;
  String? tokenAddress;
  int indexInLedger;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'address': address,
        'typeTx': typeTx,
        'recipient': recipient,
        'amount': amount,
        'fee': fee,
        'from': from,
        'content': content,
        'timestamp': timestamp,
        'type': type,
        'decryptedSecret': decryptedSecret,
      };
}
