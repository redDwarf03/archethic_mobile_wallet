import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetCurrentAccountCommandHandler extends CommandHandler {
  GetCurrentAccountCommandHandler({
    required WidgetRef ref,
  }) : super(
          canHandle: (command) =>
              command is RPCCommand<awc.GetCurrentAccountRequest>,
          handle: (command) async {
            command as RPCCommand<awc.GetCurrentAccountRequest>;

            final selectedAccount =
                await ref.read(accountsNotifierProvider.future).selectedAccount;

            if (selectedAccount == null) {
              return const Result.failure(
                awc.Failure.unknownAccount,
              );
            }

            final account = awc.AppAccount(
              serviceName: selectedAccount.name,
              shortName: selectedAccount.nameDisplayed,
              genesisAddress: selectedAccount.genesisAddress,
            );

            return Result.success(
              awc.GetCurrentAccountResult(
                genesisAddress: account.genesisAddress,
                serviceName: account.serviceName,
                shortName: account.shortName,
              ),
            );
          },
        );
}
