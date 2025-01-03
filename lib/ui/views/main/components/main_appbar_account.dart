import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/archethic_theme_base.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/accounts/layouts/account_list.dart';
import 'package:aewallet/ui/views/accounts/layouts/components/add_account_button.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainAppBarAccount extends ConsumerWidget {
  const MainAppBarAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final keychain = ref.watch(
      sessionNotifierProvider.select(
        (value) => value.loggedIn?.wallet.appKeychain,
      ),
    );
    final selectedAccount = ref
        .watch(
          accountsNotifierProvider,
        )
        .valueOrNull
        ?.selectedAccount;
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: InkWell(
        onTap: () async {
          await showCupertinoModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 1,
                child: Scaffold(
                  backgroundColor:
                      aedappfm.AppThemeBase.sheetBackground.withOpacity(0.2),
                  body: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text:
                                          keychain?.address.toUpperCase() ?? '',
                                    ),
                                  );
                                  UIUtil.showSnackbar(
                                    localizations.keychainAddressCopied,
                                    context,
                                    ref,
                                    ArchethicTheme.text,
                                    ArchethicTheme.snackBarShadow,
                                    icon: Symbols.info,
                                  );
                                },
                                child: Text(
                                  localizations.accountsHeader,
                                  style: ArchethicThemeStyles
                                      .textStyleSize16W600Primary,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 5),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(Icons.info, size: 16),
                                    ),
                                    TextSpan(
                                      text:
                                          ' ${localizations.accountsListWarningRemoveAccount}',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary,
                                    ),
                                    TextSpan(
                                      text:
                                          ' (${localizations.accountsListWarningRemoveAccountConfirmRequired})',
                                      style: ArchethicThemeStyles
                                          .textStyleSize12W100Primary
                                          .copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const AccountsList(),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 20,
                          ),
                          child: const Row(
                            children: [
                              AddAccountButton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Row(
          children: [
            Text(
              selectedAccount?.nameDisplayed ?? ' ',
              style: ArchethicThemeStyles.textStyleSize24W700Primary.copyWith(
                color: aedappfm.AppThemeBase.secondaryColor,
              ),
            ),
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
    ).animate().fade(duration: const Duration(milliseconds: 300));
  }
}
