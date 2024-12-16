import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider.freezed.dart';

@freezed
class DecryptPayloadsConfirmationFormState
    with _$DecryptPayloadsConfirmationFormState {
  const factory DecryptPayloadsConfirmationFormState({
    required RPCCommand<DecryptPayloadRequest> decryptTransactionCommand,
  }) = _DecryptPayloadsConfirmationFormState;
  const DecryptPayloadsConfirmationFormState._();
}

class DecryptPayloadsConfirmationFormNotifiers
    extends AutoDisposeFamilyAsyncNotifier<DecryptPayloadsConfirmationFormState,
        RPCCommand<DecryptPayloadRequest>> {
  @override
  Future<DecryptPayloadsConfirmationFormState> build(
    RPCCommand<DecryptPayloadRequest> arg,
  ) async {
    return DecryptPayloadsConfirmationFormState(
      decryptTransactionCommand: arg,
    );
  }
}

class DecryptPayloadsConfirmationProviders {
  static final form = AsyncNotifierProvider.autoDispose.family<
      DecryptPayloadsConfirmationFormNotifiers,
      DecryptPayloadsConfirmationFormState,
      RPCCommand<DecryptPayloadRequest>>(
    DecryptPayloadsConfirmationFormNotifiers.new,
  );
}
