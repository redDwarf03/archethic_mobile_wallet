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
    final newText = recipient.when(
      address: (address) => address.address!,
      account: (account) => account.nameDisplayed,
      unknownContact: (name) => name,
    );

    if (sendAddressController.text != newText) {
      sendAddressController.text = newText;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final transfer = ref.watch(TransferFormProvider.transferForm);
    final hasQRCode = ref.watch(DeviceAbilities.hasQRCodeProvider);

    final localizations = AppLocalizations.of(context)!;

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
                                      await ref
                                          .read(
                                            TransferFormProvider
                                                .transferForm.notifier,
                                          )
                                          .setRecipientNameOrAddress(
                                            context: context,
                                            text: text,
                                            apiService:
                                                ref.read(apiServiceProvider),
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
                                          account: (_) => 20,
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
                          await ref
                              .read(TransferFormProvider.transferForm.notifier)
                              .setContactAddress(
                                context: context,
                                address: address,
                                apiService: ref.read(apiServiceProvider),
                              );
                          _updateAdressTextController();
                        }
                      },
                    ),
                  PasteIcon(
                    onPaste: (String value) {
                      sendAddressController.text = value;
                      ref
                          .read(TransferFormProvider.transferForm.notifier)
                          .setRecipientNameOrAddress(
                            context: context,
                            text: value,
                            apiService: ref.read(apiServiceProvider),
                          );
                    },
                  ),
                  TextFieldButton(
                    icon: Symbols.contacts,
                    onPressed: () async {
                      final accounts =
                          await ref.read(accountsNotifierProvider.future);
                      final accountSelected = await ref
                          .read(accountsNotifierProvider.future)
                          .selectedAccount;
                      final filteredAccounts = accounts
                        ..removeWhere(
                          (element) =>
                              element.format.toUpperCase() ==
                              accountSelected?.format.toUpperCase(),
                        );

                      final account = await AccountsDialog.selectSingleAccount(
                        context: context,
                        accounts: filteredAccounts,
                        dialogTitle: localizations.accountsHeader,
                        isModal: true,
                        heightFactor: 0.5,
                      );

                      if (account == null) return;
                      sendAddressController.text = account.nameDisplayed;
                      ref
                          .read(TransferFormProvider.transferForm.notifier)
                          .setRecipient(
                            context: context,
                            contact:
                                TransferRecipient.account(account: account),
                          );
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
