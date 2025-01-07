// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_dapps.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myDAppsRepositoryHash() => r'98a7570736399f42abf5bfffbd2b2490578499b8';

/// See also [myDAppsRepository].
@ProviderFor(myDAppsRepository)
final myDAppsRepositoryProvider =
    AutoDisposeProvider<MyDAppsRepositoryImpl>.internal(
  myDAppsRepository,
  name: r'myDAppsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myDAppsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyDAppsRepositoryRef = AutoDisposeProviderRef<MyDAppsRepositoryImpl>;
String _$getMyDAppsHash() => r'f4a095e9d71445ec350ab627dd297e3c4cdf121e';

/// See also [getMyDApps].
@ProviderFor(getMyDApps)
final getMyDAppsProvider = AutoDisposeFutureProvider<List<DApp>>.internal(
  getMyDApps,
  name: r'getMyDAppsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getMyDAppsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMyDAppsRef = AutoDisposeFutureProviderRef<List<DApp>>;
String _$getMyDAppHash() => r'f8a4270ddf026c25abc3280b8618aff34fdaf7cf';

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

/// See also [getMyDApp].
@ProviderFor(getMyDApp)
const getMyDAppProvider = GetMyDAppFamily();

/// See also [getMyDApp].
class GetMyDAppFamily extends Family<AsyncValue<DApp?>> {
  /// See also [getMyDApp].
  const GetMyDAppFamily();

  /// See also [getMyDApp].
  GetMyDAppProvider call(
    String url,
  ) {
    return GetMyDAppProvider(
      url,
    );
  }

  @override
  GetMyDAppProvider getProviderOverride(
    covariant GetMyDAppProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'getMyDAppProvider';
}

/// See also [getMyDApp].
class GetMyDAppProvider extends AutoDisposeFutureProvider<DApp?> {
  /// See also [getMyDApp].
  GetMyDAppProvider(
    String url,
  ) : this._internal(
          (ref) => getMyDApp(
            ref as GetMyDAppRef,
            url,
          ),
          from: getMyDAppProvider,
          name: r'getMyDAppProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMyDAppHash,
          dependencies: GetMyDAppFamily._dependencies,
          allTransitiveDependencies: GetMyDAppFamily._allTransitiveDependencies,
          url: url,
        );

  GetMyDAppProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<DApp?> Function(GetMyDAppRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMyDAppProvider._internal(
        (ref) => create(ref as GetMyDAppRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DApp?> createElement() {
    return _GetMyDAppProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMyDAppProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetMyDAppRef on AutoDisposeFutureProviderRef<DApp?> {
  /// The parameter `url` of this provider.
  String get url;
}

class _GetMyDAppProviderElement extends AutoDisposeFutureProviderElement<DApp?>
    with GetMyDAppRef {
  _GetMyDAppProviderElement(super.provider);

  @override
  String get url => (origin as GetMyDAppProvider).url;
}

String _$clearMyDAppsHash() => r'ebdc9ea499dbe61e470695787eb719c1c2f13a3e';

/// See also [clearMyDApps].
@ProviderFor(clearMyDApps)
final clearMyDAppsProvider = AutoDisposeFutureProvider<void>.internal(
  clearMyDApps,
  name: r'clearMyDAppsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clearMyDAppsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearMyDAppsRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
