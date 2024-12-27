// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'primary_currency.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$convertedValueHash() => r'70e18711a8d4ba5df92c6751f7655a7df06bc0b5';

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

/// See also [convertedValue].
@ProviderFor(convertedValue)
const convertedValueProvider = ConvertedValueFamily();

/// See also [convertedValue].
class ConvertedValueFamily extends Family<AsyncValue<double>> {
  /// See also [convertedValue].
  const ConvertedValueFamily();

  /// See also [convertedValue].
  ConvertedValueProvider call({
    required double amount,
  }) {
    return ConvertedValueProvider(
      amount: amount,
    );
  }

  @override
  ConvertedValueProvider getProviderOverride(
    covariant ConvertedValueProvider provider,
  ) {
    return call(
      amount: provider.amount,
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
  String? get name => r'convertedValueProvider';
}

/// See also [convertedValue].
class ConvertedValueProvider extends AutoDisposeFutureProvider<double> {
  /// See also [convertedValue].
  ConvertedValueProvider({
    required double amount,
  }) : this._internal(
          (ref) => convertedValue(
            ref as ConvertedValueRef,
            amount: amount,
          ),
          from: convertedValueProvider,
          name: r'convertedValueProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$convertedValueHash,
          dependencies: ConvertedValueFamily._dependencies,
          allTransitiveDependencies:
              ConvertedValueFamily._allTransitiveDependencies,
          amount: amount,
        );

  ConvertedValueProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.amount,
  }) : super.internal();

  final double amount;

  @override
  Override overrideWith(
    FutureOr<double> Function(ConvertedValueRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConvertedValueProvider._internal(
        (ref) => create(ref as ConvertedValueRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        amount: amount,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _ConvertedValueProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConvertedValueProvider && other.amount == amount;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, amount.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConvertedValueRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `amount` of this provider.
  double get amount;
}

class _ConvertedValueProviderElement
    extends AutoDisposeFutureProviderElement<double> with ConvertedValueRef {
  _ConvertedValueProviderElement(super.provider);

  @override
  double get amount => (origin as ConvertedValueProvider).amount;
}

String _$selectedPrimaryCurrencyHash() =>
    r'ae2bdaa30d2b746c76303048ed020b96f8d153bd';

/// See also [selectedPrimaryCurrency].
@ProviderFor(selectedPrimaryCurrency)
final selectedPrimaryCurrencyProvider =
    AutoDisposeProvider<AvailablePrimaryCurrency>.internal(
  selectedPrimaryCurrency,
  name: r'selectedPrimaryCurrencyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedPrimaryCurrencyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedPrimaryCurrencyRef
    = AutoDisposeProviderRef<AvailablePrimaryCurrency>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
