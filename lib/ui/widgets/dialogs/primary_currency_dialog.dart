/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/settings/primary_currency.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/primary_currency.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PrimaryCurrencyDialog {
  static Future<AvailablePrimaryCurrencyEnum?> getDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final pickerItemsList = List<PickerItem>.empty(growable: true);

    for (final value in AvailablePrimaryCurrencyEnum.values) {
      pickerItemsList.add(
        PickerItem(
          AvailablePrimaryCurrency(value).getDisplayName(context),
          null,
          null,
          null,
          value,
          true,
        ),
      );
    }

    return showDialog<AvailablePrimaryCurrencyEnum>(
      barrierDismissible: false,
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);
        return aedappfm.PopupTemplate(
          popupContent: SingleChildScrollView(
            child: PickerWidget(
              pickerItems: pickerItemsList,
              selectedIndexes: [primaryCurrency.getIndex()],
              onSelected: (value) async {
                final primaryCurrency = AvailablePrimaryCurrency(
                  value.value as AvailablePrimaryCurrencyEnum,
                );

                await ref
                    .read(SettingsProviders.settings.notifier)
                    .selectPrimaryCurrency(primaryCurrency);
                context.pop(value.value);
              },
            ),
          ),
          popupTitle: AppLocalizations.of(context)!.primaryCurrency,
        );
      },
    );
  }
}
