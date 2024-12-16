import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/rpc/dto/request_origin.dart';
import 'package:aewallet/infrastructure/rpc/dto/rpc_command_handler.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;

class RPCSendTransactionCommandHandler extends RPCCommandHandler<
    awc.SendTransactionRequest, archethic.TransactionConfirmation> {
  RPCSendTransactionCommandHandler() : super();

  @override
  RPCCommand<awc.SendTransactionRequest> commandToModel(awc.Request dto) {
    const _handledTypes = {
      'keychain',
      'transfer',
      'token',
      'contract',
    };
    final type = dto.payload['type'];

    assert(
      _handledTypes.contains(type),
      'SendTransaction only supports transactions of types $_handledTypes',
    );

    return RPCCommand(
      origin: dto.origin.toModel,
      data: awc.SendTransactionRequest(
        data: archethic.Data.fromJson(dto.payload['data']),
        type: type,
        version: dto.version,
        generateEncryptedSeedSC: dto.payload['generateEncryptedSeedSC'],
      ),
    );
  }

  @override
  Map<String, dynamic> resultFromModel(
    archethic.TransactionConfirmation model,
  ) =>
      awc.SendTransactionResult(
        transactionAddress: model.transactionAddress,
        maxConfirmations: model.maxConfirmations,
        nbConfirmations: model.nbConfirmations,
      ).toJson();
}
