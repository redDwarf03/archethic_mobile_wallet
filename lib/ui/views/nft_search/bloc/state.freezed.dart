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
mixin _$NftSearchBarFormState {
  String get searchCriteria => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  TokenInformation? get tokenInformation => throw _privateConstructorUsedError;

  /// Create a copy of NftSearchBarFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NftSearchBarFormStateCopyWith<NftSearchBarFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NftSearchBarFormStateCopyWith<$Res> {
  factory $NftSearchBarFormStateCopyWith(NftSearchBarFormState value,
          $Res Function(NftSearchBarFormState) then) =
      _$NftSearchBarFormStateCopyWithImpl<$Res, NftSearchBarFormState>;
  @useResult
  $Res call(
      {String searchCriteria,
      bool loading,
      String error,
      TokenInformation? tokenInformation});

  $TokenInformationCopyWith<$Res>? get tokenInformation;
}

/// @nodoc
class _$NftSearchBarFormStateCopyWithImpl<$Res,
        $Val extends NftSearchBarFormState>
    implements $NftSearchBarFormStateCopyWith<$Res> {
  _$NftSearchBarFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NftSearchBarFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchCriteria = null,
    Object? loading = null,
    Object? error = null,
    Object? tokenInformation = freezed,
  }) {
    return _then(_value.copyWith(
      searchCriteria: null == searchCriteria
          ? _value.searchCriteria
          : searchCriteria // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      tokenInformation: freezed == tokenInformation
          ? _value.tokenInformation
          : tokenInformation // ignore: cast_nullable_to_non_nullable
              as TokenInformation?,
    ) as $Val);
  }

  /// Create a copy of NftSearchBarFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInformationCopyWith<$Res>? get tokenInformation {
    if (_value.tokenInformation == null) {
      return null;
    }

    return $TokenInformationCopyWith<$Res>(_value.tokenInformation!, (value) {
      return _then(_value.copyWith(tokenInformation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NftSearchBarFormStateImplCopyWith<$Res>
    implements $NftSearchBarFormStateCopyWith<$Res> {
  factory _$$NftSearchBarFormStateImplCopyWith(
          _$NftSearchBarFormStateImpl value,
          $Res Function(_$NftSearchBarFormStateImpl) then) =
      __$$NftSearchBarFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchCriteria,
      bool loading,
      String error,
      TokenInformation? tokenInformation});

  @override
  $TokenInformationCopyWith<$Res>? get tokenInformation;
}

/// @nodoc
class __$$NftSearchBarFormStateImplCopyWithImpl<$Res>
    extends _$NftSearchBarFormStateCopyWithImpl<$Res,
        _$NftSearchBarFormStateImpl>
    implements _$$NftSearchBarFormStateImplCopyWith<$Res> {
  __$$NftSearchBarFormStateImplCopyWithImpl(_$NftSearchBarFormStateImpl _value,
      $Res Function(_$NftSearchBarFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NftSearchBarFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchCriteria = null,
    Object? loading = null,
    Object? error = null,
    Object? tokenInformation = freezed,
  }) {
    return _then(_$NftSearchBarFormStateImpl(
      searchCriteria: null == searchCriteria
          ? _value.searchCriteria
          : searchCriteria // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      tokenInformation: freezed == tokenInformation
          ? _value.tokenInformation
          : tokenInformation // ignore: cast_nullable_to_non_nullable
              as TokenInformation?,
    ));
  }
}

/// @nodoc

class _$NftSearchBarFormStateImpl extends _NftSearchBarFormState {
  const _$NftSearchBarFormStateImpl(
      {this.searchCriteria = '',
      this.loading = false,
      this.error = '',
      this.tokenInformation})
      : super._();

  @override
  @JsonKey()
  final String searchCriteria;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final String error;
  @override
  final TokenInformation? tokenInformation;

  @override
  String toString() {
    return 'NftSearchBarFormState(searchCriteria: $searchCriteria, loading: $loading, error: $error, tokenInformation: $tokenInformation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NftSearchBarFormStateImpl &&
            (identical(other.searchCriteria, searchCriteria) ||
                other.searchCriteria == searchCriteria) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.tokenInformation, tokenInformation) ||
                other.tokenInformation == tokenInformation));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, searchCriteria, loading, error, tokenInformation);

  /// Create a copy of NftSearchBarFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NftSearchBarFormStateImplCopyWith<_$NftSearchBarFormStateImpl>
      get copyWith => __$$NftSearchBarFormStateImplCopyWithImpl<
          _$NftSearchBarFormStateImpl>(this, _$identity);
}

abstract class _NftSearchBarFormState extends NftSearchBarFormState {
  const factory _NftSearchBarFormState(
      {final String searchCriteria,
      final bool loading,
      final String error,
      final TokenInformation? tokenInformation}) = _$NftSearchBarFormStateImpl;
  const _NftSearchBarFormState._() : super._();

  @override
  String get searchCriteria;
  @override
  bool get loading;
  @override
  String get error;
  @override
  TokenInformation? get tokenInformation;

  /// Create a copy of NftSearchBarFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NftSearchBarFormStateImplCopyWith<_$NftSearchBarFormStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
