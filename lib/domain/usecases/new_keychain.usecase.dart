/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:aewallet/application/session/session.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

final _logger = Logger('KeychainUtil');

class CreateNewAppWalletCase with aedappfm.TransactionMixin {
  CreateNewAppWalletCase({
    required this.apiService,
    required this.sessionNotifier,
  });

  final archethic.ApiService apiService;
  final SessionNotifier sessionNotifier;

  Future<void> run(
    String? seed,
    List<String> nameList,
  ) async {
    /// Get Wallet KeyPair
    final walletKeyPair = archethic.deriveKeyPair(seed!, 0);

    /// Generate keyChain Seed from random value
    final keychainSeed = archethic.uint8ListToHex(
      Uint8List.fromList(
        List<int>.generate(32, (int i) => Random.secure().nextInt(256)),
      ),
    );

    var keychain =
        archethic.Keychain(seed: archethic.hexToUint8List(keychainSeed));
    final servicesMap = <String, String>{};
    for (final name in nameList) {
      final kServiceName = 'archethic-wallet-${Uri.encodeFull(name)}';
      final kDerivationPathWithoutIndex = "m/650'/$kServiceName/";
      const index = '0';
      final kDerivationPath = '$kDerivationPathWithoutIndex$index';
      keychain = keychain.copyWithService(kServiceName, kDerivationPath);
      servicesMap[kServiceName] = kDerivationPath;
    }

    final blockchainTxVersion = int.parse(
      (await apiService.getBlockchainVersion()).version.transaction,
    );

    final originPrivateKey = apiService.getOriginKey();

    /// Create Keychain from keyChain seed and wallet public key to encrypt secret
    final keychainTransaction = apiService.newKeychainTransaction(
      keychainSeed,
      <String>[archethic.uint8ListToHex(walletKeyPair.publicKey!)],
      archethic.hexToUint8List(originPrivateKey),
      blockchainTxVersion,
      servicesMap: servicesMap,
    );

    _logger.info('>>> Create keychain <<< ${keychainTransaction.address}');
    try {
      final confirmation = await archethic.ArchethicTransactionSender(
        apiService: apiService,
      ).send(
        transaction: keychainTransaction,
      );

      if (confirmation == null) return;
    } on archethic.TransactionError catch (error) {
      throw ArchethicNewKeychainErrorException(error.messageLabel);
    }

    final accessKeychainTx = apiService.newAccessKeychainTransaction(
      seed,
      archethic
          .hexToUint8List(keychainTransaction.address!.address!.toUpperCase()),
      archethic.hexToUint8List(originPrivateKey),
      blockchainTxVersion,
    );

    _logger.info('>>> Create access <<< ${accessKeychainTx.address}');
    try {
      final confirmation = await archethic.ArchethicTransactionSender(
        apiService: apiService,
      ).send(
        transaction: accessKeychainTx,
      );

      if (confirmation == null) return;
    } on archethic.TransactionError catch (error) {
      throw ArchethicNewKeychainAccessErrorException(error.messageLabel);
    }

    _logger.info('>>> Create createNewAppWallet <<<');
    await sessionNotifier.createNewAppWallet(
      seed: seed,
      keychainAddress: keychainTransaction.address!.address!,
      keychain: keychain,
      // Multi ??????
      name: nameList[0],
    );
  }
}

@immutable
class ArchethicNewKeychainErrorException
    implements archethic.ArchethicException {
  const ArchethicNewKeychainErrorException(this.cause);
  final String cause;
}

@immutable
class ArchethicNewKeychainAccessErrorException
    implements archethic.ArchethicException {
  const ArchethicNewKeychainAccessErrorException(this.cause);
  final String cause;
}
