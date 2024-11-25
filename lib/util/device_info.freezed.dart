// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeviceInfoState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int version) android,
    required TResult Function() other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int version)? android,
    TResult? Function()? other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int version)? android,
    TResult Function()? other,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeviceInfoStateAndroid value) android,
    required TResult Function(_DeviceInfoStateOther value) other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeviceInfoStateAndroid value)? android,
    TResult? Function(_DeviceInfoStateOther value)? other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeviceInfoStateAndroid value)? android,
    TResult Function(_DeviceInfoStateOther value)? other,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoStateCopyWith<$Res> {
  factory $DeviceInfoStateCopyWith(
          DeviceInfoState value, $Res Function(DeviceInfoState) then) =
      _$DeviceInfoStateCopyWithImpl<$Res, DeviceInfoState>;
}

/// @nodoc
class _$DeviceInfoStateCopyWithImpl<$Res, $Val extends DeviceInfoState>
    implements $DeviceInfoStateCopyWith<$Res> {
  _$DeviceInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DeviceInfoStateAndroidImplCopyWith<$Res> {
  factory _$$DeviceInfoStateAndroidImplCopyWith(
          _$DeviceInfoStateAndroidImpl value,
          $Res Function(_$DeviceInfoStateAndroidImpl) then) =
      __$$DeviceInfoStateAndroidImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int version});
}

/// @nodoc
class __$$DeviceInfoStateAndroidImplCopyWithImpl<$Res>
    extends _$DeviceInfoStateCopyWithImpl<$Res, _$DeviceInfoStateAndroidImpl>
    implements _$$DeviceInfoStateAndroidImplCopyWith<$Res> {
  __$$DeviceInfoStateAndroidImplCopyWithImpl(
      _$DeviceInfoStateAndroidImpl _value,
      $Res Function(_$DeviceInfoStateAndroidImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
  }) {
    return _then(_$DeviceInfoStateAndroidImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DeviceInfoStateAndroidImpl extends _DeviceInfoStateAndroid {
  const _$DeviceInfoStateAndroidImpl({required this.version}) : super._();

  @override
  final int version;

  @override
  String toString() {
    return 'DeviceInfoState.android(version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoStateAndroidImpl &&
            (identical(other.version, version) || other.version == version));
  }

  @override
  int get hashCode => Object.hash(runtimeType, version);

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoStateAndroidImplCopyWith<_$DeviceInfoStateAndroidImpl>
      get copyWith => __$$DeviceInfoStateAndroidImplCopyWithImpl<
          _$DeviceInfoStateAndroidImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int version) android,
    required TResult Function() other,
  }) {
    return android(version);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int version)? android,
    TResult? Function()? other,
  }) {
    return android?.call(version);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int version)? android,
    TResult Function()? other,
    required TResult orElse(),
  }) {
    if (android != null) {
      return android(version);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeviceInfoStateAndroid value) android,
    required TResult Function(_DeviceInfoStateOther value) other,
  }) {
    return android(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeviceInfoStateAndroid value)? android,
    TResult? Function(_DeviceInfoStateOther value)? other,
  }) {
    return android?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeviceInfoStateAndroid value)? android,
    TResult Function(_DeviceInfoStateOther value)? other,
    required TResult orElse(),
  }) {
    if (android != null) {
      return android(this);
    }
    return orElse();
  }
}

abstract class _DeviceInfoStateAndroid extends DeviceInfoState {
  const factory _DeviceInfoStateAndroid({required final int version}) =
      _$DeviceInfoStateAndroidImpl;
  const _DeviceInfoStateAndroid._() : super._();

  int get version;

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeviceInfoStateAndroidImplCopyWith<_$DeviceInfoStateAndroidImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeviceInfoStateOtherImplCopyWith<$Res> {
  factory _$$DeviceInfoStateOtherImplCopyWith(_$DeviceInfoStateOtherImpl value,
          $Res Function(_$DeviceInfoStateOtherImpl) then) =
      __$$DeviceInfoStateOtherImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeviceInfoStateOtherImplCopyWithImpl<$Res>
    extends _$DeviceInfoStateCopyWithImpl<$Res, _$DeviceInfoStateOtherImpl>
    implements _$$DeviceInfoStateOtherImplCopyWith<$Res> {
  __$$DeviceInfoStateOtherImplCopyWithImpl(_$DeviceInfoStateOtherImpl _value,
      $Res Function(_$DeviceInfoStateOtherImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeviceInfoState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$DeviceInfoStateOtherImpl extends _DeviceInfoStateOther {
  const _$DeviceInfoStateOtherImpl() : super._();

  @override
  String toString() {
    return 'DeviceInfoState.other()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoStateOtherImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int version) android,
    required TResult Function() other,
  }) {
    return other();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int version)? android,
    TResult? Function()? other,
  }) {
    return other?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int version)? android,
    TResult Function()? other,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DeviceInfoStateAndroid value) android,
    required TResult Function(_DeviceInfoStateOther value) other,
  }) {
    return other(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DeviceInfoStateAndroid value)? android,
    TResult? Function(_DeviceInfoStateOther value)? other,
  }) {
    return other?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DeviceInfoStateAndroid value)? android,
    TResult Function(_DeviceInfoStateOther value)? other,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other(this);
    }
    return orElse();
  }
}

abstract class _DeviceInfoStateOther extends DeviceInfoState {
  const factory _DeviceInfoStateOther() = _$DeviceInfoStateOtherImpl;
  const _DeviceInfoStateOther._() : super._();
}
