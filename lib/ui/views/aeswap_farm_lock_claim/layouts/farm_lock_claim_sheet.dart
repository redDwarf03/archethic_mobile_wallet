/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/layouts/components/farm_lock_claim_confirm_sheet.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/layouts/components/farm_lock_claim_form_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockClaimSheet extends ConsumerStatefulWidget {
  const FarmLockClaimSheet({
    required this.farmAddress,
    required this.rewardToken,
    required this.lpTokenAddress,
    required this.rewardAmount,
    required this.depositId,
    super.key,
  });

  final String farmAddress;
  final DexToken rewardToken;
  final String lpTokenAddress;
  final double rewardAmount;
  final String depositId;

  static const routerPage = '/farmLockClaim';

  @override
  ConsumerState<FarmLockClaimSheet> createState() => _FarmLockClaimSheetState();
}

class _FarmLockClaimSheetState extends ConsumerState<FarmLockClaimSheet> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        ref.read(farmLockClaimFormNotifierProvider.notifier)
          ..setFarmAddress(widget.farmAddress)
          ..setRewardToken(widget.rewardToken)
          ..setLpTokenAddress(widget.lpTokenAddress)
          ..setRewardAmount(widget.rewardAmount)
          ..setDepositId(widget.depositId);
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

    final farmLockClaimForm = ref.watch(farmLockClaimFormNotifierProvider);

    return farmLockClaimForm.processStep == ProcessStep.form
        ? const FarmLockClaimFormSheet()
        : const FarmLockClaimConfirmSheet();
  }
}
