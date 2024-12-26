import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/aeswap/usecases.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/modules/aeswap/application/balance.dart';
import 'package:aewallet/modules/aeswap/application/pool/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_pool.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:aewallet/modules/aeswap/infrastructure/pool_factory.repository.dart';
import 'package:aewallet/modules/aeswap/util/browser_util_desktop.dart'
    if (dart.library.js) 'package:aewallet/modules/aeswap/util/browser_util_web.dart';
import 'package:aewallet/ui/views/aeswap_liquidity_add/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:decimal/decimal.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class LiquidityAddFormNotifier extends _$LiquidityAddFormNotifier {
  LiquidityAddFormNotifier();

  @override
  LiquidityAddFormState build() => const LiquidityAddFormState();

  aedappfm.CancelableTask<double?>? _calculateEquivalentAmountTask;

  Future<void> setPool(DexPool pool) async {
    state = state.copyWith(pool: pool);

    final poolPopulated =
        await ref.read(DexPoolProviders.getPool(pool.poolAddress).future);

    state = state.copyWith(pool: poolPopulated);
  }

  Future<void> initBalances() async {
    final token1Balance = await ref.read(
      getBalanceProvider(
        state.token1!.isUCO ? kUCOAddress : state.token1!.address,
      ).future,
    );
    state = state.copyWith(token1Balance: token1Balance);

    final token2Balance = await ref.read(
      getBalanceProvider(
        state.token2!.isUCO ? kUCOAddress : state.token2!.address,
      ).future,
    );
    state = state.copyWith(token2Balance: token2Balance);

    final lpTokenBalance = await ref.read(
      getBalanceProvider(
        state.pool!.lpToken.address,
      ).future,
    );
    state = state.copyWith(lpTokenBalance: lpTokenBalance);
  }

  Future<void> initRatio() async {
    final apiService = ref.read(apiServiceProvider);
    final equivalentAmounResult =
        await PoolFactoryRepositoryImpl(state.pool!.poolAddress, apiService)
            .getEquivalentAmount(
      state.token1!.isUCO ? kUCOAddress : state.token1!.address,
      1,
    );
    var ratio = 0.0;
    equivalentAmounResult.map(
      success: (success) {
        if (success != null) {
          ratio = success;
        }
      },
      failure: (failure) {
        setFailure(
          aedappfm.Failure.other(
            cause: 'getEquivalentAmount error $failure',
          ),
        );
      },
    );
    state = state.copyWith(ratio: ratio);
  }

  void setTransactionAddLiquidity(
    archethic.Transaction transactionAddLiquidity,
  ) {
    state = state.copyWith(transactionAddLiquidity: transactionAddLiquidity);
  }

  void setToken1(
    DexToken token,
  ) {
    state = state.copyWith(
      token1: token,
    );
  }

  void setToken2(
    DexToken token,
  ) {
    state = state.copyWith(
      token2: token,
    );
  }

  void setToken1Balance(
    double balance,
  ) {
    state = state.copyWith(
      token1Balance: balance,
    );
  }

  void setToken2Balance(
    double balance,
  ) {
    state = state.copyWith(
      token2Balance: balance,
    );
  }

  Future<void> setExpectedTokenLP() async {
    state = state.copyWith(expectedTokenLP: 0);

    if (state.token1Amount <= 0 || state.token2Amount <= 0) {
      return;
    }
    final apiService = ref.read(apiServiceProvider);
    final expectedTokenLPResult = await PoolFactoryRepositoryImpl(
      state.pool!.poolAddress,
      apiService,
    ).getLPTokenToMint(state.token1Amount, state.token2Amount);
    expectedTokenLPResult.map(
      success: (success) {
        if (success != null) {
          state = state.copyWith(expectedTokenLP: success);

          if (success == 0) {
            setFailure(
              const aedappfm.Failure.other(
                cause:
                    'Please increase the amount of tokens added to be eligible for receiving LP Tokens.',
              ),
            );
          }
        }
      },
      failure: (failure) {},
    );
  }

  Future<double> _calculateEquivalentAmount(
    String tokenAddress,
    double amount, {
    Duration delay = const Duration(milliseconds: 800),
  }) async {
    final apiService = ref.read(apiServiceProvider);
    late final double equivalentAmount;
    try {
      equivalentAmount = await Future<double>(
        () async {
          if (amount <= 0) {
            return 0;
          }

          _calculateEquivalentAmountTask?.cancel();
          _calculateEquivalentAmountTask = aedappfm.CancelableTask<double?>(
            task: () async {
              var _equivalentAmount = 0.0;
              final equivalentAmountResult = await PoolFactoryRepositoryImpl(
                state.pool!.poolAddress,
                apiService,
              ).getEquivalentAmount(tokenAddress, amount);

              equivalentAmountResult.map(
                success: (success) {
                  if (success != null) {
                    _equivalentAmount = success;
                  }
                },
                failure: (failure) {
                  setFailure(
                    aedappfm.Failure.other(
                      cause: 'getEquivalentAmount error $failure',
                    ),
                  );
                },
              );
              return _equivalentAmount;
            },
          );

          final __equivalentAmount =
              await _calculateEquivalentAmountTask?.schedule(delay);

          return __equivalentAmount ?? 0;
        },
      );
    } on aedappfm.CanceledTask {
      return 0;
    }
    return equivalentAmount;
  }

  Future<void> calculateTokenInfos() async {
    if (state.tokenFormSelected == 1) {
      state = state.copyWith(
        calculateToken2: true,
        calculationInProgress: true,
      );
      final equivalentAmount = await _calculateEquivalentAmount(
        state.token1!.isUCO ? kUCOAddress : state.token1!.address,
        state.token1Amount,
      );
      state = state.copyWith(
        token2Amount: equivalentAmount,
        calculateToken2: false,
      );
    } else {
      state = state.copyWith(
        calculateToken1: true,
        calculationInProgress: true,
      );
      final equivalentAmount = await _calculateEquivalentAmount(
        state.token2!.isUCO ? kUCOAddress : state.token2!.address,
        state.token2Amount,
      );
      state = state.copyWith(
        token1Amount: equivalentAmount,
        calculateToken1: false,
      );
    }

    await setExpectedTokenLP();
    estimateTokenMinAmounts();

    state = state.copyWith(
      calculationInProgress: false,
    );
  }

  Future<void> setToken1Amount(
    AppLocalizations appLocalizations,
    double amount,
  ) async {
    state = state.copyWith(
      failure: null,
      messageMaxHalfUCO: false,
      token1Amount: amount,
    );

    if (state.token1Amount > state.token1Balance) {
      state = state.copyWith(
        token2Amount: 0,
      );

      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken1AmountExceedBalance,
        ),
      );
      return;
    }

    await calculateTokenInfos();

    if (state.token2Amount > state.token2Balance) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken2AmountExceedBalance,
        ),
      );
    }
  }

  Future<void> setToken2Amount(
    AppLocalizations appLocalizations,
    double amount,
  ) async {
    state = state.copyWith(
      failure: null,
      messageMaxHalfUCO: false,
      token2Amount: amount,
    );

    if (state.token2Amount > state.token2Balance) {
      state = state.copyWith(
        token1Amount: 0,
      );

      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken2AmountExceedBalance,
        ),
      );
      return;
    }

    await calculateTokenInfos();

    if (state.token1Amount > state.token1Balance) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken1AmountExceedBalance,
        ),
      );
    }
  }

  void estimateTokenMinAmounts() {
    final slippagePourcent = (Decimal.parse('100') -
            Decimal.parse(state.slippageTolerance.toString())) /
        Decimal.parse('100');
    setToken1minAmount(
      (Decimal.parse(state.token1Amount.toString()) *
              slippagePourcent.toDecimal())
          .toDouble(),
    );
    setToken2minAmount(
      (Decimal.parse(state.token2Amount.toString()) *
              slippagePourcent.toDecimal())
          .toDouble(),
    );
  }

  void estimateNetworkFees() {
    state = state.copyWith(
      networkFees: 0,
    );
  }

  void setTokenFormSelected(int tokenFormSelected) {
    state = state.copyWith(failure: null, tokenFormSelected: tokenFormSelected);
  }

  void setFailure(aedappfm.Failure? failure) {
    state = state.copyWith(
      failure: failure,
    );
  }

  void setFinalAmount(double? finalAmount) {
    state = state.copyWith(finalAmount: finalAmount);
  }

  void setLiquidityAddOk(bool liquidityAddOk) {
    state = state.copyWith(
      liquidityAddOk: liquidityAddOk,
    );
  }

  void setCurrentStep(int currentStep) {
    state = state.copyWith(currentStep: currentStep);
  }

  void setToken1minAmount(double token1minAmount) {
    state = state.copyWith(token1minAmount: token1minAmount);
  }

  void setToken2minAmount(double token2minAmount) {
    state = state.copyWith(token2minAmount: token2minAmount);
  }

  void setSlippageTolerance(double slippageTolerance) {
    state = state.copyWith(slippageTolerance: slippageTolerance);
    estimateTokenMinAmounts();
  }

  void setResumeProcess(bool resumeProcess) {
    state = state.copyWith(resumeProcess: resumeProcess);
  }

  void setProcessInProgress(bool isProcessInProgress) {
    state = state.copyWith(isProcessInProgress: isProcessInProgress);
  }

  void setLiquidityAddProcessStep(
    aedappfm.ProcessStep liquidityAddProcessStep,
  ) {
    state = state.copyWith(
      processStep: liquidityAddProcessStep,
    );
  }

  Future<void> validateForm(AppLocalizations appLocalizations) async {
    if (await control(appLocalizations) == false) {
      return;
    }

    final accountSelected = ref.read(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    DateTime? consentDateTime;
    consentDateTime = await aedappfm.ConsentRepositoryImpl()
        .getConsentTime(accountSelected!.genesisAddress);
    state = state.copyWith(consentDateTime: consentDateTime);

    setLiquidityAddProcessStep(
      aedappfm.ProcessStep.confirmation,
    );
  }

  void setMessageMaxHalfUCO(
    bool messageMaxHalfUCO,
  ) {
    state = state.copyWith(
      messageMaxHalfUCO: messageMaxHalfUCO,
    );
  }

  Future<bool> control(AppLocalizations appLocalizations) async {
    setFailure(null);
    setMessageMaxHalfUCO(false);

    if (BrowserUtil().isEdgeBrowser() ||
        BrowserUtil().isInternetExplorerBrowser()) {
      setFailure(
        const aedappfm.Failure.incompatibleBrowser(),
      );
      return false;
    }

    if (state.token1Amount <= 0) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken1AmountEmpty,
        ),
      );
      return false;
    }

    if (state.token2Amount <= 0) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken2AmountEmpty,
        ),
      );
      return false;
    }

    if (state.token1Amount > state.token1Balance) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken1AmountExceedBalance,
        ),
      );
      return false;
    }

    if (state.token2Amount > state.token2Balance) {
      setFailure(
        aedappfm.Failure.other(
          cause: appLocalizations.liquidityAddControlToken2AmountExceedBalance,
        ),
      );
      return false;
    }

    var feesEstimatedUCO = 0.0;
    if (state.token1 != null && state.token1!.isUCO) {
      state = state.copyWith(calculationInProgress: true);
      feesEstimatedUCO = await ref.read(addLiquidityCaseProvider).estimateFees(
            state.pool!.poolAddress,
            state.token1!,
            state.token1Amount,
            state.token2!,
            state.token2Amount,
            state.slippageTolerance,
          );
      state = state.copyWith(
        calculationInProgress: false,
        feesEstimatedUCO: feesEstimatedUCO,
      );
    }

    if (feesEstimatedUCO > 0) {
      if (state.token1Amount + feesEstimatedUCO > state.token1Balance) {
        final adjustedAmount = state.token1Balance - feesEstimatedUCO;
        if (adjustedAmount < 0) {
          state = state.copyWith(messageMaxHalfUCO: true);
          setFailure(const aedappfm.Failure.insufficientFunds());
          return false;
        } else {
          await setToken1Amount(appLocalizations, adjustedAmount);
          state = state.copyWith(messageMaxHalfUCO: true);
        }
      }
    }

    if (state.token2 != null && state.token2!.isUCO) {
      state = state.copyWith(calculationInProgress: true);
      feesEstimatedUCO = await ref.read(addLiquidityCaseProvider).estimateFees(
            state.pool!.poolAddress,
            state.token1!,
            state.token1Amount,
            state.token2!,
            state.token2Amount,
            state.slippageTolerance,
          );
      state = state.copyWith(
        calculationInProgress: false,
        feesEstimatedUCO: feesEstimatedUCO,
      );
    }

    if (feesEstimatedUCO > 0) {
      if (state.token2Amount + feesEstimatedUCO > state.token2Balance) {
        final adjustedAmount = state.token2Balance - feesEstimatedUCO;
        if (adjustedAmount < 0) {
          state = state.copyWith(messageMaxHalfUCO: true);
          setFailure(const aedappfm.Failure.insufficientFunds());
          return false;
        } else {
          await setToken2Amount(appLocalizations, adjustedAmount);
          state = state.copyWith(messageMaxHalfUCO: true);
        }
      }
    }

    return true;
  }

  Future<bool> add(AppLocalizations appLocalizations) async {
    setLiquidityAddOk(false);
    setProcessInProgress(true);

    if (await control(appLocalizations) == false) {
      setProcessInProgress(false);
      return false;
    }
    final accountSelected = ref.read(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    await aedappfm.ConsentRepositoryImpl()
        .addAddress(accountSelected!.genesisAddress);
    await ref.read(addLiquidityCaseProvider).run(
          appLocalizations,
          this,
          state.pool!.poolAddress,
          state.token1!,
          state.token1Amount,
          state.token2!,
          state.token2Amount,
          state.slippageTolerance,
          state.pool!.lpToken,
        );

    ref
      ..invalidate(userBalanceProvider)
      ..invalidate(DexPoolProviders.getPool(state.pool!.poolAddress));

    return true;
  }
}
