/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/usecases.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/archethic_theme_base.dart';
import 'package:aewallet/ui/util/accounts_dialog.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/environment_dialog.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnvironmentChange extends ConsumerWidget {
  const EnvironmentChange({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(environmentProvider);
    final selectedAccount = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    final settings = ref.watch(SettingsProviders.settings);
    final localizations = AppLocalizations.of(context)!;

    if (selectedAccount == null) return const SizedBox();

    return InkWell(
      onTap: settings.testnetEnabled
          ? () async {
              final _saveEnvironment = settings.environment;
              final _selectedEnvironment = await context
                  .push(EnvironmentDialog.routerPage) as aedappfm.Environment?;
              if (_selectedEnvironment == null) return;
              if (_selectedEnvironment != _saveEnvironment) {
                final seed =
                    ref.read(sessionNotifierProvider).loggedIn?.wallet.seed;

                var keychainNetworkExists = false;
                try {
                  await archethic.ApiService(
                    _selectedEnvironment.endpoint,
                  ).getKeychain(seed!);
                  keychainNetworkExists = true;
                  // ignore: empty_catches
                } catch (e) {}

                if (keychainNetworkExists == false) {
                  final session = ref.read(sessionNotifierProvider);

                  final accounts = await AccountsDialog.selectMultipleAccounts(
                    context: context,
                    accounts: session.loggedIn!.wallet.appKeychain.accounts,
                    confirmBtnLabel:
                        localizations.networkChangeCreateKeychainBtn,
                    dialogTitle: localizations.networkChangeHeader,
                    isModal: true,
                    header: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            localizations.networkChangeKeychainNotExists(
                              _selectedEnvironment.displayName,
                            ),
                            style: AppTextStyles.bodySmall(context),
                          ),
                        ],
                      ),
                    ),
                  );

                  final nameList = <String>[];
                  if (accounts == null || accounts.isEmpty) {
                    return;
                  }
                  for (final account in accounts) {
                    nameList.add(Uri.decodeFull(account.name));
                  }

                  try {
                    context.loadingOverlay.show(
                      title:
                          AppLocalizations.of(context)!.pleaseWaitChangeNetwork,
                    );
                    await ref.read(createNewAppWalletCaseProvider).run(
                          seed!,
                          archethic.ApiService(_selectedEnvironment.endpoint),
                          nameList,
                        );

                    UIUtil.showSnackbar(
                      localizations.walletCreatedTargetEnv(
                        _selectedEnvironment.displayName,
                      ),
                      context,
                      ref,
                      ArchethicTheme.text,
                      ArchethicTheme.snackBarShadow,
                      duration: const Duration(milliseconds: 5000),
                      icon: Symbols.info,
                    );
                  } catch (e) {
                    UIUtil.showSnackbar(
                      '${localizations.walletNotCreatedTargetEnv(_selectedEnvironment.displayName)} ($e)',
                      context,
                      ref,
                      ArchethicTheme.text,
                      ArchethicTheme.snackBarShadow,
                      duration: const Duration(milliseconds: 5000),
                    );

                    context.loadingOverlay.hide();
                    context.pop();
                    return;
                  }
                } else {
                  context.loadingOverlay.show(
                    title:
                        AppLocalizations.of(context)!.pleaseWaitChangeNetwork,
                  );
                }

                try {
                  final languageSeed = ref.read(
                    SettingsProviders.settings.select(
                      (settings) => settings.languageSeed,
                    ),
                  );
                  await ref
                      .read(SettingsProviders.settings.notifier)
                      .setEnvironment(_selectedEnvironment);

                  await ref
                      .read(sessionNotifierProvider.notifier)
                      .restoreFromSeed(
                        seed: seed!,
                        languageCode: languageSeed,
                      );

                  final accounts =
                      await ref.read(accountsNotifierProvider.future);

                  await ref
                      .read(accountsNotifierProvider.notifier)
                      .selectAccount(accounts.first);

                  final poolListRaw =
                      await ref.read(DexPoolProviders.getPoolListRaw.future);

                  unawaited(
                    (await ref
                            .read(accountsNotifierProvider.notifier)
                            .selectedAccountNotifier)
                        ?.refreshAll(poolListRaw),
                  );
                  context.loadingOverlay.hide();
                } catch (e) {
                  UIUtil.showSnackbar(
                    '${localizations.walletChangeLoadingError} ($e)',
                    context,
                    ref,
                    ArchethicTheme.text,
                    ArchethicTheme.snackBarShadow,
                    duration: const Duration(milliseconds: 5000),
                  );

                  await ref
                      .read(SettingsProviders.settings.notifier)
                      .setEnvironment(_saveEnvironment);

                  context.loadingOverlay.hide();
                  context.pop();
                }
              }
            }
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              child: Text(
                environment.label,
                style: AppTextStyles.bodyMediumSecondaryColor(
                  context,
                ),
              ),
            ),
          ),
          if (settings.testnetEnabled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Symbols.keyboard_arrow_down,
                    color: ArchethicThemeBase.neutral0,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
