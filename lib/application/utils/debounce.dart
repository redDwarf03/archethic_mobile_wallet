import 'package:flutter_riverpod/flutter_riverpod.dart';

extension FutureRefDebounce on Ref {
  /// Delays the provider resolution.
  ///
  /// For example, this is useful when provider
  /// is created on each user input.
  /// It may prevent spamming the backend.
  Future<T> debounce<T>({
    bool shouldDebounce = true,
    Duration delay = const Duration(milliseconds: 500),
    required Future<T> Function() build,
  }) async {
    if (!shouldDebounce) return build();

    // We capture whether the provider is currently disposed or not.
    var didDispose = false;
    onDispose(() => didDispose = true);

    // We delay the request by 500ms, to wait for the user to stop refreshing.
    await Future<void>.delayed(delay);

    // If the provider was disposed during the delay, it means that the user
    // refreshed again. We throw an exception to cancel the request.
    // It is safe to use an exception here, as it will be caught by Riverpod.
    if (didDispose) {
      throw Exception('Cancelled');
    }

    return build();
  }
}
