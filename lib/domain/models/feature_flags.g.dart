// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeatureFlagsImpl _$$FeatureFlagsImplFromJson(Map<String, dynamic> json) =>
    _$FeatureFlagsImpl(
      applicationCode: json['applicationCode'] as String,
      features: (json['features'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Map<String, bool>.from(e as Map)),
      ),
    );

Map<String, dynamic> _$$FeatureFlagsImplToJson(_$FeatureFlagsImpl instance) =>
    <String, dynamic>{
      'applicationCode': instance.applicationCode,
      'features': instance.features,
    };
