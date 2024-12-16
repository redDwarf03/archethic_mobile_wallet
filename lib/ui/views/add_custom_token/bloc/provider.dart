import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/tokens/tokens.dart';
import 'package:aewallet/domain/models/token_parser.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/modules/aeswap/application/verified_tokens.dart';
import 'package:aewallet/ui/views/add_custom_token/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class AddCustomTokenFormNotifier extends _$AddCustomTokenFormNotifier
    with TokenParser {
  AddCustomTokenFormNotifier();

  @override
  AddCustomTokenFormState build() => const AddCustomTokenFormState();

  Future<void> setTokenAddress(
    AppLocalizations appLocalizations,
    String tokenAddress,
  ) async {
    state = state.copyWith(
      tokenAddress: tokenAddress,
      token: null,
      errorText: '',
    );
    if (Address(address: state.tokenAddress).isValid()) {
      final tokenResult =
          await ref.read(tokensFromAddressesProvider([tokenAddress]).future);
      if (tokenResult[tokenAddress] != null) {
        final userTokenBalance = await ref.read(
          getBalanceProvider(
            tokenAddress,
          ).future,
        );
        final poolsListRaw =
            await ref.read(DexPoolProviders.getPoolListRaw.future);

        final apiService = ref.read(apiServiceProvider);
        final verifiedTokens = await ref
            .read(verifiedTokensRepositoryProvider)
            .getVerifiedTokens();
        final environment = ref.read(environmentProvider);
        final tokensRepositoryImpl = ref.read(tokensRepositoryImplProvider);
        final defTokensRepositoryImpl =
            ref.read(aedappfm.defTokensRepositoryImplProvider);

        final aeToken = await tokenModelToAETokenModel(
          tokenResult[tokenAddress]!,
          verifiedTokens,
          poolsListRaw,
          environment,
          apiService,
          defTokensRepositoryImpl,
          tokensRepositoryImpl,
        );

        setToken(aeToken);
        state = state.copyWith(
          userTokenBalance: userTokenBalance,
        );
      } else {
        setError(
          appLocalizations.customTokenAddressNotValid,
        );
      }
    }
  }

  void setError(
    String errorText,
  ) {
    state = state.copyWith(
      errorText: errorText,
    );
  }

  void setToken(
    aedappfm.AEToken token,
  ) {
    state = state.copyWith(
      token: token,
    );
  }

  Future<bool> control(WidgetRef ref, AppLocalizations appLocalizations) async {
    if (Address(address: state.tokenAddress).isValid() == false) {
      setError(appLocalizations.invalidAddress);
      return false;
    }

    final tokenResult = await ref
        .read(tokensFromAddressesProvider([state.tokenAddress]).future);
    if (tokenResult[state.tokenAddress] == null) {
      setError(
        appLocalizations.customTokenAddressNotValid,
      );
      return false;
    }

    final accountSelected = ref
        .read(
          AccountProviders.accounts,
        )
        .valueOrNull
        ?.selectedAccount;
    if (accountSelected != null &&
        accountSelected.customTokenAddressList != null &&
        accountSelected.checkCustomTokenAddress(state.tokenAddress)) {
      setError(appLocalizations.customTokenAddressAlreadyExistsInAccount);
      return false;
    }

    return true;
  }

  Future<bool> addCustomToken(
    WidgetRef ref,
    AppLocalizations appLocalizations,
  ) async {
    if (await control(ref, appLocalizations) == false) {
      return false;
    }

    final accountSelected = ref
        .read(
          AccountProviders.accounts,
        )
        .valueOrNull
        ?.selectedAccount;
    await accountSelected!.addCustomTokenAddress(state.tokenAddress);
    return true;
  }
}
