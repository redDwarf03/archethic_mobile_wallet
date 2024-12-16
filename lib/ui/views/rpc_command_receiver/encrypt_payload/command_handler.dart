import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class EncryptPayloadsCommandHandler extends CommandHandler {
  EncryptPayloadsCommandHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.EncryptPayloadRequest>,
          handle: (command) async {
            final logger = Logger('RPCHandler - EncryptPayloads');
            command as RPCCommand<awc.EncryptPayloadRequest>;

            final encryptedPayloadsList = <awc.EncryptPayloadsResultDetail>[];
            final serviceName = command.data.serviceName;
            final pathSuffix = command.data.pathSuffix;

            final seed =
                ref.read(sessionNotifierProvider).loggedIn!.wallet.seed;

            final apiService = ref.read(apiServiceProvider);
            final keychain = await apiService.getKeychain(seed);

            var addressGenesis = '';
            try {
              addressGenesis = archethic.uint8ListToHex(
                keychain.deriveAddress(
                  serviceName,
                  pathSuffix: pathSuffix,
                ),
              );
            } catch (e) {
              return const Result.failure(
                awc.Failure.serviceNotFound,
              );
            }

            final indexMap = await apiService.getTransactionIndex(
              [addressGenesis],
            );

            var index = indexMap[addressGenesis] ?? 0;

            final keypair = keychain.deriveKeypair(
              serviceName,
              index: index,
              pathSuffix: pathSuffix,
            );
            logger.info(
              'Service pubkey : ${archethic.uint8ListToHex(keypair.publicKey!)}',
            );
            for (final rpcEncryptPayloadCommandData in command.data.payloads) {
              final payload = rpcEncryptPayloadCommandData.payload;
              final isHexa = rpcEncryptPayloadCommandData.isHexa;

              final encryptedPayload = archethic.ecEncrypt(
                payload,
                keypair.publicKey,
                isDataHexa: isHexa,
              );

              final rpcEncryptPayloadResultDetailData =
                  awc.EncryptPayloadsResultDetail(
                encryptedPayload: archethic.uint8ListToHex(encryptedPayload),
              );

              encryptedPayloadsList.add(rpcEncryptPayloadResultDetailData);
              index++;
            }

            return Result.success(
              awc.EncryptPayloadsResult(
                encryptedPayloads: encryptedPayloadsList,
              ),
            );
          },
        );
}
