// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dapps.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dAppsRepositoryHash() => r'fb013548900316c315da404d775c03d2e4f7a24e';

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
typedef DAppsRepositoryRef = AutoDisposeProviderRef<DAppsRepositoryImpl>;
String _$getDAppHash() => r'99a3f23987c5566794003de0cbd6de2c44292da3';

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

  /// See also [getDApp].
  GetDAppProvider call(
    String code,
  ) {
    return GetDAppProvider(
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

/// See also [getDApp].
class GetDAppProvider extends AutoDisposeFutureProvider<DApp?> {
  /// See also [getDApp].
  GetDAppProvider(
    String code,
  ) : this._internal(
          (ref) => getDApp(
            ref as GetDAppRef,
            code,
          ),
          from: getDAppProvider,
          name: r'getDAppProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getDAppHash,
          dependencies: GetDAppFamily._dependencies,
          allTransitiveDependencies: GetDAppFamily._allTransitiveDependencies,
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
    return other is GetDAppProvider && other.code == code;
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
mixin GetDAppRef on AutoDisposeFutureProviderRef<DApp?> {
  /// The parameter `code` of this provider.
  String get code;
}

class _GetDAppProviderElement extends AutoDisposeFutureProviderElement<DApp?>
    with GetDAppRef {
  _GetDAppProviderElement(super.provider);

  @override
  String get code => (origin as GetDAppProvider).code;
}

String _$getDAppsFromNetworkHash() =>
    r'70c9aa2a09b0a6638582979f82d6a122c2d1df38';

/// See also [getDAppsFromNetwork].
@ProviderFor(getDAppsFromNetwork)
final getDAppsFromNetworkProvider =
    AutoDisposeFutureProvider<List<DApp>>.internal(
  getDAppsFromNetwork,
  name: r'getDAppsFromNetworkProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDAppsFromNetworkHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDAppsFromNetworkRef = AutoDisposeFutureProviderRef<List<DApp>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
