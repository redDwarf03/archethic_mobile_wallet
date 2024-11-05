import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;

abstract class DexTokenRepository {
  Future<DexToken?> getToken(
    String address,
    aedappfm.Environment environment,
  );

  Future<List<DexToken>> getTokensFromAccount(
    String accountAddress,
    List<String> userTokenLocalAddresses,
  );

  Future<List<DexToken>> getLocalTokensDescriptions(
    aedappfm.Environment environment,
  );
}
