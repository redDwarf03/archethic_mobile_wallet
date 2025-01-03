import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/usecases/new_keychain.usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usecases.g.dart';

@riverpod
CreateNewAppWalletCase createNewAppWalletCase(
  Ref ref,
) {
  return CreateNewAppWalletCase(
    sessionNotifier: ref.watch(sessionNotifierProvider.notifier),
  );
}
