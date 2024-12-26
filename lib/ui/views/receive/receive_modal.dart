import 'dart:ui';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/receive/layouts/components/explorer_button.dart';
import 'package:aewallet/ui/views/receive/layouts/components/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveModal extends ConsumerWidget {
  const ReceiveModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccount = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    final localizations = AppLocalizations.of(context)!;
    final infoQRCode = selectedAccount?.genesisAddress.toUpperCase() ?? '';
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Clipboard.setData(
              ClipboardData(text: infoQRCode),
            );
            UIUtil.showSnackbar(
              localizations.addressCopied,
              context,
              ref,
              ArchethicTheme.text,
              ArchethicTheme.snackBarShadow,
              icon: Symbols.info,
            );
          },
          child: ClipRRect(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    localizations.receiveHeader,
                    style: ArchethicThemeStyles.textStyleSize14W600Primary,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    width: 200,
                    height: 200,
                    child: QrImageView(
                      size: 200,
                      eyeStyle: const QrEyeStyle(color: Colors.black),
                      dataModuleStyle:
                          const QrDataModuleStyle(color: Colors.black),
                      data: infoQRCode,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      infoQRCode,
                      style: ArchethicThemeStyles.textStyleSize12W100Primary
                          .copyWith(letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        localizations.receiveCopy,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                      const SizedBox(width: 7),
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Symbols.content_copy,
                          weight: IconSize.weightM,
                          opticalSize: IconSize.opticalSizeM,
                          grade: IconSize.gradeM,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
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
                ExplorerButton(
                  address: infoQRCode,
                ),
                ShareButton(payload: infoQRCode),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
