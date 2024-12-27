// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contactRepositoryHash() => r'09634b29863aac57c42ff8825769bc6b72a0be69';

/// See also [contactRepository].
@ProviderFor(contactRepository)
final contactRepositoryProvider =
    AutoDisposeProvider<ContactRepositoryImpl>.internal(
  contactRepository,
  name: r'contactRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContactRepositoryRef = AutoDisposeProviderRef<ContactRepositoryImpl>;
String _$fetchContactsHash() => r'7ad90286017eccb9bbba3b302ce494697a2b700a';

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

/// See also [fetchContacts].
@ProviderFor(fetchContacts)
const fetchContactsProvider = FetchContactsFamily();

/// See also [fetchContacts].
class FetchContactsFamily extends Family<AsyncValue<List<Contact>>> {
  /// See also [fetchContacts].
  const FetchContactsFamily();

  /// See also [fetchContacts].
  FetchContactsProvider call({
    String search = '',
  }) {
    return FetchContactsProvider(
      search: search,
    );
  }

  @override
  FetchContactsProvider getProviderOverride(
    covariant FetchContactsProvider provider,
  ) {
    return call(
      search: provider.search,
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
  String? get name => r'fetchContactsProvider';
}

/// See also [fetchContacts].
class FetchContactsProvider extends AutoDisposeFutureProvider<List<Contact>> {
  /// See also [fetchContacts].
  FetchContactsProvider({
    String search = '',
  }) : this._internal(
          (ref) => fetchContacts(
            ref as FetchContactsRef,
            search: search,
          ),
          from: fetchContactsProvider,
          name: r'fetchContactsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchContactsHash,
          dependencies: FetchContactsFamily._dependencies,
          allTransitiveDependencies:
              FetchContactsFamily._allTransitiveDependencies,
          search: search,
        );

  FetchContactsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
  }) : super.internal();

  final String search;

  @override
  Override overrideWith(
    FutureOr<List<Contact>> Function(FetchContactsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchContactsProvider._internal(
        (ref) => create(ref as FetchContactsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Contact>> createElement() {
    return _FetchContactsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchContactsProvider && other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchContactsRef on AutoDisposeFutureProviderRef<List<Contact>> {
  /// The parameter `search` of this provider.
  String get search;
}

class _FetchContactsProviderElement
    extends AutoDisposeFutureProviderElement<List<Contact>>
    with FetchContactsRef {
  _FetchContactsProviderElement(super.provider);

  @override
  String get search => (origin as FetchContactsProvider).search;
}

String _$getSelectedContactHash() =>
    r'a8587668be0e199e853b616d9442e2ea282278cd';

/// See also [getSelectedContact].
@ProviderFor(getSelectedContact)
final getSelectedContactProvider = AutoDisposeFutureProvider<Contact?>.internal(
  getSelectedContact,
  name: r'getSelectedContactProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSelectedContactHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetSelectedContactRef = AutoDisposeFutureProviderRef<Contact?>;
String _$getContactWithNameHash() =>
    r'82a977ba03c39378104aaef800a7dad1bf8a46d3';

/// See also [getContactWithName].
@ProviderFor(getContactWithName)
const getContactWithNameProvider = GetContactWithNameFamily();

/// See also [getContactWithName].
class GetContactWithNameFamily extends Family<AsyncValue<Contact?>> {
  /// See also [getContactWithName].
  const GetContactWithNameFamily();

  /// See also [getContactWithName].
  GetContactWithNameProvider call(
    String contactName,
  ) {
    return GetContactWithNameProvider(
      contactName,
    );
  }

  @override
  GetContactWithNameProvider getProviderOverride(
    covariant GetContactWithNameProvider provider,
  ) {
    return call(
      provider.contactName,
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
  String? get name => r'getContactWithNameProvider';
}

/// See also [getContactWithName].
class GetContactWithNameProvider extends AutoDisposeFutureProvider<Contact?> {
  /// See also [getContactWithName].
  GetContactWithNameProvider(
    String contactName,
  ) : this._internal(
          (ref) => getContactWithName(
            ref as GetContactWithNameRef,
            contactName,
          ),
          from: getContactWithNameProvider,
          name: r'getContactWithNameProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getContactWithNameHash,
          dependencies: GetContactWithNameFamily._dependencies,
          allTransitiveDependencies:
              GetContactWithNameFamily._allTransitiveDependencies,
          contactName: contactName,
        );

  GetContactWithNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.contactName,
  }) : super.internal();

  final String contactName;

  @override
  Override overrideWith(
    FutureOr<Contact?> Function(GetContactWithNameRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetContactWithNameProvider._internal(
        (ref) => create(ref as GetContactWithNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        contactName: contactName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Contact?> createElement() {
    return _GetContactWithNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetContactWithNameProvider &&
        other.contactName == contactName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, contactName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetContactWithNameRef on AutoDisposeFutureProviderRef<Contact?> {
  /// The parameter `contactName` of this provider.
  String get contactName;
}

class _GetContactWithNameProviderElement
    extends AutoDisposeFutureProviderElement<Contact?>
    with GetContactWithNameRef {
  _GetContactWithNameProviderElement(super.provider);

  @override
  String get contactName => (origin as GetContactWithNameProvider).contactName;
}

String _$getContactWithAddressHash() =>
    r'42f9e65c821d6ee9618177fdb99238499f0021da';

/// See also [getContactWithAddress].
@ProviderFor(getContactWithAddress)
const getContactWithAddressProvider = GetContactWithAddressFamily();

/// See also [getContactWithAddress].
class GetContactWithAddressFamily extends Family<AsyncValue<Contact?>> {
  /// See also [getContactWithAddress].
  const GetContactWithAddressFamily();

  /// See also [getContactWithAddress].
  GetContactWithAddressProvider call(
    String address,
  ) {
    return GetContactWithAddressProvider(
      address,
    );
  }

  @override
  GetContactWithAddressProvider getProviderOverride(
    covariant GetContactWithAddressProvider provider,
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
  String? get name => r'getContactWithAddressProvider';
}

/// See also [getContactWithAddress].
class GetContactWithAddressProvider
    extends AutoDisposeFutureProvider<Contact?> {
  /// See also [getContactWithAddress].
  GetContactWithAddressProvider(
    String address,
  ) : this._internal(
          (ref) => getContactWithAddress(
            ref as GetContactWithAddressRef,
            address,
          ),
          from: getContactWithAddressProvider,
          name: r'getContactWithAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getContactWithAddressHash,
          dependencies: GetContactWithAddressFamily._dependencies,
          allTransitiveDependencies:
              GetContactWithAddressFamily._allTransitiveDependencies,
          address: address,
        );

  GetContactWithAddressProvider._internal(
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
    FutureOr<Contact?> Function(GetContactWithAddressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetContactWithAddressProvider._internal(
        (ref) => create(ref as GetContactWithAddressRef),
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
  AutoDisposeFutureProviderElement<Contact?> createElement() {
    return _GetContactWithAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetContactWithAddressProvider && other.address == address;
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
mixin GetContactWithAddressRef on AutoDisposeFutureProviderRef<Contact?> {
  /// The parameter `address` of this provider.
  String get address;
}

class _GetContactWithAddressProviderElement
    extends AutoDisposeFutureProviderElement<Contact?>
    with GetContactWithAddressRef {
  _GetContactWithAddressProviderElement(super.provider);

  @override
  String get address => (origin as GetContactWithAddressProvider).address;
}

String _$contactProviderResetHash() =>
    r'c1e0f3fbdb99f9675f11edceba8b6959ca43dd11';

/// See also [contactProviderReset].
@ProviderFor(contactProviderReset)
final contactProviderResetProvider = AutoDisposeFutureProvider<void>.internal(
  contactProviderReset,
  name: r'contactProviderResetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contactProviderResetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ContactProviderResetRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
