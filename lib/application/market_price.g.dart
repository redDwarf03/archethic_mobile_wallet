// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_price.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteRepositoriesHash() =>
    r'eeaffe7671b95883cedbbde55fc48eb3d51ab6c3';

/// See also [_remoteRepositories].
@ProviderFor(_remoteRepositories)
final _remoteRepositoriesProvider =
    Provider<List<MarketRepositoryInterface>>.internal(
  _remoteRepositories,
  name: r'_remoteRepositoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteRepositoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _RemoteRepositoriesRef = ProviderRef<List<MarketRepositoryInterface>>;
String _$localRepositoryHash() => r'cd558b3e8e0b1b08f356af4cd7100454e8ab670d';

/// See also [_localRepository].
@ProviderFor(_localRepository)
final _localRepositoryProvider =
    Provider<MarketLocalRepositoryInterface>.internal(
  _localRepository,
  name: r'_localRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _LocalRepositoryRef = ProviderRef<MarketLocalRepositoryInterface>;
String _$currencyMarketPriceHash() =>
    r'287c2e8e5baa424dadd7e608e4b9e2f41aa14646';

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

/// See also [_currencyMarketPrice].
@ProviderFor(_currencyMarketPrice)
const _currencyMarketPriceProvider = _CurrencyMarketPriceFamily();

/// See also [_currencyMarketPrice].
class _CurrencyMarketPriceFamily extends Family<AsyncValue<MarketPrice>> {
  /// See also [_currencyMarketPrice].
  const _CurrencyMarketPriceFamily();

  /// See also [_currencyMarketPrice].
  _CurrencyMarketPriceProvider call({
    required AvailableCurrencyEnum currency,
  }) {
    return _CurrencyMarketPriceProvider(
      currency: currency,
    );
  }

  @override
  _CurrencyMarketPriceProvider getProviderOverride(
    covariant _CurrencyMarketPriceProvider provider,
  ) {
    return call(
      currency: provider.currency,
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
  String? get name => r'_currencyMarketPriceProvider';
}

/// See also [_currencyMarketPrice].
class _CurrencyMarketPriceProvider extends FutureProvider<MarketPrice> {
  /// See also [_currencyMarketPrice].
  _CurrencyMarketPriceProvider({
    required AvailableCurrencyEnum currency,
  }) : this._internal(
          (ref) => _currencyMarketPrice(
            ref as _CurrencyMarketPriceRef,
            currency: currency,
          ),
          from: _currencyMarketPriceProvider,
          name: r'_currencyMarketPriceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$currencyMarketPriceHash,
          dependencies: _CurrencyMarketPriceFamily._dependencies,
          allTransitiveDependencies:
              _CurrencyMarketPriceFamily._allTransitiveDependencies,
          currency: currency,
        );

  _CurrencyMarketPriceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currency,
  }) : super.internal();

  final AvailableCurrencyEnum currency;

  @override
  Override overrideWith(
    FutureOr<MarketPrice> Function(_CurrencyMarketPriceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _CurrencyMarketPriceProvider._internal(
        (ref) => create(ref as _CurrencyMarketPriceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currency: currency,
      ),
    );
  }

  @override
  FutureProviderElement<MarketPrice> createElement() {
    return _CurrencyMarketPriceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _CurrencyMarketPriceProvider && other.currency == currency;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currency.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _CurrencyMarketPriceRef on FutureProviderRef<MarketPrice> {
  /// The parameter `currency` of this provider.
  AvailableCurrencyEnum get currency;
}

class _CurrencyMarketPriceProviderElement
    extends FutureProviderElement<MarketPrice> with _CurrencyMarketPriceRef {
  _CurrencyMarketPriceProviderElement(super.provider);

  @override
  AvailableCurrencyEnum get currency =>
      (origin as _CurrencyMarketPriceProvider).currency;
}

String _$selectedCurrencyMarketPriceHash() =>
    r'0cf631f6520aad26b955dad70be91fd811a7da87';

/// See also [_selectedCurrencyMarketPrice].
@ProviderFor(_selectedCurrencyMarketPrice)
final _selectedCurrencyMarketPriceProvider =
    FutureProvider<MarketPrice>.internal(
  _selectedCurrencyMarketPrice,
  name: r'_selectedCurrencyMarketPriceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCurrencyMarketPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _SelectedCurrencyMarketPriceRef = FutureProviderRef<MarketPrice>;
String _$convertedToSelectedCurrencyHash() =>
    r'214c277af4fe7cb04b5ab79e76a0b8ec55635265';

/// See also [_convertedToSelectedCurrency].
@ProviderFor(_convertedToSelectedCurrency)
const _convertedToSelectedCurrencyProvider =
    _ConvertedToSelectedCurrencyFamily();

/// See also [_convertedToSelectedCurrency].
class _ConvertedToSelectedCurrencyFamily extends Family<AsyncValue<double>> {
  /// See also [_convertedToSelectedCurrency].
  const _ConvertedToSelectedCurrencyFamily();

  /// See also [_convertedToSelectedCurrency].
  _ConvertedToSelectedCurrencyProvider call({
    required double nativeAmount,
  }) {
    return _ConvertedToSelectedCurrencyProvider(
      nativeAmount: nativeAmount,
    );
  }

  @override
  _ConvertedToSelectedCurrencyProvider getProviderOverride(
    covariant _ConvertedToSelectedCurrencyProvider provider,
  ) {
    return call(
      nativeAmount: provider.nativeAmount,
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
  String? get name => r'_convertedToSelectedCurrencyProvider';
}

/// See also [_convertedToSelectedCurrency].
class _ConvertedToSelectedCurrencyProvider
    extends AutoDisposeFutureProvider<double> {
  /// See also [_convertedToSelectedCurrency].
  _ConvertedToSelectedCurrencyProvider({
    required double nativeAmount,
  }) : this._internal(
          (ref) => _convertedToSelectedCurrency(
            ref as _ConvertedToSelectedCurrencyRef,
            nativeAmount: nativeAmount,
          ),
          from: _convertedToSelectedCurrencyProvider,
          name: r'_convertedToSelectedCurrencyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$convertedToSelectedCurrencyHash,
          dependencies: _ConvertedToSelectedCurrencyFamily._dependencies,
          allTransitiveDependencies:
              _ConvertedToSelectedCurrencyFamily._allTransitiveDependencies,
          nativeAmount: nativeAmount,
        );

  _ConvertedToSelectedCurrencyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nativeAmount,
  }) : super.internal();

  final double nativeAmount;

  @override
  Override overrideWith(
    FutureOr<double> Function(_ConvertedToSelectedCurrencyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _ConvertedToSelectedCurrencyProvider._internal(
        (ref) => create(ref as _ConvertedToSelectedCurrencyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nativeAmount: nativeAmount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _ConvertedToSelectedCurrencyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _ConvertedToSelectedCurrencyProvider &&
        other.nativeAmount == nativeAmount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nativeAmount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _ConvertedToSelectedCurrencyRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `nativeAmount` of this provider.
  double get nativeAmount;
}

class _ConvertedToSelectedCurrencyProviderElement
    extends AutoDisposeFutureProviderElement<double>
    with _ConvertedToSelectedCurrencyRef {
  _ConvertedToSelectedCurrencyProviderElement(super.provider);

  @override
  double get nativeAmount =>
      (origin as _ConvertedToSelectedCurrencyProvider).nativeAmount;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
