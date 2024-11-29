// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_phrase_saved.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isRecoveryPhraseSavedHash() =>
    r'0d549cc4793fe8049d553c65bb217f995339a543';

/// See also [_isRecoveryPhraseSaved].
@ProviderFor(_isRecoveryPhraseSaved)
final _isRecoveryPhraseSavedProvider = AutoDisposeFutureProvider<bool>.internal(
  _isRecoveryPhraseSaved,
  name: r'_isRecoveryPhraseSavedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isRecoveryPhraseSavedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _IsRecoveryPhraseSavedRef = AutoDisposeFutureProviderRef<bool>;
String _$setRecoveryPhraseSavedHash() =>
    r'c8d03b6a8319a0f577c7c5f730f3bae42f5125f1';

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

/// See also [_setRecoveryPhraseSaved].
@ProviderFor(_setRecoveryPhraseSaved)
const _setRecoveryPhraseSavedProvider = _SetRecoveryPhraseSavedFamily();

/// See also [_setRecoveryPhraseSaved].
class _SetRecoveryPhraseSavedFamily extends Family<AsyncValue<void>> {
  /// See also [_setRecoveryPhraseSaved].
  const _SetRecoveryPhraseSavedFamily();

  /// See also [_setRecoveryPhraseSaved].
  _SetRecoveryPhraseSavedProvider call(
    bool value,
  ) {
    return _SetRecoveryPhraseSavedProvider(
      value,
    );
  }

  @override
  _SetRecoveryPhraseSavedProvider getProviderOverride(
    covariant _SetRecoveryPhraseSavedProvider provider,
  ) {
    return call(
      provider.value,
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
  String? get name => r'_setRecoveryPhraseSavedProvider';
}

/// See also [_setRecoveryPhraseSaved].
class _SetRecoveryPhraseSavedProvider extends AutoDisposeFutureProvider<void> {
  /// See also [_setRecoveryPhraseSaved].
  _SetRecoveryPhraseSavedProvider(
    bool value,
  ) : this._internal(
          (ref) => _setRecoveryPhraseSaved(
            ref as _SetRecoveryPhraseSavedRef,
            value,
          ),
          from: _setRecoveryPhraseSavedProvider,
          name: r'_setRecoveryPhraseSavedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$setRecoveryPhraseSavedHash,
          dependencies: _SetRecoveryPhraseSavedFamily._dependencies,
          allTransitiveDependencies:
              _SetRecoveryPhraseSavedFamily._allTransitiveDependencies,
          value: value,
        );

  _SetRecoveryPhraseSavedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.value,
  }) : super.internal();

  final bool value;

  @override
  Override overrideWith(
    FutureOr<void> Function(_SetRecoveryPhraseSavedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _SetRecoveryPhraseSavedProvider._internal(
        (ref) => create(ref as _SetRecoveryPhraseSavedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        value: value,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _SetRecoveryPhraseSavedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _SetRecoveryPhraseSavedProvider && other.value == value;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _SetRecoveryPhraseSavedRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `value` of this provider.
  bool get value;
}

class _SetRecoveryPhraseSavedProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with _SetRecoveryPhraseSavedRef {
  _SetRecoveryPhraseSavedProviderElement(super.provider);

  @override
  bool get value => (origin as _SetRecoveryPhraseSavedProvider).value;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
