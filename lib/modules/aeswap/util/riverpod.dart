import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RefListenSelectExtension<State extends Object?, T> on Ref<State> {
  void invalidateSelfOnPropertyChange(
    T? Function(State? state) select,
  ) {
    listenSelf((previous, next) {
      final previousValue = select(previous);
      final nextValue = select(next);

      if (previousValue == nextValue) return;
      invalidateSelf();
    });
  }
}

bool _alwaysTrue() => true;

extension PeriodicReloadExtension on Ref<Object?> {
  /// Updates periodically the provider.
  /// [shouldReload] : a function that returns true if the provider should be reloaded.
  void periodicReload(
    Duration duration, {
    bool Function() shouldReload = _alwaysTrue,
  }) {
    final timer = Timer(
      duration,
      () {
        if (!shouldReload()) {
          return;
        }
        invalidateSelf();
      },
    );
    onDispose(timer.cancel);
  }
}

extension RefListenForChanges on Ref<Object?> {
  void invalidateSelfOnProviderChange<T>(ProviderBase<T> provider) {
    listen<T>(provider, (previous, next) {
      if (previous != next) {
        invalidateSelf();
      }
    });
  }
}
