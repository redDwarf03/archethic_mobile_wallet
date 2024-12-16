import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/rpc/dto/request_origin.dart';
import 'package:aewallet/infrastructure/rpc/dto/rpc_command_handler.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;

class RPCEncryptPayloadsCommandHandler extends RPCCommandHandler<
    awc.EncryptPayloadRequest, awc.EncryptPayloadsResult> {
  RPCEncryptPayloadsCommandHandler() : super();

  @override
  RPCCommand<awc.EncryptPayloadRequest> commandToModel(
    awc.Request dto,
  ) {
    final rpcEncryptPayloadCommandDataList = <awc.EncryptPayloadRequestData>[];
    final payloads = dto.payload['payloads'];
    for (final Map<String, dynamic> payload in payloads) {
      final payloadDecoded = payload['payload'] ?? '';
      final isHexa = payload['isHexa'] ?? false;
      final rpcEncryptTransactionCommandData = awc.EncryptPayloadRequestData(
        payload: payloadDecoded,
        isHexa: isHexa,
      );
      rpcEncryptPayloadCommandDataList.add(rpcEncryptTransactionCommandData);
    }

    return RPCCommand(
      origin: dto.origin.toModel,
      data: awc.EncryptPayloadRequest(
        serviceName: dto.payload['serviceName'],
        pathSuffix: dto.payload['pathSuffix'],
        payloads: rpcEncryptPayloadCommandDataList,
      ),
    );
  }

  @override
  Map<String, dynamic> resultFromModel(
    awc.EncryptPayloadsResult model,
  ) =>
      model.toJson();
}
