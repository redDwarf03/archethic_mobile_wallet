// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DAppImpl _$$DAppImplFromJson(Map<String, dynamic> json) => _$DAppImpl(
      code: json['code'] as String,
      url: json['url'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      iconUrl: json['iconUrl'] as String?,
      accessToken: json['accessToken'] as String?,
    );

Map<String, dynamic> _$$DAppImplToJson(_$DAppImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'url': instance.url,
      'category': instance.category,
      'description': instance.description,
      'name': instance.name,
      'iconUrl': instance.iconUrl,
      'accessToken': instance.accessToken,
    };
