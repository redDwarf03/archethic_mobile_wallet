import 'package:aewallet/application/account/accounts.dart';
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/address_service.dart';
import 'package:aewallet/application/recent_transactions.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/application/session/state.dart';
import 'package:aewallet/ui/util/address_formatters.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'formated_name.g.dart';

@riverpod
Future<String> formatedNameFromAddress(
  Ref ref,
  BuildContext context,
  String address,
) async {
  final localizations = AppLocalizations.of(context)!;
  final selectedAccount = ref.watch(
    accountsNotifierProvider.select(
      (accounts) => accounts.valueOrNull?.selectedAccount,
    ),
  );

  ref.watch(recentTransactionsProvider(selectedAccount!.genesisAddress));
  if (address ==
      '00000000000000000000000000000000000000000000000000000000000000000000') {
    return localizations.burnAddressLbl;
  }

  final genesisAddressAsync = ref.watch(genesisAddressProvider(address));
  var addressToSearch = address;
  genesisAddressAsync.map(
    data: (data) {
      addressToSearch = data.value;
    },
    error: (_) {},
    loading: (_) {},
  );

  return ref
      .watch(
    accountWithGenesisAddressProvider(
      addressToSearch,
    ),
  )
      .map(
    data: (data) {
      if (data.value != null) {
        return data.value!.nameDisplayed;
      }

      final environment = ref.watch(environmentProvider);
      if (addressToSearch.toUpperCase() ==
          environment.aeETHUCOPoolAddress.toUpperCase()) {
        return 'Pool aeETH/UCO';
      }
      if (addressToSearch.toUpperCase() ==
          environment.aeETHUCOFarmLockAddress.toUpperCase()) {
        return 'Farm aeETH/UCO';
      }
      if (addressToSearch.toUpperCase() ==
          environment.aeETHUCOFarmLegacyAddress.toUpperCase()) {
        return 'Farm legacy aeETH/UCO';
      }
      if (addressToSearch.toUpperCase() ==
          environment.nodeRewardsChain.toUpperCase()) {
        return 'Node rewards';
      }

      return AddressFormatters(addressToSearch).getShortString4();
    },
    error: (_) {
      return AddressFormatters(addressToSearch).getShortString4();
    },
    loading: (_) {
      return AddressFormatters(addressToSearch).getShortString4();
    },
  );
}
