// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sendTransactionUseCaseHash() =>
    r'fece2c19161c8105bbcc33268e0d0fcc060856a2';

/// See also [_sendTransactionUseCase].
@ProviderFor(_sendTransactionUseCase)
final _sendTransactionUseCaseProvider = AutoDisposeProvider<
    UseCase<SendTransactionCommand,
        Result<TransactionConfirmation, TransactionError>>>.internal(
  _sendTransactionUseCase,
  name: r'_sendTransactionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sendTransactionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _SendTransactionUseCaseRef = AutoDisposeProviderRef<
    UseCase<SendTransactionCommand,
        Result<TransactionConfirmation, TransactionError>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
