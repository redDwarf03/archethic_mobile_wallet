import 'package:aewallet/application/contact.dart';
import 'package:aewallet/application/settings/language.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/settings/theme.dart';
import 'package:aewallet/model/available_language.dart';
import 'package:aewallet/model/data/access_recipient.dart';
import 'package:aewallet/ui/util/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/authenticate/auth_factory.dart';
import 'package:aewallet/ui/views/contacts/layouts/contact_detail.dart';
import 'package:aewallet/ui/views/messenger/bloc/providers.dart';
import 'package:aewallet/ui/views/messenger/layouts/components/public_key_line.dart';
import 'package:aewallet/ui/views/messenger/layouts/components/section_title.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/scrollbar.dart';
import 'package:aewallet/ui/widgets/components/sheet_util.dart';
import 'package:aewallet/ui/widgets/components/tap_outside_unfocus.dart';
import 'package:aewallet/util/case_converter.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/haptic_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:material_symbols_icons/symbols.dart';

class DiscussionDetailsPage extends ConsumerStatefulWidget {
  const DiscussionDetailsPage({
    required this.discussionAddress,
    super.key,
  });

  final String discussionAddress;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscussionDetailsPageState();
}

class _DiscussionDetailsPageState extends ConsumerState<DiscussionDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final discussion = await ref
          .read(MessengerProviders.discussion(widget.discussionAddress).future);
      ref
          .watch(MessengerProviders.discussionDetailsForm.notifier)
          .init(discussion);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = ref.watch(ThemeProviders.selectedTheme);
    final settings = ref.watch(SettingsProviders.settings);
    final preferences = ref.watch(SettingsProviders.settings);
    final selectedContact =
        ref.watch(ContactProviders.getSelectedContact).valueOrNull;
    final discussion =
        ref.watch(MessengerProviders.discussion(widget.discussionAddress));

    final formNotifier =
        ref.watch(MessengerProviders.discussionDetailsForm.notifier);

    return discussion.maybeMap(
      data: (data) {
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
              title: Text(localizations.discussionInfo),
              actions: [
                if (selectedContact != null &&
                    data.value.adminsPubKeys.contains(
                      AccessRecipient.contact(contact: selectedContact)
                          .publicKey,
                    ))
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      '/update_discussion',
                      arguments: data.value,
                    ),
                    child: Text(
                      localizations.modify,
                      style: theme.textStyleSize12W400Primary,
                    ),
                  ),
              ],
            ),
            body: TapOutsideUnfocus(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: ArchethicScrollbar(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          ref.watch(
                            MessengerProviders.discussionDisplayName(
                              data.value,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: theme.textStyleSize28W700Primary,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            sl.get<HapticUtil>().feedback(
                                  FeedbackType.light,
                                  preferences.activeVibrations,
                                );
                            Clipboard.setData(
                              ClipboardData(text: widget.discussionAddress),
                            );
                            UIUtil.showSnackbar(
                              localizations.addressCopied,
                              context,
                              ref,
                              theme.text!,
                              theme.snackBarShadow!,
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Symbols.content_copy,
                                color: theme.text,
                                weight: IconSize.weightM,
                                opticalSize: IconSize.opticalSizeM,
                                grade: IconSize.gradeM,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                localizations.addressCopy,
                                style: theme.textStyleSize14W700Primary,
                              ),
                            ],
                          ),
                        ),
                        ExpansionTile(
                          title: SectionTitle(
                            text: localizations.messengerDiscussionMembersCount(
                              data.value.membersPubKeys.length,
                            ),
                          ),
                          children: [
                            Column(
                              children: data.value.membersPubKeys.map((pubKey) {
                                final accessRecipient = ref.watch(
                                  MessengerProviders
                                      .accessRecipientWithPublicKey(
                                    pubKey,
                                  ),
                                );

                                return PublicKeyLine(
                                  listAdmins: data.value.adminsPubKeys,
                                  pubKey: pubKey,
                                  onInfoTap: accessRecipient.maybeMap(
                                    orElse: () => null,
                                    data: (recipient) => recipient.value.map(
                                      contact: (contact) => () {
                                        sl.get<HapticUtil>().feedback(
                                              FeedbackType.light,
                                              settings.activeVibrations,
                                            );

                                        Sheets.showAppHeightNineSheet(
                                          context: context,
                                          ref: ref,
                                          widget: ContactDetail(
                                            contact: contact.contact,
                                          ),
                                        );
                                      },
                                      publicKey: (_) => null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            final language = ref.read(
                              LanguageProviders.selectedLanguage,
                            );

                            AppDialogs.showConfirmDialog(
                              context,
                              ref,
                              CaseChange.toUpperCase(
                                localizations.leaveDiscussion,
                                language.getLocaleString(),
                              ),
                              localizations.areYouSureLeaveDiscussion,
                              localizations.yes,
                              () async {
                                final auth = await AuthFactory.authenticate(
                                  context,
                                  ref,
                                  activeVibrations: ref
                                      .read(SettingsProviders.settings)
                                      .activeVibrations,
                                );
                                if (auth == false) {
                                  return;
                                }
                                await formNotifier.leaveDiscussion();
                              },
                              cancelText: localizations.no,
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Symbols.logout,
                                color: theme
                                    .textStyleSize14W600EquinoxPrimaryRed.color,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                localizations.leaveDiscussion,
                                style:
                                    theme.textStyleSize14W600EquinoxPrimaryRed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      orElse: () => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
