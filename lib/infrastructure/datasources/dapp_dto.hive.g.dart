// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapp_dto.hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DAppHiveDtoAdapter extends TypeAdapter<DAppHiveDto> {
  @override
  final int typeId = 22;

  @override
  DAppHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DAppHiveDto(
      code: fields[0] as String,
      url: fields[1] as String,
      category: fields[2] as String?,
      description: fields[3] as String?,
      name: fields[4] as String?,
      iconUrl: fields[5] as String?,
      accessToken: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DAppHiveDto obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.iconUrl)
      ..writeByte(6)
      ..write(obj.accessToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DAppHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
