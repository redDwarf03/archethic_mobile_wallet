part of 'auto_lock_guard.dart';

/// Handles navigation to the lock screen
mixin CountdownLockMixin {
  static final _logger = Logger('AuthenticationGuard-Mixin');

  /// Displays lock screen (with the timer) if
  /// application should be locked (too much authentication failures).
  ///
  /// This must be called when check is needed.
  Future<void> showLockCountdownScreenIfNeeded(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final shouldLock = await ref.read(
      AuthenticationProviders.isLockCountdownRunning.future,
    );
    if (shouldLock) {
      _logger.info('Show countdown screen');
      CountdownLockOverlay.instance().show(context);
    }
  }
}

abstract class DurationFormatters {
  static String _twoDigitsFormatter(int value) =>
      value.toString().padLeft(2, '0');

  static String hhmmss(Duration duration) =>
      '${_twoDigitsFormatter(duration.inHours)}:${_twoDigitsFormatter(duration.inMinutes % 60)}:${_twoDigitsFormatter(duration.inSeconds % 60)}';
}

abstract class AppLockScreenProviders {
  static final remainingLockSeconds = FutureProvider.autoDispose<String>(
    (ref) async {
      final remainingDuration = await ref.watch(
        AuthenticationProviders.lockCountdown.future,
      );

      return DurationFormatters.hhmmss(remainingDuration);
    },
  );
}

class CountdownLockOverlay with LockOverlayMixin {
  factory CountdownLockOverlay.instance() =>
      _instance ?? (_instance = CountdownLockOverlay._());
  CountdownLockOverlay._();
  static CountdownLockOverlay? _instance;

  @override
  Widget get child => const _CountdownLockScreen();
}

class _CountdownLockScreen extends ConsumerWidget
    implements SheetSkeletonInterface {
  const _CountdownLockScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
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
    final isLocked =
        ref.watch(AuthenticationProviders.isLockCountdownRunning).valueOrNull ??
            true;
    final countDownString = ref
            .watch(
              AppLockScreenProviders.remainingLockSeconds,
            )
            .valueOrNull ??
        '';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppButtonTiny(
              AppButtonTinyType.primary,
              isLocked ? countDownString : localizations.unlock,
              Dimens.buttonTopDimens,
              key: const Key('unlock'),
              onPressed: () {
                if (isLocked) return;
                CountdownLockOverlay.instance().hide();
              },
              disabled: isLocked,
            ),
          ],
        ),
        Container(
          height: 50,
          margin: Dimens.buttonBottomDimens.edgeInsetsDirectional,
          child: FilledButton(
            onPressed: () {
              RemoveWalletDialogOverlay.showOverlay(
                context,
                ref,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor:
                  ArchethicThemeStyles.textStyleSize16W400MainButtonLabel.color,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.removeWalletBtn,
                  style:
                      ArchethicThemeStyles.textStyleSize16W400MainButtonLabel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isLocked =
        ref.watch(AuthenticationProviders.isLockCountdownRunning).valueOrNull ??
            true;
    return SheetAppBar(
      title: isLocked ? localizations.locked : ' ',
    );
  }

  @override
  Widget getSheetContent(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Text(
        localizations.tooManyFailedAttempts,
        style: ArchethicThemeStyles.textStyleSize14W600Primary,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class RemoveWalletDialogOverlay {
  static void showOverlay(
    BuildContext context,
    WidgetRef ref,
  ) {
    final localizations = AppLocalizations.of(context)!;

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.black.withOpacity(0.8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: aedappfm.PopupTemplate(
                  displayCloseButton: false,
                  popupTitle: localizations.warning,
                  popupContent: Column(
                    children: [
                      Text(
                        localizations.removeWalletDetail,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            key: const Key('cancelButton'),
                            labelBtn: AppLocalizations.of(
                              context,
                            )!
                                .no,
                            onPressed: () {
                              overlayEntry?.remove();
                            },
                          ),
                          AppButton(
                            key: const Key('yesButton'),
                            labelBtn: localizations.yes,
                            onPressed: () async {
                              overlayEntry?.remove();
                              Overlay.of(context).insert(
                                _createConfirmOverlay(
                                  context,
                                  ref,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(overlayEntry);
  }

  static OverlayEntry _createConfirmOverlay(
    BuildContext context,
    WidgetRef ref,
  ) {
    final localizations = AppLocalizations.of(context)!;

    OverlayEntry? overlayEntry;

    // ignore: join_return_with_assignment
    overlayEntry = OverlayEntry(
      builder: (BuildContext overlayContext) {
        return Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.black.withOpacity(0.8),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: aedappfm.PopupTemplate(
                  displayCloseButton: false,
                  popupTitle: localizations.areYouSure,
                  popupContent: Column(
                    children: [
                      Text(
                        localizations.removeWalletReassurance,
                        style: ArchethicThemeStyles.textStyleSize12W100Primary,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            key: const Key('cancelButton'),
                            labelBtn: AppLocalizations.of(
                              context,
                            )!
                                .no,
                            onPressed: () {
                              overlayEntry?.remove();
                            },
                          ),
                          AppButton(
                            key: const Key('yesButton'),
                            labelBtn: AppLocalizations.of(
                              context,
                            )!
                                .yes,
                            onPressed: () async {
                              overlayEntry?.remove();

                              CountdownLockOverlay.instance().hide();
                              context.go(LoggingOutScreen.routerPage);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return overlayEntry;
  }
}
