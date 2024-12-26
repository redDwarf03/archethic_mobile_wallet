import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/consent_uri.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/farm_lock_duration_type.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_confirm_infos.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_deposit/layouts/components/farm_lock_deposit_result_sheet.dart';
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

class FarmLockDepositConfirmSheet extends ConsumerStatefulWidget {
  const FarmLockDepositConfirmSheet({
    super.key,
  });

  @override
  ConsumerState<FarmLockDepositConfirmSheet> createState() =>
      FarmLockDepositConfirmSheetState();
}

class FarmLockDepositConfirmSheetState
    extends ConsumerState<FarmLockDepositConfirmSheet>
    implements SheetSkeletonInterface {
  bool consentChecked = false;
  bool warningChecked = false;

  @override
  void initState() {
    final farmLockDeposit = ref.read(farmLockDepositFormNotifierProvider);
    if (farmLockDeposit.farmLockDepositDuration ==
        FarmLockDepositDurationType.flexible) {
      warningChecked = true;
    }
    super.initState();
  }

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
    final farmLockDeposit = ref.watch(farmLockDepositFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.btn_confirm_farm_add_lock,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockDeposit'),
          onPressed: () async {
            final farmLockDepositNotifier = ref.read(
              farmLockDepositFormNotifierProvider.notifier,
            )..setProcessInProgress(true);
            final resultOk = await farmLockDepositNotifier
                .lock(AppLocalizations.of(context)!);
            farmLockDepositNotifier.setProcessInProgress(false);
            if (resultOk) {
              await context.push(FarmLockDepositResultSheet.routerPage);
            } else {
              UIUtil.showSnackbar(
                FailureMessage(
                  context: context,
                  failure:
                      ref.read(farmLockDepositFormNotifierProvider).failure,
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
                      farmLockDeposit.consentDateTime == null)) ||
              farmLockDeposit.isProcessInProgress,
          showProgressIndicator: farmLockDeposit.isProcessInProgress,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final farmLockDepositNotifier =
        ref.read(farmLockDepositFormNotifierProvider.notifier);

    return SheetAppBar(
      title: localizations.farmLockDepositFormTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          farmLockDepositNotifier
            ..setFarmLockDepositProcessStep(
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
    final farmLockDeposit = ref.read(farmLockDepositFormNotifierProvider);
    if (farmLockDeposit.pool == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FarmLockDepositConfirmInfos(),
        if (farmLockDeposit.farmLockDepositDuration !=
            FarmLockDepositDurationType.flexible)
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: Wrap(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .farmLockDepositConfirmCheckBoxUnderstand,
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
                          .farmLockDepositConfirmMoreInfo,
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
          consentDateTime: farmLockDeposit.consentDateTime,
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
                farmLockDeposit.feesEstimatedUCO,
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
