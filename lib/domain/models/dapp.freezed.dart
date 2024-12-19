// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dapp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DApp _$DAppFromJson(Map<String, dynamic> json) {
  return _DApp.fromJson(json);
}

/// @nodoc
mixin _$DApp {
  String get code => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get iconUrl => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;

  /// Serializes this DApp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DAppCopyWith<DApp> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DAppCopyWith<$Res> {
  factory $DAppCopyWith(DApp value, $Res Function(DApp) then) =
      _$DAppCopyWithImpl<$Res, DApp>;
  @useResult
  $Res call(
      {String code,
      String url,
      String? category,
      String? description,
      String? name,
      String? iconUrl,
      String? accessToken});
}

/// @nodoc
class _$DAppCopyWithImpl<$Res, $Val extends DApp>
    implements $DAppCopyWith<$Res> {
  _$DAppCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? url = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? name = freezed,
    Object? iconUrl = freezed,
    Object? accessToken = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DAppImplCopyWith<$Res> implements $DAppCopyWith<$Res> {
  factory _$$DAppImplCopyWith(
          _$DAppImpl value, $Res Function(_$DAppImpl) then) =
      __$$DAppImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String url,
      String? category,
      String? description,
      String? name,
      String? iconUrl,
      String? accessToken});
}

/// @nodoc
class __$$DAppImplCopyWithImpl<$Res>
    extends _$DAppCopyWithImpl<$Res, _$DAppImpl>
    implements _$$DAppImplCopyWith<$Res> {
  __$$DAppImplCopyWithImpl(_$DAppImpl _value, $Res Function(_$DAppImpl) _then)
      : super(_value, _then);

  /// Create a copy of DApp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? url = null,
    Object? category = freezed,
    Object? description = freezed,
    Object? name = freezed,
    Object? iconUrl = freezed,
    Object? accessToken = freezed,
  }) {
    return _then(_$DAppImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DAppImpl implements _DApp {
  const _$DAppImpl(
      {required this.code,
      required this.url,
      this.category,
      this.description,
      this.name,
      this.iconUrl,
      this.accessToken});

  factory _$DAppImpl.fromJson(Map<String, dynamic> json) =>
      _$$DAppImplFromJson(json);

  @override
  final String code;
  @override
  final String url;
  @override
  final String? category;
  @override
  final String? description;
  @override
  final String? name;
  @override
  final String? iconUrl;
  @override
  final String? accessToken;

  @override
  String toString() {
    return 'DApp(code: $code, url: $url, category: $category, description: $description, name: $name, iconUrl: $iconUrl, accessToken: $accessToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DAppImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, url, category, description,
      name, iconUrl, accessToken);

  /// Create a copy of DApp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DAppImplCopyWith<_$DAppImpl> get copyWith =>
      __$$DAppImplCopyWithImpl<_$DAppImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DAppImplToJson(
      this,
    );
  }
}

abstract class _DApp implements DApp {
  const factory _DApp(
      {required final String code,
      required final String url,
      final String? category,
      final String? description,
      final String? name,
      final String? iconUrl,
      final String? accessToken}) = _$DAppImpl;

  factory _DApp.fromJson(Map<String, dynamic> json) = _$DAppImpl.fromJson;

  @override
  String get code;
  @override
  String get url;
  @override
  String? get category;
  @override
  String? get description;
  @override
  String? get name;
  @override
  String? get iconUrl;
  @override
  String? get accessToken;

  /// Create a copy of DApp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DAppImplCopyWith<_$DAppImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
