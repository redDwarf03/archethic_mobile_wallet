/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

// Project imports:
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/bus/otp_event.dart';
import 'package:aewallet/infrastructure/datasources/hive_preferences.dart';
import 'package:aewallet/infrastructure/datasources/hive_vault.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/util/ui_util.dart';
import 'package:aewallet/ui/widgets/components/app_text_field.dart';
import 'package:aewallet/ui/widgets/components/paste_icon.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:aewallet/util/haptic_util.dart';
import 'package:aewallet/util/nfc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yubidart/yubidart.dart';

class YubikeyScreen extends ConsumerStatefulWidget {
  const YubikeyScreen({
    super.key,
    required this.canNavigateBack,
  });

  static const name = 'YubikeyScreen';

  final bool canNavigateBack;

  @override
  ConsumerState<YubikeyScreen> createState() => _YubikeyScreenState();
}

class _YubikeyScreenState extends ConsumerState<YubikeyScreen> {
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
    final localizations = AppLocalizations.of(context)!;

    // TODO(chralu): utilisation provider ? (1)
    final preferences = await HivePreferencesDatasource.getInstance();
    final vault = await HiveVaultDatasource.getInstance();
    final yubikeyClientAPIKey = vault.getYubikeyClientAPIKey();
    final yubikeyClientID = vault.getYubikeyClientID();
    final verificationResponse =
        await Yubidart().otp.verify(otp, yubikeyClientAPIKey, yubikeyClientID);
    switch (verificationResponse.status) {
      case 'BAD_OTP':
        UIUtil.showSnackbar(
          localizations.yubikeyError_BAD_OTP,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'BACKEND_ERROR':
        UIUtil.showSnackbar(
          localizations.yubikeyError_BACKEND_ERROR,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'BAD_SIGNATURE':
        UIUtil.showSnackbar(
          localizations.yubikeyError_BAD_SIGNATURE,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'MISSING_PARAMETER':
        UIUtil.showSnackbar(
          localizations.yubikeyError_MISSING_PARAMETER,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'NOT_ENOUGH_ANSWERS':
        UIUtil.showSnackbar(
          localizations.yubikeyError_NOT_ENOUGH_ANSWERS,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'NO_SUCH_CLIENT':
        UIUtil.showSnackbar(
          localizations.yubikeyError_NO_SUCH_CLIENT,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'OPERATION_NOT_ALLOWED':
        UIUtil.showSnackbar(
          localizations.yubikeyError_OPERATION_NOT_ALLOWED,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'REPLAYED_OTP':
        UIUtil.showSnackbar(
          localizations.yubikeyError_REPLAYED_OTP,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'REPLAYED_REQUEST':
        UIUtil.showSnackbar(
          localizations.yubikeyError_REPLAYED_REQUEST,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'RESPONSE_KO':
        UIUtil.showSnackbar(
          localizations.yubikeyError_RESPONSE_KO,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
      case 'OK':
        UIUtil.showSnackbar(
          verificationResponse.status,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
          icon: Symbols.info,
        );
        preferences.resetLockAttempts();
        Navigator.of(context).pop(true);
        break;
      default:
        UIUtil.showSnackbar(
          verificationResponse.status,
          context,
          ref,
          ArchethicTheme.text,
          ArchethicTheme.snackBarShadow,
        );
        Navigator.of(context).pop(false);
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final preferences = ref.watch(SettingsProviders.settings);

    return WillPopScope(
      onWillPop: () async => widget.canNavigateBack,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                ArchethicTheme.backgroundSmall,
              ),
              fit: BoxFit.fitHeight,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ArchethicTheme.backgroundDark,
                ArchethicTheme.background,
              ],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.06,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsetsDirectional.only(start: 15),
                            height: 50,
                            width: 50,
                            child: widget.canNavigateBack
                                ? BackButton(
                                    key: const Key('back'),
                                    color: ArchethicTheme.text,
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: AutoSizeText(
                    'OTP',
                    style: ArchethicThemeStyles.textStyleSize16W400Primary,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    stepGranularity: 0.1,
                  ),
                ),
                if (isNFCAvailable)
                  ElevatedButton(
                    child: Text(
                      buttonNFCLabel,
                      style: ArchethicThemeStyles.textStyleSize16W200Primary,
                    ),
                    onPressed: () async {
                      sl.get<HapticUtil>().feedback(
                            FeedbackType.light,
                            preferences.activeVibrations,
                          );
                      setState(() {
                        buttonNFCLabel =
                            localizations.yubikeyConnectHoldNearDevice;
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
                      style: ArchethicThemeStyles.textStyleSize16W200Primary,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      stepGranularity: 0.1,
                    ),
                  ),
                if (isNFCAvailable)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  )
                else
                  AppTextField(
                    topMargin: 30,
                    maxLines: 3,
                    padding: const EdgeInsetsDirectional.only(
                      start: 16,
                      end: 16,
                    ),
                    focusNode: enterOTPFocusNode,
                    controller: enterOTPController,
                    textInputAction: TextInputAction.go,
                    autofocus: true,
                    onSubmitted: (value) async {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (String value) async {
                      if (value.trim().length == 44) {
                        EventTaxiImpl.singleton()
                            .fire(OTPReceiveEvent(otp: value));
                      }
                    },
                    inputFormatters: <LengthLimitingTextInputFormatter>[
                      LengthLimitingTextInputFormatter(45),
                    ],
                    keyboardType: TextInputType.text,
                    style: ArchethicThemeStyles.textStyleSize16W600Primary,
                    suffixButton: PasteIcon(
                      onPaste: (String value) {
                        enterOTPController!.text = value;
                        EventTaxiImpl.singleton().fire(
                          OTPReceiveEvent(
                            otp: enterOTPController!.text,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tagRead() async {
    await sl.get<NFCUtil>().authenticateWithNFCYubikey(context);
  }
}
