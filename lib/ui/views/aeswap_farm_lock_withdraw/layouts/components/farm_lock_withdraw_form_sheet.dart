import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/fiat_value.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/bloc/provider.dart';
import 'package:aewallet/ui/views/aeswap_farm_lock_withdraw/layouts/components/farm_lock_withdraw_textfield_amount.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FarmLockWithdrawFormSheet extends ConsumerWidget
    implements SheetSkeletonInterface {
  const FarmLockWithdrawFormSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final localizations = AppLocalizations.of(context)!;
    final farmLockWithdraw = ref.watch(farmLockWithdrawFormNotifierProvider);
    return Row(
      children: <Widget>[
        AppButtonTinyConnectivity(
          localizations.btn_farm_withdraw,
          Dimens.buttonBottomDimens,
          key: const Key('farmLockWithdraw'),
          onPressed: () async {
            await ref
                .read(
                  farmLockWithdrawFormNotifierProvider.notifier,
                )
                .validateForm(AppLocalizations.of(context)!);
          },
          disabled: !farmLockWithdraw.isControlsOk,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.farmLockWithdrawFormTitle,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final farmLockWithdraw = ref.watch(farmLockWithdrawFormNotifierProvider);

    if (farmLockWithdraw.rewardToken == null ||
        farmLockWithdraw.depositedAmount == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 120, bottom: 120),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 0.5),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      AppLocalizations.of(context)!.farmLockWithdrawFormText,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (farmLockWithdraw.rewardAmount == 0)
                      SelectableText(
                        AppLocalizations.of(context)!
                            .farmLockWithdrawFormTextNoRewardText1,
                        style: AppTextStyles.bodyLarge(context),
                      )
                    else
                      FutureBuilder<String>(
                        future: FiatValue().display(
                          ref,
                          farmLockWithdraw.rewardToken!,
                          farmLockWithdraw.rewardAmount!,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Wrap(
                              children: [
                                SelectableText(
                                  farmLockWithdraw.rewardAmount!.formatNumber(),
                                  style: AppTextStyles.bodyMediumSecondaryColor(
                                    context,
                                  ),
                                ),
                                SelectableText(
                                  ' ${farmLockWithdraw.rewardToken!.symbol} ',
                                  style: AppTextStyles.bodyMedium(context),
                                ),
                                SelectableText(
                                  '${snapshot.data}',
                                  style: AppTextStyles.bodyMedium(context),
                                ),
                                SelectableText(
                                  AppLocalizations.of(context)!
                                      .farmLockWithdrawFormTextNoRewardText2,
                                  style: AppTextStyles.bodyMedium(context),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    const FarmLockWithdrawAmount(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    aedappfm.ErrorMessage(
                      failure: farmLockWithdraw.failure,
                      failureMessage: FailureMessage(
                        context: context,
                        failure: farmLockWithdraw.failure,
                      ).getMessage(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
