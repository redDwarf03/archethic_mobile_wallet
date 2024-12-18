import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/repositories/transaction/archethic_transaction.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeychainDeriveKeypairCommandHandler extends CommandHandler {
  KeychainDeriveKeypairCommandHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.KeychainDeriveKeypairRequest>,
          handle: (command) async {
            command as RPCCommand<awc.KeychainDeriveKeypairRequest>;

            final apiService = ref.watch(apiServiceProvider);
            final archethicTransactionRepository =
                ArchethicTransactionRepository(
              apiService: apiService,
            );
            final session = ref.watch(sessionNotifierProvider).loggedIn!;
            final keychain = await archethicTransactionRepository.apiService
                .getKeychain(session.wallet.seed);

            if (keychain.services.containsKey(command.data.serviceName) ==
                false) {
              return const Result.failure(awc.Failure.serviceNotFound);
            }

            final publicKey = uint8ListToHex(
              keychain
                  .deriveKeypair(
                    command.data.serviceName,
                    index: command.data.index,
                    pathSuffix: command.data.pathSuffix,
                  )
                  .publicKey!,
            );

            return Result.success(
              awc.KeychainDeriveKeypairResult(publicKey: publicKey),
            );
          },
        );
}
