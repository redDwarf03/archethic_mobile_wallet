/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/btn_validate_mobile.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/components/failure_message.dart';
import 'package:aewallet/ui/util/formatters.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/bloc/provider.dart';

import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LiquiditySettingsSlippageTolerance extends ConsumerStatefulWidget {
  const LiquiditySettingsSlippageTolerance({
    super.key,
  });

  @override
  LiquiditySettingsSlippageToleranceState createState() =>
      LiquiditySettingsSlippageToleranceState();
}

class LiquiditySettingsSlippageToleranceState
    extends ConsumerState<LiquiditySettingsSlippageTolerance> {
  late TextEditingController slippageToleranceController;
  late FocusNode slippageToleranceFocusNode;

  @override
  void initState() {
    super.initState();
    final liquidityAdd = ref.read(liquidityAddFormNotifierProvider);
    slippageToleranceFocusNode = FocusNode();
    slippageToleranceController =
        TextEditingController(text: liquidityAdd.slippageTolerance.toString());
  }

  @override
  void dispose() {
    slippageToleranceFocusNode.dispose();
    slippageToleranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liquidityAddNotifier =
        ref.read(liquidityAddFormNotifierProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.slippage_tolerance,
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 75),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    width: 0.5,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface.withOpacity(1),
                      Theme.of(context).colorScheme.surface.withOpacity(0.3),
                    ],
                    stops: const [0, 1],
                  ),
                ),
                child: TextField(
                  style: Theme.of(context).textTheme.titleMedium,
                  autocorrect: false,
                  controller: slippageToleranceController,
                  focusNode: slippageToleranceFocusNode,
                  textAlign: TextAlign.right,
                  textInputAction: TextInputAction.done,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    AmountTextInputFormatter(
                      precision: 5,
                    ),
                    LengthLimitingTextInputFormatter(5),
                  ],
                  onChanged: (_) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(right: 5, top: -3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: SelectableText(
                '%',
                style: AppTextStyles.bodyLarge(context),
              ),
            ),
          ],
        ),
        if (slippageToleranceController.text.isNotEmpty &&
            slippageToleranceController.text.isValidNumber() &&
            (double.tryParse(slippageToleranceController.text)! < 0 ||
                double.tryParse(slippageToleranceController.text)! > 100))
          aedappfm.ErrorMessage(
            failure: aedappfm.Failure.other(
              cause: AppLocalizations.of(context)!
                  .liquidityAddSettingsSlippageErrorBetween0and100,
            ),
            failureMessage: FailureMessage(
              context: context,
              failure: aedappfm.Failure.other(
                cause: AppLocalizations.of(context)!
                    .liquidityAddSettingsSlippageErrorBetween0and100,
              ),
            ).getMessage(),
          ),
        if (slippageToleranceController.text.isNotEmpty &&
            slippageToleranceController.text.isValidNumber() &&
            double.tryParse(slippageToleranceController.text)! >= 3 &&
            double.tryParse(slippageToleranceController.text)! <= 100)
          aedappfm.InfoBanner(
            AppLocalizations.of(context)!
                .liquidityAddSettingsSlippageErrorHighSlippage,
            aedappfm.InfoBannerType.error,
          ),
        ButtonValidateMobile(
          controlOk:
              double.tryParse(slippageToleranceController.text) != null &&
                  (double.tryParse(slippageToleranceController.text)! >= 0 &&
                      double.tryParse(slippageToleranceController.text)! < 100),
          labelBtn: AppLocalizations.of(context)!.btn_save,
          onPressed: () {
            liquidityAddNotifier.setSlippageTolerance(
              double.tryParse(slippageToleranceController.text) ?? 0,
            );
            if (!context.mounted) return;
            context.pop();
          },
          isConnected: true,
          displayWalletConnectOnPressed: () {},
        ),
      ],
    );
  }
}
