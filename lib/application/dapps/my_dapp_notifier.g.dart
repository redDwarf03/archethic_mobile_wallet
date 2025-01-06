// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_dapp_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myDAppNotifierHash() => r'612da298145eda2a8a3b0833991bf11b3970447c';

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

abstract class _$MyDAppNotifier
    extends BuildlessAutoDisposeAsyncNotifier<DApp?> {
  late final String url;

  FutureOr<DApp?> build(
    String url,
  );
}

/// See also [MyDAppNotifier].
@ProviderFor(MyDAppNotifier)
const myDAppNotifierProvider = MyDAppNotifierFamily();

/// See also [MyDAppNotifier].
class MyDAppNotifierFamily extends Family<AsyncValue<DApp?>> {
  /// See also [MyDAppNotifier].
  const MyDAppNotifierFamily();

  /// See also [MyDAppNotifier].
  MyDAppNotifierProvider call(
    String url,
  ) {
    return MyDAppNotifierProvider(
      url,
    );
  }

  @override
  MyDAppNotifierProvider getProviderOverride(
    covariant MyDAppNotifierProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'myDAppNotifierProvider';
}

/// See also [MyDAppNotifier].
class MyDAppNotifierProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MyDAppNotifier, DApp?> {
  /// See also [MyDAppNotifier].
  MyDAppNotifierProvider(
    String url,
  ) : this._internal(
          () => MyDAppNotifier()..url = url,
          from: myDAppNotifierProvider,
          name: r'myDAppNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$myDAppNotifierHash,
          dependencies: MyDAppNotifierFamily._dependencies,
          allTransitiveDependencies:
              MyDAppNotifierFamily._allTransitiveDependencies,
          url: url,
        );

  MyDAppNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  FutureOr<DApp?> runNotifierBuild(
    covariant MyDAppNotifier notifier,
  ) {
    return notifier.build(
      url,
    );
  }

  @override
  Override overrideWith(MyDAppNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MyDAppNotifierProvider._internal(
        () => create()..url = url,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MyDAppNotifier, DApp?>
      createElement() {
    return _MyDAppNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyDAppNotifierProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyDAppNotifierRef on AutoDisposeAsyncNotifierProviderRef<DApp?> {
  /// The parameter `url` of this provider.
  String get url;
}

class _MyDAppNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MyDAppNotifier, DApp?>
    with MyDAppNotifierRef {
  _MyDAppNotifierProviderElement(super.provider);

  @override
  String get url => (origin as MyDAppNotifierProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
