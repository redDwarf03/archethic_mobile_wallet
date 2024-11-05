import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/tokens/tokens.dart';
import 'package:aewallet/util/riverpod_debounce.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<List<AEToken>> tokens(
  Ref ref, {
  String searchCriteria = '',
  bool withVerified = true,
  bool withLPToken = true,
  bool withNotVerified = true,
}) async =>
    ref.debounce(
      shouldDebounce: searchCriteria.isNotEmpty,
      build: () async {
        final selectedAccount =
            await ref.watch(AccountProviders.accounts.future).selectedAccount;

        if (selectedAccount == null) return [];

        final tokensList = await ref.watch(
          tokensFromUserBalanceProvider(
            withVerified: withVerified,
            withLPToken: withLPToken,
            withNotVerified: withNotVerified,
          ).future,
        );

        final sortedTokens = tokensList.toList()
          ..sort((a, b) {
            if (a.address == null && b.address != null) return -1;
            if (a.address != null && b.address == null) return 1;

            if (a.isVerified && !b.isVerified) return -1;
            if (!a.isVerified && b.isVerified) return 1;

            if (a.isLpToken && !b.isLpToken) return -1;
            if (!a.isLpToken && b.isLpToken) return 1;

            final symbolComparison = a.symbol.compareTo(b.symbol);
            if (symbolComparison != 0) return symbolComparison;

            return 0;
          });

        if (searchCriteria.isNotEmpty) {
          sortedTokens.removeWhere(
            (element) =>
                element.symbol.toUpperCase().contains(searchCriteria) ==
                    false &&
                element.address?.toUpperCase().contains(searchCriteria) ==
                    false,
          );
        }

        return sortedTokens;
      },
    );
