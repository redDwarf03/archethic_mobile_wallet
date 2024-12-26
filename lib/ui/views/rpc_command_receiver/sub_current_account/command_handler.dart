import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/utils/stream.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/domain/rpc/subscription.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/rpc_conversions.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final accountUpdateProvider = StreamProvider.autoDispose((ref) async* {
  final account =
      await ref.watch(accountsNotifierProvider.future).selectedAccount;
  yield account?.toRPC;
});

class SubscribeCurrentAccountHandler extends CommandHandler {
  SubscribeCurrentAccountHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.SubscribeCurrentAccountRequest>,
          handle: (command) async {
            command as RPCCommand<awc.SubscribeCurrentAccountRequest>;

            return Result.success(
              RPCSubscription(
                id: const Uuid().v4(),
                updates: ref.streamWithCurrentValue(
                  accountUpdateProvider,
                ),
              ),
            );
          },
        );
}
