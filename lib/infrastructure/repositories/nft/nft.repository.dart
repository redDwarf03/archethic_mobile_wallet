import 'dart:convert';
import 'dart:typed_data';

import 'package:aewallet/domain/repositories/nft/nft.repository.dart';
import 'package:aewallet/model/blockchain/keychain_secured_infos.dart';
import 'package:aewallet/model/blockchain/token_information.dart';
import 'package:aewallet/model/data/account_token.dart';
import 'package:aewallet/model/keychain_service_keypair.dart';
import 'package:aewallet/service/app_service.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:logging/logging.dart';

class NFTRepositoryImpl implements NFTRepository {
  static final _logger = Logger('NFTRepository');

  @override
  Future<bool> isAccountOwner(
    String accountAddress,
    String tokenAddress,
    String tokenId,
    ApiService apiService,
  ) async {
    final accountLastAddressMap =
        await apiService.getLastTransaction([accountAddress]);
    var accounLastAddress = '';
    if (accountLastAddressMap[accountAddress] == null ||
        accountLastAddressMap[accountAddress]!.address == null ||
        accountLastAddressMap[accountAddress]!.address!.address == null) {
      accounLastAddress = accountAddress;
    } else {
      accounLastAddress =
          accountLastAddressMap[accountAddress]!.address!.address!;
    }

    final accountLastInputsMap = await apiService.getTransactionInputs(
      [accounLastAddress],
      request: 'amount, from, tokenAddress, spent, timestamp, type, tokenId',
    );

    if (accountLastInputsMap[accounLastAddress] == null) {
      return false;
    }

    final _tokenId = int.tryParse(tokenId);

    final accountLastInputs = accountLastInputsMap[accounLastAddress];
    for (final input in accountLastInputs!) {
      if (_tokenId == null) {
        if (input.tokenAddress == tokenAddress) {
          return true;
        }
      } else {
        if (input.tokenAddress == tokenAddress && input.tokenId == _tokenId) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  Future<TokenInformation?> getNFTInfo(
    String address,
    KeychainServiceKeyPair keychainServiceKeyPair,
    AppService appService,
  ) async {
    final tokenMap = await appService.getToken(
      [address],
    );

    if (tokenMap.isEmpty ||
        tokenMap[address] == null ||
        tokenMap[address]!.type != 'non-fungible') {
      return null;
    }

    final token = tokenMap[address]!;

    final tokenProperties = {...token.properties};

    if (token.ownerships != null && token.ownerships!.isNotEmpty) {
      tokenProperties.addAll(
        _tokenPropertiesDecryptedSecret(
          keypair: keychainServiceKeyPair,
          ownerships: token.ownerships!,
        ),
      );
    }
    final tokenInformation = TokenInformation(
      address: address,
      name: token.name,
      id: token.id,
      type: token.type,
      decimals: token.decimals,
      supply: fromBigInt(token.supply).toDouble(),
      symbol: token.symbol,
      tokenProperties: tokenProperties,
      tokenCollection: token.collection,
    );
    return tokenInformation;
  }

  @override
  Future<(List<AccountToken>, List<AccountToken>)> getNFTList(
    String genesisAddress,
    String nameAccount,
    KeychainSecuredInfos keychainSecuredInfos,
    AppService appService,
    ApiService apiService,
  ) async {
    final balanceMap = await apiService.fetchBalance([genesisAddress]);
    final balance = balanceMap[genesisAddress];
    final nftList = <AccountToken>[];
    final nftCollectionList = <AccountToken>[];

    final tokenAddressList = <String>[];
    if (balance == null) {
      return (nftList, nftCollectionList);
    }

    for (final tokenBalance in balance.token) {
      if (tokenBalance.address != null) {
        tokenAddressList.add(tokenBalance.address!);
      }
    }

    final tokenMap = await appService.getToken(
      tokenAddressList.toSet().toList(),
    );

    for (final tokenBalance in balance.token) {
      final token = tokenMap[tokenBalance.address];

      if (token == null || token.type != 'non-fungible') {
        continue;
      }

      final newProperties = {...token.properties};

      if (tokenMap[tokenBalance.address] != null &&
          tokenMap[tokenBalance.address]!.ownerships != null &&
          tokenMap[tokenBalance.address]!.ownerships!.isNotEmpty) {
        newProperties.addAll(
          _tokenPropertiesDecryptedSecret(
            keypair: keychainSecuredInfos.services[nameAccount]!.keyPair!,
            ownerships: tokenMap[tokenBalance.address]!.ownerships!,
          ),
        );
      }

      final collectionWithTokenId = <Map<String, dynamic>>[];
      var numTokenId = 1;
      for (final collection in token.collection) {
        final nftCollection = balance.token
            .where((element) => element.address == tokenBalance.address);
        if (nftCollection.any((element) => element.tokenId == numTokenId)) {
          collection['id'] = numTokenId.toString();
          collectionWithTokenId.add(collection);
        }

        numTokenId++;
      }

      final tokenInformation = TokenInformation(
        address: tokenBalance.address,
        name: token.name,
        id: token.id,
        aeip: token.aeip,
        type: token.type,
        supply: fromBigInt(token.supply).toDouble(),
        symbol: token.symbol,
        decimals: token.decimals,
        tokenCollection: collectionWithTokenId,
        tokenProperties: newProperties,
      );

      final accountToken = AccountToken(
        tokenInformation: tokenInformation,
        amount: fromBigInt(tokenBalance.amount).toDouble(),
      );

      if (tokenInformation.tokenCollection != null &&
          tokenInformation.tokenCollection!.isNotEmpty) {
        nftCollectionList.add(accountToken);
      } else {
        nftList.add(accountToken);
      }
    }
    nftList.sort(
      (a, b) => a.tokenInformation!.name!.compareTo(b.tokenInformation!.name!),
    );
    nftCollectionList.sort(
      (a, b) => a.tokenInformation!.name!.compareTo(b.tokenInformation!.name!),
    );
    return (nftList, nftCollectionList);
  }

  Map<String, dynamic> _tokenPropertiesDecryptedSecret({
    required KeychainServiceKeyPair keypair,
    required List<Ownership> ownerships,
  }) {
    final propertiesDecrypted = <String, dynamic>{};
    for (final ownership in ownerships) {
      final authorizedPublicKey = ownership.authorizedPublicKeys.firstWhere(
        (AuthorizedKey authKey) =>
            authKey.publicKey!.toUpperCase() ==
            uint8ListToHex(Uint8List.fromList(keypair.publicKey)).toUpperCase(),
        orElse: AuthorizedKey.new,
      );
      if (authorizedPublicKey.encryptedSecretKey != null) {
        final aesKey = ecDecrypt(
          authorizedPublicKey.encryptedSecretKey,
          Uint8List.fromList(keypair.privateKey),
        );
        final decryptedSecret = aesDecrypt(ownership.secret, aesKey);
        try {
          propertiesDecrypted.addAll(json.decode(utf8.decode(decryptedSecret)));
        } catch (e, stack) {
          _logger.severe('Decryption error', e, stack);
        }
      }
    }
    return propertiesDecrypted;
  }
}
