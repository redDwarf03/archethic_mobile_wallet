// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_transactions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentTransactionsRepositoryHash() =>
    r'ff6fe6c3e570f2c5c5398c749f9cb25d474921dd';

/// See also [recentTransactionsRepository].
@ProviderFor(recentTransactionsRepository)
final recentTransactionsRepositoryProvider =
    AutoDisposeProvider<RecentTransactionsRepository>.internal(
  recentTransactionsRepository,
  name: r'recentTransactionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentTransactionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentTransactionsRepositoryRef
    = AutoDisposeProviderRef<RecentTransactionsRepository>;
String _$recentTransactionsHash() =>
    r'9ddd058382be0d42abf3a49ecce5ab13cb1ae2c2';

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

/// See also [recentTransactions].
@ProviderFor(recentTransactions)
const recentTransactionsProvider = RecentTransactionsFamily();

/// See also [recentTransactions].
class RecentTransactionsFamily
    extends Family<AsyncValue<List<RecentTransaction>>> {
  /// See also [recentTransactions].
  const RecentTransactionsFamily();

  /// See also [recentTransactions].
  RecentTransactionsProvider call(
    String genesisAddress,
  ) {
    return RecentTransactionsProvider(
      genesisAddress,
    );
  }

  @override
  RecentTransactionsProvider getProviderOverride(
    covariant RecentTransactionsProvider provider,
  ) {
    return call(
      provider.genesisAddress,
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
  String? get name => r'recentTransactionsProvider';
}

/// See also [recentTransactions].
class RecentTransactionsProvider
    extends AutoDisposeFutureProvider<List<RecentTransaction>> {
  /// See also [recentTransactions].
  RecentTransactionsProvider(
    String genesisAddress,
  ) : this._internal(
          (ref) => recentTransactions(
            ref as RecentTransactionsRef,
            genesisAddress,
          ),
          from: recentTransactionsProvider,
          name: r'recentTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentTransactionsHash,
          dependencies: RecentTransactionsFamily._dependencies,
          allTransitiveDependencies:
              RecentTransactionsFamily._allTransitiveDependencies,
          genesisAddress: genesisAddress,
        );

  RecentTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genesisAddress,
  }) : super.internal();

  final String genesisAddress;

  @override
  Override overrideWith(
    FutureOr<List<RecentTransaction>> Function(RecentTransactionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentTransactionsProvider._internal(
        (ref) => create(ref as RecentTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genesisAddress: genesisAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RecentTransaction>> createElement() {
    return _RecentTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentTransactionsProvider &&
        other.genesisAddress == genesisAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genesisAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentTransactionsRef
    on AutoDisposeFutureProviderRef<List<RecentTransaction>> {
  /// The parameter `genesisAddress` of this provider.
  String get genesisAddress;
}

class _RecentTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<RecentTransaction>>
    with RecentTransactionsRef {
  _RecentTransactionsProviderElement(super.provider);

  @override
  String get genesisAddress =>
      (origin as RecentTransactionsProvider).genesisAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
