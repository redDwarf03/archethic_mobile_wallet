import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verified_tokens.g.dart';

@riverpod
aedappfm.VerifiedTokensRepositoryInterface verifiedTokensRepository(
  Ref ref,
) {
  final environment = ref.watch(environmentProvider);
  return ref.watch(
    aedappfm.VerifiedTokensProviders.verifiedTokensRepository(environment),
  );
}

@riverpod
Future<bool> isVerifiedToken(Ref ref, String address) async {
  final environment = ref.watch(environmentProvider);
  return ref.watch(
    aedappfm.VerifiedTokensProviders.isVerifiedToken(
      environment,
      address,
    ).future,
  );
}

@riverpod
Future<List<String>> verifiedTokens(
  Ref ref,
) async {
  final environment = ref.watch(environmentProvider);

  return ref.watch(
    aedappfm.VerifiedTokensProviders.verifiedTokensByNetwork(
      environment,
    ).future,
  );
}
