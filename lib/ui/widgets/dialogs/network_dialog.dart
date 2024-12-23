import 'package:aewallet/application/network/provider.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/model/available_networks.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/app_text_field.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:aewallet/ui/widgets/components/popup_dialog.dart';
import 'package:aewallet/util/url_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NetworkDialog extends ConsumerWidget {
  const NetworkDialog({
    super.key,
  });
  static const routerPage = '/network_dialog';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curNetworksSetting = ref.watch(
      SettingsProviders.settings.select((value) => value.network),
    );

    final localizations = AppLocalizations.of(context)!;
    final endpointFocusNode = FocusNode();
    final endpointController = TextEditingController();

    final pickerItemsList = List<PickerItem>.empty(growable: true);
    for (final value in AvailableNetworks.values) {
      var _networkDevEndpoint = '';
      if (value == AvailableNetworks.archethicDevNet &&
          _networkDevEndpoint.isEmpty) {
        _networkDevEndpoint = 'http://localhost:4000';
      }
      final networkSetting = NetworksSetting(
        network: value,
        networkDevEndpoint: _networkDevEndpoint,
      );
      pickerItemsList.add(
        PickerItem(
          networkSetting.getDisplayName(context),
          networkSetting.getLink(),
          '${ArchethicTheme.assetsFolder}logo_white.png',
          null,
          networkSetting,
          true,
        ),
      );
    }

    return PopupDialog(
      title: const _NetworkTitle(),
      content: PickerWidget(
        pickerItems: pickerItemsList,
        selectedIndexes: [curNetworksSetting.getIndex()],
        onSelected: (value) async {
          final selectedNetworkSettings = value.value as NetworksSetting;
          await ref
              .read(SettingsProviders.settings.notifier)
              .setNetwork(selectedNetworkSettings);
          await ref.read(SettingsProviders.settings.notifier).setTestnetEnabled(
                selectedNetworkSettings.network !=
                    AvailableNetworks.archethicMainNet,
              );

          // If selected network is DevNet
          // Show a dialog to enter a custom network
          // else use the network selected
          if (selectedNetworkSettings.network ==
              AvailableNetworks.archethicDevNet) {
            endpointController.text =
                selectedNetworkSettings.networkDevEndpoint;

            await showDialog<AvailableNetworks>(
              barrierDismissible: false,
              context: context,
              useRootNavigator: false,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return _NetworkDialogCustomInput(
                      endpointFocusNode: endpointFocusNode,
                      endpointController: endpointController,
                      onSubmitNetwork: () async {
                        void setError(String errorText) {
                          UIUtil.showSnackbar(
                            errorText,
                            context,
                            ref,
                            ArchethicTheme.text,
                            ArchethicTheme.snackBarShadow,
                          );
                        }

                        if (endpointController.text.isEmpty) {
                          setError(localizations.enterEndpointBlank);
                          return;
                        }

                        if (!UrlUtil.isUrlValid(endpointController.text)) {
                          setError(localizations.enterEndpointNotValid);
                          return;
                        }

                        final uriInput =
                            UrlUtil.convertUri(endpointController.text);

                        if (await ref.watch(
                          NetworkProvider.isReservedNodeUri(
                            uri: uriInput,
                          ).future,
                        )) {
                          setError(
                            localizations.enterEndpointUseByNetwork,
                          );
                          return;
                        }

                        await ref
                            .read(
                              SettingsProviders.settings.notifier,
                            )
                            .setNetwork(
                              NetworksSetting(
                                network: AvailableNetworks.archethicDevNet,
                                networkDevEndpoint: uriInput.toString(),
                              ),
                            );

                        context.pop();
                      },
                    );
                  },
                );
              },
            );
          }

          context.pop(selectedNetworkSettings);
        },
      ),
    );
  }
}

class _NetworkDialogCustomInput extends ConsumerWidget {
  const _NetworkDialogCustomInput({
    required this.endpointFocusNode,
    required this.endpointController,
    required this.onSubmitNetwork,
  });

  final FocusNode endpointFocusNode;
  final TextEditingController endpointController;
  final Function() onSubmitNetwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return PopupDialog(
      title: const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: _NetworkDevnetHeader(),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppTextField(
                key: const Key('networkChoice'),
                leftMargin: 0,
                rightMargin: 0,
                focusNode: endpointFocusNode,
                controller: endpointController,
                labelText: localizations.enterEndpoint,
                keyboardType: TextInputType.text,
                style: ArchethicThemeStyles.textStyleSize14W600Primary,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(200),
                ],
              ),
              Text(
                'http://xxx.xxx.xxx.xxx:xxxx',
                style: ArchethicThemeStyles.textStyleSize12W100Primary,
              ),
              const SizedBox(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              AppButtonTiny(
                AppButtonTinyType.primary,
                localizations.ok,
                Dimens.buttonTopDimens,
                key: const Key('addEndpoint'),
                onPressed: onSubmitNetwork,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetworkTitle extends ConsumerWidget {
  const _NetworkTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        localizations.networksHeader,
        style: ArchethicThemeStyles.textStyleSize24W700Primary,
      ),
    );
  }
}

class _NetworkDevnetHeader extends ConsumerWidget {
  const _NetworkDevnetHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Image.asset(
          '${ArchethicTheme.assetsFolder}logo_white.png',
          height: 30,
        ),
        Text(
          key: const Key('networkName'),
          ref.read(SettingsProviders.settings).network.getDisplayName(context),
          style: ArchethicThemeStyles.textStyleSize10W100Primary,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          localizations.enterEndpointHeader,
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        ),
      ],
    );
  }
}
