import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/utils/stream.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/domain/rpc/subscription.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/rpc_conversions.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final accountUpdateProvider = StreamProvider.autoDispose
    .family<awc.Account?, String>((ref, serviceName) async* {
  final account = await ref.watch(AccountProviders.account(serviceName).future);

  yield account?.toRPC;
});

class SubscribeAccountHandler extends CommandHandler {
  SubscribeAccountHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.SubscribeAccountRequest>,
          handle: (command) async {
            command as RPCCommand<awc.SubscribeAccountRequest>;

            final accountExists = await ref.read(
              AccountProviders.accountExists(command.data.serviceName).future,
            );
            if (!accountExists) {
              return const Result.failure(awc.Failure.unknownAccount);
            }

            return Result.success(
              RPCSubscription(
                id: const Uuid().v4(),
                updates: ref.streamWithCurrentValue(
                  accountUpdateProvider(command.data.serviceName),
                ),
              ),
            );
          },
        );
}
