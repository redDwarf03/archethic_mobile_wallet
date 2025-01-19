// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_information.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TokenInformationAdapter extends TypeAdapter<TokenInformation> {
  @override
  final int typeId = 9;

  @override
  TokenInformation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TokenInformation(
      address: fields[0] as String?,
      name: fields[1] as String?,
      type: fields[3] as String?,
      symbol: fields[4] as String?,
      supply: fields[9] as double?,
      id: fields[10] as String?,
      tokenProperties: (fields[12] as Map?)?.cast<String, dynamic>(),
      aeip: (fields[13] as List?)?.cast<int>(),
      tokenCollection: (fields[14] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
      decimals: fields[15] as int?,
      isLPToken: fields[16] as bool?,
      isVerified: fields[17] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TokenInformation obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.symbol)
      ..writeByte(9)
      ..write(obj.supply)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(12)
      ..write(obj.tokenProperties)
      ..writeByte(13)
      ..write(obj.aeip)
      ..writeByte(14)
      ..write(obj.tokenCollection)
      ..writeByte(15)
      ..write(obj.decimals)
      ..writeByte(16)
      ..write(obj.isLPToken)
      ..writeByte(17)
      ..write(obj.isVerified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenInformationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenInformationImpl _$$TokenInformationImplFromJson(
        Map<String, dynamic> json) =>
    _$TokenInformationImpl(
      address: json['address'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      symbol: json['symbol'] as String?,
      supply: (json['supply'] as num?)?.toDouble(),
      id: json['id'] as String?,
      tokenProperties: json['tokenProperties'] as Map<String, dynamic>?,
      aeip: (json['aeip'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      tokenCollection: (json['tokenCollection'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      decimals: (json['decimals'] as num?)?.toInt(),
      isLPToken: json['isLPToken'] as bool?,
      isVerified: json['isVerified'] as bool?,
    );

Map<String, dynamic> _$$TokenInformationImplToJson(
        _$TokenInformationImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'name': instance.name,
      'type': instance.type,
      'symbol': instance.symbol,
      'supply': instance.supply,
      'id': instance.id,
      'tokenProperties': instance.tokenProperties,
      'aeip': instance.aeip,
      'tokenCollection': instance.tokenCollection,
      'decimals': instance.decimals,
      'isLPToken': instance.isLPToken,
      'isVerified': instance.isVerified,
    };
