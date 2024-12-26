import 'package:aewallet/application/account/account_notifier.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/domain/rpc/commands/command.dart';
import 'package:aewallet/infrastructure/datasources/account.hive.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;

class GetAccountsCommandHandler extends CommandHandler {
  GetAccountsCommandHandler()
      : super(
          canHandle: (command) => command is RPCCommand<awc.GetAccountsRequest>,
          handle: (command) async {
            command as RPCCommand<awc.GetAccountsRequest>;
            final accountDatasource = AccountHiveDatasource.instance();
            final appAccounts = await accountDatasource.getAccounts();
            final accounts = <awc.AppAccount>[];
            for (final accountAppName in appAccounts) {
              accounts.add(
                awc.AppAccount(
                  serviceName: accountAppName.name,
                  shortName: accountAppName.nameDisplayed,
                  genesisAddress: accountAppName.genesisAddress,
                ),
              );
            }

            return Result.success(
              awc.GetAccountsResult(accounts: accounts),
            );
          },
        );
}
