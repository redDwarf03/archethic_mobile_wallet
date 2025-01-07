import 'dart:async';

import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/views/authenticate/components/lock_overlay.mixin.dart';
import 'package:aewallet/ui/views/authenticate/logging_out.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

part 'components/lock_mask_screen.dart';
part 'countdown_lock_screen.dart';

/// Listens to app state changes and schedules autoLock
/// accordingly.
/// Checks if lock is required on startup.
///
/// An hiding overlay is displayed as soon as the app becomes [AppLifecycleState.inactive].
/// Overlay is dismissed after checking if user authentication is necessary.
/// This behavior ensures the sensible content's hiding before unlocking.
class AutoLockGuard extends ConsumerStatefulWidget {
  const AutoLockGuard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AutoLockGuardState();
}

class _AutoLockGuardState extends ConsumerState<AutoLockGuard>
    with WidgetsBindingObserver {
  RestartableTimer? timer;

  static final _logger = Logger('AuthenticationGuard-Widget');

  @override
  Widget build(BuildContext context) {
    ref.listen(AuthenticationProviders.authenticationGuard, (previous, state) {
      final value = state.valueOrNull;
      final lockDate = value?.lockDate;

      if (value == null || lockDate == null) {
        _unscheduleLock();
        return;
      }

      final durationBeforeLock = lockDate.difference(DateTime.now());
      if (value.timerEnabled && durationBeforeLock > Duration.zero) {
        _scheduleLock(durationBeforeLock);
      }
    });

    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _logger.info(
      'Init state',
    );

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.info(
      'AppLifecycleState : $state',
    );
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(AuthenticationProviders.authenticationGuard.notifier).unlock();

        break;
      case AppLifecycleState.inactive:
        ref
            .read(AuthenticationProviders.authenticationGuard.notifier)
            .scheduleNextStartupAutolock();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void _unscheduleLock() {
    _logger.info('Unschedule lock');

    timer?.cancel();
    timer = null;
  }

  void _scheduleLock(Duration durationBeforeLock) {
    _logger.info('Schedule lock in $durationBeforeLock');
    timer?.cancel();
    timer = RestartableTimer(
      durationBeforeLock,
      () async {
        await ref
            .read(AuthenticationProviders.authenticationGuard.notifier)
            .lock();
      },
    );
  }
}

/// Listens to user input and schedules autoLock accordingly.
class GuardInputListener extends ConsumerWidget {
  const GuardInputListener({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) => InputListener(
        onInput: () {
          ref
              .read(
                AuthenticationProviders.authenticationGuard.notifier,
              )
              .scheduleAutolock();
        },
        child: child,
      );
}

class InputListener extends StatelessWidget {
  const InputListener({
    super.key,
    required this.onInput,
    required this.child,
  });

  final VoidCallback onInput;
  final Widget child;

  @override
  Widget build(BuildContext context) => Focus(
        onKeyEvent: (_, __) {
          onInput();
          return KeyEventResult.ignored;
        },
        child: Listener(
          onPointerDown: (_) => onInput(),
          onPointerMove: (_) => onInput(),
          child: child,
        ),
      );
}
