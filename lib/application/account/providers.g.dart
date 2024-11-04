// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountRepositoryHash() => r'c090bc9246c833916cb2cdc6f5e3302ae2bf7a09';

/// See also [_accountRepository].
@ProviderFor(_accountRepository)
final _accountRepositoryProvider =
    AutoDisposeProvider<AccountRepository>.internal(
  _accountRepository,
  name: r'_accountRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _AccountRepositoryRef = AutoDisposeProviderRef<AccountRepository>;
String _$sortedAccountsHash() => r'674a7885782a2142ff970e85183ea43e6b9ca20b';

/// See also [_sortedAccounts].
@ProviderFor(_sortedAccounts)
final _sortedAccountsProvider =
    AutoDisposeFutureProvider<List<Account>>.internal(
  _sortedAccounts,
  name: r'_sortedAccountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortedAccountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _SortedAccountsRef = AutoDisposeFutureProviderRef<List<Account>>;
String _$getAccountNFTFilteredHash() =>
    r'73fe7ac31e9add825086e35ef9722a312a702ce0';

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

/// See also [_getAccountNFTFiltered].
@ProviderFor(_getAccountNFTFiltered)
const _getAccountNFTFilteredProvider = _GetAccountNFTFilteredFamily();

/// See also [_getAccountNFTFiltered].
class _GetAccountNFTFilteredFamily extends Family<List<AccountToken>> {
  /// See also [_getAccountNFTFiltered].
  const _GetAccountNFTFilteredFamily();

  /// See also [_getAccountNFTFiltered].
  _GetAccountNFTFilteredProvider call(
    Account account, {
    bool? favorite,
  }) {
    return _GetAccountNFTFilteredProvider(
      account,
      favorite: favorite,
    );
  }

  @override
  _GetAccountNFTFilteredProvider getProviderOverride(
    covariant _GetAccountNFTFilteredProvider provider,
  ) {
    return call(
      provider.account,
      favorite: provider.favorite,
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
  String? get name => r'_getAccountNFTFilteredProvider';
}

/// See also [_getAccountNFTFiltered].
class _GetAccountNFTFilteredProvider
    extends AutoDisposeProvider<List<AccountToken>> {
  /// See also [_getAccountNFTFiltered].
  _GetAccountNFTFilteredProvider(
    Account account, {
    bool? favorite,
  }) : this._internal(
          (ref) => _getAccountNFTFiltered(
            ref as _GetAccountNFTFilteredRef,
            account,
            favorite: favorite,
          ),
          from: _getAccountNFTFilteredProvider,
          name: r'_getAccountNFTFilteredProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getAccountNFTFilteredHash,
          dependencies: _GetAccountNFTFilteredFamily._dependencies,
          allTransitiveDependencies:
              _GetAccountNFTFilteredFamily._allTransitiveDependencies,
          account: account,
          favorite: favorite,
        );

  _GetAccountNFTFilteredProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.account,
    required this.favorite,
  }) : super.internal();

  final Account account;
  final bool? favorite;

  @override
  Override overrideWith(
    List<AccountToken> Function(_GetAccountNFTFilteredRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _GetAccountNFTFilteredProvider._internal(
        (ref) => create(ref as _GetAccountNFTFilteredRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        account: account,
        favorite: favorite,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<AccountToken>> createElement() {
    return _GetAccountNFTFilteredProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _GetAccountNFTFilteredProvider &&
        other.account == account &&
        other.favorite == favorite;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, account.hashCode);
    hash = _SystemHash.combine(hash, favorite.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _GetAccountNFTFilteredRef on AutoDisposeProviderRef<List<AccountToken>> {
  /// The parameter `account` of this provider.
  Account get account;

  /// The parameter `favorite` of this provider.
  bool? get favorite;
}

class _GetAccountNFTFilteredProviderElement
    extends AutoDisposeProviderElement<List<AccountToken>>
    with _GetAccountNFTFilteredRef {
  _GetAccountNFTFilteredProviderElement(super.provider);

  @override
  Account get account => (origin as _GetAccountNFTFilteredProvider).account;
  @override
  bool? get favorite => (origin as _GetAccountNFTFilteredProvider).favorite;
}

String _$accountsRepositoryHash() =>
    r'c58a4ccb730ce4cd829b208c00d0b0a49d6bceee';

/// See also [_accountsRepository].
@ProviderFor(_accountsRepository)
final _accountsRepositoryProvider =
    Provider<AccountLocalRepositoryInterface>.internal(
  _accountsRepository,
  name: r'_accountsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _AccountsRepositoryRef = ProviderRef<AccountLocalRepositoryInterface>;
String _$accountExistsNotifierHash() =>
    r'c2ffdcd9d52b517fbb67c33972047a984928a056';

abstract class _$AccountExistsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String accountName;

  FutureOr<bool> build(
    String accountName,
  );
}

/// See also [_AccountExistsNotifier].
@ProviderFor(_AccountExistsNotifier)
const _accountExistsNotifierProvider = _AccountExistsNotifierFamily();

/// See also [_AccountExistsNotifier].
class _AccountExistsNotifierFamily extends Family<AsyncValue<bool>> {
  /// See also [_AccountExistsNotifier].
  const _AccountExistsNotifierFamily();

  /// See also [_AccountExistsNotifier].
  _AccountExistsNotifierProvider call(
    String accountName,
  ) {
    return _AccountExistsNotifierProvider(
      accountName,
    );
  }

  @override
  _AccountExistsNotifierProvider getProviderOverride(
    covariant _AccountExistsNotifierProvider provider,
  ) {
    return call(
      provider.accountName,
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
  String? get name => r'_accountExistsNotifierProvider';
}

/// See also [_AccountExistsNotifier].
class _AccountExistsNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<_AccountExistsNotifier, bool> {
  /// See also [_AccountExistsNotifier].
  _AccountExistsNotifierProvider(
    String accountName,
  ) : this._internal(
          () => _AccountExistsNotifier()..accountName = accountName,
          from: _accountExistsNotifierProvider,
          name: r'_accountExistsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountExistsNotifierHash,
          dependencies: _AccountExistsNotifierFamily._dependencies,
          allTransitiveDependencies:
              _AccountExistsNotifierFamily._allTransitiveDependencies,
          accountName: accountName,
        );

  _AccountExistsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountName,
  }) : super.internal();

  final String accountName;

  @override
  FutureOr<bool> runNotifierBuild(
    covariant _AccountExistsNotifier notifier,
  ) {
    return notifier.build(
      accountName,
    );
  }

  @override
  Override overrideWith(_AccountExistsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: _AccountExistsNotifierProvider._internal(
        () => create()..accountName = accountName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountName: accountName,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<_AccountExistsNotifier, bool>
      createElement() {
    return _AccountExistsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AccountExistsNotifierProvider &&
        other.accountName == accountName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _AccountExistsNotifierRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `accountName` of this provider.
  String get accountName;
}

class _AccountExistsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<_AccountExistsNotifier,
        bool> with _AccountExistsNotifierRef {
  _AccountExistsNotifierProviderElement(super.provider);

  @override
  String get accountName =>
      (origin as _AccountExistsNotifierProvider).accountName;
}

String _$accountNotifierHash() => r'b66707462d0170e94fcdaa5568e52e5babfe26fb';

abstract class _$AccountNotifier extends BuildlessAsyncNotifier<Account?> {
  late final String accountName;

  FutureOr<Account?> build(
    String accountName,
  );
}

/// See also [_AccountNotifier].
@ProviderFor(_AccountNotifier)
const _accountNotifierProvider = _AccountNotifierFamily();

/// See also [_AccountNotifier].
class _AccountNotifierFamily extends Family<AsyncValue<Account?>> {
  /// See also [_AccountNotifier].
  const _AccountNotifierFamily();

  /// See also [_AccountNotifier].
  _AccountNotifierProvider call(
    String accountName,
  ) {
    return _AccountNotifierProvider(
      accountName,
    );
  }

  @override
  _AccountNotifierProvider getProviderOverride(
    covariant _AccountNotifierProvider provider,
  ) {
    return call(
      provider.accountName,
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
  String? get name => r'_accountNotifierProvider';
}

/// See also [_AccountNotifier].
class _AccountNotifierProvider
    extends AsyncNotifierProviderImpl<_AccountNotifier, Account?> {
  /// See also [_AccountNotifier].
  _AccountNotifierProvider(
    String accountName,
  ) : this._internal(
          () => _AccountNotifier()..accountName = accountName,
          from: _accountNotifierProvider,
          name: r'_accountNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountNotifierHash,
          dependencies: _AccountNotifierFamily._dependencies,
          allTransitiveDependencies:
              _AccountNotifierFamily._allTransitiveDependencies,
          accountName: accountName,
        );

  _AccountNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountName,
  }) : super.internal();

  final String accountName;

  @override
  FutureOr<Account?> runNotifierBuild(
    covariant _AccountNotifier notifier,
  ) {
    return notifier.build(
      accountName,
    );
  }

  @override
  Override overrideWith(_AccountNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: _AccountNotifierProvider._internal(
        () => create()..accountName = accountName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountName: accountName,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<_AccountNotifier, Account?> createElement() {
    return _AccountNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _AccountNotifierProvider &&
        other.accountName == accountName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _AccountNotifierRef on AsyncNotifierProviderRef<Account?> {
  /// The parameter `accountName` of this provider.
  String get accountName;
}

class _AccountNotifierProviderElement
    extends AsyncNotifierProviderElement<_AccountNotifier, Account?>
    with _AccountNotifierRef {
  _AccountNotifierProviderElement(super.provider);

  @override
  String get accountName => (origin as _AccountNotifierProvider).accountName;
}

String _$accountsNotifierHash() => r'120064998f67c5334c8703934d7848a8f13ae991';

/// See also [_AccountsNotifier].
@ProviderFor(_AccountsNotifier)
final _accountsNotifierProvider =
    AsyncNotifierProvider<_AccountsNotifier, List<Account>>.internal(
  _AccountsNotifier.new,
  name: r'_accountsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accountsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccountsNotifier = AsyncNotifier<List<Account>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
