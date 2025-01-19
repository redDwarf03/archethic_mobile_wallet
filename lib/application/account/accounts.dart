/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/address_service.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts.g.dart';

@riverpod
Future<Account?> accountWithGenesisAddress(
  Ref ref,
  String address, {
  bool searchGenesisAddress = false,
}) async {
  var addressToSearch = address;
  if (searchGenesisAddress) {
    addressToSearch = await ref.watch(genesisAddressProvider(address).future);
  }

  final accounts = await ref.watch(accountsNotifierProvider.future);
  return accounts.getAccountWithGenesisAddress(addressToSearch);
}

@riverpod
Future<Account?> accountWithName(
  Ref ref,
  String nameAccount,
) async {
  final accounts = await ref.watch(accountsNotifierProvider.future);
  return accounts.getAccountWithName(nameAccount);
}
