import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

extension WidgetRefExt on WidgetRef {
  Future<void> waitUntil<T>(
    ProviderListenable<T> provider,
    bool Function(T? previous, T next) predicate,
  ) async {
    final _logger = Logger('WaitUntilProvider ${provider.runtimeType}');
    if (predicate(null, read(provider))) return;
    _logger.info('start');
    final waitCompleter = Completer();
    ProviderSubscription? subscription;

    subscription = listenManual(
      provider,
      (previous, next) {
        if (!predicate(previous, next)) return;

        subscription?.close();
        waitCompleter.complete();
        _logger.info(
          'predicate verified',
        );
      },
      onError: (error, stackTrace) {
        subscription?.close();
        waitCompleter.completeError(error, stackTrace);
        _logger.info(
          'canceled',
        );
      },
    );

    return waitCompleter.future;
  }
}
