import 'package:aewallet/application/api_service.dart';
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
    apiService: ref.watch(apiServiceProvider),
    sessionNotifier: ref.watch(sessionNotifierProvider.notifier),
  );
}
