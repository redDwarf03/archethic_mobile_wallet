/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:typed_data';

import 'package:aewallet/bus/transaction_send_event.dart';
import 'package:aewallet/infrastructure/datasources/appwallet.hive.dart';
import 'package:aewallet/infrastructure/repositories/transaction/transaction_keychain_builder.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos_service.dart';
import 'package:aewallet/model/data/account.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/hive_app_wallet_dto.dart';
import 'package:aewallet/model/keychain_service_keypair.dart';
import 'package:aewallet/service/app_service.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:event_taxi/event_taxi.dart';
import 'package:logging/logging.dart';

const blockchainTxVersion = 3;
mixin KeychainServiceMixin {
  final kMainDerivation = "m/650'/";

  String getServiceTypeFromPath(String derivationPath) {
    var serviceType = 'other';
    final name = derivationPath.replaceFirst(kMainDerivation, '');

    if (name.startsWith('archethic-wallet-')) {
      serviceType = 'archethicWallet';
    } else {
      if (name.startsWith('aeweb-')) {
        serviceType = 'aeweb';
      }
    }
    return serviceType;
  }

  String getNameFromPath(String derivationPath) {
    final name = derivationPath.replaceFirst(kMainDerivation, '');
    return name.split('/').first;
  }

  Future<void> createKeyChainAccess(
    String? seed,
    String keychainAddress,
    Keychain keychain,
    ApiService apiService,
  ) async {
    final _logger = Logger('createKeyChainAccess');

    final originPrivateKey = apiService.getOriginKey();

    /// Create Keychain Access for wallet
    final accessKeychainTx = apiService.newAccessKeychainTransaction(
      seed!,
      hexToUint8List(keychainAddress),
      hexToUint8List(originPrivateKey),
      blockchainTxVersion,
    );

    _logger.info('>>> Create access <<< ${accessKeychainTx.address}');
    try {
      final confirmation = await ArchethicTransactionSender(
        apiService: apiService,
      ).send(
        transaction: accessKeychainTx,
      );

      if (confirmation == null) return;
      onConfirmation(
        confirmation,
        TransactionSendEventType.keychainAccess,
        params: <String, Object>{
          'keychainAddress': keychainAddress,
          'keychain': keychain,
        },
      );
    } on TransactionError catch (error) {
      onError(
        error,
        TransactionSendEventType.keychainAccess,
      );
    }
  }

  Future<void> removeService(
    String service,
    Keychain keychain,
    ApiService apiService,
  ) async {
    final originPrivateKey = apiService.getOriginKey();
    final servicesRemoved = Map<String, Service>.from(keychain.services)
      ..removeWhere((key, value) => key == service);
    final transaction = await KeychainTransactionBuilder.build(
      keychain: keychain.copyWith(services: servicesRemoved),
      originPrivateKey: originPrivateKey,
      apiService: apiService,
    );

    try {
      final confirmation = await ArchethicTransactionSender(
        apiService: apiService,
      ).send(
        transaction: transaction,
      );

      if (confirmation == null) return;
      onConfirmation(
        confirmation,
        TransactionSendEventType.keychain,
        params: <String, Object>{
          'keychainAddress': transaction.address!.address!.toUpperCase(),
          'originPrivateKey': originPrivateKey,
          'keychain': keychain,
        },
      );
    } on TransactionError catch (error) {
      onError(
        error,
        TransactionSendEventType.keychain,
      );
    }
  }

  Future<HiveAppWalletDTO?> getListAccountsFromKeychain(
    Keychain keychain,
    HiveAppWalletDTO? appWallet,
    AppService appService,
    ApiService apiService,
  ) async {
    final accounts = List<Account>.empty(growable: true);

    HiveAppWalletDTO currentAppWallet;
    try {
      final addressKeychain = deriveAddress(uint8ListToHex(keychain.seed!), 0);

      /// Creation of a new appWallet
      if (appWallet == null) {
        final lastTransactionMap =
            await apiService.getLastTransaction([addressKeychain]);

        currentAppWallet =
            await AppWalletHiveDatasource.instance().createAppWallet(
          lastTransactionMap[addressKeychain]!.address!.address!,
        );
      } else {
        currentAppWallet = appWallet;
      }

      final selectedAccount =
          await currentAppWallet.appKeychain.getAccountSelected();

      final genesisAddressAccountList = <String>[];
      final lastAddressAccountList = <String>[];

      /// Get all services for archethic blockchain
      keychain.services.forEach((serviceName, service) async {
        final serviceType = getServiceTypeFromPath(service.derivationPath);

        final genesisAddress = keychain.deriveAddress(serviceName);
        final name = getNameFromPath(service.derivationPath);

        genesisAddressAccountList.add(
          uint8ListToHex(genesisAddress),
        );

        final isSelected = selectedAccount != null &&
            selectedAccount.name == name &&
            serviceType == 'archethicWallet';

        final account = Account(
          lastLoadingTransactionInputs: DateTime.now().millisecondsSinceEpoch ~/
              Duration.millisecondsPerSecond,
          genesisAddress: uint8ListToHex(genesisAddress),
          name: name,
          balance: AccountBalance(
            nativeTokenName: 'UCO',
            nativeTokenValue: 0,
          ),
          serviceType: serviceType,
          selected: isSelected,
        );

        accounts.add(account);
      });

      final lastTransactionKeychainMap = await apiService.getLastTransaction(
        [addressKeychain, ...genesisAddressAccountList],
        request: 'address',
      );

      currentAppWallet.appKeychain.address =
          lastTransactionKeychainMap[addressKeychain]!.address!.address!;

      for (var i = 0; i < accounts.length; i++) {
        if (lastTransactionKeychainMap[accounts[i].genesisAddress] != null &&
            lastTransactionKeychainMap[accounts[i].genesisAddress]!.address !=
                null) {
          lastAddressAccountList.add(
            lastTransactionKeychainMap[accounts[i].genesisAddress]!
                .address!
                .address!,
          );
        } else {
          lastAddressAccountList.add(
            accounts[i].genesisAddress,
          );
        }
      }

      final balanceGetResponseMap =
          await appService.getBalanceGetResponse(lastAddressAccountList);

      for (var i = 0; i < accounts.length; i++) {
        if (balanceGetResponseMap[accounts[i].genesisAddress] != null) {
          final balanceGetResponse =
              balanceGetResponseMap[accounts[i].genesisAddress]!;
          final accountBalance = AccountBalance(
            nativeTokenName: AccountBalance.cryptoCurrencyLabel,
            nativeTokenValue: fromBigInt(balanceGetResponse.uco).toDouble(),
          );
          if (balanceGetResponse.uco > 0) {
            accountBalance.tokensFungiblesNb++;
          }
          for (final token in balanceGetResponse.token) {
            if (token.tokenId != null) {
              if (token.tokenId == 0) {
                accountBalance.tokensFungiblesNb++;
              } else {
                accountBalance.nftNb++;
              }
            }
          }

          accounts[i] = accounts[i].copyWith(balance: accountBalance);
        }
      }

      accounts.sort((a, b) => a.nameDisplayed.compareTo(b.nameDisplayed));
      currentAppWallet.appKeychain.accounts = accounts;

      await AppWalletHiveDatasource.instance().saveAppWallet(currentAppWallet);
    } catch (e) {
      rethrow;
    }

    return currentAppWallet;
  }

  void onConfirmation(
    TransactionConfirmation confirmation,
    TransactionSendEventType transactionSendEventType, {
    Map<String, Object>? params,
  }) {
    EventTaxiImpl.singleton().fire(
      TransactionSendEvent(
        transactionType: transactionSendEventType,
        response: 'ok',
        nbConfirmations: confirmation.nbConfirmations,
        maxConfirmations: confirmation.maxConfirmations,
        params: params,
      ),
    );
  }

  void onError(
    TransactionError error,
    TransactionSendEventType transactionSendEventType, {
    Map<String, Object>? params,
  }) {
    EventTaxiImpl.singleton().fire(
      TransactionSendEvent(
        transactionType: transactionSendEventType,
        nbConfirmations: 0,
        maxConfirmations: 0,
        response: 'ko',
      ),
    );
  }
}

extension KeychainConversionsExt on Keychain {
  /// Convert Keychain model to KeychainSecuredInfos
  KeychainSecuredInfos toKeychainSecuredInfos() {
    final keychainSecuredInfosServiceMap =
        <String, KeychainSecuredInfosService>{};
    services.forEach((key, value) {
      final keyPair = deriveKeypair(key);

      keychainSecuredInfosServiceMap[key] = KeychainSecuredInfosService(
        curve: value.curve,
        derivationPath: value.derivationPath,
        hashAlgo: value.hashAlgo,
        name: key,
        keyPair: KeychainServiceKeyPair(
          privateKey: keyPair.privateKey!,
          publicKey: keyPair.publicKey!,
        ),
      );
    });

    return KeychainSecuredInfos(
      seed: seed!,
      version: version,
      services: keychainSecuredInfosServiceMap,
    );
  }
}

extension KeychainSecuredInfosConversionsExt on KeychainSecuredInfos {
  /// Convert KeychainSecuredInfos model to Keychain
  Keychain toKeychain() {
    final keychainServices = <String, Service>{};
    services.forEach((key, value) {
      keychainServices[key] = Service(
        curve: value.curve,
        derivationPath: value.derivationPath,
        hashAlgo: value.hashAlgo,
      );
    });

    return Keychain(
      seed: Uint8List.fromList(seed),
      services: keychainServices,
      version: version,
    );
  }
}
