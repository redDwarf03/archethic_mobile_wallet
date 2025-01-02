import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeFailure extends StatelessWidget {
  const HomeFailure({
    this.helpCallback,
    this.retryCallback,
    this.removeWalletCallback,
    this.restoreFailedInfo2Label,
    super.key,
  });

  final VoidCallback? helpCallback;
  final VoidCallback? retryCallback;
  final VoidCallback? removeWalletCallback;
  final String? restoreFailedInfo2Label;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SheetSkeleton(
      appBar: SheetAppBar(
        title: localizations.restoreFailedTitle,
        widgetAfterTitle: Text(
          localizations.restoreFailedSubtitle,
          style: ArchethicThemeStyles.textStyleSize14W600Primary,
          textAlign: TextAlign.center,
        ),
      ),
      menu: true,
      sheetContent: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ArchethicTheme.backgroundSmall,
            ),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            opacity: 0.7,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 32,
            right: 32,
            bottom: 32,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Text(
                  localizations.restoreFailedInfo1,
                  style: ArchethicThemeStyles.textStyleSize16W700Primary,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  restoreFailedInfo2Label ?? localizations.restoreFailedInfo2,
                  style: ArchethicThemeStyles.textStyleSize14W400Highlighted,
                  textAlign: TextAlign.start,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (helpCallback != null)
            TextButton(
              onPressed: helpCallback,
              child: Text(
                localizations.getSomeHelp,
              ),
            ),
          if (retryCallback != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppButtonTiny(
                  AppButtonTinyType.primary,
                  localizations.retry,
                  Dimens.buttonBottomDimens,
                  onPressed: retryCallback,
                ),
              ],
            ),
          const SizedBox(
            height: 12,
          ),
          if (removeWalletCallback != null)
            Container(
              height: 50,
              margin: Dimens.buttonBottomDimens.edgeInsetsDirectional,
              child: FilledButton(
                onPressed: removeWalletCallback,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: ArchethicThemeStyles
                      .textStyleSize16W400MainButtonLabel.color,
                ),
                child: Row(
                  children: [
                    const Icon(Symbols.delete),
                    const Spacer(),
                    Text(
                      localizations.removeWalletLight,
                      style: ArchethicThemeStyles
                          .textStyleSize16W400MainButtonLabel,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
