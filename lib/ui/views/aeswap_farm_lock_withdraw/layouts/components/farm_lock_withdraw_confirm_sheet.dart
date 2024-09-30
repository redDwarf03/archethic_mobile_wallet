/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/consent_uri.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_confirm_infos.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_detail_card.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final accountSelected = ref.watch(
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
    final farmLockWithdraw = ref.watch(farmLockWithdrawFormNotifierProvider);

    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.btn_confirm_farm_withdraw,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockWithdraw'),
          onPressed: () async {
            await ref
                .read(
                  farmLockWithdrawFormNotifierProvider.notifier,
                )
                .withdraw(AppLocalizations.of(context)!);
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
        ref.watch(farmLockWithdrawFormNotifierProvider.notifier);

    return SheetAppBar(
      title: localizations.farmLockWithdrawFormTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          farmLockWithdrawNotifier.setFarmLockWithdrawProcessStep(
            aedappfm.ProcessStep.form,
          );
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final farmLockWithdraw = ref.watch(farmLockWithdrawFormNotifierProvider);

    final localizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FarmLockWithdrawConfirmInfos(),
        const SizedBox(
          height: 20,
        ),
        if (farmLockWithdraw.consentDateTime == null)
          aedappfm.ConsentToCheck(
            consentChecked: consentChecked,
            onToggleConsent: (newValue) {
              setState(() {
                consentChecked = newValue!;
              });
            },
            uriPrivacyPolicy: kURIPrivacyPolicy,
            uriTermsOfUse: kURITermsOfUse,
          )
        else
          aedappfm.ConsentAlready(
            consentDateTime: farmLockWithdraw.consentDateTime!,
            uriPrivacyPolicy: kURIPrivacyPolicy,
            uriTermsOfUse: kURITermsOfUse,
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
                'UCO',
              ),
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ),
      ],
    );
  }
}