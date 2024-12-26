/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pair.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/layouts/components/liquidity_remove_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_remove/layouts/components/liquidity_remove_form_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LiquidityRemoveSheet extends ConsumerStatefulWidget {
  const LiquidityRemoveSheet({
    required this.pool,
    required this.pair,
    required this.lpToken,
    super.key,
  });

  final DexPool pool;
  final DexPair pair;
  final DexToken lpToken;

  static const String routerPage = '/remove_liquidity';

  @override
  ConsumerState<LiquidityRemoveSheet> createState() =>
      _LiquidityRemoveSheetState();
}

class _LiquidityRemoveSheetState extends ConsumerState<LiquidityRemoveSheet> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        ref.read(liquidityRemoveFormNotifierProvider.notifier)
          ..setToken1(widget.pair.token1)
          ..setToken2(widget.pair.token2)
          ..setLpToken(widget.lpToken);

        // ignore: cascade_invocations
        await ref
            .read(liquidityRemoveFormNotifierProvider.notifier)
            .setPool(widget.pool);
        await ref
            .read(liquidityRemoveFormNotifierProvider.notifier)
            .initBalance();
      } catch (e) {
        if (mounted) {
          context.pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedAccount = ref
        .watch(
          accountsNotifierProvider,
        )
        .valueOrNull
        ?.selectedAccount;

    if (selectedAccount == null) return const SizedBox();

    final liquidityRemoveForm = ref.watch(liquidityRemoveFormNotifierProvider);

    return liquidityRemoveForm.processStep == ProcessStep.form
        ? LiquidityRemoveFormSheet(pool: widget.pool)
        : const LiquidityRemoveConfirmFormSheet();
  }
}
