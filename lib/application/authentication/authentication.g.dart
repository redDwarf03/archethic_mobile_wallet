// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authenticationRepositoryHash() =>
    r'b630377593d057ef93c30f51effb5524980151b1';

/// See also [_authenticationRepository].
@ProviderFor(_authenticationRepository)
final _authenticationRepositoryProvider =
    Provider<AuthenticationRepositoryInterface>.internal(
  _authenticationRepository,
  name: r'_authenticationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authenticationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _AuthenticationRepositoryRef
    = ProviderRef<AuthenticationRepositoryInterface>;
String _$isLockCountdownRunningHash() =>
    r'163c697c12971cf530cd89420c054b1408c2314f';

/// See also [_isLockCountdownRunning].
@ProviderFor(_isLockCountdownRunning)
final _isLockCountdownRunningProvider = FutureProvider<bool>.internal(
  _isLockCountdownRunning,
  name: r'_isLockCountdownRunningProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLockCountdownRunningHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _IsLockCountdownRunningRef = FutureProviderRef<bool>;
String _$lockCountdownHash() => r'd68cdb54ca24255c83a97738a64b623887a940cf';

/// See also [_lockCountdown].
@ProviderFor(_lockCountdown)
final _lockCountdownProvider = StreamProvider<Duration>.internal(
  _lockCountdown,
  name: r'_lockCountdownProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lockCountdownHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _LockCountdownRef = StreamProviderRef<Duration>;
String _$vaultLockedHash() => r'874d9cd95389e04cda4578dfbf1889615c135ce0';

/// See also [_vaultLocked].
@ProviderFor(_vaultLocked)
final _vaultLockedProvider = Provider<bool>.internal(
  _vaultLocked,
  name: r'_vaultLockedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$vaultLockedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _VaultLockedRef = ProviderRef<bool>;
String _$lockDateHash() => r'80287a1f5d08aa1f8d17ed20d7536488898589fc';

/// See also [_lockDate].
@ProviderFor(_lockDate)
final _lockDateProvider = FutureProvider<DateTime?>.internal(
  _lockDate,
  name: r'_lockDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lockDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _LockDateRef = FutureProviderRef<DateTime?>;
String _$lastInteractionDateNotifierHash() =>
    r'fdd8f1f1e47205aaf7128fa16ff9045fb92af836';

/// See also [_LastInteractionDateNotifier].
@ProviderFor(_LastInteractionDateNotifier)
final _lastInteractionDateNotifierProvider = AsyncNotifierProvider<
    _LastInteractionDateNotifier, LastInteractionDateValue>.internal(
  _LastInteractionDateNotifier.new,
  name: r'_lastInteractionDateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastInteractionDateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastInteractionDateNotifier = AsyncNotifier<LastInteractionDateValue>;
String _$authenticationGuardNotifierHash() =>
    r'1198a3dff12d8a30e78ab82ea2387c83b212a099';

/// See also [_AuthenticationGuardNotifier].
@ProviderFor(_AuthenticationGuardNotifier)
final _authenticationGuardNotifierProvider = AsyncNotifierProvider<
    _AuthenticationGuardNotifier, AuthenticationGuardState>.internal(
  _AuthenticationGuardNotifier.new,
  name: r'_authenticationGuardNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authenticationGuardNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthenticationGuardNotifier = AsyncNotifier<AuthenticationGuardState>;
String _$passwordAuthenticationNotifierHash() =>
    r'd2ffeb5265f757c02c49978b72c30d9fdfcbbeaf';

/// See also [_PasswordAuthenticationNotifier].
@ProviderFor(_PasswordAuthenticationNotifier)
final _passwordAuthenticationNotifierProvider =
    AutoDisposeAsyncNotifierProvider<_PasswordAuthenticationNotifier,
        PasswordAuthenticationState>.internal(
  _PasswordAuthenticationNotifier.new,
  name: r'_passwordAuthenticationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$passwordAuthenticationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PasswordAuthenticationNotifier
    = AutoDisposeAsyncNotifier<PasswordAuthenticationState>;
String _$pinAuthenticationNotifierHash() =>
    r'8e48abf3e4d6e928e6879133540c27a2b0695f9d';

/// See also [_PinAuthenticationNotifier].
@ProviderFor(_PinAuthenticationNotifier)
final _pinAuthenticationNotifierProvider = AutoDisposeAsyncNotifierProvider<
    _PinAuthenticationNotifier, PinAuthenticationState>.internal(
  _PinAuthenticationNotifier.new,
  name: r'_pinAuthenticationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinAuthenticationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinAuthenticationNotifier
    = AutoDisposeAsyncNotifier<PinAuthenticationState>;
String _$authenticationSettingsNotifierHash() =>
    r'9600bc25df6d98026447385e1cf6fc8fb56eb3df';

/// See also [_AuthenticationSettingsNotifier].
@ProviderFor(_AuthenticationSettingsNotifier)
final _authenticationSettingsNotifierProvider = NotifierProvider<
    _AuthenticationSettingsNotifier, AuthenticationSettings>.internal(
  _AuthenticationSettingsNotifier.new,
  name: r'_authenticationSettingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authenticationSettingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthenticationSettingsNotifier = Notifier<AuthenticationSettings>;
String _$yubikeyAuthenticationNotifierHash() =>
    r'447a9823bd245f81c8a2da69e07564a10ea96d0f';

/// See also [_YubikeyAuthenticationNotifier].
@ProviderFor(_YubikeyAuthenticationNotifier)
final _yubikeyAuthenticationNotifierProvider = AutoDisposeAsyncNotifierProvider<
    _YubikeyAuthenticationNotifier, YubikeyAuthenticationState>.internal(
  _YubikeyAuthenticationNotifier.new,
  name: r'_yubikeyAuthenticationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$yubikeyAuthenticationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$YubikeyAuthenticationNotifier
    = AutoDisposeAsyncNotifier<YubikeyAuthenticationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
