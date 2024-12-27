// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nftRepositoryHash() => r'7b2f6d7271498bc5d93d7db83bc26b92c051a1a1';

/// See also [_nftRepository].
@ProviderFor(_nftRepository)
final _nftRepositoryProvider = AutoDisposeProvider<NFTRepositoryImpl>.internal(
  _nftRepository,
  name: r'_nftRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nftRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _NftRepositoryRef = AutoDisposeProviderRef<NFTRepositoryImpl>;
String _$getNFTInfoHash() => r'09d7716d3ee032057bb6912c612747c3802d3e46';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [_getNFTInfo].
@ProviderFor(_getNFTInfo)
const _getNFTInfoProvider = _GetNFTInfoFamily();

/// See also [_getNFTInfo].
class _GetNFTInfoFamily extends Family<AsyncValue<TokenInformation?>> {
  /// See also [_getNFTInfo].
  const _GetNFTInfoFamily();

  /// See also [_getNFTInfo].
  _GetNFTInfoProvider call(
    String address,
    KeychainServiceKeyPair keychainServiceKeyPair,
  ) {
    return _GetNFTInfoProvider(
      address,
      keychainServiceKeyPair,
    );
  }

  @override
  _GetNFTInfoProvider getProviderOverride(
    covariant _GetNFTInfoProvider provider,
  ) {
    return call(
      provider.address,
      provider.keychainServiceKeyPair,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_getNFTInfoProvider';
}

/// See also [_getNFTInfo].
class _GetNFTInfoProvider extends AutoDisposeFutureProvider<TokenInformation?> {
  /// See also [_getNFTInfo].
  _GetNFTInfoProvider(
    String address,
    KeychainServiceKeyPair keychainServiceKeyPair,
  ) : this._internal(
          (ref) => _getNFTInfo(
            ref as _GetNFTInfoRef,
            address,
            keychainServiceKeyPair,
          ),
          from: _getNFTInfoProvider,
          name: r'_getNFTInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getNFTInfoHash,
          dependencies: _GetNFTInfoFamily._dependencies,
          allTransitiveDependencies:
              _GetNFTInfoFamily._allTransitiveDependencies,
          address: address,
          keychainServiceKeyPair: keychainServiceKeyPair,
        );

  _GetNFTInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
    required this.keychainServiceKeyPair,
  }) : super.internal();

  final String address;
  final KeychainServiceKeyPair keychainServiceKeyPair;

  @override
  Override overrideWith(
    FutureOr<TokenInformation?> Function(_GetNFTInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetNFTInfoProvider._internal(
        (ref) => create(ref as _GetNFTInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
        keychainServiceKeyPair: keychainServiceKeyPair,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TokenInformation?> createElement() {
    return _GetNFTInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetNFTInfoProvider &&
        other.address == address &&
        other.keychainServiceKeyPair == keychainServiceKeyPair;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);
    hash = _SystemHash.combine(hash, keychainServiceKeyPair.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetNFTInfoRef on AutoDisposeFutureProviderRef<TokenInformation?> {
  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `keychainServiceKeyPair` of this provider.
  KeychainServiceKeyPair get keychainServiceKeyPair;
}

class _GetNFTInfoProviderElement
    extends AutoDisposeFutureProviderElement<TokenInformation?>
    with _GetNFTInfoRef {
  _GetNFTInfoProviderElement(super.provider);

  @override
  String get address => (origin as _GetNFTInfoProvider).address;
  @override
  KeychainServiceKeyPair get keychainServiceKeyPair =>
      (origin as _GetNFTInfoProvider).keychainServiceKeyPair;
}

String _$isAccountOwnerHash() => r'cbb63a8d814dfc596d6831ba3043312a15e6a486';

/// See also [_isAccountOwner].
@ProviderFor(_isAccountOwner)
const _isAccountOwnerProvider = _IsAccountOwnerFamily();

/// See also [_isAccountOwner].
class _IsAccountOwnerFamily extends Family<AsyncValue<bool>> {
  /// See also [_isAccountOwner].
  const _IsAccountOwnerFamily();

  /// See also [_isAccountOwner].
  _IsAccountOwnerProvider call(
    String accountAddress,
    String tokenAddress,
    String tokenId,
  ) {
    return _IsAccountOwnerProvider(
      accountAddress,
      tokenAddress,
      tokenId,
    );
  }

  @override
  _IsAccountOwnerProvider getProviderOverride(
    covariant _IsAccountOwnerProvider provider,
  ) {
    return call(
      provider.accountAddress,
      provider.tokenAddress,
      provider.tokenId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_isAccountOwnerProvider';
}

/// See also [_isAccountOwner].
class _IsAccountOwnerProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [_isAccountOwner].
  _IsAccountOwnerProvider(
    String accountAddress,
    String tokenAddress,
    String tokenId,
  ) : this._internal(
          (ref) => _isAccountOwner(
            ref as _IsAccountOwnerRef,
            accountAddress,
            tokenAddress,
            tokenId,
          ),
          from: _isAccountOwnerProvider,
          name: r'_isAccountOwnerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isAccountOwnerHash,
          dependencies: _IsAccountOwnerFamily._dependencies,
          allTransitiveDependencies:
              _IsAccountOwnerFamily._allTransitiveDependencies,
          accountAddress: accountAddress,
          tokenAddress: tokenAddress,
          tokenId: tokenId,
        );

  _IsAccountOwnerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAddress,
    required this.tokenAddress,
    required this.tokenId,
  }) : super.internal();

  final String accountAddress;
  final String tokenAddress;
  final String tokenId;

  @override
  Override overrideWith(
    FutureOr<bool> Function(_IsAccountOwnerRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _IsAccountOwnerProvider._internal(
        (ref) => create(ref as _IsAccountOwnerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAddress: accountAddress,
        tokenAddress: tokenAddress,
        tokenId: tokenId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsAccountOwnerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IsAccountOwnerProvider &&
        other.accountAddress == accountAddress &&
        other.tokenAddress == tokenAddress &&
        other.tokenId == tokenId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAddress.hashCode);
    hash = _SystemHash.combine(hash, tokenAddress.hashCode);
    hash = _SystemHash.combine(hash, tokenId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _IsAccountOwnerRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `accountAddress` of this provider.
  String get accountAddress;

  /// The parameter `tokenAddress` of this provider.
  String get tokenAddress;

  /// The parameter `tokenId` of this provider.
  String get tokenId;
}

class _IsAccountOwnerProviderElement
    extends AutoDisposeFutureProviderElement<bool> with _IsAccountOwnerRef {
  _IsAccountOwnerProviderElement(super.provider);

  @override
  String get accountAddress =>
      (origin as _IsAccountOwnerProvider).accountAddress;
  @override
  String get tokenAddress => (origin as _IsAccountOwnerProvider).tokenAddress;
  @override
  String get tokenId => (origin as _IsAccountOwnerProvider).tokenId;
}

String _$getNFTListHash() => r'5dcaab1b5d8ddd6c5ac67a7c55da2705282c4185';

/// See also [_getNFTList].
@ProviderFor(_getNFTList)
const _getNFTListProvider = _GetNFTListFamily();

/// See also [_getNFTList].
class _GetNFTListFamily
    extends Family<AsyncValue<(List<AccountToken>, List<AccountToken>)>> {
  /// See also [_getNFTList].
  const _GetNFTListFamily();

  /// See also [_getNFTList].
  _GetNFTListProvider call(
    String genesisAddress,
    String nameAccount,
    KeychainSecuredInfos keychainSecuredInfos,
  ) {
    return _GetNFTListProvider(
      genesisAddress,
      nameAccount,
      keychainSecuredInfos,
    );
  }

  @override
  _GetNFTListProvider getProviderOverride(
    covariant _GetNFTListProvider provider,
  ) {
    return call(
      provider.genesisAddress,
      provider.nameAccount,
      provider.keychainSecuredInfos,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_getNFTListProvider';
}

/// See also [_getNFTList].
class _GetNFTListProvider extends AutoDisposeFutureProvider<
    (List<AccountToken>, List<AccountToken>)> {
  /// See also [_getNFTList].
  _GetNFTListProvider(
    String genesisAddress,
    String nameAccount,
    KeychainSecuredInfos keychainSecuredInfos,
  ) : this._internal(
          (ref) => _getNFTList(
            ref as _GetNFTListRef,
            genesisAddress,
            nameAccount,
            keychainSecuredInfos,
          ),
          from: _getNFTListProvider,
          name: r'_getNFTListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getNFTListHash,
          dependencies: _GetNFTListFamily._dependencies,
          allTransitiveDependencies:
              _GetNFTListFamily._allTransitiveDependencies,
          genesisAddress: genesisAddress,
          nameAccount: nameAccount,
          keychainSecuredInfos: keychainSecuredInfos,
        );

  _GetNFTListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genesisAddress,
    required this.nameAccount,
    required this.keychainSecuredInfos,
  }) : super.internal();

  final String genesisAddress;
  final String nameAccount;
  final KeychainSecuredInfos keychainSecuredInfos;

  @override
  Override overrideWith(
    FutureOr<(List<AccountToken>, List<AccountToken>)> Function(
            _GetNFTListRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetNFTListProvider._internal(
        (ref) => create(ref as _GetNFTListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genesisAddress: genesisAddress,
        nameAccount: nameAccount,
        keychainSecuredInfos: keychainSecuredInfos,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<(List<AccountToken>, List<AccountToken>)>
      createElement() {
    return _GetNFTListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetNFTListProvider &&
        other.genesisAddress == genesisAddress &&
        other.nameAccount == nameAccount &&
        other.keychainSecuredInfos == keychainSecuredInfos;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genesisAddress.hashCode);
    hash = _SystemHash.combine(hash, nameAccount.hashCode);
    hash = _SystemHash.combine(hash, keychainSecuredInfos.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetNFTListRef
    on AutoDisposeFutureProviderRef<(List<AccountToken>, List<AccountToken>)> {
  /// The parameter `genesisAddress` of this provider.
  String get genesisAddress;

  /// The parameter `nameAccount` of this provider.
  String get nameAccount;

  /// The parameter `keychainSecuredInfos` of this provider.
  KeychainSecuredInfos get keychainSecuredInfos;
}

class _GetNFTListProviderElement extends AutoDisposeFutureProviderElement<
    (List<AccountToken>, List<AccountToken>)> with _GetNFTListRef {
  _GetNFTListProviderElement(super.provider);

  @override
  String get genesisAddress => (origin as _GetNFTListProvider).genesisAddress;
  @override
  String get nameAccount => (origin as _GetNFTListProvider).nameAccount;
  @override
  KeychainSecuredInfos get keychainSecuredInfos =>
      (origin as _GetNFTListProvider).keychainSecuredInfos;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
