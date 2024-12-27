/// SPDX-License-Identifier: AGPL-3.0-or-later
part of '../transfer_sheet.dart';

class TransferTextFieldAmount extends ConsumerStatefulWidget {
  const TransferTextFieldAmount({
    super.key,
  });

  @override
  ConsumerState<TransferTextFieldAmount> createState() =>
      _TransferTextFieldAmountState();
}

class _TransferTextFieldAmountState
    extends ConsumerState<TransferTextFieldAmount> {
  late TextEditingController sendAmountController;
  late FocusNode sendAmountFocusNode;

  @override
  void initState() {
    super.initState();

    sendAmountFocusNode = FocusNode();
    sendAmountController = TextEditingController();
    _updateAmountTextController();
  }

  @override
  void dispose() {
    sendAmountFocusNode.dispose();
    sendAmountController.dispose();
    super.dispose();
  }

  void _updateAmountTextController() {
    final transfer = ref.read(TransferFormProvider.transferForm);
    sendAmountController.text = transfer.amount == 0
        ? ''
        : AmountFormatters.withoutCurrency(
            transfer.amount,
          );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;
    final transfer = ref.watch(TransferFormProvider.transferForm);
    final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);
    final accountSelected = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );

    final price = transfer.aeToken == null
        ? null
        : ref
            .watch(
              aedappfm.AETokensProviders.estimateTokenInFiat(
                transfer.aeToken!,
              ),
            )
            .valueOrNull;

    if (accountSelected == null) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            transfer.transferType == null
                ? localizations.enterAmount
                : transfer.transferType == TransferType.uco
                    ? primaryCurrency.primaryCurrency ==
                            AvailablePrimaryCurrencyEnum.native
                        ? localizations.enterAmountIn
                            .replaceFirst('%1', transfer.symbol(context))
                        : AppLocalizations.of(context)!
                            .enterAmountIn
                            .replaceFirst(
                              '%1',
                              AvailableCurrencyEnum.usd.name.toUpperCase(),
                            )
                    : localizations.enterAmountIn.replaceFirst(
                        '%1',
                        transfer.symbol(context),
                      ),
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
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          _textFieldAmount(),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                            ),
                            child: TransferTokenSelection(),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _maxBtn(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              _price(price),
              _tokenBalance(price),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 200))
        .scale(duration: const Duration(milliseconds: 200));
  }

  Widget _textFieldAmount() {
    final localCurrencyFormat = NumberFormat.currency(
      locale: CurrencyUtil.getLocale().toString(),
      symbol: CurrencyUtil.getCurrencySymbol(),
    );
    final transferNotifier =
        ref.watch(TransferFormProvider.transferForm.notifier);
    final primaryCurrency = ref.watch(selectedPrimaryCurrencyProvider);

    return Row(
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                10,
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.5,
              ),
              gradient: ArchethicTheme.gradientInputFormBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 110,
                right: 20,
              ),
              child: TextField(
                style: const TextStyle(
                  fontSize: 14,
                ),
                autocorrect: false,
                controller: sendAmountController,
                onChanged: (String text) async {
                  await transferNotifier.setAmount(
                    context: context,
                    amount: double.tryParse(
                          text.replaceAll(' ', ''),
                        ) ??
                        0,
                  );
                },
                textInputAction: TextInputAction.next,
                maxLines: null,
                focusNode: sendAmountFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  AmountTextInputFormatter(
                    precision: primaryCurrency.primaryCurrency ==
                            AvailablePrimaryCurrencyEnum.native
                        ? 8
                        : localCurrencyFormat.decimalDigits!,
                  ),
                  LengthLimitingTextInputFormatter(
                    16,
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
      ],
    );
  }

  Widget _price(double? price) {
    final transfer = ref.watch(TransferFormProvider.transferForm);
    if (transfer.transferType == null) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (price != null)
              Container(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  '1 ${transfer.symbol(context)} = \$${price.formatNumber(precision: 4)}',
                  style: ArchethicThemeStyles.textStyleSize14W200Primary,
                ),
              ),
            if (transfer.aeToken != null)
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  VerifiedTokenIcon(
                    address: transfer.aeToken!.isUCO
                        ? kUCOAddress
                        : transfer.aeToken!.address!,
                  ),
                ],
              ),
          ],
        ),
        if (transfer.amount != 0 && price != null)
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              '= \$${(price * transfer.amount).formatNumber(precision: 2)}',
              textAlign: TextAlign.right,
              style: ArchethicThemeStyles.textStyleSize14W200Primary,
            ),
          ),
      ],
    );
  }

  Widget _tokenBalance(double? price) {
    final transfer = ref.watch(TransferFormProvider.transferForm);
    if (transfer.aeToken == null || transfer.aeToken!.isUCO) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            '${localizations.tokenBalance}:',
            style: ArchethicThemeStyles.textStyleSize14W200Primary,
          ),
          Row(
            children: [
              AutoSizeText(
                minFontSize: 5,
                wrapWords: false,
                transfer.aeToken!.isLpToken
                    ? '${transfer.aeToken!.balance.formatNumber(precision: transfer.aeToken!.balance > 1 ? 2 : 4)} LP (${transfer.aeToken!.lpTokenPair!.token1.symbol.reduceSymbol()}/${transfer.aeToken!.lpTokenPair!.token2.symbol.reduceSymbol()})'
                    : '${transfer.aeToken!.balance.formatNumber(precision: transfer.aeToken!.balance > 1 ? 2 : 4)} ${transfer.aeToken!.symbol.reduceSymbol(lengthMax: 10)}',
                style: ArchethicThemeStyles.textStyleSize14W200Primary,
              ),
              if (price != null)
                AutoSizeText(
                  minFontSize: 5,
                  wrapWords: false,
                  ' / \$${(price * transfer.aeToken!.balance).formatNumber(precision: 2)}',
                  style: ArchethicThemeStyles.textStyleSize14W200Primary,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _maxBtn() {
    final transfer = ref.watch(TransferFormProvider.transferForm);
    if (transfer.transferType == null) return const SizedBox.shrink();

    final transferNotifier =
        ref.watch(TransferFormProvider.transferForm.notifier);

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () async {
          transferNotifier.setDefineMaxAmountInProgress(
            defineMaxAmountInProgress: true,
          );
          if (transferNotifier.controlMaxSend(context) == false) {
            transferNotifier.setDefineMaxAmountInProgress(
              defineMaxAmountInProgress: false,
            );
            return;
          }

          await transferNotifier.setMaxAmount(
            context: context,
          );
          _updateAmountTextController();
          transferNotifier.setDefineMaxAmountInProgress(
            defineMaxAmountInProgress: false,
          );
        },
        child: Text(
          'MAX',
          style: TextStyle(color: ArchethicTheme.maxButtonColor),
        )
            .animate()
            .fade(
              duration: const Duration(milliseconds: 500),
            )
            .scale(
              duration: const Duration(milliseconds: 500),
            ),
      ),
    );
  }
}
