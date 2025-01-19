// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'formated_name.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$formatedNameFromAddressHash() =>
    r'd31d7d49e32302612dc334e5e9e06d79bc609e63';

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

/// See also [formatedNameFromAddress].
@ProviderFor(formatedNameFromAddress)
const formatedNameFromAddressProvider = FormatedNameFromAddressFamily();

/// See also [formatedNameFromAddress].
class FormatedNameFromAddressFamily extends Family<AsyncValue<String>> {
  /// See also [formatedNameFromAddress].
  const FormatedNameFromAddressFamily();

  /// See also [formatedNameFromAddress].
  FormatedNameFromAddressProvider call(
    BuildContext context,
    String address,
  ) {
    return FormatedNameFromAddressProvider(
      context,
      address,
    );
  }

  @override
  FormatedNameFromAddressProvider getProviderOverride(
    covariant FormatedNameFromAddressProvider provider,
  ) {
    return call(
      provider.context,
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
  String? get name => r'formatedNameFromAddressProvider';
}

/// See also [formatedNameFromAddress].
class FormatedNameFromAddressProvider
    extends AutoDisposeFutureProvider<String> {
  /// See also [formatedNameFromAddress].
  FormatedNameFromAddressProvider(
    BuildContext context,
    String address,
  ) : this._internal(
          (ref) => formatedNameFromAddress(
            ref as FormatedNameFromAddressRef,
            context,
            address,
          ),
          from: formatedNameFromAddressProvider,
          name: r'formatedNameFromAddressProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$formatedNameFromAddressHash,
          dependencies: FormatedNameFromAddressFamily._dependencies,
          allTransitiveDependencies:
              FormatedNameFromAddressFamily._allTransitiveDependencies,
          context: context,
          address: address,
        );

  FormatedNameFromAddressProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
    required this.address,
  }) : super.internal();

  final BuildContext context;
  final String address;

  @override
  Override overrideWith(
    FutureOr<String> Function(FormatedNameFromAddressRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FormatedNameFromAddressProvider._internal(
        (ref) => create(ref as FormatedNameFromAddressRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
        address: address,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _FormatedNameFromAddressProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FormatedNameFromAddressProvider &&
        other.context == context &&
        other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FormatedNameFromAddressRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `context` of this provider.
  BuildContext get context;

  /// The parameter `address` of this provider.
  String get address;
}

class _FormatedNameFromAddressProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with FormatedNameFromAddressRef {
  _FormatedNameFromAddressProviderElement(super.provider);

  @override
  BuildContext get context =>
      (origin as FormatedNameFromAddressProvider).context;
  @override
  String get address => (origin as FormatedNameFromAddressProvider).address;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
