/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/themes/archethic_theme_base.dart';
import 'package:aewallet/ui/util/accounts_dialog.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/dialogs/network_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class NetworkChange extends ConsumerWidget {
  const NetworkChange({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(environmentProvider);
    final selectedAccount = ref.watch(
      AccountProviders.accounts.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    final settings = ref.watch(SettingsProviders.settings);
    final localizations = AppLocalizations.of(context)!;

    if (selectedAccount == null) return const SizedBox();

    return InkWell(
      onTap: settings.devMode
          ? () async {
              final _saveNetwork = settings.network;
              await context.push(NetworkDialog.routerPage);
              final _settings = ref.read(SettingsProviders.settings);
              if (_settings.network.network != _saveNetwork.network) {
                context.loadingOverlay.show(
                  title: AppLocalizations.of(context)!.pleaseWaitChangeNetwork,
                );
                final languageSeed = ref.read(
                  SettingsProviders.settings.select(
                    (settings) => settings.languageSeed,
                  ),
                );
                final seed =
                    ref.read(sessionNotifierProvider).loggedIn?.wallet.seed;
                if (seed != null) {
                  try {
                    await ref
                        .read(sessionNotifierProvider.notifier)
                        .restoreFromSeed(
                          seed: seed,
                          languageCode: languageSeed,
                        );
                    context.loadingOverlay.hide();
                  } on ArchethicKeychainNotExistsException catch (_) {
                    context.loadingOverlay.hide();
                    context.pop();
                    final session = ref.read(sessionNotifierProvider);
                    await AccountsDialog.selectMultipleAccounts(
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
                                _saveNetwork.getDisplayName(context),
                              ),
                              style: AppTextStyles.bodySmall(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
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
          if (settings.devMode)
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
