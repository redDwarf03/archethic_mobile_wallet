part of 'authentication.dart';

typedef LastInteractionDateValue = ({
  /// Last user interaction date.
  /// [null] when no interaction ever.
  DateTime? date,

  /// Has the value ever changed since
  /// application is in foreground ?
  bool isStartupValue,
});

@Riverpod(keepAlive: true)
class _LastInteractionDateNotifier extends _$LastInteractionDateNotifier {
  static final _logger =
      Logger('AuthenticationGuard-LastInteractionDateProvider');

  @override
  FutureOr<LastInteractionDateValue> build() async {
    return (
      date: await ref
          .watch(AuthenticationProviders.authenticationRepository)
          .getLastInteractionDate(),
      isStartupValue: true,
    );
  }

  void updateLastInteractionDate() {
    state = AsyncValue.data(
      (
        date: DateTime.now(),
        isStartupValue: false,
      ),
    );
  }

  Future<void> persist() async {
    final date = state.value?.date;
    if (date == null) return;

    _logger.info('persist $date');
    state = AsyncValue.data(
      (
        date: date,
        isStartupValue: true,
      ),
    );
    await ref
        .read(AuthenticationProviders.authenticationRepository)
        .setLastInteractionDate(date);
  }

  Future<void> clear() async {
    _logger.fine('clear storage');

    state = const AsyncValue.data(
      (
        date: null,
        isStartupValue: false,
      ),
    );

    await ref
        .read(AuthenticationProviders.authenticationRepository)
        .removeLastInteractionDate();
  }
}

@Riverpod(keepAlive: true)
bool _vaultLocked(Ref ref) {
  Vault.instance().isLocked.addListener(ref.invalidateSelf);
  ref.onDispose(
    () {
      Vault.instance().isLocked.removeListener(ref.invalidateSelf);
    },
  );
  return Vault.instance().isLocked.value;
}

@Riverpod(keepAlive: true)
Future<DateTime?> _lockDate(Ref ref) async {
  final lastInteractionDate = await ref.watch(
    _lastInteractionDateNotifierProvider.future,
  );

  final lockTimeout = ref.watch(
    AuthenticationProviders.settings.select(
      (settings) => settings.lockTimeout.duration,
    ),
  );

  if (lockTimeout == Duration.zero) {
    return null;
  }

  final date = lastInteractionDate.date;
  if (date != null) return date.add(lockTimeout);

  /// When application is just starting, and
  /// no lastInteractionDate is set, force
  /// lockDate to now.
  ///
  /// In that case, we might assume that application
  /// has been killed before saving [lastInteractionDate]
  if (lastInteractionDate.isStartupValue) return DateTime.now();

  return null;
}

@freezed
class AuthenticationGuardState with _$AuthenticationGuardState {
  const factory AuthenticationGuardState({
    /// Date at which the application should be locked
    /// [null] when application should not be locked
    required DateTime? lockDate,

    /// [true] when a timer should be set to
    /// lock application during use.
    required bool timerEnabled,

    /// [true] if application is locked
    required bool isLocked,
  }) = _AuthenticationGuardState;

  const AuthenticationGuardState._();
}

@Riverpod(keepAlive: true)
class _AuthenticationGuardNotifier extends _$AuthenticationGuardNotifier {
  static final _logger = Logger('AuthenticationGuard-Provider');

  @override
  Future<AuthenticationGuardState> build() async {
    ref.listen(
      _vaultLockedProvider,
      (wasLocked, isLocked) {
        if (wasLocked == isLocked) return;
        if (isLocked) return;

        _logger.info('Vault unlocked. Scheduling autolock.');
        scheduleAutolock();
      },
    );

    final lockTimeoutOption = ref.watch(
      AuthenticationProviders.settings.select(
        (settings) => settings.lockTimeout,
      ),
    );

    final isLocked = ref.watch(_vaultLockedProvider);
    final lockDate = await ref.watch(_lockDateProvider.future);

    return AuthenticationGuardState(
      lockDate: lockDate,
      timerEnabled: lockTimeoutOption.duration > Duration.zero,
      isLocked: isLocked,
    );
  }

  Future<void> lock() async {
    final vault = Vault.instance();
    await vault.lock();
    await vault.ensureVaultIsUnlocked();
  }

  /// Asks for user input to unlock
  /// the Vault if required.
  Future<void> unlock() async {
    final vault = Vault.instance();
    await vault.applyAutolock();
    await vault.ensureVaultIsUnlocked();
    ref
        .read(_lastInteractionDateNotifierProvider.notifier)
        .updateLastInteractionDate();
  }

  /// Challenge the verify users ability to unlock device.
  Future<bool> verifyUnlockAbility() async {
    final vault = Vault.instance();
    final result = await vault.verifyUnlockAbility();
    if (result) {
      ref
          .read(_lastInteractionDateNotifierProvider.notifier)
          .updateLastInteractionDate();
    }
    return result;
  }

  Future<void> scheduleNextStartupAutolock() async {
    _logger.info(
      'Schedule next startup Autolock',
    );

    final loadedState = state.valueOrNull;
    if (loadedState == null) return;

    final lastInteractionDateNotifier = ref
        .read(_lastInteractionDateNotifierProvider.notifier)
      ..updateLastInteractionDate();
    await lastInteractionDateNotifier.persist();
  }

  void scheduleAutolock() {
    _logger.info(
      'Schedule Autolock',
    );

    ref
        .read(_lastInteractionDateNotifierProvider.notifier)
        .updateLastInteractionDate();
  }

  Future<void> unscheduleAutolock() async {
    _logger.info(
      'Unschedule Autolock',
    );
    await ref.read(_lastInteractionDateNotifierProvider.notifier).clear();
  }
}
