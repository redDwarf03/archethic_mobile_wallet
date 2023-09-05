// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nft.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nftRepositoryHash() => r'c16cc640004fbaf88bbe6c50e643bbe5b8c577ed';

/// See also [_nftRepository].
@ProviderFor(_nftRepository)
final _nftRepositoryProvider = AutoDisposeProvider<NFTRepository>.internal(
  _nftRepository,
  name: r'_nftRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nftRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _NftRepositoryRef = AutoDisposeProviderRef<NFTRepository>;
String _$getNFTHash() => r'bd8af3a8e0ab3eace21cb12d4b5fc266453014a6';

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

/// See also [_getNFT].
@ProviderFor(_getNFT)
const _getNFTProvider = _GetNFTFamily();

/// See also [_getNFT].
class _GetNFTFamily extends Family<AsyncValue<TokenInformations?>> {
  /// See also [_getNFT].
  const _GetNFTFamily();

  /// See also [_getNFT].
  _GetNFTProvider call(
    String address,
    KeychainServiceKeyPair keychainServiceKeyPair,
  ) {
    return _GetNFTProvider(
      address,
      keychainServiceKeyPair,
    );
  }

  @override
  _GetNFTProvider getProviderOverride(
    covariant _GetNFTProvider provider,
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
  String? get name => r'_getNFTProvider';
}

/// See also [_getNFT].
class _GetNFTProvider extends AutoDisposeFutureProvider<TokenInformations?> {
  /// See also [_getNFT].
  _GetNFTProvider(
    String address,
    KeychainServiceKeyPair keychainServiceKeyPair,
  ) : this._internal(
          (ref) => _getNFT(
            ref as _GetNFTRef,
            address,
            keychainServiceKeyPair,
          ),
          from: _getNFTProvider,
          name: r'_getNFTProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getNFTHash,
          dependencies: _GetNFTFamily._dependencies,
          allTransitiveDependencies: _GetNFTFamily._allTransitiveDependencies,
          address: address,
          keychainServiceKeyPair: keychainServiceKeyPair,
        );

  _GetNFTProvider._internal(
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
    FutureOr<TokenInformations?> Function(_GetNFTRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetNFTProvider._internal(
        (ref) => create(ref as _GetNFTRef),
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
  AutoDisposeFutureProviderElement<TokenInformations?> createElement() {
    return _GetNFTProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetNFTProvider &&
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

mixin _GetNFTRef on AutoDisposeFutureProviderRef<TokenInformations?> {
  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `keychainServiceKeyPair` of this provider.
  KeychainServiceKeyPair get keychainServiceKeyPair;
}

class _GetNFTProviderElement
    extends AutoDisposeFutureProviderElement<TokenInformations?>
    with _GetNFTRef {
  _GetNFTProviderElement(super.provider);

  @override
  String get address => (origin as _GetNFTProvider).address;
  @override
  KeychainServiceKeyPair get keychainServiceKeyPair =>
      (origin as _GetNFTProvider).keychainServiceKeyPair;
}

String _$getNFTListHash() => r'3221ef9cab2cda3e080eb3eadded6f202dcb4dbe';

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
    String address,
    String nameAccount,
    KeychainSecuredInfos keychainSecuredInfos,
  ) {
    return _GetNFTListProvider(
      address,
      nameAccount,
      keychainSecuredInfos,
    );
  }

  @override
  _GetNFTListProvider getProviderOverride(
    covariant _GetNFTListProvider provider,
  ) {
    return call(
      provider.address,
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
    String address,
    String nameAccount,
    KeychainSecuredInfos keychainSecuredInfos,
  ) : this._internal(
          (ref) => _getNFTList(
            ref as _GetNFTListRef,
            address,
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
          address: address,
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
    required this.address,
    required this.nameAccount,
    required this.keychainSecuredInfos,
  }) : super.internal();

  final String address;
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
        address: address,
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
        other.address == address &&
        other.nameAccount == nameAccount &&
        other.keychainSecuredInfos == keychainSecuredInfos;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);
    hash = _SystemHash.combine(hash, nameAccount.hashCode);
    hash = _SystemHash.combine(hash, keychainSecuredInfos.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _GetNFTListRef
    on AutoDisposeFutureProviderRef<(List<AccountToken>, List<AccountToken>)> {
  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `nameAccount` of this provider.
  String get nameAccount;

  /// The parameter `keychainSecuredInfos` of this provider.
  KeychainSecuredInfos get keychainSecuredInfos;
}

class _GetNFTListProviderElement extends AutoDisposeFutureProviderElement<
    (List<AccountToken>, List<AccountToken>)> with _GetNFTListRef {
  _GetNFTListProviderElement(super.provider);

  @override
  String get address => (origin as _GetNFTListProvider).address;
  @override
  String get nameAccount => (origin as _GetNFTListProvider).nameAccount;
  @override
  KeychainSecuredInfos get keychainSecuredInfos =>
      (origin as _GetNFTListProvider).keychainSecuredInfos;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
