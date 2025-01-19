// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountWithGenesisAddressHash() =>
    r'52ee31c2665b1e4690f91f8ae06beef075023f64';

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

/// See also [accountWithGenesisAddress].
@ProviderFor(accountWithGenesisAddress)
const accountWithGenesisAddressProvider = AccountWithGenesisAddressFamily();

/// See also [accountWithGenesisAddress].
class AccountWithGenesisAddressFamily extends Family<AsyncValue<Account?>> {
  /// See also [accountWithGenesisAddress].
  const AccountWithGenesisAddressFamily();

  /// See also [accountWithGenesisAddress].
  AccountWithGenesisAddressProvider call(
    String address, {
    bool searchGenesisAddress = false,
  }) {
    return AccountWithGenesisAddressProvider(
      address,
      searchGenesisAddress: searchGenesisAddress,
    );
  }

  @override
  AccountWithGenesisAddressProvider getProviderOverride(
    covariant AccountWithGenesisAddressProvider provider,
  ) {
    return call(
      provider.address,
      searchGenesisAddress: provider.searchGenesisAddress,
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
  String? get name => r'accountWithGenesisAddressProvider';
}

/// See also [accountWithGenesisAddress].
class AccountWithGenesisAddressProvider
    extends AutoDisposeFutureProvider<Account?> {
  /// See also [accountWithGenesisAddress].
  AccountWithGenesisAddressProvider(
    String address, {
    bool searchGenesisAddress = false,
  }) : this._internal(
          (ref) => accountWithGenesisAddress(
            ref as AccountWithGenesisAddressRef,
            address,
            searchGenesisAddress: searchGenesisAddress,
          ),
          from: accountWithGenesisAddressProvider,
          name: r'accountWithGenesisAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountWithGenesisAddressHash,
          dependencies: AccountWithGenesisAddressFamily._dependencies,
          allTransitiveDependencies:
              AccountWithGenesisAddressFamily._allTransitiveDependencies,
          address: address,
          searchGenesisAddress: searchGenesisAddress,
        );

  AccountWithGenesisAddressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
    required this.searchGenesisAddress,
  }) : super.internal();

  final String address;
  final bool searchGenesisAddress;

  @override
  Override overrideWith(
    FutureOr<Account?> Function(AccountWithGenesisAddressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountWithGenesisAddressProvider._internal(
        (ref) => create(ref as AccountWithGenesisAddressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
        searchGenesisAddress: searchGenesisAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Account?> createElement() {
    return _AccountWithGenesisAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountWithGenesisAddressProvider &&
        other.address == address &&
        other.searchGenesisAddress == searchGenesisAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);
    hash = _SystemHash.combine(hash, searchGenesisAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountWithGenesisAddressRef on AutoDisposeFutureProviderRef<Account?> {
  /// The parameter `address` of this provider.
  String get address;

  /// The parameter `searchGenesisAddress` of this provider.
  bool get searchGenesisAddress;
}

class _AccountWithGenesisAddressProviderElement
    extends AutoDisposeFutureProviderElement<Account?>
    with AccountWithGenesisAddressRef {
  _AccountWithGenesisAddressProviderElement(super.provider);

  @override
  String get address => (origin as AccountWithGenesisAddressProvider).address;
  @override
  bool get searchGenesisAddress =>
      (origin as AccountWithGenesisAddressProvider).searchGenesisAddress;
}

String _$accountWithNameHash() => r'4cddbfdc930ca6db516b0f16e45758305c853224';

/// See also [accountWithName].
@ProviderFor(accountWithName)
const accountWithNameProvider = AccountWithNameFamily();

/// See also [accountWithName].
class AccountWithNameFamily extends Family<AsyncValue<Account?>> {
  /// See also [accountWithName].
  const AccountWithNameFamily();

  /// See also [accountWithName].
  AccountWithNameProvider call(
    String nameAccount,
  ) {
    return AccountWithNameProvider(
      nameAccount,
    );
  }

  @override
  AccountWithNameProvider getProviderOverride(
    covariant AccountWithNameProvider provider,
  ) {
    return call(
      provider.nameAccount,
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
  String? get name => r'accountWithNameProvider';
}

/// See also [accountWithName].
class AccountWithNameProvider extends AutoDisposeFutureProvider<Account?> {
  /// See also [accountWithName].
  AccountWithNameProvider(
    String nameAccount,
  ) : this._internal(
          (ref) => accountWithName(
            ref as AccountWithNameRef,
            nameAccount,
          ),
          from: accountWithNameProvider,
          name: r'accountWithNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountWithNameHash,
          dependencies: AccountWithNameFamily._dependencies,
          allTransitiveDependencies:
              AccountWithNameFamily._allTransitiveDependencies,
          nameAccount: nameAccount,
        );

  AccountWithNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nameAccount,
  }) : super.internal();

  final String nameAccount;

  @override
  Override overrideWith(
    FutureOr<Account?> Function(AccountWithNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountWithNameProvider._internal(
        (ref) => create(ref as AccountWithNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nameAccount: nameAccount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Account?> createElement() {
    return _AccountWithNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountWithNameProvider && other.nameAccount == nameAccount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nameAccount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountWithNameRef on AutoDisposeFutureProviderRef<Account?> {
  /// The parameter `nameAccount` of this provider.
  String get nameAccount;
}

class _AccountWithNameProviderElement
    extends AutoDisposeFutureProviderElement<Account?> with AccountWithNameRef {
  _AccountWithNameProviderElement(super.provider);

  @override
  String get nameAccount => (origin as AccountWithNameProvider).nameAccount;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
