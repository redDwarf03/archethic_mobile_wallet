// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapps.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dAppsRepositoryHash() => r'6de8e91d80ef070475a657e77ea3f07fa5d9f543';

/// See also [_dAppsRepository].
@ProviderFor(_dAppsRepository)
final _dAppsRepositoryProvider =
    AutoDisposeProvider<DAppsRepositoryImpl>.internal(
  _dAppsRepository,
  name: r'_dAppsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dAppsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DAppsRepositoryRef = AutoDisposeProviderRef<DAppsRepositoryImpl>;
String _$getDAppHash() => r'70f3139f239d37e2aaf093b1007b668aeab29d90';

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

/// See also [_getDApp].
@ProviderFor(_getDApp)
const _getDAppProvider = _GetDAppFamily();

/// See also [_getDApp].
class _GetDAppFamily extends Family<AsyncValue<DApp?>> {
  /// See also [_getDApp].
  const _GetDAppFamily();

  /// See also [_getDApp].
  _GetDAppProvider call(
    AvailableNetworks network,
    String code,
  ) {
    return _GetDAppProvider(
      network,
      code,
    );
  }

  @override
  _GetDAppProvider getProviderOverride(
    covariant _GetDAppProvider provider,
  ) {
    return call(
      provider.network,
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
  String? get name => r'_getDAppProvider';
}

/// See also [_getDApp].
class _GetDAppProvider extends AutoDisposeFutureProvider<DApp?> {
  /// See also [_getDApp].
  _GetDAppProvider(
    AvailableNetworks network,
    String code,
  ) : this._internal(
          (ref) => _getDApp(
            ref as _GetDAppRef,
            network,
            code,
          ),
          from: _getDAppProvider,
          name: r'_getDAppProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDAppHash,
          dependencies: _GetDAppFamily._dependencies,
          allTransitiveDependencies: _GetDAppFamily._allTransitiveDependencies,
          network: network,
          code: code,
        );

  _GetDAppProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.network,
    required this.code,
  }) : super.internal();

  final AvailableNetworks network;
  final String code;

  @override
  Override overrideWith(
    FutureOr<DApp?> Function(_GetDAppRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetDAppProvider._internal(
        (ref) => create(ref as _GetDAppRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        network: network,
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
    return other is _GetDAppProvider &&
        other.network == network &&
        other.code == code;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, network.hashCode);
    hash = _SystemHash.combine(hash, code.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetDAppRef on AutoDisposeFutureProviderRef<DApp?> {
  /// The parameter `network` of this provider.
  AvailableNetworks get network;

  /// The parameter `code` of this provider.
  String get code;
}

class _GetDAppProviderElement extends AutoDisposeFutureProviderElement<DApp?>
    with _GetDAppRef {
  _GetDAppProviderElement(super.provider);

  @override
  AvailableNetworks get network => (origin as _GetDAppProvider).network;
  @override
  String get code => (origin as _GetDAppProvider).code;
}

String _$getDAppsFromNetworkHash() =>
    r'0b6c8824ab7d57c392d448753b5139840976372b';

/// See also [_getDAppsFromNetwork].
@ProviderFor(_getDAppsFromNetwork)
const _getDAppsFromNetworkProvider = _GetDAppsFromNetworkFamily();

/// See also [_getDAppsFromNetwork].
class _GetDAppsFromNetworkFamily extends Family<AsyncValue<List<DApp>>> {
  /// See also [_getDAppsFromNetwork].
  const _GetDAppsFromNetworkFamily();

  /// See also [_getDAppsFromNetwork].
  _GetDAppsFromNetworkProvider call(
    AvailableNetworks network,
  ) {
    return _GetDAppsFromNetworkProvider(
      network,
    );
  }

  @override
  _GetDAppsFromNetworkProvider getProviderOverride(
    covariant _GetDAppsFromNetworkProvider provider,
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
  String? get name => r'_getDAppsFromNetworkProvider';
}

/// See also [_getDAppsFromNetwork].
class _GetDAppsFromNetworkProvider
    extends AutoDisposeFutureProvider<List<DApp>> {
  /// See also [_getDAppsFromNetwork].
  _GetDAppsFromNetworkProvider(
    AvailableNetworks network,
  ) : this._internal(
          (ref) => _getDAppsFromNetwork(
            ref as _GetDAppsFromNetworkRef,
            network,
          ),
          from: _getDAppsFromNetworkProvider,
          name: r'_getDAppsFromNetworkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDAppsFromNetworkHash,
          dependencies: _GetDAppsFromNetworkFamily._dependencies,
          allTransitiveDependencies:
              _GetDAppsFromNetworkFamily._allTransitiveDependencies,
          network: network,
        );

  _GetDAppsFromNetworkProvider._internal(
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
    FutureOr<List<DApp>> Function(_GetDAppsFromNetworkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetDAppsFromNetworkProvider._internal(
        (ref) => create(ref as _GetDAppsFromNetworkRef),
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
    return other is _GetDAppsFromNetworkProvider && other.network == network;
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
mixin _GetDAppsFromNetworkRef on AutoDisposeFutureProviderRef<List<DApp>> {
  /// The parameter `network` of this provider.
  AvailableNetworks get network;
}

class _GetDAppsFromNetworkProviderElement
    extends AutoDisposeFutureProviderElement<List<DApp>>
    with _GetDAppsFromNetworkRef {
  _GetDAppsFromNetworkProviderElement(super.provider);

  @override
  AvailableNetworks get network =>
      (origin as _GetDAppsFromNetworkProvider).network;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
