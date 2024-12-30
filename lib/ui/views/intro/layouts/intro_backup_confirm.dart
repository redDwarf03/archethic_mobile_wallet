import 'dart:async';

import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/application/recovery_phrase_saved.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/application/usecases.dart';
import 'package:aewallet/bus/authenticated_event.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/dimens.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_backup_seed.dart';
import 'package:aewallet/ui/views/intro/layouts/intro_configure_security.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/views/main/home_page.dart';
import 'package:aewallet/ui/widgets/components/app_button_tiny.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/ui/widgets/components/icon_network_warning.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/util/keychain_util.dart';
import 'package:aewallet/util/mnemonics.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class IntroBackupConfirm extends ConsumerStatefulWidget {
  const IntroBackupConfirm({
    required this.name,
    required this.seed,
    this.welcomeProcess = true,
    super.key,
  });
  final String? name;
  final String? seed;
  final bool welcomeProcess;

  static const routerPage = '/intro_backup_confirm';

  @override
  ConsumerState<IntroBackupConfirm> createState() => _IntroBackupConfirmState();
}

class _IntroBackupConfirmState extends ConsumerState<IntroBackupConfirm>
    with KeychainServiceMixin
    implements SheetSkeletonInterface {
  List<String> wordListSelected = List<String>.empty(growable: true);
  List<String> wordListToSelect = List<String>.empty(growable: true);
  List<String> originalWordsList = List<String>.empty(growable: true);

  StreamSubscription<AuthenticatedEvent>? _authSub;

  bool keychainAccessRequested = false;
  bool newWalletRequested = false;

  void _registerBus() {
    _authSub = EventTaxiImpl.singleton()
        .registerTo<AuthenticatedEvent>()
        .listen((AuthenticatedEvent event) async {
      await createKeychain();
    });
  }

  void _destroyBus() {
    _authSub?.cancel();
  }

  @override
  void dispose() {
    _destroyBus();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _registerBus();

    // TODO(reddwarf03): LanguageSeed seems to be local to "import wallet" and "create wallet" screens. Maybe it should not be stored in preferences ? (3)
    final languageSeed = ref.read(
      SettingsProviders.settings.select((settings) => settings.languageSeed),
    );
    wordListToSelect = AppMnemomics.seedToMnemonic(
      widget.seed!,
      languageCode: languageSeed,
    );
    wordListToSelect.sort(
      (a, b) => a.compareTo(b),
    );
    originalWordsList = AppMnemomics.seedToMnemonic(
      widget.seed!,
      languageCode: languageSeed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      floatingActionButton: getFloatingActionButton(context, ref),
      sheetContent: getSheetContent(context, ref),
      backgroundImage: ArchethicTheme.backgroundWelcome,
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            AppButtonTinyConnectivity(
              localizations.confirm,
              Dimens.buttonTopDimens,
              key: const Key('confirm'),
              onPressed: () async {
                var orderOk = true;

                for (var i = 0; i < originalWordsList.length; i++) {
                  if (originalWordsList[i] != wordListSelected[i]) {
                    orderOk = false;
                  }
                }
                if (orderOk == false) {
                  setState(() {
                    UIUtil.showSnackbar(
                      localizations.confirmSecretPhraseKo,
                      context,
                      ref,
                      ArchethicTheme.text,
                      ArchethicTheme.snackBarShadow,
                    );
                  });
                } else {
                  ref.read(
                    RecoveryPhraseSavedProvider.setRecoveryPhraseSaved(true),
                  );

                  if (widget.welcomeProcess) {
                    await context.push(
                      IntroConfigureSecurity.routerPage,
                      extra: {
                        'isImportProfile': false,
                      },
                    );
                  } else {
                    UIUtil.showSnackbar(
                      localizations.confirmSecretPhraseOk,
                      context,
                      ref,
                      ArchethicTheme.text,
                      ArchethicTheme.snackBarShadow,
                      icon: Symbols.info,
                    );
                    context.go(
                      HomePage.routerPage,
                    );
                  }
                }
              },
              disabled: wordListSelected.length != 24,
            ),
          ],
        ),
        if (widget.welcomeProcess)
          Row(
            children: <Widget>[
              AppButtonTinyConnectivity(
                localizations.pass,
                Dimens.buttonBottomDimens,
                key: const Key('pass'),
                onPressed: () {
                  AppDialogs.showConfirmDialog(
                    context,
                    ref,
                    localizations.passBackupConfirmationDisclaimer,
                    localizations.passBackupConfirmationMessage,
                    localizations.passRecoveryPhraseBackupSecureLater,
                    () async {
                      ref.read(
                        RecoveryPhraseSavedProvider.setRecoveryPhraseSaved(
                          false,
                        ),
                      );
                      await context.push(
                        IntroConfigureSecurity.routerPage,
                        extra: {
                          'name': widget.name,
                          'isImportProfile': false,
                        },
                      );
                    },
                    titleStyle:
                        ArchethicThemeStyles.textStyleSize14W600PrimaryRed,
                    additionalContent: localizations.archethicDoesntKeepCopy,
                    additionalContentStyle:
                        ArchethicThemeStyles.textStyleSize12W300PrimaryRed,
                    cancelText: localizations.passRecoveryPhraseBackupSecureNow,
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);

    return SheetAppBar(
      title: localizations.recoveryPhrase,
      widgetLeft: BackButton(
        key: const Key('back'),
        color: ArchethicTheme.text,
        onPressed: () {
          if (widget.welcomeProcess == false) {
            context.pop();
          } else {
            context.go(
              IntroBackupSeedPage.routerPage,
              extra: widget.name,
            );
          }
        },
      ),
      widgetRight:
          connectivityStatusProvider == ConnectivityStatus.isDisconnected
              ? const Padding(
                  padding: EdgeInsets.only(
                    right: 7,
                    top: 7,
                  ),
                  child: IconNetworkWarning(
                    alignment: Alignment.topRight,
                  ),
                )
              : const SizedBox.shrink(),
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
          ),
          alignment: AlignmentDirectional.centerStart,
          child: AutoSizeText(
            localizations.confirmSecretPhrase,
            style: ArchethicThemeStyles.textStyleSize14W600Primary,
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
            top: 15,
          ),
          child: AutoSizeText(
            localizations.confirmSecretPhraseExplanation,
            style: ArchethicThemeStyles.textStyleSize12W100Primary,
            textAlign: TextAlign.justify,
            maxLines: 6,
            stepGranularity: 0.5,
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
            top: 15,
          ),
          child: Wrap(
            spacing: 10,
            children: wordListSelected.asMap().entries.map((MapEntry entry) {
              return Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.grey.shade800,
                        child: Text(
                          (entry.key + 1).toString(),
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary60,
                        ),
                      ),
                      label: Text(
                        entry.value,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                      onDeleted: () {
                        setState(() {
                          wordListToSelect.add(entry.value);
                          wordListSelected.removeAt(entry.key);
                        });
                      },
                      deleteIconColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: ArchethicTheme.gradient,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
            top: 15,
            bottom: 80,
          ),
          child: Wrap(
            spacing: 10,
            children: wordListToSelect.asMap().entries.map((MapEntry entry) {
              return Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: GestureDetector(
                      onTap: () {
                        wordListSelected.add(entry.value);
                        wordListToSelect.removeAt(entry.key);
                        setState(() {});
                      },
                      child: Chip(
                        label: Text(
                          entry.value,
                          style:
                              ArchethicThemeStyles.textStyleSize12W100Primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> createKeychain() async {
    final localizations = AppLocalizations.of(context)!;
    context.loadingOverlay.show(
      title: localizations.appWalletInitInProgress,
    );

    try {
      await ref.read(createNewAppWalletCaseProvider).run(
        widget.seed,
        [widget.name!],
      );

      context.loadingOverlay.hide();
      context.go(
        HomePage.routerPage,
      );
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;

      UIUtil.showSnackbar(
        '${localizations.sendError} (${_getErrorMessage(e)})',
        context,
        ref,
        ArchethicTheme.text,
        ArchethicTheme.snackBarShadow,
      );
      context.loadingOverlay.hide();

      if (widget.welcomeProcess == false) {
        context.pop();
      } else {
        context.go(
          IntroBackupSeedPage.routerPage,
          extra: widget.name,
        );
      }
    }
  }

  String _getErrorMessage(Object e) {
    if (e is archethic.ArchethicConnectionException) {
      return e.cause;
    } else if (e is archethic.ArchethicInvalidResponseException) {
      return e.cause;
    }
    return e.toString();
  }
}
