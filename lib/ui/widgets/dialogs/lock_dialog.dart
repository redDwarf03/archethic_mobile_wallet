/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/model/device_unlock_option.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LockDialog {
  static Future<UnlockSetting?> getDialog(
    BuildContext context,
    WidgetRef ref,
    UnlockSetting curUnlockSetting,
  ) async {
    final pickerItemsList = List<PickerItem>.empty(growable: true);
    for (final value in UnlockOption.values) {
      pickerItemsList.add(
        PickerItem(
          UnlockSetting(value).getDisplayName(context),
          null,
          null,
          null,
          value,
          true,
        ),
      );
    }
    return showDialog<UnlockSetting>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ArchethicTheme.backgroundPopupColor,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context)!.lockAppSetting,
            style: ArchethicThemeStyles.textStyleSize24W700Primary,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          content: SingleChildScrollView(
            child: PickerWidget(
              pickerItems: pickerItemsList,
              selectedIndexes: [curUnlockSetting.setting.index],
              onSelected: (value) {
                final pickedOption = value.value as UnlockOption;

                ref
                    .read(AuthenticationProviders.settings.notifier)
                    .setLockApp(pickedOption);

                Navigator.pop(
                  context,
                  UnlockSetting(pickedOption),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
