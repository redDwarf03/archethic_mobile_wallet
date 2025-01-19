/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/account/account_notifier.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/infrastructure/repositories/local_account.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_notifier.g.dart';

@riverpod
class AccountsNotifier extends _$AccountsNotifier {
  @override
  FutureOr<Iterable<Account>> build() async {
    final session = ref.watch(sessionNotifierProvider);
    if (session.isLoggedOut) {
      return [];
    }

    final accountNames = await AccountLocalRepository().accountNames();

    return [
      for (final accountName in accountNames)
        await ref.watch(
          accountNotifierProvider(accountName).future,
        ),
    ].whereType<Account>().toList();
  }

  Future<void> selectAccount(Account account) async {
    final previouslySelectedAccount =
        await AccountLocalRepository().getSelectedAccount();
    if (account.name == previouslySelectedAccount?.name) return;

    await AccountLocalRepository().selectAccount(account.name);

    if (previouslySelectedAccount != null) {
      ref.invalidate(accountNotifierProvider(previouslySelectedAccount.name));
    }
    ref.invalidate(
      accountNotifierProvider(account.name),
    );
  }

  // ignore: avoid_public_notifier_properties
  Future<AccountNotifier?> get selectedAccountNotifier async {
    final accountName = (await future).selectedAccount?.name;
    if (accountName == null) return null;

    return ref.read(accountNotifierProvider(accountName).notifier);
  }
}

extension AccountsExt on Iterable<Account> {
  Account? get selectedAccount {
    for (final account in this) {
      if (account.selected == true) return account;
    }
    return null;
  }

  Account? getAccountWithGenesisAddress(
    String genesisAddress,
  ) {
    return firstWhereOrNull(
      (account) =>
          account.genesisAddress.toLowerCase() == genesisAddress.toLowerCase(),
    );
  }

  Account? getAccountWithName(
    String nameAccount,
  ) {
    return firstWhereOrNull(
      (account) =>
          account.nameDisplayed.toLowerCase() == nameAccount.toLowerCase(),
    );
  }
}

extension FutureAccountsExt on Future<Iterable<Account>> {
  Future<Account?> get selectedAccount async {
    return (await this).selectedAccount;
  }
}
