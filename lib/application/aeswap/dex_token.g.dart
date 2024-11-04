// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dex_token.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dexTokenRepositoryHash() =>
    r'b6199a276d5b46d767899f2d0d374bbaa5cc2e59';

/// See also [_dexTokenRepository].
@ProviderFor(_dexTokenRepository)
final _dexTokenRepositoryProvider =
    AutoDisposeProvider<DexTokenRepositoryImpl>.internal(
  _dexTokenRepository,
  name: r'_dexTokenRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dexTokenRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DexTokenRepositoryRef = AutoDisposeProviderRef<DexTokenRepositoryImpl>;
String _$getTokenFromAddressHash() =>
    r'bba5c993a736821dabff5c9078ab5377bdb5e397';

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

/// See also [_getTokenFromAddress].
@ProviderFor(_getTokenFromAddress)
const _getTokenFromAddressProvider = _GetTokenFromAddressFamily();

/// See also [_getTokenFromAddress].
class _GetTokenFromAddressFamily extends Family<AsyncValue<DexToken?>> {
  /// See also [_getTokenFromAddress].
  const _GetTokenFromAddressFamily();

  /// See also [_getTokenFromAddress].
  _GetTokenFromAddressProvider call(
    dynamic address,
  ) {
    return _GetTokenFromAddressProvider(
      address,
    );
  }

  @override
  _GetTokenFromAddressProvider getProviderOverride(
    covariant _GetTokenFromAddressProvider provider,
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
  String? get name => r'_getTokenFromAddressProvider';
}

/// See also [_getTokenFromAddress].
class _GetTokenFromAddressProvider
    extends AutoDisposeFutureProvider<DexToken?> {
  /// See also [_getTokenFromAddress].
  _GetTokenFromAddressProvider(
    dynamic address,
  ) : this._internal(
          (ref) => _getTokenFromAddress(
            ref as _GetTokenFromAddressRef,
            address,
          ),
          from: _getTokenFromAddressProvider,
          name: r'_getTokenFromAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTokenFromAddressHash,
          dependencies: _GetTokenFromAddressFamily._dependencies,
          allTransitiveDependencies:
              _GetTokenFromAddressFamily._allTransitiveDependencies,
          address: address,
        );

  _GetTokenFromAddressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final dynamic address;

  @override
  Override overrideWith(
    FutureOr<DexToken?> Function(_GetTokenFromAddressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetTokenFromAddressProvider._internal(
        (ref) => create(ref as _GetTokenFromAddressRef),
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
  AutoDisposeFutureProviderElement<DexToken?> createElement() {
    return _GetTokenFromAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetTokenFromAddressProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetTokenFromAddressRef on AutoDisposeFutureProviderRef<DexToken?> {
  /// The parameter `address` of this provider.
  dynamic get address;
}

class _GetTokenFromAddressProviderElement
    extends AutoDisposeFutureProviderElement<DexToken?>
    with _GetTokenFromAddressRef {
  _GetTokenFromAddressProviderElement(super.provider);

  @override
  dynamic get address => (origin as _GetTokenFromAddressProvider).address;
}

String _$tokensFromAccountHash() => r'5569df982bfeec1ae0830584cc20954eccc43fbc';

/// See also [_tokensFromAccount].
@ProviderFor(_tokensFromAccount)
final _tokensFromAccountProvider =
    AutoDisposeFutureProvider<List<DexToken>>.internal(
  _tokensFromAccount,
  name: r'_tokensFromAccountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tokensFromAccountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _TokensFromAccountRef = AutoDisposeFutureProviderRef<List<DexToken>>;
String _$dexTokenBasesHash() => r'acae7f5858035ad4bf8617eaf922876a43eb98ed';

/// See also [_dexTokenBases].
@ProviderFor(_dexTokenBases)
final _dexTokenBasesProvider =
    AutoDisposeFutureProvider<List<DexToken>>.internal(
  _dexTokenBases,
  name: r'_dexTokenBasesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dexTokenBasesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _DexTokenBasesRef = AutoDisposeFutureProviderRef<List<DexToken>>;
String _$dexTokenBaseHash() => r'890d12040de2fbaefcb758cf3d38aa6f25e30176';

/// See also [_dexTokenBase].
@ProviderFor(_dexTokenBase)
const _dexTokenBaseProvider = _DexTokenBaseFamily();

/// See also [_dexTokenBase].
class _DexTokenBaseFamily extends Family<AsyncValue<DexToken?>> {
  /// See also [_dexTokenBase].
  const _DexTokenBaseFamily();

  /// See also [_dexTokenBase].
  _DexTokenBaseProvider call(
    String address,
  ) {
    return _DexTokenBaseProvider(
      address,
    );
  }

  @override
  _DexTokenBaseProvider getProviderOverride(
    covariant _DexTokenBaseProvider provider,
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
  String? get name => r'_dexTokenBaseProvider';
}

/// See also [_dexTokenBase].
class _DexTokenBaseProvider extends AutoDisposeFutureProvider<DexToken?> {
  /// See also [_dexTokenBase].
  _DexTokenBaseProvider(
    String address,
  ) : this._internal(
          (ref) => _dexTokenBase(
            ref as _DexTokenBaseRef,
            address,
          ),
          from: _dexTokenBaseProvider,
          name: r'_dexTokenBaseProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dexTokenBaseHash,
          dependencies: _DexTokenBaseFamily._dependencies,
          allTransitiveDependencies:
              _DexTokenBaseFamily._allTransitiveDependencies,
          address: address,
        );

  _DexTokenBaseProvider._internal(
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
    FutureOr<DexToken?> Function(_DexTokenBaseRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _DexTokenBaseProvider._internal(
        (ref) => create(ref as _DexTokenBaseRef),
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
  AutoDisposeFutureProviderElement<DexToken?> createElement() {
    return _DexTokenBaseProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _DexTokenBaseProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _DexTokenBaseRef on AutoDisposeFutureProviderRef<DexToken?> {
  /// The parameter `address` of this provider.
  String get address;
}

class _DexTokenBaseProviderElement
    extends AutoDisposeFutureProviderElement<DexToken?> with _DexTokenBaseRef {
  _DexTokenBaseProviderElement(super.provider);

  @override
  String get address => (origin as _DexTokenBaseProvider).address;
}

String _$getTokenIconHash() => r'fc3c2ba657b7424a189e4ed6981ef9d106b0d117';

/// See also [_getTokenIcon].
@ProviderFor(_getTokenIcon)
const _getTokenIconProvider = _GetTokenIconFamily();

/// See also [_getTokenIcon].
class _GetTokenIconFamily extends Family<AsyncValue<String?>> {
  /// See also [_getTokenIcon].
  const _GetTokenIconFamily();

  /// See also [_getTokenIcon].
  _GetTokenIconProvider call(
    dynamic address,
  ) {
    return _GetTokenIconProvider(
      address,
    );
  }

  @override
  _GetTokenIconProvider getProviderOverride(
    covariant _GetTokenIconProvider provider,
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
  String? get name => r'_getTokenIconProvider';
}

/// See also [_getTokenIcon].
class _GetTokenIconProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [_getTokenIcon].
  _GetTokenIconProvider(
    dynamic address,
  ) : this._internal(
          (ref) => _getTokenIcon(
            ref as _GetTokenIconRef,
            address,
          ),
          from: _getTokenIconProvider,
          name: r'_getTokenIconProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTokenIconHash,
          dependencies: _GetTokenIconFamily._dependencies,
          allTransitiveDependencies:
              _GetTokenIconFamily._allTransitiveDependencies,
          address: address,
        );

  _GetTokenIconProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final dynamic address;

  @override
  Override overrideWith(
    FutureOr<String?> Function(_GetTokenIconRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetTokenIconProvider._internal(
        (ref) => create(ref as _GetTokenIconRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _GetTokenIconProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetTokenIconProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetTokenIconRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `address` of this provider.
  dynamic get address;
}

class _GetTokenIconProviderElement
    extends AutoDisposeFutureProviderElement<String?> with _GetTokenIconRef {
  _GetTokenIconProviderElement(super.provider);

  @override
  dynamic get address => (origin as _GetTokenIconProvider).address;
}

String _$estimateTokenInFiatHash() =>
    r'2f22e5eecfbf9315132fcec98e6812153f0ae01e';

/// See also [_estimateTokenInFiat].
@ProviderFor(_estimateTokenInFiat)
const _estimateTokenInFiatProvider = _EstimateTokenInFiatFamily();

/// See also [_estimateTokenInFiat].
class _EstimateTokenInFiatFamily extends Family<AsyncValue<double>> {
  /// See also [_estimateTokenInFiat].
  const _EstimateTokenInFiatFamily();

  /// See also [_estimateTokenInFiat].
  _EstimateTokenInFiatProvider call(
    String tokenAddress,
  ) {
    return _EstimateTokenInFiatProvider(
      tokenAddress,
    );
  }

  @override
  _EstimateTokenInFiatProvider getProviderOverride(
    covariant _EstimateTokenInFiatProvider provider,
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
  String? get name => r'_estimateTokenInFiatProvider';
}

/// See also [_estimateTokenInFiat].
class _EstimateTokenInFiatProvider extends AutoDisposeFutureProvider<double> {
  /// See also [_estimateTokenInFiat].
  _EstimateTokenInFiatProvider(
    String tokenAddress,
  ) : this._internal(
          (ref) => _estimateTokenInFiat(
            ref as _EstimateTokenInFiatRef,
            tokenAddress,
          ),
          from: _estimateTokenInFiatProvider,
          name: r'_estimateTokenInFiatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$estimateTokenInFiatHash,
          dependencies: _EstimateTokenInFiatFamily._dependencies,
          allTransitiveDependencies:
              _EstimateTokenInFiatFamily._allTransitiveDependencies,
          tokenAddress: tokenAddress,
        );

  _EstimateTokenInFiatProvider._internal(
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
    FutureOr<double> Function(_EstimateTokenInFiatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _EstimateTokenInFiatProvider._internal(
        (ref) => create(ref as _EstimateTokenInFiatRef),
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
    return _EstimateTokenInFiatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _EstimateTokenInFiatProvider &&
        other.tokenAddress == tokenAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tokenAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _EstimateTokenInFiatRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `tokenAddress` of this provider.
  String get tokenAddress;
}

class _EstimateTokenInFiatProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with _EstimateTokenInFiatRef {
  _EstimateTokenInFiatProviderElement(super.provider);

  @override
  String get tokenAddress =>
      (origin as _EstimateTokenInFiatProvider).tokenAddress;
}

String _$getRemoveAmountsHash() => r'5ef17a0246ccf402c8cfa2334909514bb491625f';

/// This provider is used to cache request result
/// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
/// if `lpTokenAmount` hasn't changed.
///
/// Copied from [_getRemoveAmounts].
@ProviderFor(_getRemoveAmounts)
const _getRemoveAmountsProvider = _GetRemoveAmountsFamily();

/// This provider is used to cache request result
/// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
/// if `lpTokenAmount` hasn't changed.
///
/// Copied from [_getRemoveAmounts].
class _GetRemoveAmountsFamily
    extends Family<AsyncValue<({double token1, double token2})>> {
  /// This provider is used to cache request result
  /// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
  /// if `lpTokenAmount` hasn't changed.
  ///
  /// Copied from [_getRemoveAmounts].
  const _GetRemoveAmountsFamily();

  /// This provider is used to cache request result
  /// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
  /// if `lpTokenAmount` hasn't changed.
  ///
  /// Copied from [_getRemoveAmounts].
  _GetRemoveAmountsProvider call(
    String poolAddress,
    double lpTokenAmount,
  ) {
    return _GetRemoveAmountsProvider(
      poolAddress,
      lpTokenAmount,
    );
  }

  @override
  _GetRemoveAmountsProvider getProviderOverride(
    covariant _GetRemoveAmountsProvider provider,
  ) {
    return call(
      provider.poolAddress,
      provider.lpTokenAmount,
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
  String? get name => r'_getRemoveAmountsProvider';
}

/// This provider is used to cache request result
/// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
/// if `lpTokenAmount` hasn't changed.
///
/// Copied from [_getRemoveAmounts].
class _GetRemoveAmountsProvider
    extends AutoDisposeFutureProvider<({double token1, double token2})> {
  /// This provider is used to cache request result
  /// It ensures, for example, that an oracle update won't trigger a new `getRemoveAmounts` request
  /// if `lpTokenAmount` hasn't changed.
  ///
  /// Copied from [_getRemoveAmounts].
  _GetRemoveAmountsProvider(
    String poolAddress,
    double lpTokenAmount,
  ) : this._internal(
          (ref) => _getRemoveAmounts(
            ref as _GetRemoveAmountsRef,
            poolAddress,
            lpTokenAmount,
          ),
          from: _getRemoveAmountsProvider,
          name: r'_getRemoveAmountsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRemoveAmountsHash,
          dependencies: _GetRemoveAmountsFamily._dependencies,
          allTransitiveDependencies:
              _GetRemoveAmountsFamily._allTransitiveDependencies,
          poolAddress: poolAddress,
          lpTokenAmount: lpTokenAmount,
        );

  _GetRemoveAmountsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.poolAddress,
    required this.lpTokenAmount,
  }) : super.internal();

  final String poolAddress;
  final double lpTokenAmount;

  @override
  Override overrideWith(
    FutureOr<({double token1, double token2})> Function(
            _GetRemoveAmountsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetRemoveAmountsProvider._internal(
        (ref) => create(ref as _GetRemoveAmountsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        poolAddress: poolAddress,
        lpTokenAmount: lpTokenAmount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<({double token1, double token2})>
      createElement() {
    return _GetRemoveAmountsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetRemoveAmountsProvider &&
        other.poolAddress == poolAddress &&
        other.lpTokenAmount == lpTokenAmount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, lpTokenAmount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetRemoveAmountsRef
    on AutoDisposeFutureProviderRef<({double token1, double token2})> {
  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `lpTokenAmount` of this provider.
  double get lpTokenAmount;
}

class _GetRemoveAmountsProviderElement
    extends AutoDisposeFutureProviderElement<({double token1, double token2})>
    with _GetRemoveAmountsRef {
  _GetRemoveAmountsProviderElement(super.provider);

  @override
  String get poolAddress => (origin as _GetRemoveAmountsProvider).poolAddress;
  @override
  double get lpTokenAmount =>
      (origin as _GetRemoveAmountsProvider).lpTokenAmount;
}

String _$estimateLPTokenInFiatHash() =>
<<<<<<< HEAD
    r'117d1b9fae927eca34724ab59d026abeaf3a6393';
=======
    r'4da34defbb60f367688c57c66b713d474f680f72';
>>>>>>> 0fc830d6 (feat: :sparkles: Add Custom tokens management)

/// See also [_estimateLPTokenInFiat].
@ProviderFor(_estimateLPTokenInFiat)
const _estimateLPTokenInFiatProvider = _EstimateLPTokenInFiatFamily();

/// See also [_estimateLPTokenInFiat].
class _EstimateLPTokenInFiatFamily extends Family<AsyncValue<double>> {
  /// See also [_estimateLPTokenInFiat].
  const _EstimateLPTokenInFiatFamily();

  /// See also [_estimateLPTokenInFiat].
  _EstimateLPTokenInFiatProvider call(
    String token1Address,
    String token2Address,
    double lpTokenAmount,
    String poolAddress,
  ) {
    return _EstimateLPTokenInFiatProvider(
      token1Address,
      token2Address,
      lpTokenAmount,
      poolAddress,
    );
  }

  @override
  _EstimateLPTokenInFiatProvider getProviderOverride(
    covariant _EstimateLPTokenInFiatProvider provider,
  ) {
    return call(
      provider.token1Address,
      provider.token2Address,
      provider.lpTokenAmount,
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
  String? get name => r'_estimateLPTokenInFiatProvider';
}

/// See also [_estimateLPTokenInFiat].
class _EstimateLPTokenInFiatProvider extends AutoDisposeFutureProvider<double> {
  /// See also [_estimateLPTokenInFiat].
  _EstimateLPTokenInFiatProvider(
    String token1Address,
    String token2Address,
    double lpTokenAmount,
    String poolAddress,
  ) : this._internal(
          (ref) => _estimateLPTokenInFiat(
            ref as _EstimateLPTokenInFiatRef,
            token1Address,
            token2Address,
            lpTokenAmount,
            poolAddress,
          ),
          from: _estimateLPTokenInFiatProvider,
          name: r'_estimateLPTokenInFiatProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$estimateLPTokenInFiatHash,
          dependencies: _EstimateLPTokenInFiatFamily._dependencies,
          allTransitiveDependencies:
              _EstimateLPTokenInFiatFamily._allTransitiveDependencies,
          token1Address: token1Address,
          token2Address: token2Address,
          lpTokenAmount: lpTokenAmount,
          poolAddress: poolAddress,
        );

  _EstimateLPTokenInFiatProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token1Address,
    required this.token2Address,
    required this.lpTokenAmount,
    required this.poolAddress,
  }) : super.internal();

  final String token1Address;
  final String token2Address;
  final double lpTokenAmount;
  final String poolAddress;

  @override
  Override overrideWith(
    FutureOr<double> Function(_EstimateLPTokenInFiatRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _EstimateLPTokenInFiatProvider._internal(
        (ref) => create(ref as _EstimateLPTokenInFiatRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token1Address: token1Address,
        token2Address: token2Address,
        lpTokenAmount: lpTokenAmount,
        poolAddress: poolAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _EstimateLPTokenInFiatProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _EstimateLPTokenInFiatProvider &&
        other.token1Address == token1Address &&
        other.token2Address == token2Address &&
        other.lpTokenAmount == lpTokenAmount &&
        other.poolAddress == poolAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token1Address.hashCode);
    hash = _SystemHash.combine(hash, token2Address.hashCode);
    hash = _SystemHash.combine(hash, lpTokenAmount.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _EstimateLPTokenInFiatRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `token1Address` of this provider.
  String get token1Address;

  /// The parameter `token2Address` of this provider.
  String get token2Address;

  /// The parameter `lpTokenAmount` of this provider.
  double get lpTokenAmount;

  /// The parameter `poolAddress` of this provider.
  String get poolAddress;
}

class _EstimateLPTokenInFiatProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with _EstimateLPTokenInFiatRef {
  _EstimateLPTokenInFiatProviderElement(super.provider);

  @override
  String get token1Address =>
      (origin as _EstimateLPTokenInFiatProvider).token1Address;
  @override
  String get token2Address =>
      (origin as _EstimateLPTokenInFiatProvider).token2Address;
  @override
  double get lpTokenAmount =>
      (origin as _EstimateLPTokenInFiatProvider).lpTokenAmount;
  @override
  String get poolAddress =>
      (origin as _EstimateLPTokenInFiatProvider).poolAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
