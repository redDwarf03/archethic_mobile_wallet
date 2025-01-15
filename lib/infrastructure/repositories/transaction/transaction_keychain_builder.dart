/// SPDX-License-Identifier: AGPL-3.0-or-later
// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';
import 'dart:math';
import 'package:archethic_lib_dart/archethic_lib_dart.dart' as archethic;
import 'package:flutter/foundation.dart';

const blockchainTxVersion = 3;

extension KeychainTransactionBuilder on archethic.Transaction {
  /// Builds a creation of keychain Transaction
  static Future<archethic.Transaction> build({
    required archethic.Keychain keychain,
    required String originPrivateKey,
    required archethic.ApiService apiService,
  }) async {
    final genesisAddressKeychain =
        archethic.deriveAddress(archethic.uint8ListToHex(keychain.seed!), 0);

    final lastTransactionKeychainMap = await apiService.getLastTransaction(
      [genesisAddressKeychain],
      request:
          'chainLength, data { content, ownerships { authorizedPublicKeys { publicKey } } }',
    );

    final aesKey = archethic.uint8ListToHex(
      Uint8List.fromList(
        List<int>.generate(32, (int i) => Random.secure().nextInt(256)),
      ),
    );

    final keychainTransaction = archethic.Transaction(
      type: 'keychain',
      version: blockchainTxVersion,
      data: archethic.Transaction.initData(),
    ).setContent(jsonEncode(keychain.toDID()));

    final authorizedKeys = List<archethic.AuthorizedKey>.empty(growable: true);
    final authorizedKeysList =
        lastTransactionKeychainMap[genesisAddressKeychain]!
            .data!
            .ownerships[0]
            .authorizedPublicKeys;
    for (final authorizedKey in authorizedKeysList) {
      authorizedKeys.add(
        archethic.AuthorizedKey(
          encryptedSecretKey: archethic.uint8ListToHex(
            archethic.ecEncrypt(aesKey, authorizedKey.publicKey),
          ),
          publicKey: authorizedKey.publicKey,
        ),
      );
    }

    keychainTransaction.addOwnership(
      archethic.uint8ListToHex(archethic.aesEncrypt(keychain.encode(), aesKey)),
      authorizedKeys,
    );

    return keychainTransaction
        .build(
          archethic.uint8ListToHex(keychain.seed!),
          lastTransactionKeychainMap[genesisAddressKeychain]!.chainLength!,
        )
        .transaction
        .originSign(originPrivateKey);
  }
}
