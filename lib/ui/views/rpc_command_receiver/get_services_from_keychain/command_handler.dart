import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/repositories/transaction/archethic_transaction.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetServicesFromKeychainCommandHandler extends CommandHandler {
  GetServicesFromKeychainCommandHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.GetServicesFromKeychainRequest>,
          handle: (command) async {
            command as RPCCommand<awc.GetServicesFromKeychainRequest>;

            final apiService = ref.watch(apiServiceProvider);

            final archethicTransactionRepository =
                ArchethicTransactionRepository(
              apiService: apiService,
            );
            final session = ref.watch(sessionNotifierProvider).loggedIn!;
            final keychain = await archethicTransactionRepository.apiService
                .getKeychain(session.wallet.seed);

            final services = <Service>[];
            keychain.services.forEach((key, value) {
              services.add(
                Service(
                  derivationPath: value.derivationPath,
                  curve: value.curve,
                  hashAlgo: value.hashAlgo,
                ),
              );
            });

            return Result.success(
              awc.GetServicesFromKeychainResult(services: services),
            );
          },
        );
}
