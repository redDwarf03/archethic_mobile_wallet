part of 'authentication.dart';

@freezed
class PasswordAuthenticationState with _$PasswordAuthenticationState {
  const factory PasswordAuthenticationState({
    required int failedAttemptsCount,
    required int maxAttemptsCount,
  }) = _PasswordAuthenticationState;
  const PasswordAuthenticationState._();
}

@riverpod
class _PasswordAuthenticationNotifier extends _$PasswordAuthenticationNotifier {
  @override
  FutureOr<PasswordAuthenticationState> build() async {
    final authenticationRepository = ref.read(
      AuthenticationProviders.authenticationRepository,
    );

    final maxAttemptsCount = AuthenticateWithPassword.maxFailedAttempts;
    final failedPinAttempts =
        await authenticationRepository.getFailedAttempts();

    return PasswordAuthenticationState(
      maxAttemptsCount: maxAttemptsCount,
      failedAttemptsCount: failedPinAttempts % maxAttemptsCount,
    );
  }

  Future<AuthenticationResult> authenticateWithPassword(
    PasswordCredentials password,
  ) async {
    final lState = await future;

    final authenticationRepository = ref.read(
      AuthenticationProviders.authenticationRepository,
    );
    final authenticationResult = await AuthenticateWithPassword(
      repository: authenticationRepository,
    ).run(password);

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

  Future<UpdatePasswordResult> updatePassword({
    required String password,
    required String passwordConfirmation,
    required Uint8List challenge,
  }) async =>
      UpdateMyPassword(
        repository: ref.read(AuthenticationProviders.authenticationRepository),
      ).run(
        UpdatePasswordCommand(
          password: password,
          passwordConfirmation: passwordConfirmation,
          challenge: challenge,
        ),
      );
}
