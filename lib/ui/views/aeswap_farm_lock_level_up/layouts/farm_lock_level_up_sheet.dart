/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/ui/views/aeswap_earn/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_form_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockLevelUpSheet extends ConsumerStatefulWidget {
  const FarmLockLevelUpSheet({
    required this.pool,
    required this.depositId,
    required this.currentLevel,
    required this.lpAmount,
    required this.rewardAmount,
    super.key,
  });

  final DexPool pool;
  final String depositId;
  final String currentLevel;
  final double lpAmount;
  final double rewardAmount;

  static const routerPage = '/farmLockLevelUp';

  @override
  ConsumerState<FarmLockLevelUpSheet> createState() =>
      _FarmLockLevelUpSheetState();
}

class _FarmLockLevelUpSheetState extends ConsumerState<FarmLockLevelUpSheet> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        final farmLock = ref.read(farmLockFormFarmLockProvider).value;

        ref.read(farmLockLevelUpFormNotifierProvider.notifier)
          ..setDexPool(widget.pool)
          ..setDepositId(widget.depositId)
          ..setAmount(widget.lpAmount)
          ..setCurrentLevel(widget.currentLevel);

        if (farmLock != null) {
          ref.read(farmLockLevelUpFormNotifierProvider.notifier)
            ..setDexFarmLock(farmLock)
            ..setLevel(farmLock.availableLevels.entries.last.key)
            ..setAPREstimation(farmLock.apr3years * 100);
        }
        await ref
            .read(farmLockLevelUpFormNotifierProvider.notifier)
            .initBalances();

        ref
            .read(farmLockLevelUpFormNotifierProvider.notifier)
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

    final farmLockLevelUpForm = ref.watch(farmLockLevelUpFormNotifierProvider);

    return farmLockLevelUpForm.processStep == ProcessStep.form
        ? FarmLockLevelUpFormSheet(
            rewardAmount: widget.rewardAmount,
          )
        : const FarmLockLevelUpConfirmSheet();
  }
}
