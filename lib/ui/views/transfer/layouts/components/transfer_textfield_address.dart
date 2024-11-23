/// SPDX-License-Identifier: AGPL-3.0-or-later
part of '../transfer_sheet.dart';

class TransferTextFieldAddress extends ConsumerStatefulWidget {
  const TransferTextFieldAddress({
    super.key,
  });

  @override
  ConsumerState<TransferTextFieldAddress> createState() =>
      _TransferTextFieldAddressState();
}

class _TransferTextFieldAddressState
    extends ConsumerState<TransferTextFieldAddress> {
  late TextEditingController sendAddressController;
  late FocusNode sendAddressFocusNode;

  @override
  void initState() {
    super.initState();
    sendAddressFocusNode = FocusNode();
    sendAddressController = TextEditingController();
    _updateAdressTextController();

    sendAddressFocusNode.addListener(() {
      if (sendAddressFocusNode.hasFocus) {
        sendAddressController.selection = TextSelection.fromPosition(
          TextPosition(offset: sendAddressController.text.length),
        );
        if (sendAddressController.text.startsWith('@')) {
          ContactsHiveDatasource.instance()
              .getContactsWithNameLike(sendAddressController.text)
              .then((List<Contact> contactList) {});
        }
      } else {
        if (sendAddressController.text.trim() == '@') {
          sendAddressController.text = '';
        }
      }
    });
  }

  @override
  void dispose() {
    sendAddressFocusNode.dispose();
    sendAddressController.dispose();
    super.dispose();
  }

  void _updateAdressTextController() {
    final recipient = ref.read(TransferFormProvider.transferForm).recipient;
    sendAddressController.text = recipient.when(
      address: (address) => address.address!,
      contact: (contact) => contact.format,
      unknownContact: (name) => name,
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final transfer = ref.watch(TransferFormProvider.transferForm);
    final transferNotifier =
        ref.watch(TransferFormProvider.transferForm.notifier);
    final hasQRCode = ref.watch(DeviceAbilities.hasQRCodeProvider);
    final apiService = ref.watch(apiServiceProvider);

    if (sendAddressController.text.isNotEmpty) {
      _updateAdressTextController();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            AppLocalizations.of(context)!.enterAddress,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
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
                              child: Opacity(
                                opacity: transfer.recipient.isAddressValid
                                    ? 1.0
                                    : 0.6,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextField(
                                    style: TextStyle(
                                      fontFamily: ArchethicTheme.addressFont,
                                      fontSize: 14,
                                    ),
                                    autocorrect: false,
                                    controller: sendAddressController,
                                    onChanged: (text) async {
                                      await transferNotifier
                                          .setRecipientNameOrAddress(
                                        context: context,
                                        text: text,
                                        apiService: apiService,
                                      );
                                    },
                                    focusNode: sendAddressFocusNode,
                                    textInputAction: TextInputAction.next,
                                    maxLines: null,
                                    keyboardType: TextInputType.text,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(
                                        transfer.recipient.maybeWhen(
                                          address: (_) => 68,
                                          unknownContact: (_) => 68,
                                          contact: (_) => 20,
                                          orElse: () => 20,
                                        ),
                                      ),
                                    ],
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasQRCode)
                    TextFieldButton(
                      icon: Symbols.qr_code_scanner,
                      onPressed: () async {
                        final scanResult = await UserDataUtil.getQRData(
                          DataType.address,
                          context,
                          ref,
                        );
                        if (scanResult == null) {
                          UIUtil.showSnackbar(
                            AppLocalizations.of(context)!.qrInvalidAddress,
                            context,
                            ref,
                            ArchethicTheme.text,
                            ArchethicTheme.snackBarShadow,
                          );
                        } else if (QRScanErrs.errorList.contains(scanResult)) {
                          UIUtil.showSnackbar(
                            scanResult,
                            context,
                            ref,
                            ArchethicTheme.text,
                            ArchethicTheme.snackBarShadow,
                          );
                          return;
                        } else {
                          // Is a URI
                          final address = Address(address: scanResult);
                          await transferNotifier.setContactAddress(
                            context: context,
                            address: address,
                            apiService: apiService,
                          );
                          _updateAdressTextController();
                        }
                      },
                    ),
                  PasteIcon(
                    onPaste: (String value) {
                      sendAddressController.text = value;
                      transferNotifier.setRecipientNameOrAddress(
                        context: context,
                        text: value,
                        apiService: apiService,
                      );
                    },
                  ),
                  TextFieldButton(
                    icon: Symbols.contacts,
                    onPressed: () async {
                      final contact =
                          await ContactsDialog.getDialog(context, ref);
                      if (contact == null) return;

                      transferNotifier.setRecipient(
                        context: context,
                        contact: TransferRecipient.contact(contact: contact),
                      );

                      _updateAdressTextController();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Text(
            AppLocalizations.of(context)!.enterAddressHelp,
            style: ArchethicThemeStyles.textStyleSize10W100Primary,
          ),
        ),
      ],
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 200))
        .scale(duration: const Duration(milliseconds: 200));
  }
}
