import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pair.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_form_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockWithdrawSheet extends ConsumerStatefulWidget {
  const FarmLockWithdrawSheet({
    required this.farmAddress,
    required this.poolAddress,
    required this.rewardToken,
    required this.lpToken,
    required this.lpTokenPair,
    required this.rewardAmount,
    required this.depositId,
    required this.depositedAmount,
    required this.endDate,
    super.key,
  });

  final String farmAddress;
  final String poolAddress;
  final DexToken rewardToken;
  final DexToken lpToken;
  final DexPair lpTokenPair;
  final String depositId;
  final double rewardAmount;
  final double depositedAmount;
  final DateTime endDate;

  static const routerPage = '/farmLockWithdraw';

  @override
  ConsumerState<FarmLockWithdrawSheet> createState() =>
      _FarmLockWithdrawSheetState();
}

class _FarmLockWithdrawSheetState extends ConsumerState<FarmLockWithdrawSheet> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        ref.read(farmLockWithdrawFormNotifierProvider.notifier)
          ..setFarmAddress(widget.farmAddress)
          ..setRewardToken(widget.rewardToken)
          ..setDepositId(widget.depositId)
          ..setDepositedAmount(widget.depositedAmount)
          ..setRewardAmount(widget.rewardAmount)
          ..setEndDate(widget.endDate)
          ..setPoolAddress(widget.poolAddress)
          ..setLPTokenPair(widget.lpTokenPair)
          ..setLpToken(widget.lpToken);
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

    final farmLockWithdrawForm =
        ref.watch(farmLockWithdrawFormNotifierProvider);

    return farmLockWithdrawForm.processStep == ProcessStep.form
        ? const FarmLockWithdrawFormSheet()
        : const FarmLockWithdrawConfirmSheet();
  }
}
