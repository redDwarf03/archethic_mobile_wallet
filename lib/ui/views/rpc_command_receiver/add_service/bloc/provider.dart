import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/domain/usecases/transaction/send_transaction.dart';
import 'package:aewallet/domain/usecases/usecase.dart';

import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart'
    show SendTransactionRequest;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@freezed
class AddServiceConfirmationFormState with _$AddServiceConfirmationFormState {
  const factory AddServiceConfirmationFormState({
    required RPCCommand<SendTransactionRequest> signTransactionCommand,
  }) = _AddServiceConfirmationFormState;
  const AddServiceConfirmationFormState._();
}

class AddServiceConfirmationFormNotifier extends AutoDisposeFamilyAsyncNotifier<
    AddServiceConfirmationFormState, RPCCommand<SendTransactionRequest>> {
  @override
  Future<AddServiceConfirmationFormState> build(
    RPCCommand<SendTransactionRequest> arg,
  ) async {
    return AddServiceConfirmationFormState(
      signTransactionCommand: arg,
    );
  }

  Future<Result<TransactionConfirmation, TransactionError>> send(
    UseCaseProgressListener onProgress,
  ) async =>
      state.maybeMap(
        orElse: () => const Result.failure(TransactionError.other()),
        data: (data) {
          final useCase = ref.read(_sendTransactionUseCaseProvider);
          final accountSelected =
              ref.read(AccountProviders.accounts).valueOrNull?.selectedAccount;
          return useCase
              .run(
            SendTransactionCommand(
              senderAccount: accountSelected!,
              data: data.value.signTransactionCommand.data.data,
              type: data.value.signTransactionCommand.data.type,
              version: data.value.signTransactionCommand.data.version,
            ),
            onProgress: onProgress,
          )
              .then((result) {
            return result.map(
              success: Result.success,
              failure: Result.failure,
            );
          });
        },
      );
}

@riverpod
UseCase<SendTransactionCommand,
    Result<TransactionConfirmation, TransactionError>> _sendTransactionUseCase(
  Ref ref,
) =>
    SendTransactionUseCase(
      wallet: ref.watch(sessionNotifierProvider).loggedIn!.wallet,
      apiService: ref.watch(apiServiceProvider),
      networkSettings: ref.watch(
        SettingsProviders.settings.select((settings) => settings.network),
      ),
    );

class AddServiceConfirmationProviders {
  static final form = AsyncNotifierProvider.autoDispose.family<
      AddServiceConfirmationFormNotifier,
      AddServiceConfirmationFormState,
      RPCCommand<SendTransactionRequest>>(
    AddServiceConfirmationFormNotifier.new,
  );
}
