import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

extension WidgetRefExt on WidgetRef {
  /// Creates a Stream containing the Provider values.
  /// Stream is initialized with the last Provider value.
  /// Then, every Provider update is added to the stream.
  /// When Stream is not listened anymore, Provider is not watched anymore.
  Stream<T> streamWithCurrentValue<T>(
    AutoDisposeStreamProvider<T> provider,
  ) async* {
    yield await read(provider.future);

    ProviderSubscription<AsyncValue<T>>? subscription;
    final streamController = StreamController<T>(
      onCancel: () {
        subscription?.close();
      },
    );

    subscription = listenManual(
      provider,
      (previous, next) {
        final value = next.valueOrNull;
        if (value == null) return;
        streamController.add(value);
      },
    );

    yield* streamController.stream;
  }
}
