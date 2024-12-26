/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_form_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockDepositSheet extends ConsumerStatefulWidget {
  const FarmLockDepositSheet({
    required this.pool,
    super.key,
  });

  final DexPool pool;

  static const String routerPage = '/farmLockDeposit';

  @override
  ConsumerState<FarmLockDepositSheet> createState() =>
      _FarmLockDepositSheetState();
}

class _FarmLockDepositSheetState extends ConsumerState<FarmLockDepositSheet> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        final farmLock = ref.read(farmLockFormFarmLockProvider).value;
        ref
            .read(farmLockDepositFormNotifierProvider.notifier)
            .setDexPool(widget.pool);
        if (farmLock != null) {
          ref.read(farmLockDepositFormNotifierProvider.notifier)
            ..setDexFarmLock(farmLock)
            ..setLevel(farmLock.availableLevels.entries.last.key)
            ..setAPREstimation(farmLock.apr3years * 100);
        }
        ref
            .read(farmLockDepositFormNotifierProvider.notifier)
            .filterAvailableLevels();
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

    final farmLockDepositForm = ref.watch(farmLockDepositFormNotifierProvider);

    return farmLockDepositForm.processStep == ProcessStep.form
        ? const FarmLockDepositFormSheet()
        : const FarmLockDepositConfirmSheet();
  }
}
