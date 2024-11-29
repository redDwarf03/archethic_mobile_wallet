import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_flags.freezed.dart';
part 'feature_flags.g.dart';

@freezed
class FeatureFlags with _$FeatureFlags {
  const factory FeatureFlags({
    required String applicationCode,
    required Map<String, Map<String, bool>> features,
  }) = _FeatureFlags;

  factory FeatureFlags.fromJson(Map<String, dynamic> json) =>
      _$FeatureFlagsFromJson(json);
}
