// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountNotifierHash() => r'9769742204cef6836ddfd285e8c4d8a58afa2c7d';

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

abstract class _$AccountNotifier
    extends BuildlessAutoDisposeAsyncNotifier<Account?> {
  late final String accountName;

  FutureOr<Account?> build(
    String accountName,
  );
}

/// See also [AccountNotifier].
@ProviderFor(AccountNotifier)
const accountNotifierProvider = AccountNotifierFamily();

/// See also [AccountNotifier].
class AccountNotifierFamily extends Family<AsyncValue<Account?>> {
  /// See also [AccountNotifier].
  const AccountNotifierFamily();

  /// See also [AccountNotifier].
  AccountNotifierProvider call(
    String accountName,
  ) {
    return AccountNotifierProvider(
      accountName,
    );
  }

  @override
  AccountNotifierProvider getProviderOverride(
    covariant AccountNotifierProvider provider,
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
  String? get name => r'accountNotifierProvider';
}

/// See also [AccountNotifier].
class AccountNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<AccountNotifier, Account?> {
  /// See also [AccountNotifier].
  AccountNotifierProvider(
    String accountName,
  ) : this._internal(
          () => AccountNotifier()..accountName = accountName,
          from: accountNotifierProvider,
          name: r'accountNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountNotifierHash,
          dependencies: AccountNotifierFamily._dependencies,
          allTransitiveDependencies:
              AccountNotifierFamily._allTransitiveDependencies,
          accountName: accountName,
        );

  AccountNotifierProvider._internal(
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
    covariant AccountNotifier notifier,
  ) {
    return notifier.build(
      accountName,
    );
  }

  @override
  Override overrideWith(AccountNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<AccountNotifier, Account?>
      createElement() {
    return _AccountNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountNotifierProvider && other.accountName == accountName;
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
mixin AccountNotifierRef on AutoDisposeAsyncNotifierProviderRef<Account?> {
  /// The parameter `accountName` of this provider.
  String get accountName;
}

class _AccountNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<AccountNotifier, Account?>
    with AccountNotifierRef {
  _AccountNotifierProviderElement(super.provider);

  @override
  String get accountName => (origin as AccountNotifierProvider).accountName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
