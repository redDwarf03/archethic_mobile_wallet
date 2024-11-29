// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dex_farm_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dexFarmLockRepositoryHash() =>
    r'f9d56df10c2e63f45b4758c168944173c7118a6e';

/// See also [_dexFarmLockRepository].
@ProviderFor(_dexFarmLockRepository)
final _dexFarmLockRepositoryProvider =
    AutoDisposeProvider<DexFarmLockRepositoryImpl>.internal(
  _dexFarmLockRepository,
  name: r'_dexFarmLockRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dexFarmLockRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DexFarmLockRepositoryRef
    = AutoDisposeProviderRef<DexFarmLockRepositoryImpl>;
String _$getFarmLockInfosHash() => r'23bfc7fdae2835b6ee7e845676138a202678c312';

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

/// See also [_getFarmLockInfos].
@ProviderFor(_getFarmLockInfos)
const _getFarmLockInfosProvider = _GetFarmLockInfosFamily();

/// See also [_getFarmLockInfos].
class _GetFarmLockInfosFamily extends Family<AsyncValue<DexFarmLock?>> {
  /// See also [_getFarmLockInfos].
  const _GetFarmLockInfosFamily();

  /// See also [_getFarmLockInfos].
  _GetFarmLockInfosProvider call(
    String farmGenesisAddress,
    String poolAddress, {
    DexFarmLock? dexFarmLockInput,
  }) {
    return _GetFarmLockInfosProvider(
      farmGenesisAddress,
      poolAddress,
      dexFarmLockInput: dexFarmLockInput,
    );
  }

  @override
  _GetFarmLockInfosProvider getProviderOverride(
    covariant _GetFarmLockInfosProvider provider,
  ) {
    return call(
      provider.farmGenesisAddress,
      provider.poolAddress,
      dexFarmLockInput: provider.dexFarmLockInput,
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
  String? get name => r'_getFarmLockInfosProvider';
}

/// See also [_getFarmLockInfos].
class _GetFarmLockInfosProvider
    extends AutoDisposeFutureProvider<DexFarmLock?> {
  /// See also [_getFarmLockInfos].
  _GetFarmLockInfosProvider(
    String farmGenesisAddress,
    String poolAddress, {
    DexFarmLock? dexFarmLockInput,
  }) : this._internal(
          (ref) => _getFarmLockInfos(
            ref as _GetFarmLockInfosRef,
            farmGenesisAddress,
            poolAddress,
            dexFarmLockInput: dexFarmLockInput,
          ),
          from: _getFarmLockInfosProvider,
          name: r'_getFarmLockInfosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getFarmLockInfosHash,
          dependencies: _GetFarmLockInfosFamily._dependencies,
          allTransitiveDependencies:
              _GetFarmLockInfosFamily._allTransitiveDependencies,
          farmGenesisAddress: farmGenesisAddress,
          poolAddress: poolAddress,
          dexFarmLockInput: dexFarmLockInput,
        );

  _GetFarmLockInfosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmGenesisAddress,
    required this.poolAddress,
    required this.dexFarmLockInput,
  }) : super.internal();

  final String farmGenesisAddress;
  final String poolAddress;
  final DexFarmLock? dexFarmLockInput;

  @override
  Override overrideWith(
    FutureOr<DexFarmLock?> Function(_GetFarmLockInfosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetFarmLockInfosProvider._internal(
        (ref) => create(ref as _GetFarmLockInfosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmGenesisAddress: farmGenesisAddress,
        poolAddress: poolAddress,
        dexFarmLockInput: dexFarmLockInput,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DexFarmLock?> createElement() {
    return _GetFarmLockInfosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetFarmLockInfosProvider &&
        other.farmGenesisAddress == farmGenesisAddress &&
        other.poolAddress == poolAddress &&
        other.dexFarmLockInput == dexFarmLockInput;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmGenesisAddress.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, dexFarmLockInput.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetFarmLockInfosRef on AutoDisposeFutureProviderRef<DexFarmLock?> {
  /// The parameter `farmGenesisAddress` of this provider.
  String get farmGenesisAddress;

  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `dexFarmLockInput` of this provider.
  DexFarmLock? get dexFarmLockInput;
}

class _GetFarmLockInfosProviderElement
    extends AutoDisposeFutureProviderElement<DexFarmLock?>
    with _GetFarmLockInfosRef {
  _GetFarmLockInfosProviderElement(super.provider);

  @override
  String get farmGenesisAddress =>
      (origin as _GetFarmLockInfosProvider).farmGenesisAddress;
  @override
  String get poolAddress => (origin as _GetFarmLockInfosProvider).poolAddress;
  @override
  DexFarmLock? get dexFarmLockInput =>
      (origin as _GetFarmLockInfosProvider).dexFarmLockInput;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
