// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$networkLinkHash() => r'1dc389164e6dd1fadbfc555b54db260a0032c45a';

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

/// See also [_networkLink].
@ProviderFor(_networkLink)
const _networkLinkProvider = _NetworkLinkFamily();

/// See also [_networkLink].
class _NetworkLinkFamily extends Family<String> {
  /// See also [_networkLink].
  const _NetworkLinkFamily();

  /// See also [_networkLink].
  _NetworkLinkProvider call({
    required AvailableNetworks network,
  }) {
    return _NetworkLinkProvider(
      network: network,
    );
  }

  @override
  _NetworkLinkProvider getProviderOverride(
    covariant _NetworkLinkProvider provider,
  ) {
    return call(
      network: provider.network,
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
  String? get name => r'_networkLinkProvider';
}

/// See also [_networkLink].
class _NetworkLinkProvider extends AutoDisposeProvider<String> {
  /// See also [_networkLink].
  _NetworkLinkProvider({
    required AvailableNetworks network,
  }) : this._internal(
          (ref) => _networkLink(
            ref as _NetworkLinkRef,
            network: network,
          ),
          from: _networkLinkProvider,
          name: r'_networkLinkProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$networkLinkHash,
          dependencies: _NetworkLinkFamily._dependencies,
          allTransitiveDependencies:
              _NetworkLinkFamily._allTransitiveDependencies,
          network: network,
        );

  _NetworkLinkProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.network,
  }) : super.internal();

  final AvailableNetworks network;

  @override
  Override overrideWith(
    String Function(_NetworkLinkRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _NetworkLinkProvider._internal(
        (ref) => create(ref as _NetworkLinkRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        network: network,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _NetworkLinkProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _NetworkLinkProvider && other.network == network;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, network.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _NetworkLinkRef on AutoDisposeProviderRef<String> {
  /// The parameter `network` of this provider.
  AvailableNetworks get network;
}

class _NetworkLinkProviderElement extends AutoDisposeProviderElement<String>
    with _NetworkLinkRef {
  _NetworkLinkProviderElement(super.provider);

  @override
  AvailableNetworks get network => (origin as _NetworkLinkProvider).network;
}

String _$networkNodesHash() => r'b73184d08e3a705b6f8c9a5085a2b0adf202ab84';

/// See also [_networkNodes].
@ProviderFor(_networkNodes)
const _networkNodesProvider = _NetworkNodesFamily();

/// See also [_networkNodes].
class _NetworkNodesFamily extends Family<AsyncValue<List<Node>>> {
  /// See also [_networkNodes].
  const _NetworkNodesFamily();

  /// See also [_networkNodes].
  _NetworkNodesProvider call({
    required AvailableNetworks network,
  }) {
    return _NetworkNodesProvider(
      network: network,
    );
  }

  @override
  _NetworkNodesProvider getProviderOverride(
    covariant _NetworkNodesProvider provider,
  ) {
    return call(
      network: provider.network,
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
  String? get name => r'_networkNodesProvider';
}

/// See also [_networkNodes].
class _NetworkNodesProvider extends AutoDisposeFutureProvider<List<Node>> {
  /// See also [_networkNodes].
  _NetworkNodesProvider({
    required AvailableNetworks network,
  }) : this._internal(
          (ref) => _networkNodes(
            ref as _NetworkNodesRef,
            network: network,
          ),
          from: _networkNodesProvider,
          name: r'_networkNodesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$networkNodesHash,
          dependencies: _NetworkNodesFamily._dependencies,
          allTransitiveDependencies:
              _NetworkNodesFamily._allTransitiveDependencies,
          network: network,
        );

  _NetworkNodesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.network,
  }) : super.internal();

  final AvailableNetworks network;

  @override
  Override overrideWith(
    FutureOr<List<Node>> Function(_NetworkNodesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _NetworkNodesProvider._internal(
        (ref) => create(ref as _NetworkNodesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        network: network,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Node>> createElement() {
    return _NetworkNodesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _NetworkNodesProvider && other.network == network;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, network.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _NetworkNodesRef on AutoDisposeFutureProviderRef<List<Node>> {
  /// The parameter `network` of this provider.
  AvailableNetworks get network;
}

class _NetworkNodesProviderElement
    extends AutoDisposeFutureProviderElement<List<Node>> with _NetworkNodesRef {
  _NetworkNodesProviderElement(super.provider);

  @override
  AvailableNetworks get network => (origin as _NetworkNodesProvider).network;
}

String _$isReservedNodeUriHash() => r'a069da95adf0e5f07c485b10a98bf1bf3ae08108';

/// See also [_isReservedNodeUri].
@ProviderFor(_isReservedNodeUri)
const _isReservedNodeUriProvider = _IsReservedNodeUriFamily();

/// See also [_isReservedNodeUri].
class _IsReservedNodeUriFamily extends Family<AsyncValue<bool>> {
  /// See also [_isReservedNodeUri].
  const _IsReservedNodeUriFamily();

  /// See also [_isReservedNodeUri].
  _IsReservedNodeUriProvider call({
    required Uri uri,
  }) {
    return _IsReservedNodeUriProvider(
      uri: uri,
    );
  }

  @override
  _IsReservedNodeUriProvider getProviderOverride(
    covariant _IsReservedNodeUriProvider provider,
  ) {
    return call(
      uri: provider.uri,
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
  String? get name => r'_isReservedNodeUriProvider';
}

/// See also [_isReservedNodeUri].
class _IsReservedNodeUriProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [_isReservedNodeUri].
  _IsReservedNodeUriProvider({
    required Uri uri,
  }) : this._internal(
          (ref) => _isReservedNodeUri(
            ref as _IsReservedNodeUriRef,
            uri: uri,
          ),
          from: _isReservedNodeUriProvider,
          name: r'_isReservedNodeUriProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isReservedNodeUriHash,
          dependencies: _IsReservedNodeUriFamily._dependencies,
          allTransitiveDependencies:
              _IsReservedNodeUriFamily._allTransitiveDependencies,
          uri: uri,
        );

  _IsReservedNodeUriProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uri,
  }) : super.internal();

  final Uri uri;

  @override
  Override overrideWith(
    FutureOr<bool> Function(_IsReservedNodeUriRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _IsReservedNodeUriProvider._internal(
        (ref) => create(ref as _IsReservedNodeUriRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uri: uri,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _IsReservedNodeUriProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IsReservedNodeUriProvider && other.uri == uri;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uri.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _IsReservedNodeUriRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `uri` of this provider.
  Uri get uri;
}

class _IsReservedNodeUriProviderElement
    extends AutoDisposeFutureProviderElement<bool> with _IsReservedNodeUriRef {
  _IsReservedNodeUriProviderElement(super.provider);

  @override
  Uri get uri => (origin as _IsReservedNodeUriProvider).uri;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
