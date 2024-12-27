import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;

extension AccountToRPC on Account {
  awc.Account get toRPC => awc.Account(
        genesisAddress: genesisAddress,
        name: name,
        balance: balance?.toRPC,
      );
}

extension BalanceToRPC on AccountBalance {
  awc.AccountBalance get toRPC => awc.AccountBalance(
        nativeTokenName: nativeTokenName,
        nativeTokenValue: nativeTokenValue,
      );
}
