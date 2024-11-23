// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userBalanceHash() => r'a25cf954acd90262212a4514facb265630130ef3';

/// See also [userBalance].
@ProviderFor(userBalance)
final userBalanceProvider =
    AutoDisposeFutureProvider<archethic.Balance>.internal(
  userBalance,
  name: r'userBalanceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserBalanceRef = AutoDisposeFutureProviderRef<archethic.Balance>;
String _$addressBalanceHash() => r'bd82de0cb548e90afad6edcf01840fb4548008e6';

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

/// See also [addressBalance].
@ProviderFor(addressBalance)
const addressBalanceProvider = AddressBalanceFamily();

/// See also [addressBalance].
class AddressBalanceFamily extends Family<AsyncValue<archethic.Balance>> {
  /// See also [addressBalance].
  const AddressBalanceFamily();

  /// See also [addressBalance].
  AddressBalanceProvider call(
    String address,
  ) {
    return AddressBalanceProvider(
      address,
    );
  }

  @override
  AddressBalanceProvider getProviderOverride(
    covariant AddressBalanceProvider provider,
  ) {
    return call(
      provider.address,
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
  String? get name => r'addressBalanceProvider';
}

/// See also [addressBalance].
class AddressBalanceProvider
    extends AutoDisposeFutureProvider<archethic.Balance> {
  /// See also [addressBalance].
  AddressBalanceProvider(
    String address,
  ) : this._internal(
          (ref) => addressBalance(
            ref as AddressBalanceRef,
            address,
          ),
          from: addressBalanceProvider,
          name: r'addressBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addressBalanceHash,
          dependencies: AddressBalanceFamily._dependencies,
          allTransitiveDependencies:
              AddressBalanceFamily._allTransitiveDependencies,
          address: address,
        );

  AddressBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final String address;

  @override
  Override overrideWith(
    FutureOr<archethic.Balance> Function(AddressBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddressBalanceProvider._internal(
        (ref) => create(ref as AddressBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<archethic.Balance> createElement() {
    return _AddressBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressBalanceProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddressBalanceRef on AutoDisposeFutureProviderRef<archethic.Balance> {
  /// The parameter `address` of this provider.
  String get address;
}

class _AddressBalanceProviderElement
    extends AutoDisposeFutureProviderElement<archethic.Balance>
    with AddressBalanceRef {
  _AddressBalanceProviderElement(super.provider);

  @override
  String get address => (origin as AddressBalanceProvider).address;
}

String _$addressBalanceTotalFiatHash() =>
    r'39f9c8fc5cd22a8b4ae2c923013783f59c219326';

/// See also [addressBalanceTotalFiat].
@ProviderFor(addressBalanceTotalFiat)
const addressBalanceTotalFiatProvider = AddressBalanceTotalFiatFamily();

/// See also [addressBalanceTotalFiat].
class AddressBalanceTotalFiatFamily extends Family<AsyncValue<double>> {
  /// See also [addressBalanceTotalFiat].
  const AddressBalanceTotalFiatFamily();

  /// See also [addressBalanceTotalFiat].
  AddressBalanceTotalFiatProvider call(
    String address,
  ) {
    return AddressBalanceTotalFiatProvider(
      address,
    );
  }

  @override
  AddressBalanceTotalFiatProvider getProviderOverride(
    covariant AddressBalanceTotalFiatProvider provider,
  ) {
    return call(
      provider.address,
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
  String? get name => r'addressBalanceTotalFiatProvider';
}

/// See also [addressBalanceTotalFiat].
class AddressBalanceTotalFiatProvider
    extends AutoDisposeFutureProvider<double> {
  /// See also [addressBalanceTotalFiat].
  AddressBalanceTotalFiatProvider(
    String address,
  ) : this._internal(
          (ref) => addressBalanceTotalFiat(
            ref as AddressBalanceTotalFiatRef,
            address,
          ),
          from: addressBalanceTotalFiatProvider,
          name: r'addressBalanceTotalFiatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$addressBalanceTotalFiatHash,
          dependencies: AddressBalanceTotalFiatFamily._dependencies,
          allTransitiveDependencies:
              AddressBalanceTotalFiatFamily._allTransitiveDependencies,
          address: address,
        );

  AddressBalanceTotalFiatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final String address;

  @override
  Override overrideWith(
    FutureOr<double> Function(AddressBalanceTotalFiatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddressBalanceTotalFiatProvider._internal(
        (ref) => create(ref as AddressBalanceTotalFiatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _AddressBalanceTotalFiatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressBalanceTotalFiatProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AddressBalanceTotalFiatRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `address` of this provider.
  String get address;
}

class _AddressBalanceTotalFiatProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with AddressBalanceTotalFiatRef {
  _AddressBalanceTotalFiatProviderElement(super.provider);

  @override
  String get address => (origin as AddressBalanceTotalFiatProvider).address;
}

String _$getBalanceHash() => r'434260970828b87135c5630cca11ea79edadc8aa';

/// See also [getBalance].
@ProviderFor(getBalance)
const getBalanceProvider = GetBalanceFamily();

/// See also [getBalance].
class GetBalanceFamily extends Family<AsyncValue<double>> {
  /// See also [getBalance].
  const GetBalanceFamily();

  /// See also [getBalance].
  GetBalanceProvider call(
    String tokenAddress,
  ) {
    return GetBalanceProvider(
      tokenAddress,
    );
  }

  @override
  GetBalanceProvider getProviderOverride(
    covariant GetBalanceProvider provider,
  ) {
    return call(
      provider.tokenAddress,
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
  String? get name => r'getBalanceProvider';
}

/// See also [getBalance].
class GetBalanceProvider extends AutoDisposeFutureProvider<double> {
  /// See also [getBalance].
  GetBalanceProvider(
    String tokenAddress,
  ) : this._internal(
          (ref) => getBalance(
            ref as GetBalanceRef,
            tokenAddress,
          ),
          from: getBalanceProvider,
          name: r'getBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getBalanceHash,
          dependencies: GetBalanceFamily._dependencies,
          allTransitiveDependencies:
              GetBalanceFamily._allTransitiveDependencies,
          tokenAddress: tokenAddress,
        );

  GetBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tokenAddress,
  }) : super.internal();

  final String tokenAddress;

  @override
  Override overrideWith(
    FutureOr<double> Function(GetBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetBalanceProvider._internal(
        (ref) => create(ref as GetBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tokenAddress: tokenAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _GetBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetBalanceProvider && other.tokenAddress == tokenAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tokenAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetBalanceRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `tokenAddress` of this provider.
  String get tokenAddress;
}

class _GetBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double> with GetBalanceRef {
  _GetBalanceProviderElement(super.provider);

  @override
  String get tokenAddress => (origin as GetBalanceProvider).tokenAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
