// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddCustomTokenFormState {
  String get tokenAddress => throw _privateConstructorUsedError;
  String get errorText => throw _privateConstructorUsedError;
  AEToken? get token => throw _privateConstructorUsedError;
  double get userTokenBalance => throw _privateConstructorUsedError;

  /// Create a copy of AddCustomTokenFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddCustomTokenFormStateCopyWith<AddCustomTokenFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddCustomTokenFormStateCopyWith<$Res> {
  factory $AddCustomTokenFormStateCopyWith(AddCustomTokenFormState value,
          $Res Function(AddCustomTokenFormState) then) =
      _$AddCustomTokenFormStateCopyWithImpl<$Res, AddCustomTokenFormState>;
  @useResult
  $Res call(
      {String tokenAddress,
      String errorText,
      AEToken? token,
      double userTokenBalance});

  $AETokenCopyWith<$Res>? get token;
}

/// @nodoc
class _$AddCustomTokenFormStateCopyWithImpl<$Res,
        $Val extends AddCustomTokenFormState>
    implements $AddCustomTokenFormStateCopyWith<$Res> {
  _$AddCustomTokenFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddCustomTokenFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenAddress = null,
    Object? errorText = null,
    Object? token = freezed,
    Object? userTokenBalance = null,
  }) {
    return _then(_value.copyWith(
      tokenAddress: null == tokenAddress
          ? _value.tokenAddress
          : tokenAddress // ignore: cast_nullable_to_non_nullable
              as String,
      errorText: null == errorText
          ? _value.errorText
          : errorText // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as AEToken?,
      userTokenBalance: null == userTokenBalance
          ? _value.userTokenBalance
          : userTokenBalance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of AddCustomTokenFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AETokenCopyWith<$Res>? get token {
    if (_value.token == null) {
      return null;
    }

    return $AETokenCopyWith<$Res>(_value.token!, (value) {
      return _then(_value.copyWith(token: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddCustomTokenFormStateImplCopyWith<$Res>
    implements $AddCustomTokenFormStateCopyWith<$Res> {
  factory _$$AddCustomTokenFormStateImplCopyWith(
          _$AddCustomTokenFormStateImpl value,
          $Res Function(_$AddCustomTokenFormStateImpl) then) =
      __$$AddCustomTokenFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tokenAddress,
      String errorText,
      AEToken? token,
      double userTokenBalance});

  @override
  $AETokenCopyWith<$Res>? get token;
}

/// @nodoc
class __$$AddCustomTokenFormStateImplCopyWithImpl<$Res>
    extends _$AddCustomTokenFormStateCopyWithImpl<$Res,
        _$AddCustomTokenFormStateImpl>
    implements _$$AddCustomTokenFormStateImplCopyWith<$Res> {
  __$$AddCustomTokenFormStateImplCopyWithImpl(
      _$AddCustomTokenFormStateImpl _value,
      $Res Function(_$AddCustomTokenFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddCustomTokenFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tokenAddress = null,
    Object? errorText = null,
    Object? token = freezed,
    Object? userTokenBalance = null,
  }) {
    return _then(_$AddCustomTokenFormStateImpl(
      tokenAddress: null == tokenAddress
          ? _value.tokenAddress
          : tokenAddress // ignore: cast_nullable_to_non_nullable
              as String,
      errorText: null == errorText
          ? _value.errorText
          : errorText // ignore: cast_nullable_to_non_nullable
              as String,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as AEToken?,
      userTokenBalance: null == userTokenBalance
          ? _value.userTokenBalance
          : userTokenBalance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$AddCustomTokenFormStateImpl extends _AddCustomTokenFormState {
  const _$AddCustomTokenFormStateImpl(
      {this.tokenAddress = '',
      this.errorText = '',
      this.token,
      this.userTokenBalance = 0})
      : super._();

  @override
  @JsonKey()
  final String tokenAddress;
  @override
  @JsonKey()
  final String errorText;
  @override
  final AEToken? token;
  @override
  @JsonKey()
  final double userTokenBalance;

  @override
  String toString() {
    return 'AddCustomTokenFormState(tokenAddress: $tokenAddress, errorText: $errorText, token: $token, userTokenBalance: $userTokenBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddCustomTokenFormStateImpl &&
            (identical(other.tokenAddress, tokenAddress) ||
                other.tokenAddress == tokenAddress) &&
            (identical(other.errorText, errorText) ||
                other.errorText == errorText) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.userTokenBalance, userTokenBalance) ||
                other.userTokenBalance == userTokenBalance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, tokenAddress, errorText, token, userTokenBalance);

  /// Create a copy of AddCustomTokenFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddCustomTokenFormStateImplCopyWith<_$AddCustomTokenFormStateImpl>
      get copyWith => __$$AddCustomTokenFormStateImplCopyWithImpl<
          _$AddCustomTokenFormStateImpl>(this, _$identity);
}

abstract class _AddCustomTokenFormState extends AddCustomTokenFormState {
  const factory _AddCustomTokenFormState(
      {final String tokenAddress,
      final String errorText,
      final AEToken? token,
      final double userTokenBalance}) = _$AddCustomTokenFormStateImpl;
  const _AddCustomTokenFormState._() : super._();

  @override
  String get tokenAddress;
  @override
  String get errorText;
  @override
  AEToken? get token;
  @override
  double get userTokenBalance;

  /// Create a copy of AddCustomTokenFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddCustomTokenFormStateImplCopyWith<_$AddCustomTokenFormStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
