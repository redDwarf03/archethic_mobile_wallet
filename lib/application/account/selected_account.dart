/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_account.g.dart';

@riverpod
List<AccountToken> selectedAccountNFTFiltered(
  Ref ref,
) {
  final selectedAccount = ref.watch(
    accountsNotifierProvider.select(
      (accounts) => accounts.valueOrNull?.selectedAccount,
    ),
  );
  if (selectedAccount == null) {
    return <AccountToken>[];
  }

  return <AccountToken>[
    ...selectedAccount.accountNFT ?? [],
    // A collection of NFT has the same address for all the sub NFT, we only want to display one NFT in that case
    ...(selectedAccount.accountNFTCollections?.where(
          (e) => <String>{}.add(e.tokenInformation?.address ?? ''),
        ) ??
        []),
  ];
}
