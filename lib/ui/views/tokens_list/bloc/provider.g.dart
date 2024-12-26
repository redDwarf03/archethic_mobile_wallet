// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tokensHash() => r'7fae616873afd7998f36c75217bd22d0f0f389b3';

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

/// See also [tokens].
@ProviderFor(tokens)
const tokensProvider = TokensFamily();

/// See also [tokens].
class TokensFamily extends Family<AsyncValue<List<AEToken>>> {
  /// See also [tokens].
  const TokensFamily();

  /// See also [tokens].
  TokensProvider call({
    String searchCriteria = '',
    bool withVerified = true,
    bool withLPToken = true,
    bool withNotVerified = true,
  }) {
    return TokensProvider(
      searchCriteria: searchCriteria,
      withVerified: withVerified,
      withLPToken: withLPToken,
      withNotVerified: withNotVerified,
    );
  }

  @override
  TokensProvider getProviderOverride(
    covariant TokensProvider provider,
  ) {
    return call(
      searchCriteria: provider.searchCriteria,
      withVerified: provider.withVerified,
      withLPToken: provider.withLPToken,
      withNotVerified: provider.withNotVerified,
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
  String? get name => r'tokensProvider';
}

/// See also [tokens].
class TokensProvider extends AutoDisposeFutureProvider<List<AEToken>> {
  /// See also [tokens].
  TokensProvider({
    String searchCriteria = '',
    bool withVerified = true,
    bool withLPToken = true,
    bool withNotVerified = true,
  }) : this._internal(
          (ref) => tokens(
            ref as TokensRef,
            searchCriteria: searchCriteria,
            withVerified: withVerified,
            withLPToken: withLPToken,
            withNotVerified: withNotVerified,
          ),
          from: tokensProvider,
          name: r'tokensProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tokensHash,
          dependencies: TokensFamily._dependencies,
          allTransitiveDependencies: TokensFamily._allTransitiveDependencies,
          searchCriteria: searchCriteria,
          withVerified: withVerified,
          withLPToken: withLPToken,
          withNotVerified: withNotVerified,
        );

  TokensProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchCriteria,
    required this.withVerified,
    required this.withLPToken,
    required this.withNotVerified,
  }) : super.internal();

  final String searchCriteria;
  final bool withVerified;
  final bool withLPToken;
  final bool withNotVerified;

  @override
  Override overrideWith(
    FutureOr<List<AEToken>> Function(TokensRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TokensProvider._internal(
        (ref) => create(ref as TokensRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchCriteria: searchCriteria,
        withVerified: withVerified,
        withLPToken: withLPToken,
        withNotVerified: withNotVerified,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AEToken>> createElement() {
    return _TokensProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TokensProvider &&
        other.searchCriteria == searchCriteria &&
        other.withVerified == withVerified &&
        other.withLPToken == withLPToken &&
        other.withNotVerified == withNotVerified;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchCriteria.hashCode);
    hash = _SystemHash.combine(hash, withVerified.hashCode);
    hash = _SystemHash.combine(hash, withLPToken.hashCode);
    hash = _SystemHash.combine(hash, withNotVerified.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TokensRef on AutoDisposeFutureProviderRef<List<AEToken>> {
  /// The parameter `searchCriteria` of this provider.
  String get searchCriteria;

  /// The parameter `withVerified` of this provider.
  bool get withVerified;

  /// The parameter `withLPToken` of this provider.
  bool get withLPToken;

  /// The parameter `withNotVerified` of this provider.
  bool get withNotVerified;
}

class _TokensProviderElement
    extends AutoDisposeFutureProviderElement<List<AEToken>> with TokensRef {
  _TokensProviderElement(super.provider);

  @override
  String get searchCriteria => (origin as TokensProvider).searchCriteria;
  @override
  bool get withVerified => (origin as TokensProvider).withVerified;
  @override
  bool get withLPToken => (origin as TokensProvider).withLPToken;
  @override
  bool get withNotVerified => (origin as TokensProvider).withNotVerified;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
