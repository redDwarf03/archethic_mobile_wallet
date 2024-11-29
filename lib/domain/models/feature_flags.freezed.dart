// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_flags.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeatureFlags _$FeatureFlagsFromJson(Map<String, dynamic> json) {
  return _FeatureFlags.fromJson(json);
}

/// @nodoc
mixin _$FeatureFlags {
  String get applicationCode => throw _privateConstructorUsedError;
  Map<String, Map<String, bool>> get features =>
      throw _privateConstructorUsedError;

  /// Serializes this FeatureFlags to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureFlagsCopyWith<FeatureFlags> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureFlagsCopyWith<$Res> {
  factory $FeatureFlagsCopyWith(
          FeatureFlags value, $Res Function(FeatureFlags) then) =
      _$FeatureFlagsCopyWithImpl<$Res, FeatureFlags>;
  @useResult
  $Res call({String applicationCode, Map<String, Map<String, bool>> features});
}

/// @nodoc
class _$FeatureFlagsCopyWithImpl<$Res, $Val extends FeatureFlags>
    implements $FeatureFlagsCopyWith<$Res> {
  _$FeatureFlagsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationCode = null,
    Object? features = null,
  }) {
    return _then(_value.copyWith(
      applicationCode: null == applicationCode
          ? _value.applicationCode
          : applicationCode // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, bool>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureFlagsImplCopyWith<$Res>
    implements $FeatureFlagsCopyWith<$Res> {
  factory _$$FeatureFlagsImplCopyWith(
          _$FeatureFlagsImpl value, $Res Function(_$FeatureFlagsImpl) then) =
      __$$FeatureFlagsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String applicationCode, Map<String, Map<String, bool>> features});
}

/// @nodoc
class __$$FeatureFlagsImplCopyWithImpl<$Res>
    extends _$FeatureFlagsCopyWithImpl<$Res, _$FeatureFlagsImpl>
    implements _$$FeatureFlagsImplCopyWith<$Res> {
  __$$FeatureFlagsImplCopyWithImpl(
      _$FeatureFlagsImpl _value, $Res Function(_$FeatureFlagsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? applicationCode = null,
    Object? features = null,
  }) {
    return _then(_$FeatureFlagsImpl(
      applicationCode: null == applicationCode
          ? _value.applicationCode
          : applicationCode // ignore: cast_nullable_to_non_nullable
              as String,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, bool>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeatureFlagsImpl implements _FeatureFlags {
  const _$FeatureFlagsImpl(
      {required this.applicationCode,
      required final Map<String, Map<String, bool>> features})
      : _features = features;

  factory _$FeatureFlagsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeatureFlagsImplFromJson(json);

  @override
  final String applicationCode;
  final Map<String, Map<String, bool>> _features;
  @override
  Map<String, Map<String, bool>> get features {
    if (_features is EqualUnmodifiableMapView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_features);
  }

  @override
  String toString() {
    return 'FeatureFlags(applicationCode: $applicationCode, features: $features)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureFlagsImpl &&
            (identical(other.applicationCode, applicationCode) ||
                other.applicationCode == applicationCode) &&
            const DeepCollectionEquality().equals(other._features, _features));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, applicationCode,
      const DeepCollectionEquality().hash(_features));

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureFlagsImplCopyWith<_$FeatureFlagsImpl> get copyWith =>
      __$$FeatureFlagsImplCopyWithImpl<_$FeatureFlagsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeatureFlagsImplToJson(
      this,
    );
  }
}

abstract class _FeatureFlags implements FeatureFlags {
  const factory _FeatureFlags(
          {required final String applicationCode,
          required final Map<String, Map<String, bool>> features}) =
      _$FeatureFlagsImpl;

  factory _FeatureFlags.fromJson(Map<String, dynamic> json) =
      _$FeatureFlagsImpl.fromJson;

  @override
  String get applicationCode;
  @override
  Map<String, Map<String, bool>> get features;

  /// Create a copy of FeatureFlags
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureFlagsImplCopyWith<_$FeatureFlagsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
