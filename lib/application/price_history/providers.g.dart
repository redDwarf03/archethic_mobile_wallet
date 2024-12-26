// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$priceHistoryRepositoryHash() =>
    r'3b4f325abc67795b1bd581b58f29965e781fdc40';

/// See also [priceHistoryRepository].
@ProviderFor(priceHistoryRepository)
final priceHistoryRepositoryProvider =
    AutoDisposeProvider<CoinPriceHistoryRepositoryInterface>.internal(
  priceHistoryRepository,
  name: r'priceHistoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$priceHistoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PriceHistoryRepositoryRef
    = AutoDisposeProviderRef<CoinPriceHistoryRepositoryInterface>;
String _$priceHistoryIntervalOptionHash() =>
    r'a96fa0d83b79a3f48fdcfa2dd11f974310350086';

/// See also [priceHistoryIntervalOption].
@ProviderFor(priceHistoryIntervalOption)
final priceHistoryIntervalOptionProvider =
    AutoDisposeProvider<MarketPriceHistoryInterval>.internal(
  priceHistoryIntervalOption,
  name: r'priceHistoryIntervalOptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$priceHistoryIntervalOptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PriceHistoryIntervalOptionRef
    = AutoDisposeProviderRef<MarketPriceHistoryInterval>;
String _$priceHistoryHash() => r'fe93818ce842d7c1cec311f2c67ed47bc3816114';

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

/// See also [priceHistory].
@ProviderFor(priceHistory)
const priceHistoryProvider = PriceHistoryFamily();

/// See also [priceHistory].
class PriceHistoryFamily extends Family<AsyncValue<List<PriceHistoryValue>?>> {
  /// See also [priceHistory].
  const PriceHistoryFamily();

  /// See also [priceHistory].
  PriceHistoryProvider call({
    int? ucid,
  }) {
    return PriceHistoryProvider(
      ucid: ucid,
    );
  }

  @override
  PriceHistoryProvider getProviderOverride(
    covariant PriceHistoryProvider provider,
  ) {
    return call(
      ucid: provider.ucid,
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
  String? get name => r'priceHistoryProvider';
}

/// See also [priceHistory].
class PriceHistoryProvider
    extends AutoDisposeFutureProvider<List<PriceHistoryValue>?> {
  /// See also [priceHistory].
  PriceHistoryProvider({
    int? ucid,
  }) : this._internal(
          (ref) => priceHistory(
            ref as PriceHistoryRef,
            ucid: ucid,
          ),
          from: priceHistoryProvider,
          name: r'priceHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$priceHistoryHash,
          dependencies: PriceHistoryFamily._dependencies,
          allTransitiveDependencies:
              PriceHistoryFamily._allTransitiveDependencies,
          ucid: ucid,
        );

  PriceHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ucid,
  }) : super.internal();

  final int? ucid;

  @override
  Override overrideWith(
    FutureOr<List<PriceHistoryValue>?> Function(PriceHistoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PriceHistoryProvider._internal(
        (ref) => create(ref as PriceHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ucid: ucid,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PriceHistoryValue>?> createElement() {
    return _PriceHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PriceHistoryProvider && other.ucid == ucid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ucid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PriceHistoryRef
    on AutoDisposeFutureProviderRef<List<PriceHistoryValue>?> {
  /// The parameter `ucid` of this provider.
  int? get ucid;
}

class _PriceHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<PriceHistoryValue>?>
    with PriceHistoryRef {
  _PriceHistoryProviderElement(super.provider);

  @override
  int? get ucid => (origin as PriceHistoryProvider).ucid;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
