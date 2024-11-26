// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Credentials {
  Uint8List get challenge => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String pin, Uint8List challenge) pin,
    required TResult Function(String password, Uint8List challenge) password,
    required TResult Function(String otp, Uint8List challenge) yubikey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pin, Uint8List challenge)? pin,
    TResult? Function(String password, Uint8List challenge)? password,
    TResult? Function(String otp, Uint8List challenge)? yubikey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pin, Uint8List challenge)? pin,
    TResult Function(String password, Uint8List challenge)? password,
    TResult Function(String otp, Uint8List challenge)? yubikey,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PinCredentials value) pin,
    required TResult Function(PasswordCredentials value) password,
    required TResult Function(YubikeyCredentials value) yubikey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PinCredentials value)? pin,
    TResult? Function(PasswordCredentials value)? password,
    TResult? Function(YubikeyCredentials value)? yubikey,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PinCredentials value)? pin,
    TResult Function(PasswordCredentials value)? password,
    TResult Function(YubikeyCredentials value)? yubikey,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CredentialsCopyWith<Credentials> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CredentialsCopyWith<$Res> {
  factory $CredentialsCopyWith(
          Credentials value, $Res Function(Credentials) then) =
      _$CredentialsCopyWithImpl<$Res, Credentials>;
  @useResult
  $Res call({Uint8List challenge});
}

/// @nodoc
class _$CredentialsCopyWithImpl<$Res, $Val extends Credentials>
    implements $CredentialsCopyWith<$Res> {
  _$CredentialsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? challenge = null,
  }) {
    return _then(_value.copyWith(
      challenge: null == challenge
          ? _value.challenge
          : challenge // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PinCredentialsImplCopyWith<$Res>
    implements $CredentialsCopyWith<$Res> {
  factory _$$PinCredentialsImplCopyWith(_$PinCredentialsImpl value,
          $Res Function(_$PinCredentialsImpl) then) =
      __$$PinCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pin, Uint8List challenge});
}

/// @nodoc
class __$$PinCredentialsImplCopyWithImpl<$Res>
    extends _$CredentialsCopyWithImpl<$Res, _$PinCredentialsImpl>
    implements _$$PinCredentialsImplCopyWith<$Res> {
  __$$PinCredentialsImplCopyWithImpl(
      _$PinCredentialsImpl _value, $Res Function(_$PinCredentialsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
    Object? challenge = null,
  }) {
    return _then(_$PinCredentialsImpl(
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      challenge: null == challenge
          ? _value.challenge
          : challenge // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$PinCredentialsImpl extends PinCredentials with DiagnosticableTreeMixin {
  const _$PinCredentialsImpl({required this.pin, required this.challenge})
      : super._();

  @override
  final String pin;
  @override
  final Uint8List challenge;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Credentials.pin(pin: $pin, challenge: $challenge)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Credentials.pin'))
      ..add(DiagnosticsProperty('pin', pin))
      ..add(DiagnosticsProperty('challenge', challenge));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinCredentialsImpl &&
            (identical(other.pin, pin) || other.pin == pin) &&
            const DeepCollectionEquality().equals(other.challenge, challenge));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, pin, const DeepCollectionEquality().hash(challenge));

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PinCredentialsImplCopyWith<_$PinCredentialsImpl> get copyWith =>
      __$$PinCredentialsImplCopyWithImpl<_$PinCredentialsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String pin, Uint8List challenge) pin,
    required TResult Function(String password, Uint8List challenge) password,
    required TResult Function(String otp, Uint8List challenge) yubikey,
  }) {
    return pin(this.pin, challenge);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pin, Uint8List challenge)? pin,
    TResult? Function(String password, Uint8List challenge)? password,
    TResult? Function(String otp, Uint8List challenge)? yubikey,
  }) {
    return pin?.call(this.pin, challenge);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pin, Uint8List challenge)? pin,
    TResult Function(String password, Uint8List challenge)? password,
    TResult Function(String otp, Uint8List challenge)? yubikey,
    required TResult orElse(),
  }) {
    if (pin != null) {
      return pin(this.pin, challenge);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PinCredentials value) pin,
    required TResult Function(PasswordCredentials value) password,
    required TResult Function(YubikeyCredentials value) yubikey,
  }) {
    return pin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PinCredentials value)? pin,
    TResult? Function(PasswordCredentials value)? password,
    TResult? Function(YubikeyCredentials value)? yubikey,
  }) {
    return pin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PinCredentials value)? pin,
    TResult Function(PasswordCredentials value)? password,
    TResult Function(YubikeyCredentials value)? yubikey,
    required TResult orElse(),
  }) {
    if (pin != null) {
      return pin(this);
    }
    return orElse();
  }
}

abstract class PinCredentials extends Credentials {
  const factory PinCredentials(
      {required final String pin,
      required final Uint8List challenge}) = _$PinCredentialsImpl;
  const PinCredentials._() : super._();

  String get pin;
  @override
  Uint8List get challenge;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PinCredentialsImplCopyWith<_$PinCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PasswordCredentialsImplCopyWith<$Res>
    implements $CredentialsCopyWith<$Res> {
  factory _$$PasswordCredentialsImplCopyWith(_$PasswordCredentialsImpl value,
          $Res Function(_$PasswordCredentialsImpl) then) =
      __$$PasswordCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String password, Uint8List challenge});
}

/// @nodoc
class __$$PasswordCredentialsImplCopyWithImpl<$Res>
    extends _$CredentialsCopyWithImpl<$Res, _$PasswordCredentialsImpl>
    implements _$$PasswordCredentialsImplCopyWith<$Res> {
  __$$PasswordCredentialsImplCopyWithImpl(_$PasswordCredentialsImpl _value,
      $Res Function(_$PasswordCredentialsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? challenge = null,
  }) {
    return _then(_$PasswordCredentialsImpl(
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      challenge: null == challenge
          ? _value.challenge
          : challenge // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$PasswordCredentialsImpl extends PasswordCredentials
    with DiagnosticableTreeMixin {
  const _$PasswordCredentialsImpl(
      {required this.password, required this.challenge})
      : super._();

  @override
  final String password;
  @override
  final Uint8List challenge;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Credentials.password(password: $password, challenge: $challenge)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Credentials.password'))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('challenge', challenge));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordCredentialsImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            const DeepCollectionEquality().equals(other.challenge, challenge));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, password, const DeepCollectionEquality().hash(challenge));

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordCredentialsImplCopyWith<_$PasswordCredentialsImpl> get copyWith =>
      __$$PasswordCredentialsImplCopyWithImpl<_$PasswordCredentialsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String pin, Uint8List challenge) pin,
    required TResult Function(String password, Uint8List challenge) password,
    required TResult Function(String otp, Uint8List challenge) yubikey,
  }) {
    return password(this.password, challenge);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pin, Uint8List challenge)? pin,
    TResult? Function(String password, Uint8List challenge)? password,
    TResult? Function(String otp, Uint8List challenge)? yubikey,
  }) {
    return password?.call(this.password, challenge);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pin, Uint8List challenge)? pin,
    TResult Function(String password, Uint8List challenge)? password,
    TResult Function(String otp, Uint8List challenge)? yubikey,
    required TResult orElse(),
  }) {
    if (password != null) {
      return password(this.password, challenge);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PinCredentials value) pin,
    required TResult Function(PasswordCredentials value) password,
    required TResult Function(YubikeyCredentials value) yubikey,
  }) {
    return password(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PinCredentials value)? pin,
    TResult? Function(PasswordCredentials value)? password,
    TResult? Function(YubikeyCredentials value)? yubikey,
  }) {
    return password?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PinCredentials value)? pin,
    TResult Function(PasswordCredentials value)? password,
    TResult Function(YubikeyCredentials value)? yubikey,
    required TResult orElse(),
  }) {
    if (password != null) {
      return password(this);
    }
    return orElse();
  }
}

abstract class PasswordCredentials extends Credentials {
  const factory PasswordCredentials(
      {required final String password,
      required final Uint8List challenge}) = _$PasswordCredentialsImpl;
  const PasswordCredentials._() : super._();

  String get password;
  @override
  Uint8List get challenge;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordCredentialsImplCopyWith<_$PasswordCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$YubikeyCredentialsImplCopyWith<$Res>
    implements $CredentialsCopyWith<$Res> {
  factory _$$YubikeyCredentialsImplCopyWith(_$YubikeyCredentialsImpl value,
          $Res Function(_$YubikeyCredentialsImpl) then) =
      __$$YubikeyCredentialsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String otp, Uint8List challenge});
}

/// @nodoc
class __$$YubikeyCredentialsImplCopyWithImpl<$Res>
    extends _$CredentialsCopyWithImpl<$Res, _$YubikeyCredentialsImpl>
    implements _$$YubikeyCredentialsImplCopyWith<$Res> {
  __$$YubikeyCredentialsImplCopyWithImpl(_$YubikeyCredentialsImpl _value,
      $Res Function(_$YubikeyCredentialsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otp = null,
    Object? challenge = null,
  }) {
    return _then(_$YubikeyCredentialsImpl(
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
      challenge: null == challenge
          ? _value.challenge
          : challenge // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$YubikeyCredentialsImpl extends YubikeyCredentials
    with DiagnosticableTreeMixin {
  const _$YubikeyCredentialsImpl({required this.otp, required this.challenge})
      : super._();

  @override
  final String otp;
  @override
  final Uint8List challenge;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Credentials.yubikey(otp: $otp, challenge: $challenge)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Credentials.yubikey'))
      ..add(DiagnosticsProperty('otp', otp))
      ..add(DiagnosticsProperty('challenge', challenge));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YubikeyCredentialsImpl &&
            (identical(other.otp, otp) || other.otp == otp) &&
            const DeepCollectionEquality().equals(other.challenge, challenge));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, otp, const DeepCollectionEquality().hash(challenge));

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YubikeyCredentialsImplCopyWith<_$YubikeyCredentialsImpl> get copyWith =>
      __$$YubikeyCredentialsImplCopyWithImpl<_$YubikeyCredentialsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String pin, Uint8List challenge) pin,
    required TResult Function(String password, Uint8List challenge) password,
    required TResult Function(String otp, Uint8List challenge) yubikey,
  }) {
    return yubikey(otp, challenge);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String pin, Uint8List challenge)? pin,
    TResult? Function(String password, Uint8List challenge)? password,
    TResult? Function(String otp, Uint8List challenge)? yubikey,
  }) {
    return yubikey?.call(otp, challenge);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String pin, Uint8List challenge)? pin,
    TResult Function(String password, Uint8List challenge)? password,
    TResult Function(String otp, Uint8List challenge)? yubikey,
    required TResult orElse(),
  }) {
    if (yubikey != null) {
      return yubikey(otp, challenge);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PinCredentials value) pin,
    required TResult Function(PasswordCredentials value) password,
    required TResult Function(YubikeyCredentials value) yubikey,
  }) {
    return yubikey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PinCredentials value)? pin,
    TResult? Function(PasswordCredentials value)? password,
    TResult? Function(YubikeyCredentials value)? yubikey,
  }) {
    return yubikey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PinCredentials value)? pin,
    TResult Function(PasswordCredentials value)? password,
    TResult Function(YubikeyCredentials value)? yubikey,
    required TResult orElse(),
  }) {
    if (yubikey != null) {
      return yubikey(this);
    }
    return orElse();
  }
}

abstract class YubikeyCredentials extends Credentials {
  const factory YubikeyCredentials(
      {required final String otp,
      required final Uint8List challenge}) = _$YubikeyCredentialsImpl;
  const YubikeyCredentials._() : super._();

  String get otp;
  @override
  Uint8List get challenge;

  /// Create a copy of Credentials
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YubikeyCredentialsImplCopyWith<_$YubikeyCredentialsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthenticationSettings {
  AuthMethod get authenticationMethod => throw _privateConstructorUsedError;
  bool get pinPadShuffle => throw _privateConstructorUsedError;
  LockTimeoutOption get lockTimeout => throw _privateConstructorUsedError;
  PrivacyMaskOption get privacyMask => throw _privateConstructorUsedError;

  /// Create a copy of AuthenticationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthenticationSettingsCopyWith<AuthenticationSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationSettingsCopyWith<$Res> {
  factory $AuthenticationSettingsCopyWith(AuthenticationSettings value,
          $Res Function(AuthenticationSettings) then) =
      _$AuthenticationSettingsCopyWithImpl<$Res, AuthenticationSettings>;
  @useResult
  $Res call(
      {AuthMethod authenticationMethod,
      bool pinPadShuffle,
      LockTimeoutOption lockTimeout,
      PrivacyMaskOption privacyMask});
}

/// @nodoc
class _$AuthenticationSettingsCopyWithImpl<$Res,
        $Val extends AuthenticationSettings>
    implements $AuthenticationSettingsCopyWith<$Res> {
  _$AuthenticationSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthenticationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authenticationMethod = null,
    Object? pinPadShuffle = null,
    Object? lockTimeout = null,
    Object? privacyMask = null,
  }) {
    return _then(_value.copyWith(
      authenticationMethod: null == authenticationMethod
          ? _value.authenticationMethod
          : authenticationMethod // ignore: cast_nullable_to_non_nullable
              as AuthMethod,
      pinPadShuffle: null == pinPadShuffle
          ? _value.pinPadShuffle
          : pinPadShuffle // ignore: cast_nullable_to_non_nullable
              as bool,
      lockTimeout: null == lockTimeout
          ? _value.lockTimeout
          : lockTimeout // ignore: cast_nullable_to_non_nullable
              as LockTimeoutOption,
      privacyMask: null == privacyMask
          ? _value.privacyMask
          : privacyMask // ignore: cast_nullable_to_non_nullable
              as PrivacyMaskOption,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthenticationSettingsImplCopyWith<$Res>
    implements $AuthenticationSettingsCopyWith<$Res> {
  factory _$$AuthenticationSettingsImplCopyWith(
          _$AuthenticationSettingsImpl value,
          $Res Function(_$AuthenticationSettingsImpl) then) =
      __$$AuthenticationSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthMethod authenticationMethod,
      bool pinPadShuffle,
      LockTimeoutOption lockTimeout,
      PrivacyMaskOption privacyMask});
}

/// @nodoc
class __$$AuthenticationSettingsImplCopyWithImpl<$Res>
    extends _$AuthenticationSettingsCopyWithImpl<$Res,
        _$AuthenticationSettingsImpl>
    implements _$$AuthenticationSettingsImplCopyWith<$Res> {
  __$$AuthenticationSettingsImplCopyWithImpl(
      _$AuthenticationSettingsImpl _value,
      $Res Function(_$AuthenticationSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthenticationSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authenticationMethod = null,
    Object? pinPadShuffle = null,
    Object? lockTimeout = null,
    Object? privacyMask = null,
  }) {
    return _then(_$AuthenticationSettingsImpl(
      authenticationMethod: null == authenticationMethod
          ? _value.authenticationMethod
          : authenticationMethod // ignore: cast_nullable_to_non_nullable
              as AuthMethod,
      pinPadShuffle: null == pinPadShuffle
          ? _value.pinPadShuffle
          : pinPadShuffle // ignore: cast_nullable_to_non_nullable
              as bool,
      lockTimeout: null == lockTimeout
          ? _value.lockTimeout
          : lockTimeout // ignore: cast_nullable_to_non_nullable
              as LockTimeoutOption,
      privacyMask: null == privacyMask
          ? _value.privacyMask
          : privacyMask // ignore: cast_nullable_to_non_nullable
              as PrivacyMaskOption,
    ));
  }
}

/// @nodoc

class _$AuthenticationSettingsImpl extends _AuthenticationSettings
    with DiagnosticableTreeMixin {
  const _$AuthenticationSettingsImpl(
      {required this.authenticationMethod,
      required this.pinPadShuffle,
      required this.lockTimeout,
      required this.privacyMask})
      : super._();

  @override
  final AuthMethod authenticationMethod;
  @override
  final bool pinPadShuffle;
  @override
  final LockTimeoutOption lockTimeout;
  @override
  final PrivacyMaskOption privacyMask;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AuthenticationSettings(authenticationMethod: $authenticationMethod, pinPadShuffle: $pinPadShuffle, lockTimeout: $lockTimeout, privacyMask: $privacyMask)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AuthenticationSettings'))
      ..add(DiagnosticsProperty('authenticationMethod', authenticationMethod))
      ..add(DiagnosticsProperty('pinPadShuffle', pinPadShuffle))
      ..add(DiagnosticsProperty('lockTimeout', lockTimeout))
      ..add(DiagnosticsProperty('privacyMask', privacyMask));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationSettingsImpl &&
            (identical(other.authenticationMethod, authenticationMethod) ||
                other.authenticationMethod == authenticationMethod) &&
            (identical(other.pinPadShuffle, pinPadShuffle) ||
                other.pinPadShuffle == pinPadShuffle) &&
            (identical(other.lockTimeout, lockTimeout) ||
                other.lockTimeout == lockTimeout) &&
            (identical(other.privacyMask, privacyMask) ||
                other.privacyMask == privacyMask));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authenticationMethod,
      pinPadShuffle, lockTimeout, privacyMask);

  /// Create a copy of AuthenticationSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationSettingsImplCopyWith<_$AuthenticationSettingsImpl>
      get copyWith => __$$AuthenticationSettingsImplCopyWithImpl<
          _$AuthenticationSettingsImpl>(this, _$identity);
}

abstract class _AuthenticationSettings extends AuthenticationSettings {
  const factory _AuthenticationSettings(
          {required final AuthMethod authenticationMethod,
          required final bool pinPadShuffle,
          required final LockTimeoutOption lockTimeout,
          required final PrivacyMaskOption privacyMask}) =
      _$AuthenticationSettingsImpl;
  const _AuthenticationSettings._() : super._();

  @override
  AuthMethod get authenticationMethod;
  @override
  bool get pinPadShuffle;
  @override
  LockTimeoutOption get lockTimeout;
  @override
  PrivacyMaskOption get privacyMask;

  /// Create a copy of AuthenticationSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticationSettingsImplCopyWith<_$AuthenticationSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$YubikeyOTPSettings {
  String get clientId => throw _privateConstructorUsedError;
  String get clientApiKey => throw _privateConstructorUsedError;

  /// Create a copy of YubikeyOTPSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YubikeyOTPSettingsCopyWith<YubikeyOTPSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YubikeyOTPSettingsCopyWith<$Res> {
  factory $YubikeyOTPSettingsCopyWith(
          YubikeyOTPSettings value, $Res Function(YubikeyOTPSettings) then) =
      _$YubikeyOTPSettingsCopyWithImpl<$Res, YubikeyOTPSettings>;
  @useResult
  $Res call({String clientId, String clientApiKey});
}

/// @nodoc
class _$YubikeyOTPSettingsCopyWithImpl<$Res, $Val extends YubikeyOTPSettings>
    implements $YubikeyOTPSettingsCopyWith<$Res> {
  _$YubikeyOTPSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YubikeyOTPSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? clientApiKey = null,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientApiKey: null == clientApiKey
          ? _value.clientApiKey
          : clientApiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$YubikeyOTPSettingsImplCopyWith<$Res>
    implements $YubikeyOTPSettingsCopyWith<$Res> {
  factory _$$YubikeyOTPSettingsImplCopyWith(_$YubikeyOTPSettingsImpl value,
          $Res Function(_$YubikeyOTPSettingsImpl) then) =
      __$$YubikeyOTPSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String clientId, String clientApiKey});
}

/// @nodoc
class __$$YubikeyOTPSettingsImplCopyWithImpl<$Res>
    extends _$YubikeyOTPSettingsCopyWithImpl<$Res, _$YubikeyOTPSettingsImpl>
    implements _$$YubikeyOTPSettingsImplCopyWith<$Res> {
  __$$YubikeyOTPSettingsImplCopyWithImpl(_$YubikeyOTPSettingsImpl _value,
      $Res Function(_$YubikeyOTPSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of YubikeyOTPSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? clientApiKey = null,
  }) {
    return _then(_$YubikeyOTPSettingsImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      clientApiKey: null == clientApiKey
          ? _value.clientApiKey
          : clientApiKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$YubikeyOTPSettingsImpl extends _YubikeyOTPSettings
    with DiagnosticableTreeMixin {
  const _$YubikeyOTPSettingsImpl(
      {required this.clientId, required this.clientApiKey})
      : super._();

  @override
  final String clientId;
  @override
  final String clientApiKey;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'YubikeyOTPSettings(clientId: $clientId, clientApiKey: $clientApiKey)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'YubikeyOTPSettings'))
      ..add(DiagnosticsProperty('clientId', clientId))
      ..add(DiagnosticsProperty('clientApiKey', clientApiKey));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YubikeyOTPSettingsImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.clientApiKey, clientApiKey) ||
                other.clientApiKey == clientApiKey));
  }

  @override
  int get hashCode => Object.hash(runtimeType, clientId, clientApiKey);

  /// Create a copy of YubikeyOTPSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YubikeyOTPSettingsImplCopyWith<_$YubikeyOTPSettingsImpl> get copyWith =>
      __$$YubikeyOTPSettingsImplCopyWithImpl<_$YubikeyOTPSettingsImpl>(
          this, _$identity);
}

abstract class _YubikeyOTPSettings extends YubikeyOTPSettings {
  const factory _YubikeyOTPSettings(
      {required final String clientId,
      required final String clientApiKey}) = _$YubikeyOTPSettingsImpl;
  const _YubikeyOTPSettings._() : super._();

  @override
  String get clientId;
  @override
  String get clientApiKey;

  /// Create a copy of YubikeyOTPSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YubikeyOTPSettingsImplCopyWith<_$YubikeyOTPSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
