// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferDestinationAddressImpl _$$TransferDestinationAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferDestinationAddressImpl(
      address: const AddressJsonConverter().fromJson(json['address'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TransferDestinationAddressImplToJson(
        _$TransferDestinationAddressImpl instance) =>
    <String, dynamic>{
      'address': const AddressJsonConverter().toJson(instance.address),
      'runtimeType': instance.$type,
    };

_$TransferDestinationContactImpl _$$TransferDestinationContactImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferDestinationContactImpl(
      account: const AccountConverter()
          .fromJson(json['account'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$TransferDestinationContactImplToJson(
        _$TransferDestinationContactImpl instance) =>
    <String, dynamic>{
      'account': const AccountConverter().toJson(instance.account),
      'runtimeType': instance.$type,
    };

_$TransferDestinationUnknownContactImpl
    _$$TransferDestinationUnknownContactImplFromJson(
            Map<String, dynamic> json) =>
        _$TransferDestinationUnknownContactImpl(
          name: json['name'] as String,
          $type: json['runtimeType'] as String?,
        );

Map<String, dynamic> _$$TransferDestinationUnknownContactImplToJson(
        _$TransferDestinationUnknownContactImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'runtimeType': instance.$type,
    };
