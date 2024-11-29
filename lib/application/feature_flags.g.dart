// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_flags.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$featureFlagsRepositoryHash() =>
    r'9180d0917256c29e3ec72c217c1c44de80a5ef19';

/// See also [_featureFlagsRepository].
@ProviderFor(_featureFlagsRepository)
final _featureFlagsRepositoryProvider =
    AutoDisposeProvider<FeatureFlagsRepositoryImpl>.internal(
  _featureFlagsRepository,
  name: r'_featureFlagsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$featureFlagsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _FeatureFlagsRepositoryRef
    = AutoDisposeProviderRef<FeatureFlagsRepositoryImpl>;
String _$getFeatureFlagHash() => r'47b824545e1ef90d87487954d7b1ca8568c93cda';

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

/// See also [getFeatureFlag].
@ProviderFor(getFeatureFlag)
const getFeatureFlagProvider = GetFeatureFlagFamily();

/// See also [getFeatureFlag].
class GetFeatureFlagFamily extends Family<AsyncValue<bool?>> {
  /// See also [getFeatureFlag].
  const GetFeatureFlagFamily();

  /// See also [getFeatureFlag].
  GetFeatureFlagProvider call(
    AvailableNetworks network,
    String applicationCode,
    String featureCode,
  ) {
    return GetFeatureFlagProvider(
      network,
      applicationCode,
      featureCode,
    );
  }

  @override
  GetFeatureFlagProvider getProviderOverride(
    covariant GetFeatureFlagProvider provider,
  ) {
    return call(
      provider.network,
      provider.applicationCode,
      provider.featureCode,
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
  String? get name => r'getFeatureFlagProvider';
}

/// See also [getFeatureFlag].
class GetFeatureFlagProvider extends AutoDisposeFutureProvider<bool?> {
  /// See also [getFeatureFlag].
  GetFeatureFlagProvider(
    AvailableNetworks network,
    String applicationCode,
    String featureCode,
  ) : this._internal(
          (ref) => getFeatureFlag(
            ref as GetFeatureFlagRef,
            network,
            applicationCode,
            featureCode,
          ),
          from: getFeatureFlagProvider,
          name: r'getFeatureFlagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFeatureFlagHash,
          dependencies: GetFeatureFlagFamily._dependencies,
          allTransitiveDependencies:
              GetFeatureFlagFamily._allTransitiveDependencies,
          network: network,
          applicationCode: applicationCode,
          featureCode: featureCode,
        );

  GetFeatureFlagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.network,
    required this.applicationCode,
    required this.featureCode,
  }) : super.internal();

  final AvailableNetworks network;
  final String applicationCode;
  final String featureCode;

  @override
  Override overrideWith(
    FutureOr<bool?> Function(GetFeatureFlagRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetFeatureFlagProvider._internal(
        (ref) => create(ref as GetFeatureFlagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        network: network,
        applicationCode: applicationCode,
        featureCode: featureCode,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool?> createElement() {
    return _GetFeatureFlagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetFeatureFlagProvider &&
        other.network == network &&
        other.applicationCode == applicationCode &&
        other.featureCode == featureCode;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, network.hashCode);
    hash = _SystemHash.combine(hash, applicationCode.hashCode);
    hash = _SystemHash.combine(hash, featureCode.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetFeatureFlagRef on AutoDisposeFutureProviderRef<bool?> {
  /// The parameter `network` of this provider.
  AvailableNetworks get network;

  /// The parameter `applicationCode` of this provider.
  String get applicationCode;

  /// The parameter `featureCode` of this provider.
  String get featureCode;
}

class _GetFeatureFlagProviderElement
    extends AutoDisposeFutureProviderElement<bool?> with GetFeatureFlagRef {
  _GetFeatureFlagProviderElement(super.provider);

  @override
  AvailableNetworks get network => (origin as GetFeatureFlagProvider).network;
  @override
  String get applicationCode =>
      (origin as GetFeatureFlagProvider).applicationCode;
  @override
  String get featureCode => (origin as GetFeatureFlagProvider).featureCode;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
