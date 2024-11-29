import 'dart:async';

import 'package:aewallet/domain/models/authentication.dart';
import 'package:aewallet/domain/repositories/authentication.dart';
import 'package:aewallet/domain/usecases/authentication/authentication.dart';
import 'package:aewallet/domain/usecases/authentication/update_my_password.dart';
import 'package:aewallet/infrastructure/datasources/vault/vault.dart';
import 'package:aewallet/infrastructure/repositories/authentication.nonweb.dart';
import 'package:aewallet/infrastructure/repositories/authentication.web.dart';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/model/device_lock_timeout.dart';
import 'package:aewallet/model/privacy_mask_option.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication.freezed.dart';
part 'authentication.g.dart';
part 'auto_lock_guard.dart';
part 'password.dart';
part 'pin.dart';
part 'settings.dart';
part 'yubikey.dart';

@Riverpod(keepAlive: true)
AuthenticationRepositoryInterface _authenticationRepository(
  Ref ref,
) {
  if (kIsWeb) return AuthenticationRepositoryWeb();
  return AuthenticationRepositoryNonWeb();
}

@Riverpod(keepAlive: true)
Future<bool> _isLockCountdownRunning(
  Ref ref,
) async {
  final lockCountDownDuration = await ref.watch(_lockCountdownProvider.future);
  return lockCountDownDuration.inSeconds > 1;
}

@Riverpod(keepAlive: true)
Stream<Duration> _lockCountdown(
  Ref ref,
) async* {
  final lockDate = await ref
      .watch(
        AuthenticationProviders.authenticationRepository,
      )
      .getLockUntilDate();
  if (lockDate == null || lockDate.isBefore(DateTime.now().toUtc())) {
    yield Duration.zero;
    return;
  }

  while (true) {
    final durationToWait = lockDate.difference(DateTime.now().toUtc());
    if (durationToWait < Duration.zero) {
      yield Duration.zero;
      return;
    }

    yield durationToWait;
    await Future.delayed(const Duration(seconds: 1));
  }
}

abstract class AuthenticationProviders {
  static final authenticationRepository = _authenticationRepositoryProvider;

  /// Whether the application is locked.
  static final isLockCountdownRunning = _isLockCountdownRunningProvider;

  /// Counts remaining lock duration.
  /// Lock occurs when authentication failed too much times.
  static final lockCountdown = _lockCountdownProvider;

  static final authenticationGuard = _authenticationGuardNotifierProvider;

  static final passwordAuthentication = _passwordAuthenticationNotifierProvider;

  static final pinAuthentication = _pinAuthenticationNotifierProvider;

  static final yubikeyAuthentication = _yubikeyAuthenticationNotifierProvider;

  static final settings = _authenticationSettingsNotifierProvider;

  static Future<void> reset(Ref ref) async {
    await ref.read(AuthenticationProviders.settings.notifier).reset();
    await ref.read(authenticationGuard.notifier).unscheduleAutolock();
    await ref.read(authenticationRepository).clear();

    ref
      ..invalidate(passwordAuthentication)
      ..invalidate(pinAuthentication)
      ..invalidate(yubikeyAuthentication);
  }
}
