part of 'authentication.dart';

class AuthenticateWithYubikey
    with AuthenticationWithLock
    implements UseCase<YubikeyCredentials, AuthenticationResult> {
  const AuthenticateWithYubikey({
    required this.repository,
    this.settings,
  });

  @override
  final AuthenticationRepositoryInterface repository;

  final YubikeyOTPSettings? settings;

  static int get maxFailedAttempts => AuthenticationWithLock.maxFailedAttempts;

  Future<YubikeyOTPSettings?> get _settings async {
    if (settings != null) return settings;

    final vault = await AuthentHiveSecuredDatasource.getInstance();

    final clientApiKey = vault.getYubikeyClientAPIKey();
    final clientId = vault.getYubikeyClientID();
    if (clientId.isEmpty || clientApiKey.isEmpty) {
      return null;
    }
    return YubikeyOTPSettings(
      clientId: clientId,
      clientApiKey: clientApiKey,
    );
  }

  @override
  Future<AuthenticationResult> run(
    YubikeyCredentials credentials, {
    UseCaseProgressListener? onProgress,
  }) async {
    final settings = await _settings;
    if (settings == null) {
      return const AuthenticationResult.notSetup();
    }
    final verificationResponse = await Yubidart()
        .otp
        .verify(credentials.otp, settings.clientApiKey, settings.clientId);

    if (verificationResponse.status == 'OK') {
      return authenticationSucceed(credentials.challenge);
    }

    return authenticationFailed();
  }
}
