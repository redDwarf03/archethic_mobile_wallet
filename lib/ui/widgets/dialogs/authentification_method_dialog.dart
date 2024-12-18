/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/domain/models/core/failures.dart';
import 'package:aewallet/infrastructure/datasources/vault/vault.dart';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:aewallet/ui/widgets/dialogs/authentification_method_dialog_help.dart';
import 'package:aewallet/util/biometrics_util.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

extension AuthMethodAvailability on AuthMethod {
  Future<bool> isAvailable(WidgetRef ref) async {
    if (kIsWeb && this != AuthMethod.password) {
      return false;
    }
    final hasBiometrics = await sl.get<BiometricUtil>().hasBiometrics();
    if (this == AuthMethod.biometrics && !hasBiometrics) {
      return false;
    }

    return true;
  }
}

class AuthentificationMethodDialog {
  static Future<void> getDialog(
    BuildContext context,
    WidgetRef ref,
    AuthenticationMethod curAuthMethod,
  ) async {
    final settingsNotifier = ref.read(
      AuthenticationProviders.settings.notifier,
    );
    final pickerItemsList = await Future.wait(
      AuthMethod.values.map(
        (method) async => PickerItem<AuthMethod>(
          AuthenticationMethod(method).getDisplayName(context),
          null,
          AuthenticationMethod.getIcon(method),
          ArchethicTheme.pickerItemIconEnabled,
          method,
          true,
          displayed: await method.isAvailable(ref),
        ),
      ),
    ) as List<PickerItem>;

    await showDialog<AuthMethod>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return aedappfm.PopupTemplate(
          popupContent: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: PickerWidget(
                  scrollable: true,
                  pickerItems: pickerItemsList,
                  selectedIndexes: [curAuthMethod.method.index],
                  onSelected: (value) async {
                    final authMethod = value.value;

                    try {
                      await Vault.instance().updateCipher(
                        AuthFactory.of(context).vaultCipherDelegate(
                          authMethod: authMethod,
                        ),
                      );
                    } on Failure catch (e) {
                      if (e == const Failure.operationCanceled()) {
                        return;
                      }
                      rethrow;
                    }
                    await settingsNotifier.setAuthMethod(
                      authMethod,
                    );
                    if (context.canPop()) context.pop(value.value);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: InkWell(
                  onTap: () async {
                    return AuthentificationMethodDialogHelp.getDialog(
                      context,
                      ref,
                    );
                  },
                  child: Icon(
                    Symbols.help,
                    color: ArchethicTheme.text,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          popupTitle: AppLocalizations.of(context)!.authMethod,
        );
      },
    );
  }
}
