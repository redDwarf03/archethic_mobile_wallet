import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/repositories/transaction/archethic_transaction.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeychainDeriveAddressCommandHandler extends CommandHandler {
  KeychainDeriveAddressCommandHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.KeychainDeriveAddressRequest>,
          handle: (command) async {
            command as RPCCommand<awc.KeychainDeriveAddressRequest>;

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

            final address = uint8ListToHex(
              keychain.deriveAddress(
                command.data.serviceName,
                index: command.data.index,
                pathSuffix: command.data.pathSuffix,
              ),
            );

            return Result.success(
              awc.KeychainDeriveAddressResult(address: address),
            );
          },
        );
}
