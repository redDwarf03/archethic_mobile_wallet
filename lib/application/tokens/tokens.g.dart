// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

<<<<<<< HEAD
<<<<<<< HEAD
String _$tokensListHash() => r'593e48ed9063457663e2e48b344aed4ca8bc7518';
=======
String _$tokensFromAddressesHash() =>
<<<<<<< HEAD
    r'4cd16d00a6c3c466c3eefe8e60852b2791c7527b';
>>>>>>> 0fc830d6 (feat: :sparkles: Add Custom tokens management)
=======
    r'dfc16b82d33ff918a59411a80e8a0d3719259f92';
>>>>>>> 97bbb94a (chore: :arrow_up: Upgrade riverpod)
=======
String _$tokensRepositoryImplHash() =>
    r'6d0639fff11793ccb691c0bdb8aa86b99078ee47';

/// See also [tokensRepositoryImpl].
@ProviderFor(tokensRepositoryImpl)
final tokensRepositoryImplProvider =
    AutoDisposeProvider<TokensRepositoryImpl>.internal(
  tokensRepositoryImpl,
  name: r'tokensRepositoryImplProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tokensRepositoryImplHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TokensRepositoryImplRef = AutoDisposeProviderRef<TokensRepositoryImpl>;
String _$tokensFromAddressesHash() =>
    r'3eb854cf86092bf7599a28a546924b3a2eb3bf14';
>>>>>>> d48d1eb3 (chore: :recycle: Use provider to use TokensRepositoryImpl)

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

/// See also [tokensFromAddresses].
@ProviderFor(tokensFromAddresses)
const tokensFromAddressesProvider = TokensFromAddressesFamily();

/// See also [tokensFromAddresses].
class TokensFromAddressesFamily
    extends Family<AsyncValue<Map<String, archethic.Token>>> {
  /// See also [tokensFromAddresses].
  const TokensFromAddressesFamily();

  /// See also [tokensFromAddresses].
  TokensFromAddressesProvider call(
    List<String> addresses,
  ) {
    return TokensFromAddressesProvider(
      addresses,
    );
  }

  @override
  TokensFromAddressesProvider getProviderOverride(
    covariant TokensFromAddressesProvider provider,
  ) {
    return call(
      provider.addresses,
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
  String? get name => r'tokensFromAddressesProvider';
}

/// See also [tokensFromAddresses].
class TokensFromAddressesProvider
    extends AutoDisposeFutureProvider<Map<String, archethic.Token>> {
  /// See also [tokensFromAddresses].
  TokensFromAddressesProvider(
    List<String> addresses,
  ) : this._internal(
          (ref) => tokensFromAddresses(
            ref as TokensFromAddressesRef,
            addresses,
          ),
          from: tokensFromAddressesProvider,
          name: r'tokensFromAddressesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tokensFromAddressesHash,
          dependencies: TokensFromAddressesFamily._dependencies,
          allTransitiveDependencies:
              TokensFromAddressesFamily._allTransitiveDependencies,
          addresses: addresses,
        );

  TokensFromAddressesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.addresses,
  }) : super.internal();

  final List<String> addresses;

  @override
  Override overrideWith(
    FutureOr<Map<String, archethic.Token>> Function(
            TokensFromAddressesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TokensFromAddressesProvider._internal(
        (ref) => create(ref as TokensFromAddressesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        addresses: addresses,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, archethic.Token>>
      createElement() {
    return _TokensFromAddressesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TokensFromAddressesProvider && other.addresses == addresses;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, addresses.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TokensFromAddressesRef
    on AutoDisposeFutureProviderRef<Map<String, archethic.Token>> {
  /// The parameter `addresses` of this provider.
  List<String> get addresses;
}

class _TokensFromAddressesProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, archethic.Token>>
    with TokensFromAddressesRef {
  _TokensFromAddressesProviderElement(super.provider);

  @override
  List<String> get addresses =>
      (origin as TokensFromAddressesProvider).addresses;
}

String _$tokensFromUserBalanceHash() =>
    r'65295bf500c0c6e9682ed073e1e342a741289f05';

/// See also [tokensFromUserBalance].
@ProviderFor(tokensFromUserBalance)
const tokensFromUserBalanceProvider = TokensFromUserBalanceFamily();

/// See also [tokensFromUserBalance].
class TokensFromUserBalanceFamily
    extends Family<AsyncValue<List<aedappfm.AEToken>>> {
  /// See also [tokensFromUserBalance].
  const TokensFromUserBalanceFamily();

  /// See also [tokensFromUserBalance].
  TokensFromUserBalanceProvider call({
    bool withUCO = true,
    bool withVerified = true,
    bool withLPToken = true,
    bool withNotVerified = true,
    bool withCustomToken = true,
  }) {
    return TokensFromUserBalanceProvider(
      withUCO: withUCO,
      withVerified: withVerified,
      withLPToken: withLPToken,
      withNotVerified: withNotVerified,
      withCustomToken: withCustomToken,
    );
  }

  @override
  TokensFromUserBalanceProvider getProviderOverride(
    covariant TokensFromUserBalanceProvider provider,
  ) {
    return call(
      withUCO: provider.withUCO,
      withVerified: provider.withVerified,
      withLPToken: provider.withLPToken,
      withNotVerified: provider.withNotVerified,
      withCustomToken: provider.withCustomToken,
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
  String? get name => r'tokensFromUserBalanceProvider';
}

/// See also [tokensFromUserBalance].
class TokensFromUserBalanceProvider
    extends AutoDisposeFutureProvider<List<aedappfm.AEToken>> {
  /// See also [tokensFromUserBalance].
  TokensFromUserBalanceProvider({
    bool withUCO = true,
    bool withVerified = true,
    bool withLPToken = true,
    bool withNotVerified = true,
    bool withCustomToken = true,
  }) : this._internal(
          (ref) => tokensFromUserBalance(
            ref as TokensFromUserBalanceRef,
            withUCO: withUCO,
            withVerified: withVerified,
            withLPToken: withLPToken,
            withNotVerified: withNotVerified,
            withCustomToken: withCustomToken,
          ),
          from: tokensFromUserBalanceProvider,
          name: r'tokensFromUserBalanceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tokensFromUserBalanceHash,
          dependencies: TokensFromUserBalanceFamily._dependencies,
          allTransitiveDependencies:
              TokensFromUserBalanceFamily._allTransitiveDependencies,
          withUCO: withUCO,
          withVerified: withVerified,
          withLPToken: withLPToken,
          withNotVerified: withNotVerified,
          withCustomToken: withCustomToken,
        );

  TokensFromUserBalanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.withUCO,
    required this.withVerified,
    required this.withLPToken,
    required this.withNotVerified,
    required this.withCustomToken,
  }) : super.internal();

  final bool withUCO;
  final bool withVerified;
  final bool withLPToken;
  final bool withNotVerified;
  final bool withCustomToken;

  @override
  Override overrideWith(
    FutureOr<List<aedappfm.AEToken>> Function(TokensFromUserBalanceRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TokensFromUserBalanceProvider._internal(
        (ref) => create(ref as TokensFromUserBalanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        withUCO: withUCO,
        withVerified: withVerified,
        withLPToken: withLPToken,
        withNotVerified: withNotVerified,
        withCustomToken: withCustomToken,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<aedappfm.AEToken>> createElement() {
    return _TokensFromUserBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TokensFromUserBalanceProvider &&
        other.withUCO == withUCO &&
        other.withVerified == withVerified &&
        other.withLPToken == withLPToken &&
        other.withNotVerified == withNotVerified &&
        other.withCustomToken == withCustomToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, withUCO.hashCode);
    hash = _SystemHash.combine(hash, withVerified.hashCode);
    hash = _SystemHash.combine(hash, withLPToken.hashCode);
    hash = _SystemHash.combine(hash, withNotVerified.hashCode);
    hash = _SystemHash.combine(hash, withCustomToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

<<<<<<< HEAD
<<<<<<< HEAD
@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TokensListRef on AutoDisposeFutureProviderRef<List<aedappfm.AEToken>> {
  /// The parameter `userGenesisAddress` of this provider.
  String get userGenesisAddress;

=======
=======
@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
>>>>>>> 97bbb94a (chore: :arrow_up: Upgrade riverpod)
mixin TokensFromUserBalanceRef
    on AutoDisposeFutureProviderRef<List<aedappfm.AEToken>> {
<<<<<<< HEAD
>>>>>>> 0fc830d6 (feat: :sparkles: Add Custom tokens management)
=======
  /// The parameter `withUCO` of this provider.
  bool get withUCO;

>>>>>>> c07b6392 (fix: :bug: Bugs fixing)
  /// The parameter `withVerified` of this provider.
  bool get withVerified;

  /// The parameter `withLPToken` of this provider.
  bool get withLPToken;

  /// The parameter `withNotVerified` of this provider.
  bool get withNotVerified;

  /// The parameter `withCustomToken` of this provider.
  bool get withCustomToken;
}

class _TokensFromUserBalanceProviderElement
    extends AutoDisposeFutureProviderElement<List<aedappfm.AEToken>>
    with TokensFromUserBalanceRef {
  _TokensFromUserBalanceProviderElement(super.provider);

  @override
  bool get withUCO => (origin as TokensFromUserBalanceProvider).withUCO;
  @override
  bool get withVerified =>
      (origin as TokensFromUserBalanceProvider).withVerified;
  @override
  bool get withLPToken => (origin as TokensFromUserBalanceProvider).withLPToken;
  @override
  bool get withNotVerified =>
      (origin as TokensFromUserBalanceProvider).withNotVerified;
  @override
  bool get withCustomToken =>
      (origin as TokensFromUserBalanceProvider).withCustomToken;
}

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
String _$tokensTotalUSDHash() => r'a0f42e1ef21073d1ec7f627b48fde93b76205a7a';
=======
String _$tokensTotalUSDHash() => r'98ac96ba39ca5f3b227f4d114c7556532a4d24dd';
>>>>>>> 0fc830d6 (feat: :sparkles: Add Custom tokens management)
=======
String _$tokensTotalUSDHash() => r'39ec8250b31cdf374fe272bd8b3077dd8efb6476';
>>>>>>> 97bbb94a (chore: :arrow_up: Upgrade riverpod)
=======
String _$tokensTotalUSDHash() => r'f3e1d13475c67a72664e0fdb557b296f134fc9ad';
>>>>>>> d4305dd0 (fix: :bug: Bug fixing)
=======
String _$tokensTotalUSDHash() => r'4cd1d9dfe1e4a3c828254a2be2461ee032318cc0';
>>>>>>> 4d0cd1d9 (chore: :recycle: Use constants)

/// See also [tokensTotalUSD].
@ProviderFor(tokensTotalUSD)
final tokensTotalUSDProvider = AutoDisposeFutureProvider<double>.internal(
  tokensTotalUSD,
  name: r'tokensTotalUSDProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tokensTotalUSDHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

<<<<<<< HEAD
<<<<<<< HEAD
/// See also [tokensTotalUSD].
class TokensTotalUSDFamily extends Family<AsyncValue<double>> {
  /// See also [tokensTotalUSD].
  const TokensTotalUSDFamily();

  /// See also [tokensTotalUSD].
  TokensTotalUSDProvider call(
    String userGenesisAddress,
  ) {
    return TokensTotalUSDProvider(
      userGenesisAddress,
    );
  }

  @override
  TokensTotalUSDProvider getProviderOverride(
    covariant TokensTotalUSDProvider provider,
  ) {
    return call(
      provider.userGenesisAddress,
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
  String? get name => r'tokensTotalUSDProvider';
}

/// See also [tokensTotalUSD].
class TokensTotalUSDProvider extends AutoDisposeFutureProvider<double> {
  /// See also [tokensTotalUSD].
  TokensTotalUSDProvider(
    String userGenesisAddress,
  ) : this._internal(
          (ref) => tokensTotalUSD(
            ref as TokensTotalUSDRef,
            userGenesisAddress,
          ),
          from: tokensTotalUSDProvider,
          name: r'tokensTotalUSDProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tokensTotalUSDHash,
          dependencies: TokensTotalUSDFamily._dependencies,
          allTransitiveDependencies:
              TokensTotalUSDFamily._allTransitiveDependencies,
          userGenesisAddress: userGenesisAddress,
        );

  TokensTotalUSDProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userGenesisAddress,
  }) : super.internal();

  final String userGenesisAddress;

  @override
  Override overrideWith(
    FutureOr<double> Function(TokensTotalUSDRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TokensTotalUSDProvider._internal(
        (ref) => create(ref as TokensTotalUSDRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userGenesisAddress: userGenesisAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double> createElement() {
    return _TokensTotalUSDProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TokensTotalUSDProvider &&
        other.userGenesisAddress == userGenesisAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userGenesisAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TokensTotalUSDRef on AutoDisposeFutureProviderRef<double> {
  /// The parameter `userGenesisAddress` of this provider.
  String get userGenesisAddress;
}

class _TokensTotalUSDProviderElement
    extends AutoDisposeFutureProviderElement<double> with TokensTotalUSDRef {
  _TokensTotalUSDProviderElement(super.provider);

  @override
  String get userGenesisAddress =>
      (origin as TokensTotalUSDProvider).userGenesisAddress;
}
=======
=======
@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
>>>>>>> 97bbb94a (chore: :arrow_up: Upgrade riverpod)
typedef TokensTotalUSDRef = AutoDisposeFutureProviderRef<double>;
>>>>>>> 0fc830d6 (feat: :sparkles: Add Custom tokens management)
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
