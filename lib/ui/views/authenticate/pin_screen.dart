import 'dart:math';

// Project imports:
import 'package:aewallet/application/authentication/authentication.dart';
import 'package:aewallet/domain/models/authentication.dart';
import 'package:aewallet/model/authentication_method.dart';
import 'package:aewallet/model/device_lock_timeout.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/authenticate/auth_screen_overlay.dart';
import 'package:aewallet/ui/views/authenticate/auto_lock_guard.dart';
import 'package:aewallet/ui/views/authenticate/pin_screen_button.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton_interface.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Used to unlock the app with a pin.
class PinAuthScreenOverlay extends AuthScreenOverlay {
  PinAuthScreenOverlay({
    required bool canNavigateBack,
    required Uint8List challenge,
    String? description,
  }) : super(
          name: 'UnlockPinScreenOverlay',
          widgetBuilder: (context, onDone) => _PinScreen(
            PinOverlayType.enterPin,
            canNavigateBack: canNavigateBack,
            challenge: challenge,
            action: CipherDelegateAction.decode,
            onDone: onDone,
            description: description ?? '',
          ),
        );
}

/// Used to set a new pin.
class SetPinScreenOverlay extends AuthScreenOverlay {
  SetPinScreenOverlay({
    required bool canNavigateBack,
    required Uint8List challenge,
    String? description,
  }) : super(
          name: 'SetPinScreenOverlay',
          widgetBuilder: (context, onDone) => GuardInputListener(
            child: _PinScreen(
              PinOverlayType.newPin,
              canNavigateBack: canNavigateBack,
              challenge: challenge,
              action: CipherDelegateAction.encode,
              onDone: onDone,
              description: description ?? '',
            ),
          ),
        );
}

enum CipherDelegateAction { encode, decode }

enum PinOverlayType { newPin, enterPin }

class _ShakeCurve extends Curve {
  @override
  double transform(double t) {
    //t from 0.0 to 1.0
    return sin(t * 2.5 * pi);
  }
}

class _PinScreen extends ConsumerStatefulWidget {
  const _PinScreen(
    this.type, {
    required this.action,
    required this.challenge,
    this.description = '',
    this.canNavigateBack = true,
    required this.onDone,
  });

  final bool canNavigateBack;
  final CipherDelegateAction action;
  final Uint8List challenge;
  final PinOverlayType type;
  final String description;
  final void Function(Uint8List? result) onDone;

  @override
  ConsumerState<_PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends ConsumerState<_PinScreen>
    with SingleTickerProviderStateMixin, CountdownLockMixin
    implements SheetSkeletonInterface {
  static const int _pinLength = 6;
  double buttonSize = 70;
  final FocusNode _focusNode = FocusNode();

  String pinEnterTitle = '';
  String pinCreateTitle = '';

  // Stateful data
  String _pin = '';
  String _pinConfirmed = '';
  late bool _awaitingConfirmation;
  late String _header;
  final List<int> _listPinNumber = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  // Invalid animation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    // Initialize list all empty
    if (widget.type == PinOverlayType.enterPin) {
      _header = pinEnterTitle;
    } else {
      _header = pinCreateTitle;
    }
    _awaitingConfirmation = false;
    _pin = '';
    _pinConfirmed = '';

    final shouldShuffle = ref.read(
      AuthenticationProviders.settings.select(
        (settings) => settings.pinPadShuffle,
      ),
    );

    if (shouldShuffle) {
      _listPinNumber.shuffle();
    }

    // Set animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: _ShakeCurve(),
    );
    _animation = Tween<double>(begin: 0, end: 25).animate(curve);

    showLockCountdownScreenIfNeeded(context, ref);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// The pin being entered
  ///
  /// It returns either pin or confirmation pin.
  String get displayedPin => _awaitingConfirmation ? _pinConfirmed : _pin;

  /// return true if entered pin is long enough
  bool get allExpectedCharactersEntered {
    return displayedPin.length >= _pinLength;
  }

  /// Set next character in the pin set
  void _setCharacter(String character) {
    if (_awaitingConfirmation) {
      if (_pinConfirmed.length >= _pinLength) return;
      setState(() {
        _pinConfirmed = _pinConfirmed + character;
      });
    } else {
      if (_pin.length >= _pinLength) return;
      setState(() {
        _pin = _pin + character;
      });
    }
  }

  void _backSpace() {
    setState(() {
      if (_awaitingConfirmation) {
        _pinConfirmed = _pinConfirmed.substring(0, _pinConfirmed.length - 1);
      } else {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _onTapDownbuttonPin(TapDownDetails details, String buttonText) {
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.reverse) {
      return;
    }

    _setCharacter(buttonText);
    if (allExpectedCharactersEntered) {
      // Mild delay so they can actually see the last dot get filled
      Future<void>.delayed(
        const Duration(milliseconds: 50),
        () async {
          if (widget.type == PinOverlayType.enterPin) {
            await _decodePayload(context);
          } else {
            if (!_awaitingConfirmation) {
              // Switch to confirm pin
              setState(() {
                _awaitingConfirmation = true;
                _header = AppLocalizations.of(context)!.pinConfirmTitle;
              });
            } else {
              // First and second pins match
              await _encodePayload(context, ref);
            }
          }
        },
      );
    }
  }

  Future<void> _encodePayload(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final updatePinResult = await ref
        .read(AuthenticationProviders.pinAuthentication.notifier)
        .updatePin(
          pin: _pin,
          pinConfirmation: _pinConfirmed,
          challenge: widget.challenge,
        );

    await updatePinResult.map(
      pinsDoNotMatch: (value) {
        _controller.forward().then((_) {
          setState(() {
            _awaitingConfirmation = false;
            _pin = '';
            _pinConfirmed = '';
            _header = AppLocalizations.of(context)!.pinConfirmError;
            _controller.value = 0;
          });
        });
      },
      success: (value) async {
        await ref
            .read(
              AuthenticationProviders.settings.notifier,
            )
            .setAuthMethod(AuthMethod.pin);
        widget.onDone(value.encodedChallenge);
      },
    );
  }

  Future<void> _decodePayload(
    BuildContext context,
  ) async {
    if (!mounted) return;
    final result = await ref
        .read(
          AuthenticationProviders.pinAuthentication.notifier,
        )
        .decodeWithPin(
          PinCredentials(pin: _pin, challenge: widget.challenge),
        );

    await result.maybeMap(
      success: (success) async {
        widget.onDone(success.decodedChallenge);
        return;
      },
      orElse: () {
        showLockCountdownScreenIfNeeded(context, ref);
        _controller.forward().then((_) async {
          final isLocked = await ref.read(
            AuthenticationProviders.isLockCountdownRunning.future,
          );

          if (isLocked) {
            setState(() {
              _pin = '';
              _controller.value = 0;
              _header = pinEnterTitle;
            });
          } else {
            setState(() {
              _pin = '';
              _header = AppLocalizations.of(context)!.pinInvalid;
              _controller.value = 0;
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canNavigateBack,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          widget.onDone(null);
        }
      },
      child: SheetSkeleton(
        appBar: getAppBar(context, ref),
        floatingActionButton: getFloatingActionButton(context, ref),
        sheetContent: getSheetContent(context, ref),
      ),
    );
  }

  @override
  Widget getFloatingActionButton(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    final lockTimeoutOption = ref.watch(
      AuthenticationProviders.settings.select(
        (settings) => settings.lockTimeout,
      ),
    );

    return Container(
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.07,
        right: MediaQuery.of(context).size.width * 0.07,
        bottom: smallScreen(context)
            ? MediaQuery.of(context).size.height * 0.02
            : MediaQuery.of(context).size.height * 0.05,
        top: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(0).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(1).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(2).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(3).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(4).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(5).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(6).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(7).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(8).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.009,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                  height: smallScreen(context) ? buttonSize - 15 : buttonSize,
                  width: smallScreen(context) ? buttonSize - 15 : buttonSize,
                ),
                PinScreenButton(
                  buttonText: _listPinNumber.elementAt(9).toString(),
                  buttonSize: buttonSize,
                  onTapDownbuttonPin: _onTapDownbuttonPin,
                ),
                SizedBox(
                  height: smallScreen(context) ? buttonSize - 15 : buttonSize,
                  width: smallScreen(context) ? buttonSize - 15 : buttonSize,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(200),
                    highlightColor: ArchethicTheme.text15,
                    splashColor: ArchethicTheme.text30,
                    onTap: () {},
                    onTapDown: (TapDownDetails details) {
                      _backSpace();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: ArchethicTheme.background40,
                            blurRadius: 15,
                            spreadRadius: -15,
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                      child: Icon(
                        Symbols.backspace,
                        color: ArchethicTheme.text,
                        size: 26,
                        weight: IconSize.weightM,
                        opticalSize: IconSize.opticalSizeM,
                        grade: IconSize.gradeM,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (lockTimeoutOption != LockTimeoutOption.disabled)
            Padding(
              padding: const EdgeInsets.all(8),
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

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    return SheetAppBar(
      title: ' ',
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

    final pinAuthentication = ref
        .watch(
          AuthenticationProviders.pinAuthentication,
        )
        .valueOrNull;

    if (pinAuthentication == null) {
      return const Center(child: aedappfm.Loading());
    }

    if (pinEnterTitle.isEmpty) {
      setState(() {
        pinEnterTitle = localizations.pinEnterTitle;
        if (widget.type == PinOverlayType.enterPin) {
          _header = pinEnterTitle;
        }
      });
    }
    if (pinCreateTitle.isEmpty) {
      setState(() {
        pinCreateTitle = localizations.pinCreateTitle;
        if (widget.type == PinOverlayType.newPin) {
          _header = pinCreateTitle;
        }
      });
    }

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          final logicalKey = event.logicalKey;

          var keyLabel = '';
          if (logicalKey.keyLabel == '' &&
              logicalKey.debugName != null &&
              logicalKey.debugName!.startsWith('Digit')) {
            keyLabel = logicalKey.debugName!.substring(5);
          } else if (logicalKey.keyId >= LogicalKeyboardKey.numpad0.keyId &&
              logicalKey.keyId <= LogicalKeyboardKey.numpad9.keyId) {
            keyLabel = (logicalKey.keyId - LogicalKeyboardKey.numpad0.keyId)
                .toString();
          } else {
            keyLabel = logicalKey.keyLabel;
          }

          if (keyLabel.isNotEmpty && '0123456789'.contains(keyLabel)) {
            _setCharacter(keyLabel);
            if (allExpectedCharactersEntered) {
              // Mild delay so they can actually see the last dot get filled
              Future<void>.delayed(
                const Duration(milliseconds: 50),
                () async {
                  if (widget.action == CipherDelegateAction.decode) {
                    await _decodePayload(context);
                  } else {
                    if (!_awaitingConfirmation) {
                      // Switch to confirm pin
                      setState(() {
                        _awaitingConfirmation = true;
                        _header = AppLocalizations.of(context)!.pinConfirmTitle;
                      });
                    } else {
                      // First and second pins match
                      await _encodePayload(context, ref);
                    }
                  }
                },
              );
            }
          }
          if (logicalKey.keyLabel.isNotEmpty &&
              logicalKey == LogicalKeyboardKey.backspace) {
            _backSpace();
          }
        }
      },
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: AutoSizeText(
                  _header,
                  style: ArchethicThemeStyles.textStyleSize24W700Primary,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  stepGranularity: 0.1,
                ),
              ),
              if (widget.description.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: AutoSizeText(
                    widget.description,
                    style: ArchethicThemeStyles.textStyleSize16W100Primary,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    stepGranularity: 0.1,
                  ),
                ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Container(
                  margin: EdgeInsetsDirectional.only(
                    start: MediaQuery.of(context).size.width * 0.25 +
                        _animation.value,
                    end: MediaQuery.of(context).size.width * 0.25 -
                        _animation.value,
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(
                        displayedPin.length,
                        (index) => Icon(
                          Symbols.circle,
                          fill: 1,
                          color: ArchethicTheme.text,
                          size: 15,
                        ),
                      ),
                      ...List.generate(
                        max(_pinLength - displayedPin.length, 0),
                        (index) => Icon(
                          Symbols.remove,
                          color: ArchethicTheme.text,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (pinAuthentication.failedAttemptsCount > 0)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                  child: AutoSizeText(
                    '${localizations.attempt}${pinAuthentication.failedAttemptsCount}/${pinAuthentication.maxAttemptsCount}',
                    style: ArchethicThemeStyles.textStyleSize16W100Primary,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    stepGranularity: 0.1,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
