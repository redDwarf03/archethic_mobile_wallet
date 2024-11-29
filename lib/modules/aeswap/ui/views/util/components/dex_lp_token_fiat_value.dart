import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dex_lp_token_fiat_value.g.dart';

@riverpod
String dexLPTokenFiatValue(
  Ref ref,
  DexToken token1,
  DexToken token2,
  double lpTokenAmount,
  String poolAddress, {
  bool withParenthesis = true,
}) {
  if (lpTokenAmount == 0) {
    if (withParenthesis) {
      return '(\$${0.0.formatNumber(precision: 2)})';
    } else {
      return '\$${0.0.formatNumber(precision: 2)}';
    }
  }

  final estimateLPTokenInFiat = ref.watch(
    DexTokensProviders.estimateLPTokenInFiat(
      token1.address,
      token2.address,
      lpTokenAmount,
      poolAddress,
    ),
  );

  // ignore: cascade_invocations
  return estimateLPTokenInFiat.map(
    data: (data) {
      if (withParenthesis) {
        return '(\$${data.value.formatNumber(precision: 2)})';
      } else {
        return '\$${data.value.formatNumber(precision: 2)}';
      }
    },
    error: (error) {
      if (withParenthesis) {
        return r'($--)';
      } else {
        return r'$--';
      }
    },
    loading: (loading) {
      if (withParenthesis) {
        return r'($0.00)';
      } else {
        return r'$0.00';
      }
    },
  );
}
