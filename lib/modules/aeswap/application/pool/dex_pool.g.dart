// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dex_pool.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dexPoolRepositoryHash() => r'04682a17d0cf6dd9e8e3381f313c5dca5d20cdd0';

/// See also [_dexPoolRepository].
@ProviderFor(_dexPoolRepository)
final _dexPoolRepositoryProvider =
    AutoDisposeProvider<DexPoolRepository>.internal(
  _dexPoolRepository,
  name: r'_dexPoolRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dexPoolRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DexPoolRepositoryRef = AutoDisposeProviderRef<DexPoolRepository>;
String _$getRatioHash() => r'6c180032d6dc0ddcd33e949d2e0cf9632d11ca9c';

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

/// See also [_getRatio].
@ProviderFor(_getRatio)
const _getRatioProvider = _GetRatioFamily();

/// See also [_getRatio].
class _GetRatioFamily extends Family<AsyncValue<double>> {
  /// See also [_getRatio].
  const _GetRatioFamily();

  /// See also [_getRatio].
  _GetRatioProvider call(
    String poolGenesisAddress,
    DexToken token,
  ) {
    return _GetRatioProvider(
      poolGenesisAddress,
      token,
    );
  }

  @override
  _GetRatioProvider getProviderOverride(
    covariant _GetRatioProvider provider,
  ) {
    return call(
      provider.poolGenesisAddress,
      provider.token,
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
  String? get name => r'_getRatioProvider';
}

/// See also [_getRatio].
class _GetRatioProvider extends AutoDisposeFutureProvider<double> {
  /// See also [_getRatio].
  _GetRatioProvider(
    String poolGenesisAddress,
    DexToken token,
  ) : this._internal(
          (ref) => _getRatio(
            ref as _GetRatioRef,
            poolGenesisAddress,
            token,
          ),
          from: _getRatioProvider,
          name: r'_getRatioProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRatioHash,
          dependencies: _GetRatioFamily._dependencies,
          allTransitiveDependencies: _GetRatioFamily._allTransitiveDependencies,
          poolGenesisAddress: poolGenesisAddress,
          token: token,
        );

  _GetRatioProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolGenesisAddress,
    required this.token,
  }) : super.internal();

  final String poolGenesisAddress;
  final DexToken token;

  @override
  Override overrideWith(
    FutureOr<double> Function(_GetRatioRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetRatioProvider._internal(
        (ref) => create(ref as _GetRatioRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolGenesisAddress: poolGenesisAddress,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _GetRatioProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetRatioProvider &&
        other.poolGenesisAddress == poolGenesisAddress &&
        other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolGenesisAddress.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetRatioRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `poolGenesisAddress` of this provider.
  String get poolGenesisAddress;

  /// The parameter `token` of this provider.
  DexToken get token;
}

class _GetRatioProviderElement extends AutoDisposeFutureProviderElement<double>
    with _GetRatioRef {
  _GetRatioProviderElement(super.provider);

  @override
  String get poolGenesisAddress =>
      (origin as _GetRatioProvider).poolGenesisAddress;
  @override
  DexToken get token => (origin as _GetRatioProvider).token;
}

String _$estimatePoolTVLInFiatHash() =>
    r'94e173608d7feedaf12a04cc902323af50d975f1';

/// See also [_estimatePoolTVLInFiat].
@ProviderFor(_estimatePoolTVLInFiat)
const _estimatePoolTVLInFiatProvider = _EstimatePoolTVLInFiatFamily();

/// See also [_estimatePoolTVLInFiat].
class _EstimatePoolTVLInFiatFamily extends Family<AsyncValue<double>> {
  /// See also [_estimatePoolTVLInFiat].
  const _EstimatePoolTVLInFiatFamily();

  /// See also [_estimatePoolTVLInFiat].
  _EstimatePoolTVLInFiatProvider call(
    DexPool? pool,
  ) {
    return _EstimatePoolTVLInFiatProvider(
      pool,
    );
  }

  @override
  _EstimatePoolTVLInFiatProvider getProviderOverride(
    covariant _EstimatePoolTVLInFiatProvider provider,
  ) {
    return call(
      provider.pool,
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
  String? get name => r'_estimatePoolTVLInFiatProvider';
}

/// See also [_estimatePoolTVLInFiat].
class _EstimatePoolTVLInFiatProvider extends AutoDisposeFutureProvider<double> {
  /// See also [_estimatePoolTVLInFiat].
  _EstimatePoolTVLInFiatProvider(
    DexPool? pool,
  ) : this._internal(
          (ref) => _estimatePoolTVLInFiat(
            ref as _EstimatePoolTVLInFiatRef,
            pool,
          ),
          from: _estimatePoolTVLInFiatProvider,
          name: r'_estimatePoolTVLInFiatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$estimatePoolTVLInFiatHash,
          dependencies: _EstimatePoolTVLInFiatFamily._dependencies,
          allTransitiveDependencies:
              _EstimatePoolTVLInFiatFamily._allTransitiveDependencies,
          pool: pool,
        );

  _EstimatePoolTVLInFiatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pool,
  }) : super.internal();

  final DexPool? pool;

  @override
  Override overrideWith(
    FutureOr<double> Function(_EstimatePoolTVLInFiatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _EstimatePoolTVLInFiatProvider._internal(
        (ref) => create(ref as _EstimatePoolTVLInFiatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pool: pool,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _EstimatePoolTVLInFiatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _EstimatePoolTVLInFiatProvider && other.pool == pool;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pool.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _EstimatePoolTVLInFiatRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `pool` of this provider.
  DexPool? get pool;
}

class _EstimatePoolTVLInFiatProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with _EstimatePoolTVLInFiatRef {
  _EstimatePoolTVLInFiatProviderElement(super.provider);

  @override
  DexPool? get pool => (origin as _EstimatePoolTVLInFiatProvider).pool;
}

String _$estimateStatsHash() => r'3cf6a7bb2b134dc8ab9e22d6b6c5268b2414b7b4';

/// See also [_estimateStats].
@ProviderFor(_estimateStats)
const _estimateStatsProvider = _EstimateStatsFamily();

/// See also [_estimateStats].
class _EstimateStatsFamily extends Family<AsyncValue<DexPoolStats>> {
  /// See also [_estimateStats].
  const _EstimateStatsFamily();

  /// See also [_estimateStats].
  _EstimateStatsProvider call(
    String dexPoolAddress,
  ) {
    return _EstimateStatsProvider(
      dexPoolAddress,
    );
  }

  @override
  _EstimateStatsProvider getProviderOverride(
    covariant _EstimateStatsProvider provider,
  ) {
    return call(
      provider.dexPoolAddress,
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
  String? get name => r'_estimateStatsProvider';
}

/// See also [_estimateStats].
class _EstimateStatsProvider extends AutoDisposeFutureProvider<DexPoolStats> {
  /// See also [_estimateStats].
  _EstimateStatsProvider(
    String dexPoolAddress,
  ) : this._internal(
          (ref) => _estimateStats(
            ref as _EstimateStatsRef,
            dexPoolAddress,
          ),
          from: _estimateStatsProvider,
          name: r'_estimateStatsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$estimateStatsHash,
          dependencies: _EstimateStatsFamily._dependencies,
          allTransitiveDependencies:
              _EstimateStatsFamily._allTransitiveDependencies,
          dexPoolAddress: dexPoolAddress,
        );

  _EstimateStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dexPoolAddress,
  }) : super.internal();

  final String dexPoolAddress;

  @override
  Override overrideWith(
    FutureOr<DexPoolStats> Function(_EstimateStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _EstimateStatsProvider._internal(
        (ref) => create(ref as _EstimateStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dexPoolAddress: dexPoolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DexPoolStats> createElement() {
    return _EstimateStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _EstimateStatsProvider &&
        other.dexPoolAddress == dexPoolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dexPoolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _EstimateStatsRef on AutoDisposeFutureProviderRef<DexPoolStats> {
  /// The parameter `dexPoolAddress` of this provider.
  String get dexPoolAddress;
}

class _EstimateStatsProviderElement
    extends AutoDisposeFutureProviderElement<DexPoolStats>
    with _EstimateStatsRef {
  _EstimateStatsProviderElement(super.provider);

  @override
  String get dexPoolAddress =>
      (origin as _EstimateStatsProvider).dexPoolAddress;
}

String _$poolHash() => r'37012e7faeb6dc6b03374b4823435e242b185a5b';

/// See also [_pool].
@ProviderFor(_pool)
const _poolProvider = _PoolFamily();

/// See also [_pool].
class _PoolFamily extends Family<AsyncValue<DexPool?>> {
  /// See also [_pool].
  const _PoolFamily();

  /// See also [_pool].
  _PoolProvider call(
    String poolAddress,
  ) {
    return _PoolProvider(
      poolAddress,
    );
  }

  @override
  _PoolProvider getProviderOverride(
    covariant _PoolProvider provider,
  ) {
    return call(
      provider.poolAddress,
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
  String? get name => r'_poolProvider';
}

/// See also [_pool].
class _PoolProvider extends AutoDisposeFutureProvider<DexPool?> {
  /// See also [_pool].
  _PoolProvider(
    String poolAddress,
  ) : this._internal(
          (ref) => _pool(
            ref as _PoolRef,
            poolAddress,
          ),
          from: _poolProvider,
          name: r'_poolProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product') ? null : _$poolHash,
          dependencies: _PoolFamily._dependencies,
          allTransitiveDependencies: _PoolFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
        );

  _PoolProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
  }) : super.internal();

  final String poolAddress;

  @override
  Override overrideWith(
    FutureOr<DexPool?> Function(_PoolRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _PoolProvider._internal(
        (ref) => create(ref as _PoolRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DexPool?> createElement() {
    return _PoolProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _PoolProvider && other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _PoolRef on AutoDisposeFutureProviderRef<DexPool?> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _PoolProviderElement extends AutoDisposeFutureProviderElement<DexPool?>
    with _PoolRef {
  _PoolProviderElement(super.provider);

  @override
  String get poolAddress => (origin as _PoolProvider).poolAddress;
}

String _$poolInfosHash() => r'a7bbb294f23c8cdd5f99cf0c89f32c56364d3633';

/// See also [_poolInfos].
@ProviderFor(_poolInfos)
const _poolInfosProvider = _PoolInfosFamily();

/// See also [_poolInfos].
class _PoolInfosFamily extends Family<AsyncValue<DexPoolInfos>> {
  /// See also [_poolInfos].
  const _PoolInfosFamily();

  /// See also [_poolInfos].
  _PoolInfosProvider call(
    String poolAddress,
  ) {
    return _PoolInfosProvider(
      poolAddress,
    );
  }

  @override
  _PoolInfosProvider getProviderOverride(
    covariant _PoolInfosProvider provider,
  ) {
    return call(
      provider.poolAddress,
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
  String? get name => r'_poolInfosProvider';
}

/// See also [_poolInfos].
class _PoolInfosProvider extends AutoDisposeFutureProvider<DexPoolInfos> {
  /// See also [_poolInfos].
  _PoolInfosProvider(
    String poolAddress,
  ) : this._internal(
          (ref) => _poolInfos(
            ref as _PoolInfosRef,
            poolAddress,
          ),
          from: _poolInfosProvider,
          name: r'_poolInfosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$poolInfosHash,
          dependencies: _PoolInfosFamily._dependencies,
          allTransitiveDependencies:
              _PoolInfosFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
        );

  _PoolInfosProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
  }) : super.internal();

  final String poolAddress;

  @override
  Override overrideWith(
    FutureOr<DexPoolInfos> Function(_PoolInfosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _PoolInfosProvider._internal(
        (ref) => create(ref as _PoolInfosRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<DexPoolInfos> createElement() {
    return _PoolInfosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _PoolInfosProvider && other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _PoolInfosRef on AutoDisposeFutureProviderRef<DexPoolInfos> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _PoolInfosProviderElement
    extends AutoDisposeFutureProviderElement<DexPoolInfos> with _PoolInfosRef {
  _PoolInfosProviderElement(super.provider);

  @override
  String get poolAddress => (origin as _PoolInfosProvider).poolAddress;
}

String _$getPoolListHash() => r'c105fb2e6011358c360513fc7ad1d65ee2ef7520';

/// See also [_getPoolList].
@ProviderFor(_getPoolList)
final _getPoolListProvider = AutoDisposeFutureProvider<List<DexPool>>.internal(
  _getPoolList,
  name: r'_getPoolListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getPoolListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _GetPoolListRef = AutoDisposeFutureProviderRef<List<DexPool>>;
String _$getPoolListRawHash() => r'5f3ed33dea82dd4ab23aa13b5862f4eb2987804f';

/// See also [_getPoolListRaw].
@ProviderFor(_getPoolListRaw)
final _getPoolListRawProvider =
    AutoDisposeFutureProvider<List<GetPoolListResponse>>.internal(
  _getPoolListRaw,
  name: r'_getPoolListRawProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPoolListRawHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _GetPoolListRawRef
    = AutoDisposeFutureProviderRef<List<GetPoolListResponse>>;
String _$getPoolListForSearchHash() =>
    r'551f5a5513556631d0b5a9454cb9d128fd58bf13';

/// See also [_getPoolListForSearch].
@ProviderFor(_getPoolListForSearch)
const _getPoolListForSearchProvider = _GetPoolListForSearchFamily();

/// See also [_getPoolListForSearch].
class _GetPoolListForSearchFamily extends Family<List<DexPool>> {
  /// See also [_getPoolListForSearch].
  const _GetPoolListForSearchFamily();

  /// See also [_getPoolListForSearch].
  _GetPoolListForSearchProvider call(
    String searchText,
    List<DexPool> poolList,
  ) {
    return _GetPoolListForSearchProvider(
      searchText,
      poolList,
    );
  }

  @override
  _GetPoolListForSearchProvider getProviderOverride(
    covariant _GetPoolListForSearchProvider provider,
  ) {
    return call(
      provider.searchText,
      provider.poolList,
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
  String? get name => r'_getPoolListForSearchProvider';
}

/// See also [_getPoolListForSearch].
class _GetPoolListForSearchProvider extends AutoDisposeProvider<List<DexPool>> {
  /// See also [_getPoolListForSearch].
  _GetPoolListForSearchProvider(
    String searchText,
    List<DexPool> poolList,
  ) : this._internal(
          (ref) => _getPoolListForSearch(
            ref as _GetPoolListForSearchRef,
            searchText,
            poolList,
          ),
          from: _getPoolListForSearchProvider,
          name: r'_getPoolListForSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPoolListForSearchHash,
          dependencies: _GetPoolListForSearchFamily._dependencies,
          allTransitiveDependencies:
              _GetPoolListForSearchFamily._allTransitiveDependencies,
          searchText: searchText,
          poolList: poolList,
        );

  _GetPoolListForSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchText,
    required this.poolList,
  }) : super.internal();

  final String searchText;
  final List<DexPool> poolList;

  @override
  Override overrideWith(
    List<DexPool> Function(_GetPoolListForSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetPoolListForSearchProvider._internal(
        (ref) => create(ref as _GetPoolListForSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchText: searchText,
        poolList: poolList,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DexPool>> createElement() {
    return _GetPoolListForSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetPoolListForSearchProvider &&
        other.searchText == searchText &&
        other.poolList == poolList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchText.hashCode);
    hash = _SystemHash.combine(hash, poolList.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetPoolListForSearchRef on AutoDisposeProviderRef<List<DexPool>> {
  /// The parameter `searchText` of this provider.
  String get searchText;

  /// The parameter `poolList` of this provider.
  List<DexPool> get poolList;
}

class _GetPoolListForSearchProviderElement
    extends AutoDisposeProviderElement<List<DexPool>>
    with _GetPoolListForSearchRef {
  _GetPoolListForSearchProviderElement(super.provider);

  @override
  String get searchText => (origin as _GetPoolListForSearchProvider).searchText;
  @override
  List<DexPool> get poolList =>
      (origin as _GetPoolListForSearchProvider).poolList;
}

String _$getPoolTxListHash() => r'86be07f288bf7a7ad8c651feda039965ed38c02b';

/// See also [_getPoolTxList].
@ProviderFor(_getPoolTxList)
const _getPoolTxListProvider = _GetPoolTxListFamily();

/// See also [_getPoolTxList].
class _GetPoolTxListFamily extends Family<AsyncValue<List<DexPoolTx>>> {
  /// See also [_getPoolTxList].
  const _GetPoolTxListFamily();

  /// See also [_getPoolTxList].
  _GetPoolTxListProvider call(
    DexPool pool,
    String lastTransactionAddress,
  ) {
    return _GetPoolTxListProvider(
      pool,
      lastTransactionAddress,
    );
  }

  @override
  _GetPoolTxListProvider getProviderOverride(
    covariant _GetPoolTxListProvider provider,
  ) {
    return call(
      provider.pool,
      provider.lastTransactionAddress,
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
  String? get name => r'_getPoolTxListProvider';
}

/// See also [_getPoolTxList].
class _GetPoolTxListProvider
    extends AutoDisposeFutureProvider<List<DexPoolTx>> {
  /// See also [_getPoolTxList].
  _GetPoolTxListProvider(
    DexPool pool,
    String lastTransactionAddress,
  ) : this._internal(
          (ref) => _getPoolTxList(
            ref as _GetPoolTxListRef,
            pool,
            lastTransactionAddress,
          ),
          from: _getPoolTxListProvider,
          name: r'_getPoolTxListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getPoolTxListHash,
          dependencies: _GetPoolTxListFamily._dependencies,
          allTransitiveDependencies:
              _GetPoolTxListFamily._allTransitiveDependencies,
          pool: pool,
          lastTransactionAddress: lastTransactionAddress,
        );

  _GetPoolTxListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pool,
    required this.lastTransactionAddress,
  }) : super.internal();

  final DexPool pool;
  final String lastTransactionAddress;

  @override
  Override overrideWith(
    FutureOr<List<DexPoolTx>> Function(_GetPoolTxListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetPoolTxListProvider._internal(
        (ref) => create(ref as _GetPoolTxListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pool: pool,
        lastTransactionAddress: lastTransactionAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DexPoolTx>> createElement() {
    return _GetPoolTxListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetPoolTxListProvider &&
        other.pool == pool &&
        other.lastTransactionAddress == lastTransactionAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pool.hashCode);
    hash = _SystemHash.combine(hash, lastTransactionAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetPoolTxListRef on AutoDisposeFutureProviderRef<List<DexPoolTx>> {
  /// The parameter `pool` of this provider.
  DexPool get pool;

  /// The parameter `lastTransactionAddress` of this provider.
  String get lastTransactionAddress;
}

class _GetPoolTxListProviderElement
    extends AutoDisposeFutureProviderElement<List<DexPoolTx>>
    with _GetPoolTxListRef {
  _GetPoolTxListProviderElement(super.provider);

  @override
  DexPool get pool => (origin as _GetPoolTxListProvider).pool;
  @override
  String get lastTransactionAddress =>
      (origin as _GetPoolTxListProvider).lastTransactionAddress;
}

String _$poolFavoriteNotifierHash() =>
    r'361bdaa4cea7d0f8606483c3f3cef3e65cbb50a5';

abstract class _$PoolFavoriteNotifier
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String poolAddress;

  FutureOr<bool> build(
    String poolAddress,
  );
}

/// See also [_PoolFavoriteNotifier].
@ProviderFor(_PoolFavoriteNotifier)
const _poolFavoriteNotifierProvider = _PoolFavoriteNotifierFamily();

/// See also [_PoolFavoriteNotifier].
class _PoolFavoriteNotifierFamily extends Family<AsyncValue<bool>> {
  /// See also [_PoolFavoriteNotifier].
  const _PoolFavoriteNotifierFamily();

  /// See also [_PoolFavoriteNotifier].
  _PoolFavoriteNotifierProvider call(
    String poolAddress,
  ) {
    return _PoolFavoriteNotifierProvider(
      poolAddress,
    );
  }

  @override
  _PoolFavoriteNotifierProvider getProviderOverride(
    covariant _PoolFavoriteNotifierProvider provider,
  ) {
    return call(
      provider.poolAddress,
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
  String? get name => r'_poolFavoriteNotifierProvider';
}

/// See also [_PoolFavoriteNotifier].
class _PoolFavoriteNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<_PoolFavoriteNotifier, bool> {
  /// See also [_PoolFavoriteNotifier].
  _PoolFavoriteNotifierProvider(
    String poolAddress,
  ) : this._internal(
          () => _PoolFavoriteNotifier()..poolAddress = poolAddress,
          from: _poolFavoriteNotifierProvider,
          name: r'_poolFavoriteNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$poolFavoriteNotifierHash,
          dependencies: _PoolFavoriteNotifierFamily._dependencies,
          allTransitiveDependencies:
              _PoolFavoriteNotifierFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
        );

  _PoolFavoriteNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
  }) : super.internal();

  final String poolAddress;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant _PoolFavoriteNotifier notifier,
  ) {
    return notifier.build(
      poolAddress,
    );
  }

  @override
  Override overrideWith(_PoolFavoriteNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: _PoolFavoriteNotifierProvider._internal(
        () => create()..poolAddress = poolAddress,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<_PoolFavoriteNotifier, bool>
      createElement() {
    return _PoolFavoriteNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _PoolFavoriteNotifierProvider &&
        other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _PoolFavoriteNotifierRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _PoolFavoriteNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_PoolFavoriteNotifier, bool>
    with _PoolFavoriteNotifierRef {
  _PoolFavoriteNotifierProviderElement(super.provider);

  @override
  String get poolAddress =>
      (origin as _PoolFavoriteNotifierProvider).poolAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
