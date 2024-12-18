/// SPDX-License-Identifier: AGPL-3.0-or-later
part of '../settings_sheet.dart';

class _SettingsListItemWithDefaultValue extends _SettingsListItem {
  const _SettingsListItemWithDefaultValue({
    required this.heading,
    required this.defaultValue,
    required this.icon,
    required this.onPressed,
  });

  final String heading;
  final SettingSelectionItem defaultValue;
  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      ignoring: false,
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(),
          ),
        ),
        // ignore: unnecessary_lambdas
        onPressed: () {
          onPressed();
        },
        child: Container(
          height: 65,
          margin: const EdgeInsetsDirectional.only(start: 10),
          child: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsetsDirectional.only(end: 13),
                child: IconDataWidget(
                  icon: icon,
                  width: AppFontSizes.size28,
                  height: AppFontSizes.size28,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      heading,
                      style: ArchethicThemeStyles.textStyleSize16W600Primary,
                    ),
                    AutoSizeText(
                      defaultValue.getDisplayName(context),
                      style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      maxLines: 1,
                      stepGranularity: 0.1,
                      minFontSize: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
