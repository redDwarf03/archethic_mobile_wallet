// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DecryptPayloadsConfirmationFormState {
  RPCCommand<DecryptPayloadRequest> get decryptTransactionCommand =>
      throw _privateConstructorUsedError;

  /// Create a copy of DecryptPayloadsConfirmationFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DecryptPayloadsConfirmationFormStateCopyWith<
          DecryptPayloadsConfirmationFormState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DecryptPayloadsConfirmationFormStateCopyWith<$Res> {
  factory $DecryptPayloadsConfirmationFormStateCopyWith(
          DecryptPayloadsConfirmationFormState value,
          $Res Function(DecryptPayloadsConfirmationFormState) then) =
      _$DecryptPayloadsConfirmationFormStateCopyWithImpl<$Res,
          DecryptPayloadsConfirmationFormState>;
  @useResult
  $Res call({RPCCommand<DecryptPayloadRequest> decryptTransactionCommand});

  $RPCCommandCopyWith<DecryptPayloadRequest, $Res>
      get decryptTransactionCommand;
}

/// @nodoc
class _$DecryptPayloadsConfirmationFormStateCopyWithImpl<$Res,
        $Val extends DecryptPayloadsConfirmationFormState>
    implements $DecryptPayloadsConfirmationFormStateCopyWith<$Res> {
  _$DecryptPayloadsConfirmationFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DecryptPayloadsConfirmationFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decryptTransactionCommand = null,
  }) {
    return _then(_value.copyWith(
      decryptTransactionCommand: null == decryptTransactionCommand
          ? _value.decryptTransactionCommand
          : decryptTransactionCommand // ignore: cast_nullable_to_non_nullable
              as RPCCommand<DecryptPayloadRequest>,
    ) as $Val);
  }

  /// Create a copy of DecryptPayloadsConfirmationFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RPCCommandCopyWith<DecryptPayloadRequest, $Res>
      get decryptTransactionCommand {
    return $RPCCommandCopyWith<DecryptPayloadRequest, $Res>(
        _value.decryptTransactionCommand, (value) {
      return _then(_value.copyWith(decryptTransactionCommand: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DecryptPayloadsConfirmationFormStateImplCopyWith<$Res>
    implements $DecryptPayloadsConfirmationFormStateCopyWith<$Res> {
  factory _$$DecryptPayloadsConfirmationFormStateImplCopyWith(
          _$DecryptPayloadsConfirmationFormStateImpl value,
          $Res Function(_$DecryptPayloadsConfirmationFormStateImpl) then) =
      __$$DecryptPayloadsConfirmationFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RPCCommand<DecryptPayloadRequest> decryptTransactionCommand});

  @override
  $RPCCommandCopyWith<DecryptPayloadRequest, $Res>
      get decryptTransactionCommand;
}

/// @nodoc
class __$$DecryptPayloadsConfirmationFormStateImplCopyWithImpl<$Res>
    extends _$DecryptPayloadsConfirmationFormStateCopyWithImpl<$Res,
        _$DecryptPayloadsConfirmationFormStateImpl>
    implements _$$DecryptPayloadsConfirmationFormStateImplCopyWith<$Res> {
  __$$DecryptPayloadsConfirmationFormStateImplCopyWithImpl(
      _$DecryptPayloadsConfirmationFormStateImpl _value,
      $Res Function(_$DecryptPayloadsConfirmationFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of DecryptPayloadsConfirmationFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? decryptTransactionCommand = null,
  }) {
    return _then(_$DecryptPayloadsConfirmationFormStateImpl(
      decryptTransactionCommand: null == decryptTransactionCommand
          ? _value.decryptTransactionCommand
          : decryptTransactionCommand // ignore: cast_nullable_to_non_nullable
              as RPCCommand<DecryptPayloadRequest>,
    ));
  }
}

/// @nodoc

class _$DecryptPayloadsConfirmationFormStateImpl
    extends _DecryptPayloadsConfirmationFormState {
  const _$DecryptPayloadsConfirmationFormStateImpl(
      {required this.decryptTransactionCommand})
      : super._();

  @override
  final RPCCommand<DecryptPayloadRequest> decryptTransactionCommand;

  @override
  String toString() {
    return 'DecryptPayloadsConfirmationFormState(decryptTransactionCommand: $decryptTransactionCommand)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DecryptPayloadsConfirmationFormStateImpl &&
            (identical(other.decryptTransactionCommand,
                    decryptTransactionCommand) ||
                other.decryptTransactionCommand == decryptTransactionCommand));
  }

  @override
  int get hashCode => Object.hash(runtimeType, decryptTransactionCommand);

  /// Create a copy of DecryptPayloadsConfirmationFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DecryptPayloadsConfirmationFormStateImplCopyWith<
          _$DecryptPayloadsConfirmationFormStateImpl>
      get copyWith => __$$DecryptPayloadsConfirmationFormStateImplCopyWithImpl<
          _$DecryptPayloadsConfirmationFormStateImpl>(this, _$identity);
}

abstract class _DecryptPayloadsConfirmationFormState
    extends DecryptPayloadsConfirmationFormState {
  const factory _DecryptPayloadsConfirmationFormState(
          {required final RPCCommand<DecryptPayloadRequest>
              decryptTransactionCommand}) =
      _$DecryptPayloadsConfirmationFormStateImpl;
  const _DecryptPayloadsConfirmationFormState._() : super._();

  @override
  RPCCommand<DecryptPayloadRequest> get decryptTransactionCommand;

  /// Create a copy of DecryptPayloadsConfirmationFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DecryptPayloadsConfirmationFormStateImplCopyWith<
          _$DecryptPayloadsConfirmationFormStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
