import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/application/transaction_repository.dart';
import 'package:aewallet/domain/usecases/aeswap/add_liquidity.usecase.dart';
import 'package:aewallet/domain/usecases/aeswap/claim_farm_lock.usecase.dart';
import 'package:aewallet/domain/usecases/aeswap/deposit_farm_lock.usecase.dart';
import 'package:aewallet/domain/usecases/aeswap/level_up_farm_lock.usecase.dart';
import 'package:aewallet/domain/usecases/aeswap/remove_liquidity.usecase.dart';
import 'package:aewallet/domain/usecases/aeswap/swap.usecase.dart';
import 'package:aewallet/domain/usecases/aeswap/withdraw_farm_lock.usecase.dart';
import 'package:aewallet/modules/aeswap/application/notification.dart';
import 'package:aewallet/modules/aeswap/application/verified_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usecases.g.dart';

@riverpod
AddLiquidityCase addLiquidityCase(
  Ref ref,
) =>
    AddLiquidityCase(
      apiService: ref.watch(apiServiceProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );

@riverpod
ClaimFarmLockCase claimFarmLockCase(
  Ref ref,
) =>
    ClaimFarmLockCase(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );

@riverpod
DepositFarmLockCase depositFarmLockCase(
  Ref ref,
) =>
    DepositFarmLockCase(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );

@riverpod
LevelUpFarmLockCase levelUpFarmLockCase(
  Ref ref,
) =>
    LevelUpFarmLockCase(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );

@riverpod
RemoveLiquidityCase removeLiquidityCase(
  Ref ref,
) =>
    RemoveLiquidityCase(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );

@riverpod
SwapCase swapCase(
  Ref ref,
) =>
    SwapCase(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );

@riverpod
WithdrawFarmLockCase withdrawFarmLockCase(
  Ref ref,
) =>
    WithdrawFarmLockCase(
      apiService: ref.watch(apiServiceProvider),
      verifiedTokensRepository: ref.watch(verifiedTokensRepositoryProvider),
      notificationService: ref.watch(NotificationProviders.notificationService),
      transactionRepository: ref.watch(archethicTransactionRepositoryProvider),
      keychainSecuredInfos: ref
          .watch(sessionNotifierProvider)
          .loggedIn!
          .wallet
          .keychainSecuredInfos,
      selectedAccount: ref
          .watch(
            AccountProviders.accounts,
          )
          .value!
          .selectedAccount!,
    );
