/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/consent_uri.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_confirm_infos.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_level_up/layouts/components/farm_lock_level_up_result_sheet.dart';
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
import 'package:url_launcher/url_launcher.dart';

class FarmLockLevelUpConfirmSheet extends ConsumerStatefulWidget {
  const FarmLockLevelUpConfirmSheet({super.key});

  @override
  ConsumerState<FarmLockLevelUpConfirmSheet> createState() =>
      FarmLockLevelUpConfirmSheetState();
}

class FarmLockLevelUpConfirmSheetState
    extends ConsumerState<FarmLockLevelUpConfirmSheet>
    implements SheetSkeletonInterface {
  bool consentChecked = false;
  bool warningChecked = false;

  @override
  void initState() {
    final farmLockLevelUp = ref.read(farmLockLevelUpFormNotifierProvider);
    if (farmLockLevelUp.farmLockLevelUpDuration ==
        FarmLockDepositDurationType.flexible) {
      warningChecked = true;
    }
    super.initState();
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final farmLockLevelUp = ref.watch(farmLockLevelUpFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.btn_confirm_farm_add_lock,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockLevelUp'),
          onPressed: () async {
            final farmLockLevelUpNotifier = ref.read(
              farmLockLevelUpFormNotifierProvider.notifier,
            )..setProcessInProgress(true);
            final resultOk = await farmLockLevelUpNotifier
                .lock(AppLocalizations.of(context)!);
            farmLockLevelUpNotifier.setProcessInProgress(false);
            if (resultOk) {
              await context.push(FarmLockLevelUpResultSheet.routerPage);
            } else {
              UIUtil.showSnackbar(
                FailureMessage(
                  context: context,
                  failure:
                      ref.read(farmLockLevelUpFormNotifierProvider).failure,
                ).getMessage(),
                context,
                ref,
                ArchethicTheme.text,
                ArchethicTheme.snackBarShadow,
                duration: const Duration(seconds: 5),
              );
            }
          },
          disabled: (!warningChecked ||
                  (!consentChecked &&
                      farmLockLevelUp.consentDateTime == null)) ||
              farmLockLevelUp.isProcessInProgress,
          showProgressIndicator: farmLockLevelUp.isProcessInProgress,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final farmLockLevelUpNotifier =
        ref.read(farmLockLevelUpFormNotifierProvider.notifier);

    return SheetAppBar(
      title: localizations.farmLockLevelUpConfirmTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          farmLockLevelUpNotifier
            ..setFarmLockLevelUpProcessStep(
              aedappfm.ProcessStep.form,
            )
            ..setFailure(null);
        },
      ),
    );
  }

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
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final farmLockLevelUp = ref.read(farmLockLevelUpFormNotifierProvider);
    if (farmLockLevelUp.pool == null) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FarmLockLevelUpConfirmInfos(),
        if (farmLockLevelUp.farmLockLevelUpDuration !=
            FarmLockDepositDurationType.flexible)
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: Wrap(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .farmLockLevelUpConfirmCheckBoxUnderstand,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color:
                                  aedappfm.ArchethicThemeBase.systemWarning500,
                            ),
                      ),
                    ],
                  ),
                  dense: true,
                  value: warningChecked,
                  onChanged: (newValue) {
                    setState(() {
                      warningChecked = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: InkWell(
                    onTap: () async {
                      final uri = Uri.parse(kURIFarmLockFarmTuto);
                      if (!await canLaunchUrl(uri)) return;
                      await launchUrl(uri);
                    },
                    child: Text(
                      AppLocalizations.of(context)!
                          .farmLockLevelUpConfirmMoreInfo,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            color: aedappfm.ArchethicThemeBase.systemWarning500,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ConsentWidget(
          consentDateTime: farmLockLevelUp.consentDateTime,
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
                farmLockLevelUp.feesEstimatedUCO,
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
