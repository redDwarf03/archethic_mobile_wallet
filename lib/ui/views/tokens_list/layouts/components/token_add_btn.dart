/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/ui/views/tokens_fungibles/layouts/add_token_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class TokenAddBtn extends ConsumerWidget {
  const TokenAddBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    if (accountSelected?.balance?.isNativeTokenValuePositive() == false) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: aedappfm.AppThemeBase.gradientBtn,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Symbols.add,
              color: Colors.white,
              size: 15,
            ),
          ),
          onTap: () {
            context.push(AddTokenSheet.routerPage);
          },
        ),
      ],
    );
  }
}
