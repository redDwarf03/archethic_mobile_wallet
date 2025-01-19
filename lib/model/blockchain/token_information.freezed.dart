// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_information.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TokenInformation _$TokenInformationFromJson(Map<String, dynamic> json) {
  return _TokenInformation.fromJson(json);
}

/// @nodoc
mixin _$TokenInformation {
  @HiveField(0)
  String? get address => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get name => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get type => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get symbol => throw _privateConstructorUsedError;
  @HiveField(9)
  double? get supply => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get id => throw _privateConstructorUsedError;
  @HiveField(12)
  Map<String, dynamic>? get tokenProperties =>
      throw _privateConstructorUsedError;
  @HiveField(13)
  List<int>? get aeip => throw _privateConstructorUsedError;
  @HiveField(14)
  List<Map<String, dynamic>>? get tokenCollection =>
      throw _privateConstructorUsedError;
  @HiveField(15)
  int? get decimals => throw _privateConstructorUsedError;
  @HiveField(16)
  bool? get isLPToken => throw _privateConstructorUsedError;
  @HiveField(17)
  bool? get isVerified => throw _privateConstructorUsedError;

  /// Serializes this TokenInformation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TokenInformation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TokenInformationCopyWith<TokenInformation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenInformationCopyWith<$Res> {
  factory $TokenInformationCopyWith(
          TokenInformation value, $Res Function(TokenInformation) then) =
      _$TokenInformationCopyWithImpl<$Res, TokenInformation>;
  @useResult
  $Res call(
      {@HiveField(0) String? address,
      @HiveField(1) String? name,
      @HiveField(3) String? type,
      @HiveField(4) String? symbol,
      @HiveField(9) double? supply,
      @HiveField(10) String? id,
      @HiveField(12) Map<String, dynamic>? tokenProperties,
      @HiveField(13) List<int>? aeip,
      @HiveField(14) List<Map<String, dynamic>>? tokenCollection,
      @HiveField(15) int? decimals,
      @HiveField(16) bool? isLPToken,
      @HiveField(17) bool? isVerified});
}

/// @nodoc
class _$TokenInformationCopyWithImpl<$Res, $Val extends TokenInformation>
    implements $TokenInformationCopyWith<$Res> {
  _$TokenInformationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TokenInformation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? name = freezed,
    Object? type = freezed,
    Object? symbol = freezed,
    Object? supply = freezed,
    Object? id = freezed,
    Object? tokenProperties = freezed,
    Object? aeip = freezed,
    Object? tokenCollection = freezed,
    Object? decimals = freezed,
    Object? isLPToken = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_value.copyWith(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      supply: freezed == supply
          ? _value.supply
          : supply // ignore: cast_nullable_to_non_nullable
              as double?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenProperties: freezed == tokenProperties
          ? _value.tokenProperties
          : tokenProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      aeip: freezed == aeip
          ? _value.aeip
          : aeip // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      tokenCollection: freezed == tokenCollection
          ? _value.tokenCollection
          : tokenCollection // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      decimals: freezed == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int?,
      isLPToken: freezed == isLPToken
          ? _value.isLPToken
          : isLPToken // ignore: cast_nullable_to_non_nullable
              as bool?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokenInformationImplCopyWith<$Res>
    implements $TokenInformationCopyWith<$Res> {
  factory _$$TokenInformationImplCopyWith(_$TokenInformationImpl value,
          $Res Function(_$TokenInformationImpl) then) =
      __$$TokenInformationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? address,
      @HiveField(1) String? name,
      @HiveField(3) String? type,
      @HiveField(4) String? symbol,
      @HiveField(9) double? supply,
      @HiveField(10) String? id,
      @HiveField(12) Map<String, dynamic>? tokenProperties,
      @HiveField(13) List<int>? aeip,
      @HiveField(14) List<Map<String, dynamic>>? tokenCollection,
      @HiveField(15) int? decimals,
      @HiveField(16) bool? isLPToken,
      @HiveField(17) bool? isVerified});
}

/// @nodoc
class __$$TokenInformationImplCopyWithImpl<$Res>
    extends _$TokenInformationCopyWithImpl<$Res, _$TokenInformationImpl>
    implements _$$TokenInformationImplCopyWith<$Res> {
  __$$TokenInformationImplCopyWithImpl(_$TokenInformationImpl _value,
      $Res Function(_$TokenInformationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TokenInformation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? name = freezed,
    Object? type = freezed,
    Object? symbol = freezed,
    Object? supply = freezed,
    Object? id = freezed,
    Object? tokenProperties = freezed,
    Object? aeip = freezed,
    Object? tokenCollection = freezed,
    Object? decimals = freezed,
    Object? isLPToken = freezed,
    Object? isVerified = freezed,
  }) {
    return _then(_$TokenInformationImpl(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      supply: freezed == supply
          ? _value.supply
          : supply // ignore: cast_nullable_to_non_nullable
              as double?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenProperties: freezed == tokenProperties
          ? _value._tokenProperties
          : tokenProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      aeip: freezed == aeip
          ? _value._aeip
          : aeip // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      tokenCollection: freezed == tokenCollection
          ? _value._tokenCollection
          : tokenCollection // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      decimals: freezed == decimals
          ? _value.decimals
          : decimals // ignore: cast_nullable_to_non_nullable
              as int?,
      isLPToken: freezed == isLPToken
          ? _value.isLPToken
          : isLPToken // ignore: cast_nullable_to_non_nullable
              as bool?,
      isVerified: freezed == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokenInformationImpl implements _TokenInformation {
  const _$TokenInformationImpl(
      {@HiveField(0) this.address,
      @HiveField(1) this.name,
      @HiveField(3) this.type,
      @HiveField(4) this.symbol,
      @HiveField(9) this.supply,
      @HiveField(10) this.id,
      @HiveField(12) final Map<String, dynamic>? tokenProperties,
      @HiveField(13) final List<int>? aeip,
      @HiveField(14) final List<Map<String, dynamic>>? tokenCollection,
      @HiveField(15) this.decimals,
      @HiveField(16) this.isLPToken,
      @HiveField(17) this.isVerified})
      : _tokenProperties = tokenProperties,
        _aeip = aeip,
        _tokenCollection = tokenCollection;

  factory _$TokenInformationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokenInformationImplFromJson(json);

  @override
  @HiveField(0)
  final String? address;
  @override
  @HiveField(1)
  final String? name;
  @override
  @HiveField(3)
  final String? type;
  @override
  @HiveField(4)
  final String? symbol;
  @override
  @HiveField(9)
  final double? supply;
  @override
  @HiveField(10)
  final String? id;
  final Map<String, dynamic>? _tokenProperties;
  @override
  @HiveField(12)
  Map<String, dynamic>? get tokenProperties {
    final value = _tokenProperties;
    if (value == null) return null;
    if (_tokenProperties is EqualUnmodifiableMapView) return _tokenProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<int>? _aeip;
  @override
  @HiveField(13)
  List<int>? get aeip {
    final value = _aeip;
    if (value == null) return null;
    if (_aeip is EqualUnmodifiableListView) return _aeip;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _tokenCollection;
  @override
  @HiveField(14)
  List<Map<String, dynamic>>? get tokenCollection {
    final value = _tokenCollection;
    if (value == null) return null;
    if (_tokenCollection is EqualUnmodifiableListView) return _tokenCollection;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @HiveField(15)
  final int? decimals;
  @override
  @HiveField(16)
  final bool? isLPToken;
  @override
  @HiveField(17)
  final bool? isVerified;

  @override
  String toString() {
    return 'TokenInformation(address: $address, name: $name, type: $type, symbol: $symbol, supply: $supply, id: $id, tokenProperties: $tokenProperties, aeip: $aeip, tokenCollection: $tokenCollection, decimals: $decimals, isLPToken: $isLPToken, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokenInformationImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.supply, supply) || other.supply == supply) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._tokenProperties, _tokenProperties) &&
            const DeepCollectionEquality().equals(other._aeip, _aeip) &&
            const DeepCollectionEquality()
                .equals(other._tokenCollection, _tokenCollection) &&
            (identical(other.decimals, decimals) ||
                other.decimals == decimals) &&
            (identical(other.isLPToken, isLPToken) ||
                other.isLPToken == isLPToken) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      name,
      type,
      symbol,
      supply,
      id,
      const DeepCollectionEquality().hash(_tokenProperties),
      const DeepCollectionEquality().hash(_aeip),
      const DeepCollectionEquality().hash(_tokenCollection),
      decimals,
      isLPToken,
      isVerified);

  /// Create a copy of TokenInformation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TokenInformationImplCopyWith<_$TokenInformationImpl> get copyWith =>
      __$$TokenInformationImplCopyWithImpl<_$TokenInformationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokenInformationImplToJson(
      this,
    );
  }
}

abstract class _TokenInformation implements TokenInformation {
  const factory _TokenInformation(
      {@HiveField(0) final String? address,
      @HiveField(1) final String? name,
      @HiveField(3) final String? type,
      @HiveField(4) final String? symbol,
      @HiveField(9) final double? supply,
      @HiveField(10) final String? id,
      @HiveField(12) final Map<String, dynamic>? tokenProperties,
      @HiveField(13) final List<int>? aeip,
      @HiveField(14) final List<Map<String, dynamic>>? tokenCollection,
      @HiveField(15) final int? decimals,
      @HiveField(16) final bool? isLPToken,
      @HiveField(17) final bool? isVerified}) = _$TokenInformationImpl;

  factory _TokenInformation.fromJson(Map<String, dynamic> json) =
      _$TokenInformationImpl.fromJson;

  @override
  @HiveField(0)
  String? get address;
  @override
  @HiveField(1)
  String? get name;
  @override
  @HiveField(3)
  String? get type;
  @override
  @HiveField(4)
  String? get symbol;
  @override
  @HiveField(9)
  double? get supply;
  @override
  @HiveField(10)
  String? get id;
  @override
  @HiveField(12)
  Map<String, dynamic>? get tokenProperties;
  @override
  @HiveField(13)
  List<int>? get aeip;
  @override
  @HiveField(14)
  List<Map<String, dynamic>>? get tokenCollection;
  @override
  @HiveField(15)
  int? get decimals;
  @override
  @HiveField(16)
  bool? get isLPToken;
  @override
  @HiveField(17)
  bool? get isVerified;

  /// Create a copy of TokenInformation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TokenInformationImplCopyWith<_$TokenInformationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
