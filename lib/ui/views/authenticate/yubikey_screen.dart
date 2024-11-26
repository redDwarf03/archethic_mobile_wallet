/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

// Project imports:
import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/bus/otp_event.dart';
import 'package:aewallet/domain/models/authentication.dart';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/model/device_lock_timeout.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/views/authenticate/auth_screen_overlay.dart';
import 'package:aewallet/ui/views/authenticate/auto_lock_guard.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/paste_icon.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/nfc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class YubikeyAuthScreenOverlay extends AuthScreenOverlay {
  YubikeyAuthScreenOverlay({
    required bool canNavigateBack,
    required Uint8List challenge,
    YubikeyOTPSettings? settings,
  }) : super(
          name: 'YubikeyScreenOverlay',
          widgetBuilder: (context, onDone) => _YubikeyScreen(
            canNavigateBack: canNavigateBack,
            challenge: challenge,
            onDone: onDone,
            settings: settings,
          ),
        );
}

class _YubikeyScreen extends ConsumerStatefulWidget {
  const _YubikeyScreen({
    required this.canNavigateBack,
    required this.challenge,
    required this.onDone,
    this.settings,
  });

  final void Function(Uint8List? result) onDone;
  final bool canNavigateBack;
  final Uint8List challenge;
  final YubikeyOTPSettings? settings;

  @override
  ConsumerState<_YubikeyScreen> createState() => _YubikeyScreenState();
}

class _YubikeyScreenState extends ConsumerState<_YubikeyScreen>
    with CountdownLockMixin
    implements SheetSkeletonInterface {
  StreamSubscription<OTPReceiveEvent>? _otpReceiveSub;

  double buttonSize = 100;

  FocusNode? enterOTPFocusNode;
  TextEditingController? enterOTPController;
  String buttonNFCLabel = 'get my OTP via NFC';
  bool isNFCAvailable = false;

  @override
  void initState() {
    super.initState();
    _registerBus();

    enterOTPFocusNode = FocusNode();
    enterOTPController = TextEditingController();

    sl.get<NFCUtil>().hasNFC().then((bool hasNFC) {
      setState(() {
        isNFCAvailable = hasNFC;
      });
    });
  }

  void _registerBus() {
    _otpReceiveSub = EventTaxiImpl.singleton()
        .registerTo<OTPReceiveEvent>()
        .listen((OTPReceiveEvent event) {
      setState(() {
        buttonNFCLabel = 'get my OTP via NFC';
      });
      _verifyOTP(event.otp!);
    });
  }

  @override
  void dispose() {
    _otpReceiveSub?.cancel();

    super.dispose();
  }

  Future<void> _verifyOTP(String otp) async {
    if (!mounted) return;
    final result = await ref
        .read(
          AuthenticationProviders.yubikeyAuthentication.notifier,
        )
        .authenticateWithYubikey(
          YubikeyCredentials(otp: otp, challenge: widget.challenge),
          settings: widget.settings,
        );

    final localizations = AppLocalizations.of(context)!;

    await result.maybeMap(
      success: (_) async {
        await ref
            .read(
              AuthenticationProviders.settings.notifier,
            )
            .setAuthMethod(AuthMethod.yubikeyWithYubicloud);
        widget.onDone(widget.challenge);
        return;
      },
      orElse: () async {
        UIUtil.showSnackbar(
          localizations.yubikeyError_BAD_OTP,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        widget.onDone(null);
      },
    );

    setState(() {});
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
    return const SizedBox.shrink();
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    return SheetAppBar(
      title: 'OTP',
      widgetLeft: widget.canNavigateBack
          ? BackButton(
              key: const Key('back'),
              color: ArchethicTheme.text,
              onPressed: () {
                widget.onDone(null);
              },
            )
          : const SizedBox(),
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final lockTimeoutOption = ref.watch(
      AuthenticationProviders.settings.select(
        (settings) => settings.lockTimeout,
      ),
    );

    return PopScope(
      canPop: widget.canNavigateBack,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.onDone(null);
        }
      },
      child: Column(
        children: <Widget>[
          if (isNFCAvailable)
            ElevatedButton(
              child: Text(
                buttonNFCLabel,
                style: ArchethicThemeStyles.textStyleSize16W100Primary,
              ),
              onPressed: () async {
                setState(() {
                  buttonNFCLabel = localizations.yubikeyConnectHoldNearDevice;
                });
                await _tagRead();
              },
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              ),
              child: AutoSizeText(
                localizations.yubikeyConnectInvite,
                style: ArchethicThemeStyles.textStyleSize14W600Primary,
                maxLines: 1,
                stepGranularity: 0.1,
              ),
            ),
          if (isNFCAvailable)
            SizedBox(
              width: MediaQuery.of(context).size.width,
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                    gradient: ArchethicTheme
                                        .gradientInputFormBackground,
                                  ),
                                  child: TextField(
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    autocorrect: false,
                                    controller: enterOTPController,
                                    textInputAction: TextInputAction.go,
                                    autofocus: true,
                                    onSubmitted: (value) async {
                                      FocusScope.of(context).unfocus();
                                    },
                                    onChanged: (value) async {
                                      if (value.trim().length == 44) {
                                        EventTaxiImpl.singleton().fire(
                                          OTPReceiveEvent(otp: value),
                                        );
                                      }
                                    },
                                    focusNode: enterOTPFocusNode,
                                    keyboardType: TextInputType.text,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(
                                        45,
                                      ),
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
                      PasteIcon(
                        onPaste: (String value) {
                          enterOTPController!.text = value;
                          EventTaxiImpl.singleton().fire(
                            OTPReceiveEvent(
                              otp: enterOTPController!.text,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (lockTimeoutOption != LockTimeoutOption.disabled)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Symbols.lightbulb,
                      //size: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      localizations.autoLockTips.replaceAll(
                        '%0',
                        LockTimeoutSetting(lockTimeoutOption)
                            .getDisplayName(context)
                            .toLowerCase(),
                      ),
                      style: ArchethicThemeStyles.textStyleSize12W600Primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _tagRead() async {
    await sl.get<NFCUtil>().authenticateWithNFCYubikey(context);
  }
}
