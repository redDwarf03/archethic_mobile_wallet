/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_confirm_infos.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_result_sheet.dart';
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

class FarmLockWithdrawConfirmSheet extends ConsumerStatefulWidget {
  const FarmLockWithdrawConfirmSheet({super.key});

  @override
  ConsumerState<FarmLockWithdrawConfirmSheet> createState() =>
      FarmLockWithdrawConfirmSheetState();
}

class FarmLockWithdrawConfirmSheetState
    extends ConsumerState<FarmLockWithdrawConfirmSheet>
    implements SheetSkeletonInterface {
  bool consentChecked = false;

  @override
  Widget build(BuildContext context) {
    final accountSelected = ref.read(
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
    final farmLockWithdraw = ref.watch(farmLockWithdrawFormNotifierProvider);

    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.btn_confirm_farm_withdraw,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockWithdraw'),
          onPressed: () async {
            final farmLockWithdrawFormNotifier = ref.read(
              farmLockWithdrawFormNotifierProvider.notifier,
            )..setProcessInProgress(true);
            final resultOk = await farmLockWithdrawFormNotifier
                .withdraw(AppLocalizations.of(context)!);
            farmLockWithdrawFormNotifier.setProcessInProgress(false);
            if (resultOk) {
              await context.push(FarmLockWithdrawResultSheet.routerPage);
            } else {
              UIUtil.showSnackbar(
                FailureMessage(
                  context: context,
                  failure:
                      ref.read(farmLockWithdrawFormNotifierProvider).failure,
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
              (!consentChecked && farmLockWithdraw.consentDateTime == null) ||
                  farmLockWithdraw.isProcessInProgress,
          showProgressIndicator: farmLockWithdraw.isProcessInProgress,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final farmLockWithdrawNotifier =
        ref.read(farmLockWithdrawFormNotifierProvider.notifier);

    return SheetAppBar(
      title: localizations.farmLockWithdrawFormTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          farmLockWithdrawNotifier
            ..setFarmLockWithdrawProcessStep(
              aedappfm.ProcessStep.form,
            )
            ..setFailure(null);
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final farmLockWithdraw = ref.read(farmLockWithdrawFormNotifierProvider);

    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FarmLockWithdrawConfirmInfos(),
        const SizedBox(
          height: 20,
        ),
        ConsentWidget(
          consentDateTime: farmLockWithdraw.consentDateTime,
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
                farmLockWithdraw.feesEstimatedUCO,
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
