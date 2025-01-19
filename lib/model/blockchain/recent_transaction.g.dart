// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentTransactionAdapter extends TypeAdapter<RecentTransaction> {
  @override
  final int typeId = 6;

  @override
  RecentTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentTransaction(
      address: fields[0] as String?,
      typeTx: fields[1] as int?,
      timestamp: fields[4] as int?,
      fee: fields[5] as double?,
      from: fields[6] as String?,
      content: fields[9] as String?,
      type: fields[10] as String?,
      contactInformation: fields[12] as Contact?,
      decryptedSecret: (fields[14] as List?)?.cast<String>(),
      action: fields[15] as String?,
      ledgerOperationMvtInfo: (fields[16] as List?)?.cast<
          ({
            double amount,
            String to,
            TokenInformation tokenInformation,
            String type
          })>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecentTransaction obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.typeTx)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.fee)
      ..writeByte(6)
      ..write(obj.from)
      ..writeByte(9)
      ..write(obj.content)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.contactInformation)
      ..writeByte(14)
      ..write(obj.decryptedSecret)
      ..writeByte(15)
      ..write(obj.action)
      ..writeByte(16)
      ..write(obj.ledgerOperationMvtInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
