// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapps.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

<<<<<<< HEAD
String _$dAppsRepositoryHash() => r'6de8e91d80ef070475a657e77ea3f07fa5d9f543';
=======
String _$dAppsRepositoryHash() => r'fb013548900316c315da404d775c03d2e4f7a24e';
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)

/// See also [dAppsRepository].
@ProviderFor(dAppsRepository)
final dAppsRepositoryProvider =
    AutoDisposeProvider<DAppsRepositoryImpl>.internal(
  dAppsRepository,
  name: r'dAppsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dAppsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
<<<<<<< HEAD
typedef _DAppsRepositoryRef = AutoDisposeProviderRef<DAppsRepositoryImpl>;
String _$getDAppHash() => r'e708424d60dbef17da84a12ed02a67dd493a28a2';
=======
typedef DAppsRepositoryRef = AutoDisposeProviderRef<DAppsRepositoryImpl>;
String _$getDAppHash() => r'ecbe738bde602c22d655a26d4284ad83fb6f2c53';
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)

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

/// See also [getDApp].
@ProviderFor(getDApp)
const getDAppProvider = GetDAppFamily();

/// See also [getDApp].
class GetDAppFamily extends Family<AsyncValue<DApp?>> {
  /// See also [getDApp].
  const GetDAppFamily();

<<<<<<< HEAD
  /// See also [_getDApp].
  _GetDAppProvider call(
    String code,
  ) {
    return _GetDAppProvider(
=======
  /// See also [getDApp].
  GetDAppProvider call(
    AvailableNetworks network,
    String code,
  ) {
    return GetDAppProvider(
      network,
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)
      code,
    );
  }

  @override
  GetDAppProvider getProviderOverride(
    covariant GetDAppProvider provider,
  ) {
    return call(
      provider.code,
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
  String? get name => r'getDAppProvider';
}

<<<<<<< HEAD
/// See also [_getDApp].
class _GetDAppProvider extends AutoDisposeFutureProvider<DApp?> {
  /// See also [_getDApp].
  _GetDAppProvider(
    String code,
  ) : this._internal(
          (ref) => _getDApp(
            ref as _GetDAppRef,
=======
/// See also [getDApp].
class GetDAppProvider extends AutoDisposeFutureProvider<DApp?> {
  /// See also [getDApp].
  GetDAppProvider(
    AvailableNetworks network,
    String code,
  ) : this._internal(
          (ref) => getDApp(
            ref as GetDAppRef,
            network,
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)
            code,
          ),
          from: getDAppProvider,
          name: r'getDAppProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDAppHash,
<<<<<<< HEAD
          dependencies: _GetDAppFamily._dependencies,
          allTransitiveDependencies: _GetDAppFamily._allTransitiveDependencies,
=======
          dependencies: GetDAppFamily._dependencies,
          allTransitiveDependencies: GetDAppFamily._allTransitiveDependencies,
          network: network,
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)
          code: code,
        );

  GetDAppProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.code,
  }) : super.internal();

  final String code;

  @override
  Override overrideWith(
    FutureOr<DApp?> Function(GetDAppRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetDAppProvider._internal(
        (ref) => create(ref as GetDAppRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        code: code,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DApp?> createElement() {
    return _GetDAppProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
<<<<<<< HEAD
    return other is _GetDAppProvider && other.code == code;
=======
    return other is GetDAppProvider &&
        other.network == network &&
        other.code == code;
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, code.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
<<<<<<< HEAD
mixin _GetDAppRef on AutoDisposeFutureProviderRef<DApp?> {
=======
mixin GetDAppRef on AutoDisposeFutureProviderRef<DApp?> {
  /// The parameter `network` of this provider.
  AvailableNetworks get network;

>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)
  /// The parameter `code` of this provider.
  String get code;
}

class _GetDAppProviderElement extends AutoDisposeFutureProviderElement<DApp?>
    with GetDAppRef {
  _GetDAppProviderElement(super.provider);

  @override
<<<<<<< HEAD
  String get code => (origin as _GetDAppProvider).code;
}

String _$getDAppsFromNetworkHash() =>
    r'0b6c8824ab7d57c392d448753b5139840976372b';
=======
  AvailableNetworks get network => (origin as GetDAppProvider).network;
  @override
  String get code => (origin as GetDAppProvider).code;
}

String _$getDAppsFromNetworkHash() =>
    r'684e026068e0ca42e51aa771ac8e6e43fd92da55';
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)

/// See also [getDAppsFromNetwork].
@ProviderFor(getDAppsFromNetwork)
const getDAppsFromNetworkProvider = GetDAppsFromNetworkFamily();

/// See also [getDAppsFromNetwork].
class GetDAppsFromNetworkFamily extends Family<AsyncValue<List<DApp>>> {
  /// See also [getDAppsFromNetwork].
  const GetDAppsFromNetworkFamily();

  /// See also [getDAppsFromNetwork].
  GetDAppsFromNetworkProvider call(
    AvailableNetworks network,
  ) {
    return GetDAppsFromNetworkProvider(
      network,
    );
  }

  @override
  GetDAppsFromNetworkProvider getProviderOverride(
    covariant GetDAppsFromNetworkProvider provider,
  ) {
    return call(
      provider.network,
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
  String? get name => r'getDAppsFromNetworkProvider';
}

/// See also [getDAppsFromNetwork].
class GetDAppsFromNetworkProvider
    extends AutoDisposeFutureProvider<List<DApp>> {
  /// See also [getDAppsFromNetwork].
  GetDAppsFromNetworkProvider(
    AvailableNetworks network,
  ) : this._internal(
          (ref) => getDAppsFromNetwork(
            ref as GetDAppsFromNetworkRef,
            network,
          ),
          from: getDAppsFromNetworkProvider,
          name: r'getDAppsFromNetworkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDAppsFromNetworkHash,
          dependencies: GetDAppsFromNetworkFamily._dependencies,
          allTransitiveDependencies:
              GetDAppsFromNetworkFamily._allTransitiveDependencies,
          network: network,
        );

  GetDAppsFromNetworkProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.network,
  }) : super.internal();

  final AvailableNetworks network;

  @override
  Override overrideWith(
    FutureOr<List<DApp>> Function(GetDAppsFromNetworkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetDAppsFromNetworkProvider._internal(
        (ref) => create(ref as GetDAppsFromNetworkRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        network: network,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DApp>> createElement() {
    return _GetDAppsFromNetworkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetDAppsFromNetworkProvider && other.network == network;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, network.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
<<<<<<< HEAD
mixin _GetDAppsFromNetworkRef on AutoDisposeFutureProviderRef<List<DApp>> {
=======
mixin GetDAppsFromNetworkRef on AutoDisposeFutureProviderRef<List<DApp>> {
>>>>>>> 3cd2a51c (feat: :sparkles: Add Dapps Board)
  /// The parameter `network` of this provider.
  AvailableNetworks get network;
}

class _GetDAppsFromNetworkProviderElement
    extends AutoDisposeFutureProviderElement<List<DApp>>
    with GetDAppsFromNetworkRef {
  _GetDAppsFromNetworkProviderElement(super.provider);

  @override
  AvailableNetworks get network =>
      (origin as GetDAppsFromNetworkProvider).network;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
