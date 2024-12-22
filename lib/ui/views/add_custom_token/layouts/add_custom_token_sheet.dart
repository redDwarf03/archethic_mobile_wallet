/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:ui';

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/add_custom_token/bloc/provider.dart';
import 'package:aewallet/ui/views/add_custom_token/bloc/state.dart';
import 'package:aewallet/ui/views/add_custom_token/layouts/components/add_custom_token_info_token.dart';
import 'package:aewallet/ui/views/add_custom_token/layouts/components/add_custom_token_textfield_address.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddCustomTokenSheet extends ConsumerWidget {
  const AddCustomTokenSheet({
    this.myTokens,
    super.key,
  });
  final List<aedappfm.AEToken>? myTokens;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addCustomTokenForm = ref.watch(addCustomTokenFormNotifierProvider);
    ref.listen<AddCustomTokenFormState>(
      addCustomTokenFormNotifierProvider,
      (_, addCustomToken) {
        if (addCustomToken.isControlsOk || addCustomToken.errorText == '') {
          return;
        }

        UIUtil.showSnackbar(
          addCustomToken.errorText,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
          duration: const Duration(seconds: 5),
        );

        ref.read(addCustomTokenFormNotifierProvider.notifier).setError(
              '',
            );
      },
    );

    final localizations = AppLocalizations.of(context)!;
    return Stack(
      children: [
        ClipRRect(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 40,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.customTokenAddTitle,
                      style: ArchethicThemeStyles.textStyleSize16W600Primary,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AddCustomTokenTextFieldAddress(
                      myTokens: myTokens,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: AddCustomTokenInfoToken(),
                    ),
                    Text(
                      localizations.customTokenAddDesc,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 20,
            ),
            child: Row(
              children: [
                AppButtonTinyConnectivity(
                  localizations.cancel,
                  Dimens.buttonBottomDimens,
                  key: const Key('cancel'),
                  onPressed: () {
                    context.pop();
                  },
                ),
                AppButtonTinyConnectivity(
                  localizations.confirm,
                  disabled: !addCustomTokenForm.isControlsOk,
                  Dimens.buttonBottomDimens,
                  key: const Key('confirm'),
                  onPressed: () async {
                    final result = await ref
                        .read(addCustomTokenFormNotifierProvider.notifier)
                        .addCustomToken(ref, localizations);

                    if (!result) return;

                    final poolListRaw =
                        await ref.read(DexPoolProviders.getPoolListRaw.future);

                    unawaited(
                      (await ref
                              .read(AccountProviders.accounts.notifier)
                              .selectedAccountNotifier)
                          ?.refreshBalance(),
                    );
                    unawaited(
                      (await ref
                              .read(AccountProviders.accounts.notifier)
                              .selectedAccountNotifier)
                          ?.refreshFungibleTokens(poolListRaw),
                    );

                    context.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
