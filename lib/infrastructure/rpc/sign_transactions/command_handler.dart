import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/rpc/dto/request_origin.dart';
import 'package:aewallet/infrastructure/rpc/dto/rpc_command_handler.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;

class RPCSignTransactionsCommandHandler extends RPCCommandHandler<
    awc.SignTransactionRequest, awc.SignTransactionsResult> {
  RPCSignTransactionsCommandHandler() : super();
  @override
  RPCCommand<awc.SignTransactionRequest> commandToModel(
    awc.Request dto,
  ) {
    final rpcSignTransactionCommandDataList =
        <awc.SignTransactionRequestData>[];
    final transactions = dto.payload['transactions'];
    for (final Map<String, dynamic> transaction in transactions) {
      final tx = archethic.Transaction.fromNodeRPC(transaction);
      final rpcSignTransactionCommandData = awc.SignTransactionRequestData(
        data: tx.data!,
        version: tx.version,
        type: tx.type!,
      );
      rpcSignTransactionCommandDataList.add(rpcSignTransactionCommandData);
    }
    return RPCCommand(
      origin: dto.origin.toModel,
      data: awc.SignTransactionRequest(
        serviceName: dto.payload['serviceName'],
        pathSuffix: dto.payload['pathSuffix'],
        description: dto.payload['description'] ?? {},
        transactions: rpcSignTransactionCommandDataList,
      ),
    );
  }

  @override
  Map<String, dynamic> resultFromModel(
    awc.SignTransactionsResult model,
  ) =>
      model.toJson();
}
