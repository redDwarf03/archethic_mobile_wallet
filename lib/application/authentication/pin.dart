part of 'authentication.dart';

@freezed
class PinAuthenticationState with _$PinAuthenticationState {
  const factory PinAuthenticationState({
    required int failedAttemptsCount,
    required int maxAttemptsCount,
  }) = _PinAuthenticationState;
  const PinAuthenticationState._();
}

@riverpod
class _PinAuthenticationNotifier extends _$PinAuthenticationNotifier {
  @override
  Future<PinAuthenticationState> build() async {
    final authenticationRepository = ref.watch(
      AuthenticationProviders.authenticationRepository,
    );

    final maxAttemptsCount = AuthenticateWithPin.maxFailedAttempts;
    final failedPinAttempts =
        await authenticationRepository.getFailedAttempts();

    return PinAuthenticationState(
      failedAttemptsCount: failedPinAttempts % maxAttemptsCount,
      maxAttemptsCount: AuthenticateWithPin.maxFailedAttempts,
    );
  }

  Future<AuthenticationResult> decodeWithPin(
    PinCredentials pin,
  ) async {
    final lState = await future;

    final authenticationRepository = ref.read(
      AuthenticationProviders.authenticationRepository,
    );
    final authenticationResult = await AuthenticateWithPin(
      repository: authenticationRepository,
    ).run(pin);

    authenticationResult.maybeMap(
      tooMuchAttempts: (value) {
        ref.invalidate(AuthenticationProviders.lockCountdown);
      },
      orElse: () {},
    );

    state = AsyncData(
      lState.copyWith(
        failedAttemptsCount:
            await authenticationRepository.getFailedAttempts() %
                lState.maxAttemptsCount,
      ),
    );

    return authenticationResult;
  }

  Future<UpdatePinResult> updatePin({
    required String pin,
    required String pinConfirmation,
    required Uint8List challenge,
  }) async =>
      UpdateMyPin(
        repository: ref.read(
          AuthenticationProviders.authenticationRepository,
        ),
      ).run(
        PinUpdateCommand(
          pin: pin,
          pinConfirmation: pinConfirmation,
          challenge: challenge,
        ),
      );
}
