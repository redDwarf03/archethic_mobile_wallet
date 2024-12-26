import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/components/liquidity_add_confirm_infos.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/layouts/components/liquidity_add_result_sheet.dart';
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

class LiquidityAddConfirmFormSheet extends ConsumerStatefulWidget {
  const LiquidityAddConfirmFormSheet({
    super.key,
  });

  @override
  ConsumerState<LiquidityAddConfirmFormSheet> createState() =>
      LiquidityAddConfirmFormSheetState();
}

class LiquidityAddConfirmFormSheetState
    extends ConsumerState<LiquidityAddConfirmFormSheet>
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
    final liquidityAdd = ref.watch(liquidityAddFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          AppLocalizations.of(context)!.btn_confirm_liquidity_add,
          Dimens.buttonBottomDimens,
          key: const Key('addLiquidity'),
          onPressed: () async {
            final liquidityAddFormNotifier = ref
                .read(liquidityAddFormNotifierProvider.notifier)
              ..setProcessInProgress(true);
            final resultOk = await liquidityAddFormNotifier
                .add(AppLocalizations.of(context)!);
            liquidityAddFormNotifier.setProcessInProgress(false);
            if (resultOk) {
              await context.push(LiquidityAddResultSheet.routerPage);
            } else {
              UIUtil.showSnackbar(
                FailureMessage(
                  context: context,
                  failure: ref.read(liquidityAddFormNotifierProvider).failure,
                ).getMessage(),
                context,
                ref,
                ArchethicTheme.text,
                ArchethicTheme.snackBarShadow,
                duration: const Duration(seconds: 5),
              );
            }
          },
          disabled: (!consentChecked && liquidityAdd.consentDateTime == null) ||
              liquidityAdd.isProcessInProgress,
          showProgressIndicator: liquidityAdd.isProcessInProgress,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final liquidityAddNotifier =
        ref.read(liquidityAddFormNotifierProvider.notifier);

    return SheetAppBar(
      title: localizations.addLiquidity,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          liquidityAddNotifier
            ..setLiquidityAddProcessStep(
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
    final liquidityAdd = ref.read(liquidityAddFormNotifierProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const LiquidityAddConfirmInfos(),
          const SizedBox(
            height: 20,
          ),
          ConsentWidget(
            consentDateTime: liquidityAdd.consentDateTime,
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
                  liquidityAdd.feesEstimatedUCO,
                  kUCOAddress,
                  decimal: 3,
                ),
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
