import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/add_custom_token/bloc/provider.dart';
import 'package:aewallet/ui/views/transfer/layouts/components/transfer_tokens_list.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AddCustomTokenTextFieldAddress extends ConsumerStatefulWidget {
  const AddCustomTokenTextFieldAddress({
    this.myTokens,
    super.key,
  });

  final List<aedappfm.AEToken>? myTokens;

  @override
  ConsumerState<AddCustomTokenTextFieldAddress> createState() =>
      _AddCustomTokenTextFieldAddressState();
}

class _AddCustomTokenTextFieldAddressState
    extends ConsumerState<AddCustomTokenTextFieldAddress> {
  late TextEditingController addressController;
  late FocusNode addressFocusNode;

  @override
  void initState() {
    super.initState();
    addressFocusNode = FocusNode();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    addressFocusNode.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final addCustomTokenFormNotifier =
        ref.watch(addCustomTokenFormNotifierProvider.notifier);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            AppLocalizations.of(context)!.customTokenAddTextFieldLabel,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              width: 0.5,
                            ),
                            gradient:
                                ArchethicTheme.gradientInputFormBackground,
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            autocorrect: false,
                            textAlignVertical: TextAlignVertical.center,
                            maxLines: 3,
                            maxLength: 68,
                            controller: addressController,
                            onChanged: (text) async {
                              await addCustomTokenFormNotifier.setTokenAddress(
                                AppLocalizations.of(context)!,
                                text,
                              );
                            },
                            focusNode: addressFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(
                                68,
                              ),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ),
                      aedappfm.TextFieldButton(
                        icon: Symbols.data_loss_prevention,
                        onPressed: () async {
                          final tokenSelected =
                              await showCupertinoModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 1,
                                child: Scaffold(
                                  backgroundColor: aedappfm
                                      .AppThemeBase.sheetBackground
                                      .withOpacity(0.2),
                                  body: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15),
                                          child: Text(
                                            localizations
                                                .customTokenAddSelectionTokenTitle,
                                            style: ArchethicThemeStyles
                                                .textStyleSize16W600Primary,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        TransferTokensList(
                                          withUCO: false,
                                          withLPToken: true,
                                          withNotVerified: true,
                                          withCustomToken: false,
                                          myTokens: widget.myTokens,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ) as aedappfm.AEToken;
                          if (tokenSelected.address != null) {
                            addressController.text = tokenSelected.address!;
                            await ref
                                .read(
                                  addCustomTokenFormNotifierProvider.notifier,
                                )
                                .setTokenAddress(
                                  localizations,
                                  tokenSelected.address!,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 200))
        .scale(duration: const Duration(milliseconds: 200));
  }
}
