import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/rpc/dto/request_origin.dart';
import 'package:aewallet/infrastructure/rpc/dto/rpc_command_handler.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;

class RPCDecryptPayloadsCommandHandler extends RPCCommandHandler<
    awc.DecryptPayloadRequest, awc.DecryptPayloadsResult> {
  RPCDecryptPayloadsCommandHandler() : super();

  @override
  RPCCommand<awc.DecryptPayloadRequest> commandToModel(
    awc.Request dto,
  ) {
    final rpcDecryptPayloadCommandDataList = <awc.DecryptPayloadRequestData>[];
    final payloads = dto.payload['payloads'];
    for (final Map<String, dynamic> payload in payloads) {
      final payloadDecoded = payload['payload'] ?? '';
      final isHexa = payload['isHexa'] ?? false;
      final rpcDecryptTransactionCommandData = awc.DecryptPayloadRequestData(
        payload: payloadDecoded,
        isHexa: isHexa,
      );
      rpcDecryptPayloadCommandDataList.add(rpcDecryptTransactionCommandData);
    }

    return RPCCommand(
      origin: dto.origin.toModel,
      data: awc.DecryptPayloadRequest(
        serviceName: dto.payload['serviceName'],
        pathSuffix: dto.payload['pathSuffix'],
        description: dto.payload['description'] ?? {},
        payloads: rpcDecryptPayloadCommandDataList,
      ),
    );
  }

  @override
  Map<String, dynamic> resultFromModel(
    awc.DecryptPayloadsResult model,
  ) =>
      model.toJson();
}
