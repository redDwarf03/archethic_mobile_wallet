/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/components/liquidity_add_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/components/liquidity_add_form_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LiquidityAddSheet extends ConsumerStatefulWidget {
  const LiquidityAddSheet({
    required this.pool,
    super.key,
  });

  final DexPool pool;

  static const String routerPage = '/add_liquidity';

  @override
  ConsumerState<LiquidityAddSheet> createState() => _LiquidityAddSheetState();
}

class _LiquidityAddSheetState extends ConsumerState<LiquidityAddSheet> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        ref.read(liquidityAddFormNotifierProvider.notifier)
          ..setToken1(widget.pool.pair.token1)
          ..setToken2(widget.pool.pair.token2);

        await ref
            .read(liquidityAddFormNotifierProvider.notifier)
            .setPool(widget.pool);
        await ref
            .read(liquidityAddFormNotifierProvider.notifier)
            .initBalances();
        await ref.read(liquidityAddFormNotifierProvider.notifier).initRatio();
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

    final liquidityAddForm = ref.watch(liquidityAddFormNotifierProvider);

    return liquidityAddForm.processStep == ProcessStep.form
        ? LiquidityAddFormSheet(pool: widget.pool)
        : const LiquidityAddConfirmFormSheet();
  }
}
