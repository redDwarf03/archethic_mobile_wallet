// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dex_farm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dexFarmRepositoryHash() => r'fec3aeb4f1c23a29ea656868c59f125c160581fb';

/// See also [_dexFarmRepository].
@ProviderFor(_dexFarmRepository)
final _dexFarmRepositoryProvider =
    AutoDisposeProvider<DexFarmRepositoryImpl>.internal(
  _dexFarmRepository,
  name: r'_dexFarmRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dexFarmRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DexFarmRepositoryRef = AutoDisposeProviderRef<DexFarmRepositoryImpl>;
String _$getFarmInfosHash() => r'e895abbf94c6c9192df55d478e523362b4fc9072';

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

/// See also [_getFarmInfos].
@ProviderFor(_getFarmInfos)
const _getFarmInfosProvider = _GetFarmInfosFamily();

/// See also [_getFarmInfos].
class _GetFarmInfosFamily extends Family<AsyncValue<DexFarm?>> {
  /// See also [_getFarmInfos].
  const _GetFarmInfosFamily();

  /// See also [_getFarmInfos].
  _GetFarmInfosProvider call(
    String farmGenesisAddress,
    String poolAddress, {
    DexFarm? dexFarmInput,
  }) {
    return _GetFarmInfosProvider(
      farmGenesisAddress,
      poolAddress,
      dexFarmInput: dexFarmInput,
    );
  }

  @override
  _GetFarmInfosProvider getProviderOverride(
    covariant _GetFarmInfosProvider provider,
  ) {
    return call(
      provider.farmGenesisAddress,
      provider.poolAddress,
      dexFarmInput: provider.dexFarmInput,
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
  String? get name => r'_getFarmInfosProvider';
}

/// See also [_getFarmInfos].
class _GetFarmInfosProvider extends AutoDisposeFutureProvider<DexFarm?> {
  /// See also [_getFarmInfos].
  _GetFarmInfosProvider(
    String farmGenesisAddress,
    String poolAddress, {
    DexFarm? dexFarmInput,
  }) : this._internal(
          (ref) => _getFarmInfos(
            ref as _GetFarmInfosRef,
            farmGenesisAddress,
            poolAddress,
            dexFarmInput: dexFarmInput,
          ),
          from: _getFarmInfosProvider,
          name: r'_getFarmInfosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFarmInfosHash,
          dependencies: _GetFarmInfosFamily._dependencies,
          allTransitiveDependencies:
              _GetFarmInfosFamily._allTransitiveDependencies,
          farmGenesisAddress: farmGenesisAddress,
          poolAddress: poolAddress,
          dexFarmInput: dexFarmInput,
        );

  _GetFarmInfosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmGenesisAddress,
    required this.poolAddress,
    required this.dexFarmInput,
  }) : super.internal();

  final String farmGenesisAddress;
  final String poolAddress;
  final DexFarm? dexFarmInput;

  @override
  Override overrideWith(
    FutureOr<DexFarm?> Function(_GetFarmInfosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetFarmInfosProvider._internal(
        (ref) => create(ref as _GetFarmInfosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmGenesisAddress: farmGenesisAddress,
        poolAddress: poolAddress,
        dexFarmInput: dexFarmInput,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DexFarm?> createElement() {
    return _GetFarmInfosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetFarmInfosProvider &&
        other.farmGenesisAddress == farmGenesisAddress &&
        other.poolAddress == poolAddress &&
        other.dexFarmInput == dexFarmInput;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmGenesisAddress.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, dexFarmInput.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetFarmInfosRef on AutoDisposeFutureProviderRef<DexFarm?> {
  /// The parameter `farmGenesisAddress` of this provider.
  String get farmGenesisAddress;

  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `dexFarmInput` of this provider.
  DexFarm? get dexFarmInput;
}

class _GetFarmInfosProviderElement
    extends AutoDisposeFutureProviderElement<DexFarm?> with _GetFarmInfosRef {
  _GetFarmInfosProviderElement(super.provider);

  @override
  String get farmGenesisAddress =>
      (origin as _GetFarmInfosProvider).farmGenesisAddress;
  @override
  String get poolAddress => (origin as _GetFarmInfosProvider).poolAddress;
  @override
  DexFarm? get dexFarmInput => (origin as _GetFarmInfosProvider).dexFarmInput;
}

String _$getFarmListHash() => r'beeee317150777f92f74e0d1acb1418950579ab9';

/// See also [_getFarmList].
@ProviderFor(_getFarmList)
final _getFarmListProvider = AutoDisposeFutureProvider<List<DexFarm>>.internal(
  _getFarmList,
  name: r'_getFarmListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getFarmListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _GetFarmListRef = AutoDisposeFutureProviderRef<List<DexFarm>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
