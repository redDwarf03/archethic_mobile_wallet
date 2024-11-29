// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authenticationRepositoryHash() =>
    r'f75d369f73fe4563b4a0f284c4aad3fcecb9cc6d';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _AuthenticationRepositoryRef
    = ProviderRef<AuthenticationRepositoryInterface>;
String _$isLockCountdownRunningHash() =>
    r'18aea73b8dd6244daa11329f5483cdc31f61df50';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _IsLockCountdownRunningRef = FutureProviderRef<bool>;
String _$lockCountdownHash() => r'2997dd1966cb92c9e6137a178b1325a524034993';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _LockCountdownRef = StreamProviderRef<Duration>;
String _$vaultLockedHash() => r'e578f8e35561e505d4b8d5343eb96d1c21d73b60';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _VaultLockedRef = ProviderRef<bool>;
String _$lockDateHash() => r'a7fa23f38446e0f56795145d07ffa3714c1f03f4';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
    r'64597049cb0d54833b7488d27d43ab7080fba825';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
