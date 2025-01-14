// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountImplAdapter extends TypeAdapter<_$AccountImpl> {
  @override
  final int typeId = 1;

  @override
  _$AccountImpl read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$AccountImpl(
      name: fields[0] as String,
      genesisAddress: fields[1] as String,
      lastLoadingTransactionInputs: fields[2] as int?,
      selected: fields[3] as bool?,
      lastAddress: fields[4] as String?,
      balance: fields[5] as AccountBalance?,
      recentTransactions: (fields[6] as List?)?.cast<RecentTransaction>(),
      accountTokens: (fields[7] as List?)?.cast<AccountToken>(),
      accountNFT: (fields[8] as List?)?.cast<AccountToken>(),
      nftInfosOffChainList: (fields[10] as List?)?.cast<NftInfosOffChain>(),
      serviceType: fields[13] as String?,
      accountNFTCollections: (fields[14] as List?)?.cast<AccountToken>(),
      customTokenAddressList: (fields[15] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, _$AccountImpl obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.genesisAddress)
      ..writeByte(2)
      ..write(obj.lastLoadingTransactionInputs)
      ..writeByte(3)
      ..write(obj.selected)
      ..writeByte(4)
      ..write(obj.lastAddress)
      ..writeByte(5)
      ..write(obj.balance)
      ..writeByte(13)
      ..write(obj.serviceType)
      ..writeByte(6)
      ..write(obj.recentTransactions)
      ..writeByte(7)
      ..write(obj.accountTokens)
      ..writeByte(8)
      ..write(obj.accountNFT)
      ..writeByte(10)
      ..write(obj.nftInfosOffChainList)
      ..writeByte(14)
      ..write(obj.accountNFTCollections)
      ..writeByte(15)
      ..write(obj.customTokenAddressList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountImplAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
