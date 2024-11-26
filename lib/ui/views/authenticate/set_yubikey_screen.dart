/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/domain/models/authentication.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/views/authenticate/yubikey_screen.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SetYubikey extends ConsumerStatefulWidget {
  const SetYubikey({
    super.key,
    required this.challenge,
  });

  final Uint8List challenge;

  static const routerPage = '/set_yubikey';

  @override
  ConsumerState<SetYubikey> createState() => _SetYubikeyState();
}

class _SetYubikeyState extends ConsumerState<SetYubikey>
    implements SheetSkeletonInterface {
  late FocusNode clientIDFocusNode;
  late TextEditingController clientIDController;
  late FocusNode clientAPIKeyFocusNode;
  late TextEditingController clientAPIKeyController;
  String clientIDValidationText = '';
  String clientAPIKeyValidationText = '';

  @override
  void initState() {
    super.initState();
    clientAPIKeyFocusNode = FocusNode();
    clientIDFocusNode = FocusNode();
    clientAPIKeyController = TextEditingController();
    clientIDController = TextEditingController();
  }

  @override
  void dispose() {
    clientAPIKeyFocusNode.dispose();
    clientIDFocusNode.dispose();
    clientAPIKeyController.dispose();
    clientIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Row(
      children: <Widget>[
        AppButtonTiny(
          AppButtonTinyType.primary,
          localizations.confirm,
          Dimens.buttonTopDimens,
          key: const Key('confirm'),
          onPressed: validate,
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return SheetAppBar(
      title: localizations.yubikeyWithYubiCloudMethod,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
            top: 15,
          ),
          child: Linkify(
            text: localizations.setYubicloudDescription,
            style: ArchethicThemeStyles.textStyleSize12W100Primary,
            textAlign: TextAlign.left,
            options: const LinkifyOptions(
              humanize: false,
            ),
            linkStyle: ArchethicThemeStyles.textStyleSize12W100Primary.copyWith(
              decoration: TextDecoration.underline,
            ),
            onOpen: (link) async {
              final uri = Uri.parse(link.url);
              if (!await canLaunchUrl(uri)) return;

              await launchUrl(uri);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: getClientIDContainer(),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          margin: const EdgeInsets.only(top: 3),
          child: Text(
            clientIDValidationText,
            style: ArchethicThemeStyles.textStyleSize14W600Primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: getClientAPIKeyContainer(),
        ),
        Container(
          alignment: AlignmentDirectional.center,
          margin: const EdgeInsets.only(top: 3),
          child: Text(
            clientAPIKeyValidationText,
            style: ArchethicThemeStyles.textStyleSize14W600Primary,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget getClientIDContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            AppLocalizations.of(context)!.enterYubikeyClientID,
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
                            controller: clientIDController,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) async {
                              setState(() {
                                clientIDValidationText = '';
                              });
                            },
                            focusNode: clientIDFocusNode,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
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

  Widget getClientAPIKeyContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            AppLocalizations.of(context)!.enterYubikeyClientAPIKey,
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
                            controller: clientAPIKeyController,
                            textInputAction: TextInputAction.done,
                            autofocus: true,
                            onChanged: (value) async {
                              setState(() {
                                clientAPIKeyValidationText = '';
                              });
                            },
                            focusNode: clientAPIKeyFocusNode,
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(40),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
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

  Future<void> validate() async {
    final clientId = clientIDController.text;
    final clientApiKey = clientAPIKeyController.text;

    if (clientId.isEmpty) {
      setState(() {
        clientIDValidationText =
            AppLocalizations.of(context)!.enterYubikeyClientIDEmpty;
      });
      return;
    }

    if (clientApiKey.isEmpty) {
      setState(() {
        clientAPIKeyValidationText =
            AppLocalizations.of(context)!.enterYubikeyAPIKeyEmpty;
      });
      return;
    }

    final auth = await YubikeyAuthScreenOverlay(
      canNavigateBack: true,
      challenge: widget.challenge,
      settings: YubikeyOTPSettings(
        clientId: clientId,
        clientApiKey: clientApiKey,
      ),
    ).show(
      context,
    );
    if (auth == null) return;

    await ref.read(AuthenticationProviders.authenticationRepository).setYubikey(
          clientId: clientId,
          clientApiKey: clientApiKey,
        );

    context.pop(widget.challenge);
  }
}
