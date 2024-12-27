/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'transfer.freezed.dart';

/// Represents a transfer, blockchain agnostic.
@freezed
class Transfer with _$Transfer {
  const Transfer._();
  const factory Transfer.uco({
    required KeychainSecuredInfos keychainSecuredInfos,
    required String genesisAddress,
    required String accountSelectedName,
    required String message,
    required double amount, // expressed in UCO
    required Address recipientAddress,
  }) = _TransferUco;

  const factory Transfer.token({
    required KeychainSecuredInfos keychainSecuredInfos,
    required String genesisAddress,
    required String accountSelectedName,
    required String message,
    required double amount, // expressed in token
    required Address recipientAddress,
    required String type,
    required String? tokenAddress,
    required int? tokenId,
    required Map<String, dynamic> properties,
    required List<int> aeip,
  }) = _TransferToken;
}
