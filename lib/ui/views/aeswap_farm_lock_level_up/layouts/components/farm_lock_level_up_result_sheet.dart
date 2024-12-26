import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/format_address_link_copy_big_icon.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_final_amount.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockLevelUpResultSheet extends ConsumerStatefulWidget {
  const FarmLockLevelUpResultSheet({
    super.key,
  });

  static const String routerPage = '/farmLockLevelUp_result';

  @override
  ConsumerState<FarmLockLevelUpResultSheet> createState() =>
      FarmLockLevelUpResultSheetState();
}

class FarmLockLevelUpResultSheetState
    extends ConsumerState<FarmLockLevelUpResultSheet>
    implements SheetSkeletonInterface {
  @override
  Widget build(BuildContext context) {
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    if (accountSelected == null) return const SizedBox();

    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.close,
          Dimens.buttonBottomDimens,
          key: const Key('close'),
          onPressed: () async {
            ref.invalidate(farmLockLevelUpFormNotifierProvider);
            context
              ..pop()
              ..pop();
          },
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return SheetAppBar(
      title: localizations.farmLockLevelUpFormTitle,
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final farmLockLevelUp = ref.watch(farmLockLevelUpFormNotifierProvider);
    if (farmLockLevelUp.amount == 0) {
      return const SizedBox.shrink();
    }
    final finalAmount = farmLockLevelUp.finalAmount;
    final timeout = ref.watch(
      farmLockLevelUpFormNotifierProvider
          .select((value) => value.failure != null),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetDetailCard(
              children: [
                if (finalAmount == null)
                  if (timeout == false)
                    Row(
                      children: [
                        AutoSizeText(
                          AppLocalizations.of(context)!.processingInProgress,
                          style: AppTextStyles.bodyLarge(context),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        ),
                      ],
                    )
                  else
                    Text(
                      FailureMessage(
                        context: context,
                        failure: farmLockLevelUp.failure,
                      ).getMessage(),
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: aedappfm.ArchethicThemeBase.systemDanger500,
                      ),
                    )
                else
                  AutoSizeText(
                    AppLocalizations.of(context)!.levelUpFarmLockDone,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: aedappfm.ArchethicThemeBase.systemPositive600,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            if (farmLockLevelUp.transactionFarmLockLevelUp != null &&
                farmLockLevelUp.transactionFarmLockLevelUp!.address != null &&
                farmLockLevelUp.transactionFarmLockLevelUp!.address!.address !=
                    null &&
                finalAmount != null)
              Column(
                children: [
                  FormatAddressLinkCopyBigIcon(
                    address: farmLockLevelUp
                        .transactionFarmLockLevelUp!.address!.address!
                        .toUpperCase(),
                    header:
                        AppLocalizations.of(context)!.farmLockLevelUpTxAddress,
                    typeAddress: TypeAddressLinkCopyBigIcon.transaction,
                    reduceAddress: true,
                    fontSize: 16,
                    iconSize: 26,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            if (finalAmount != null || timeout)
              const SheetDetailCard(
                children: [
                  FarmLockLevelUpFinalAmount(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
