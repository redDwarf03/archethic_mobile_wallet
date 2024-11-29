// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dex_lp_token_fiat_value.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dexLPTokenFiatValueHash() =>
    r'9d5ef30cb6961d62f12bf67bbf35e54763d4cbae';

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

/// See also [dexLPTokenFiatValue].
@ProviderFor(dexLPTokenFiatValue)
const dexLPTokenFiatValueProvider = DexLPTokenFiatValueFamily();

/// See also [dexLPTokenFiatValue].
class DexLPTokenFiatValueFamily extends Family<String> {
  /// See also [dexLPTokenFiatValue].
  const DexLPTokenFiatValueFamily();

  /// See also [dexLPTokenFiatValue].
  DexLPTokenFiatValueProvider call(
    DexToken token1,
    DexToken token2,
    double lpTokenAmount,
    String poolAddress, {
    bool withParenthesis = true,
  }) {
    return DexLPTokenFiatValueProvider(
      token1,
      token2,
      lpTokenAmount,
      poolAddress,
      withParenthesis: withParenthesis,
    );
  }

  @override
  DexLPTokenFiatValueProvider getProviderOverride(
    covariant DexLPTokenFiatValueProvider provider,
  ) {
    return call(
      provider.token1,
      provider.token2,
      provider.lpTokenAmount,
      provider.poolAddress,
      withParenthesis: provider.withParenthesis,
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
  String? get name => r'dexLPTokenFiatValueProvider';
}

/// See also [dexLPTokenFiatValue].
class DexLPTokenFiatValueProvider extends AutoDisposeProvider<String> {
  /// See also [dexLPTokenFiatValue].
  DexLPTokenFiatValueProvider(
    DexToken token1,
    DexToken token2,
    double lpTokenAmount,
    String poolAddress, {
    bool withParenthesis = true,
  }) : this._internal(
          (ref) => dexLPTokenFiatValue(
            ref as DexLPTokenFiatValueRef,
            token1,
            token2,
            lpTokenAmount,
            poolAddress,
            withParenthesis: withParenthesis,
          ),
          from: dexLPTokenFiatValueProvider,
          name: r'dexLPTokenFiatValueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dexLPTokenFiatValueHash,
          dependencies: DexLPTokenFiatValueFamily._dependencies,
          allTransitiveDependencies:
              DexLPTokenFiatValueFamily._allTransitiveDependencies,
          token1: token1,
          token2: token2,
          lpTokenAmount: lpTokenAmount,
          poolAddress: poolAddress,
          withParenthesis: withParenthesis,
        );

  DexLPTokenFiatValueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token1,
    required this.token2,
    required this.lpTokenAmount,
    required this.poolAddress,
    required this.withParenthesis,
  }) : super.internal();

  final DexToken token1;
  final DexToken token2;
  final double lpTokenAmount;
  final String poolAddress;
  final bool withParenthesis;

  @override
  Override overrideWith(
    String Function(DexLPTokenFiatValueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DexLPTokenFiatValueProvider._internal(
        (ref) => create(ref as DexLPTokenFiatValueRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token1: token1,
        token2: token2,
        lpTokenAmount: lpTokenAmount,
        poolAddress: poolAddress,
        withParenthesis: withParenthesis,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _DexLPTokenFiatValueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DexLPTokenFiatValueProvider &&
        other.token1 == token1 &&
        other.token2 == token2 &&
        other.lpTokenAmount == lpTokenAmount &&
        other.poolAddress == poolAddress &&
        other.withParenthesis == withParenthesis;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token1.hashCode);
    hash = _SystemHash.combine(hash, token2.hashCode);
    hash = _SystemHash.combine(hash, lpTokenAmount.hashCode);
    hash = _SystemHash.combine(hash, poolAddress.hashCode);
    hash = _SystemHash.combine(hash, withParenthesis.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DexLPTokenFiatValueRef on AutoDisposeProviderRef<String> {
  /// The parameter `token1` of this provider.
  DexToken get token1;

  /// The parameter `token2` of this provider.
  DexToken get token2;

  /// The parameter `lpTokenAmount` of this provider.
  double get lpTokenAmount;

  /// The parameter `poolAddress` of this provider.
  String get poolAddress;

  /// The parameter `withParenthesis` of this provider.
  bool get withParenthesis;
}

class _DexLPTokenFiatValueProviderElement
    extends AutoDisposeProviderElement<String> with DexLPTokenFiatValueRef {
  _DexLPTokenFiatValueProviderElement(super.provider);

  @override
  DexToken get token1 => (origin as DexLPTokenFiatValueProvider).token1;
  @override
  DexToken get token2 => (origin as DexLPTokenFiatValueProvider).token2;
  @override
  double get lpTokenAmount =>
      (origin as DexLPTokenFiatValueProvider).lpTokenAmount;
  @override
  String get poolAddress => (origin as DexLPTokenFiatValueProvider).poolAddress;
  @override
  bool get withParenthesis =>
      (origin as DexLPTokenFiatValueProvider).withParenthesis;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
