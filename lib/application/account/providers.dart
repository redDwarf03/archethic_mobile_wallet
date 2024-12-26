/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:aewallet/application/address_service.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/application/nft/nft.dart';
import 'package:aewallet/application/refresh_in_progress.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/tokens/tokens.dart';
import 'package:aewallet/domain/repositories/account.dart';
import 'package:aewallet/infrastructure/repositories/local_account.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/domain/models/util/get_pool_list_response.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_notifier.dart';
part 'accounts_notifier.dart';
part 'providers.g.dart';

@riverpod
AccountRepository _accountRepository(Ref ref) => AccountRepository();

@riverpod
List<AccountToken> _getAccountNFTFiltered(
  Ref ref,
  Account account,
) {
  return ref.watch(_accountRepositoryProvider).getAccountNFTFiltered(
        account,
      );
}

class AccountRepository {
  List<AccountToken> getAccountNFTFiltered(
    Account account,
  ) {
    final accountNFTFiltered = <AccountToken>[
      ...account.accountNFT ?? [],
      // A collection of NFT has the same address for all the sub NFT, we only want to display one NFT in that case
      ...(account.accountNFTCollections?.where(
            (e) => <String>{}.add(e.tokenInformation?.address ?? ''),
          ) ??
          []),
    ];
    return accountNFTFiltered;
  }
}

@riverpod
AccountLocalRepositoryInterface _accountsRepository(
  Ref ref,
) =>
    AccountLocalRepository();

abstract class AccountProviders {
  static final accountsRepository = _accountsRepositoryProvider;
  static final accounts = _accountsNotifierProvider;
  static const account = _accountNotifierProvider;
  static final accountRepository = _accountRepositoryProvider;
  static const getAccountNFTFiltered = _getAccountNFTFilteredProvider;

  static Future<void> reset(Ref ref) async {
    ref
      ..invalidate(accountsRepository)
      ..invalidate(account)
      ..invalidate(accountRepository)
      ..invalidate(getAccountNFTFiltered);
  }
}
