/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/layouts/components/farm_lock_claim_confirm_infos.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_claim/layouts/components/farm_lock_claim_result_sheet.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/ui/widgets/consent_widget.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockClaimConfirmSheet extends ConsumerStatefulWidget {
  const FarmLockClaimConfirmSheet({super.key});

  @override
  ConsumerState<FarmLockClaimConfirmSheet> createState() =>
      FarmLockClaimConfirmSheetState();
}

class FarmLockClaimConfirmSheetState
    extends ConsumerState<FarmLockClaimConfirmSheet>
    implements SheetSkeletonInterface {
  bool consentChecked = false;

  @override
  Widget build(BuildContext context) {
    final accountSelected = ref.read(
      AccountProviders.accounts.select(
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
    final farmLockClaim = ref.watch(farmLockClaimFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.btn_confirm_farm_lock_claim,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockClaim'),
          onPressed: () async {
            final farmLockClaimFormNotifier = ref
                .read(farmLockClaimFormNotifierProvider.notifier)
              ..setProcessInProgress(true);
            final resultOk = await farmLockClaimFormNotifier
                .claim(AppLocalizations.of(context)!);
            farmLockClaimFormNotifier.setProcessInProgress(false);
            if (resultOk) {
              await context.push(FarmLockClaimResultSheet.routerPage);
            } else {
              UIUtil.showSnackbar(
                FailureMessage(
                  context: context,
                  failure: ref.read(farmLockClaimFormNotifierProvider).failure,
                ).getMessage(),
                context,
                ref,
                ArchethicTheme.text,
                ArchethicTheme.snackBarShadow,
                duration: const Duration(seconds: 5),
              );
            }
          },
          disabled:
              (!consentChecked && farmLockClaim.consentDateTime == null) ||
                  farmLockClaim.isProcessInProgress,
          showProgressIndicator: farmLockClaim.isProcessInProgress,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final farmLockClaimNotifier =
        ref.read(farmLockClaimFormNotifierProvider.notifier);

    return SheetAppBar(
      title: localizations.farmLockClaimConfirmTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          farmLockClaimNotifier
            ..setFarmLockClaimProcessStep(
              aedappfm.ProcessStep.form,
            )
            ..setFailure(null);
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final farmLockClaim = ref.read(farmLockClaimFormNotifierProvider);
    if (farmLockClaim.rewardAmount == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FarmLockClaimConfirmInfos(),
        const SizedBox(
          height: 20,
        ),
        ConsentWidget(
          consentDateTime: farmLockClaim.consentDateTime,
          consentChecked: consentChecked,
          onToggleConsent: (newValue) {
            setState(() {
              consentChecked = newValue!;
            });
          },
          textStyle: AppTextStyles.bodyMedium(
            context,
          ),
        ),
        SheetDetailCard(
          children: [
            Text(
              localizations.estimatedTxFees,
              style: AppTextStyles.bodyMedium(context),
            ),
            Text(
              AmountFormatters.standardSmallValue(
                farmLockClaim.feesEstimatedUCO,
                kUCOAddress,
                decimal: 3,
              ),
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ),
      ],
    );
  }
}
