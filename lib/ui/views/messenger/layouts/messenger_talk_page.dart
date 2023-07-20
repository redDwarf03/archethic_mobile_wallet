import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/market_price.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/settings/theme.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/messenger/message.dart';
import 'package:aewallet/ui/util/amount_formatters.dart';
import 'package:aewallet/ui/util/contact_formatters.dart';
import 'package:aewallet/ui/util/styles.dart';
import 'package:aewallet/ui/views/messenger/bloc/providers.dart';
import 'package:aewallet/ui/views/messenger/layouts/talk_details_sheet.dart';
import 'package:aewallet/ui/widgets/components/sheet_util.dart';
import 'package:aewallet/util/currency_util.dart';
import 'package:aewallet/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MessengerTalkPage extends ConsumerWidget {
  const MessengerTalkPage({
    super.key,
    required this.talkAddress,
  });

  final String talkAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);

    final talk = ref.watch(MessengerProviders.talk(talkAddress));
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            theme.background3Small!,
          ),
          fit: BoxFit.fitHeight,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[theme.backgroundDark!, theme.background!],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: talk.maybeMap(
            data: (data) {
              final displayName = ref.watch(
                MessengerProviders.talkDisplayName(data.value),
              );

              return InkWell(
                onTap: () {
                  Sheets.showAppHeightNineSheet(
                    context: context,
                    ref: ref,
                    widget: TalkDetailsSheet(talkAddress: talkAddress),
                  );
                },
                child: Text(displayName),
              );
            },
            orElse: () => const Text('           ')
                .animate(
                  onComplete: (controller) =>
                      controller.repeat(period: 1.seconds),
                )
                .shimmer(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _MessagesList(
                talkAddress: talkAddress,
              ),
            ),
            _MessageSendForm(
              talkAddress: talkAddress,
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageSendForm extends ConsumerStatefulWidget {
  const _MessageSendForm({
    required this.talkAddress,
  });

  final String talkAddress;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __MessageSendFormState();
}

class __MessageSendFormState extends ConsumerState<_MessageSendForm> {
  late TextEditingController textEditingController;
  late FocusNode messageFocusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    messageFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(ThemeProviders.selectedTheme);
    final isCreating = ref.watch(
      MessengerProviders.messageCreationForm(widget.talkAddress)
          .select((value) => value.isCreating),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: _MessageTextField(
                    talkAddress: widget.talkAddress,
                    textEditingController: textEditingController,
                    focusNode: messageFocusNode,
                  ),
                ),
              ),
              if (isCreating)
                SizedBox(
                  width: 55,
                  height: 20,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: theme.text,
                      ),
                    ),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: ref
                          .watch(
                            MessengerProviders.messageCreationForm(
                              widget.talkAddress,
                            ),
                          )
                          .text
                          .isEmpty
                      ? null
                      : () async {
                          await ref
                              .read(
                                MessengerProviders.messageCreationForm(
                                  widget.talkAddress,
                                ).notifier,
                              )
                              .createMessage();

                          textEditingController.text = ref
                              .read(
                                MessengerProviders.messageCreationForm(
                                  widget.talkAddress,
                                ),
                              )
                              .text;
                          messageFocusNode.requestFocus();
                        },
                  icon: Icon(
                    Icons.send,
                    color: theme.text,
                  ),
                  label: Container(),
                ),
            ],
          ),
          const SizedBox(height: 6),
          _MessageCreationFormFees(talkAddress: widget.talkAddress),
        ],
      ),
    );
  }
}

class _MessageTextField extends ConsumerWidget {
  const _MessageTextField({
    required this.talkAddress,
    required this.textEditingController,
    required this.focusNode,
  });

  final TextEditingController textEditingController;
  final String talkAddress;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);

    return Stack(
      children: [
        TextField(
          autofocus: true,
          maxLines: null,
          controller: textEditingController,
          focusNode: focusNode,
          onChanged: (value) => ref
              .read(
                MessengerProviders.messageCreationForm(
                  talkAddress,
                ).notifier,
              )
              .setText(value),
        ),
        Positioned(
          bottom: 1,
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: theme.gradient,
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageCreationFormFees extends ConsumerWidget {
  const _MessageCreationFormFees({
    required this.talkAddress,
  });

  final String talkAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);
    final text =
        ref.watch(MessengerProviders.messageCreationForm(talkAddress)).text;

    if (text.isEmpty) return const SizedBox(height: 12);

    final nativeFeeEstimation = ref
        .watch(
          MessengerProviders.messageCreationFees(
            talkAddress,
            text,
          ),
        )
        .valueOrNull;

    if (nativeFeeEstimation == null) {
      return LoadingAnimationWidget.prograssiveDots(
        color: theme.text!,
        size: 12,
      );
    }

    final fiatFeeEstimation = ref
        .watch(
          MarketPriceProviders.convertedToSelectedCurrency(
            nativeAmount: nativeFeeEstimation,
          ),
        )
        .valueOrNull;

    if (fiatFeeEstimation == null) {
      return LoadingAnimationWidget.prograssiveDots(
        color: theme.text!,
        size: 12,
      );
    }

    final currencyName = ref
        .watch(
          SettingsProviders.settings.select((settings) => settings.currency),
        )
        .name;

    return SizedBox(
      height: 12,
      child: Text(
        '+ ${AmountFormatters.standardSmallValue(
          nativeFeeEstimation,
          AccountBalance.cryptoCurrencyLabel,
        )} (${CurrencyUtil.formatWithNumberOfDigits(
          currencyName,
          fiatFeeEstimation,
          2,
        )})',
        style: theme.textStyleSize12W100Primary,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MessagesList extends ConsumerWidget {
  const _MessagesList({
    required this.talkAddress,
  });
  final String talkAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);
    final me = ref.watch(ContactProviders.getSelectedContact).valueOrNull;
    final pagingController =
        ref.watch(MessengerProviders.paginatedMessages(talkAddress));

    if (me == null) return Container();

    return PagedListView(
      pagingController: pagingController,
      shrinkWrap: true,
      reverse: true,
      builderDelegate: PagedChildBuilderDelegate<TalkMessage>(
        itemBuilder: (context, message, index) {
          final isSentByMe = message.senderGenesisPublicKey == me.publicKey;

          if (isSentByMe) {
            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 42, right: 8, bottom: 8),
                child: _MessageItem(
                  key: Key(message.address),
                  color: theme.background!,
                  message: message,
                  showSender: false,
                ),
              ),
            );
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 42, bottom: 8),
              child: _MessageItem(
                key: Key(message.address),
                color: theme.iconDataWidgetIconBackground!,
                message: message,
                showSender: true,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageItem extends ConsumerWidget {
  const _MessageItem({
    required this.message,
    required this.color,
    required this.showSender,
    super.key,
  });

  final TalkMessage message;
  final Color color;
  final bool showSender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(ThemeProviders.selectedTheme);

    final _contact = ref.watch(
      ContactProviders.getContactWithGenesisPublicKey(
        message.senderGenesisPublicKey,
      ),
    );

    return Card(
      shape: showSender
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            )
          : const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSender)
              _contact.maybeWhen(
                data: (contact) {
                  return Text(
                    contact?.format ?? '',
                    style: theme.textStyleSize12W600Primary,
                  );
                },
                loading: () => const SizedBox(),
                orElse: () => const SizedBox(),
              ),
            const SizedBox(height: 3),
            SelectableText(
              message.content,
              style: theme.textStyleSize12W400Primary,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                message.date.format(context),
                style: theme.textStyleSize10W100Primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
