/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LanguageDialog {
  static Future<AvailableLanguage?> getDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final pickerItemsList = AvailableLanguage.values
        .map(
          (value) => PickerItem(
            LanguageSetting(value).getDisplayName(context),
            null,
            null,
            null,
            value,
            true,
          ),
        )
        .toList();

    return showDialog<AvailableLanguage>(
      barrierDismissible: false,
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        final selectedLanguage = ref.watch(LanguageProviders.selectedLanguage);
        return aedappfm.PopupTemplate(
          popupContent: SingleChildScrollView(
            child: PickerWidget(
              pickerItems: pickerItemsList,
              selectedIndexes: [selectedLanguage.index],
              onSelected: (value) async {
                await ref
                    .read(SettingsProviders.settings.notifier)
                    .selectLanguage(value.value);
                context.pop(value.value);
              },
            ),
          ),
          popupTitle: AppLocalizations.of(context)!.language,
        );
      },
    );
  }
}
