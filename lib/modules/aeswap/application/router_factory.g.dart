// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_factory.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerFactoryHash() => r'5185ab0b0622385bedbf868f984167123db6697c';

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

/// See also [routerFactory].
@ProviderFor(routerFactory)
const routerFactoryProvider = RouterFactoryFamily();

/// See also [routerFactory].
class RouterFactoryFamily extends Family<RouterFactory> {
  /// See also [routerFactory].
  const RouterFactoryFamily();

  /// See also [routerFactory].
  RouterFactoryProvider call(
    String address,
  ) {
    return RouterFactoryProvider(
      address,
    );
  }

  @override
  RouterFactoryProvider getProviderOverride(
    covariant RouterFactoryProvider provider,
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
  String? get name => r'routerFactoryProvider';
}

/// See also [routerFactory].
class RouterFactoryProvider extends AutoDisposeProvider<RouterFactory> {
  /// See also [routerFactory].
  RouterFactoryProvider(
    String address,
  ) : this._internal(
          (ref) => routerFactory(
            ref as RouterFactoryRef,
            address,
          ),
          from: routerFactoryProvider,
          name: r'routerFactoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$routerFactoryHash,
          dependencies: RouterFactoryFamily._dependencies,
          allTransitiveDependencies:
              RouterFactoryFamily._allTransitiveDependencies,
          address: address,
        );

  RouterFactoryProvider._internal(
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
    RouterFactory Function(RouterFactoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RouterFactoryProvider._internal(
        (ref) => create(ref as RouterFactoryRef),
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
  AutoDisposeProviderElement<RouterFactory> createElement() {
    return _RouterFactoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RouterFactoryProvider && other.address == address;
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
mixin RouterFactoryRef on AutoDisposeProviderRef<RouterFactory> {
  /// The parameter `address` of this provider.
  String get address;
}

class _RouterFactoryProviderElement
    extends AutoDisposeProviderElement<RouterFactory> with RouterFactoryRef {
  _RouterFactoryProviderElement(super.provider);

  @override
  String get address => (origin as RouterFactoryProvider).address;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
