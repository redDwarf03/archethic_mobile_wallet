// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransferFormState {
  TransferType? get transferType => throw _privateConstructorUsedError;
  TransferProcessStep get transferProcessStep =>
      throw _privateConstructorUsedError; // TODO(reddwarf03): too complicated to manage by hand in [TransferFormNotifier]. Use a small dedicated [FutureProvider] (3)
  AsyncValue<double> get feeEstimation => throw _privateConstructorUsedError;
  bool get defineMaxAmountInProgress => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;

  /// Amount converted in UCO if primary currency is native. Else in fiat currency
// TODO(reddwarf03): too complicated to manage by hand in [TransferFormNotifier]. Use a small dedicated [FutureProvider] (3)
  double get amountConverted => throw _privateConstructorUsedError;
  AccountBalance get accountBalance => throw _privateConstructorUsedError;
  TransferRecipient get recipient => throw _privateConstructorUsedError;
  AEToken? get aeToken => throw _privateConstructorUsedError;
  AccountToken? get accountToken => throw _privateConstructorUsedError;
  String get tokenId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get errorAddressText => throw _privateConstructorUsedError;
  String get errorAmountText => throw _privateConstructorUsedError;
  String get errorMessageText => throw _privateConstructorUsedError;

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferFormStateCopyWith<TransferFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferFormStateCopyWith<$Res> {
  factory $TransferFormStateCopyWith(
          TransferFormState value, $Res Function(TransferFormState) then) =
      _$TransferFormStateCopyWithImpl<$Res, TransferFormState>;
  @useResult
  $Res call(
      {TransferType? transferType,
      TransferProcessStep transferProcessStep,
      AsyncValue<double> feeEstimation,
      bool defineMaxAmountInProgress,
      double amount,
      double amountConverted,
      AccountBalance accountBalance,
      TransferRecipient recipient,
      AEToken? aeToken,
      AccountToken? accountToken,
      String tokenId,
      String message,
      String errorAddressText,
      String errorAmountText,
      String errorMessageText});

  $TransferRecipientCopyWith<$Res> get recipient;
  $AETokenCopyWith<$Res>? get aeToken;
}

/// @nodoc
class _$TransferFormStateCopyWithImpl<$Res, $Val extends TransferFormState>
    implements $TransferFormStateCopyWith<$Res> {
  _$TransferFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferType = freezed,
    Object? transferProcessStep = null,
    Object? feeEstimation = null,
    Object? defineMaxAmountInProgress = null,
    Object? amount = null,
    Object? amountConverted = null,
    Object? accountBalance = null,
    Object? recipient = null,
    Object? aeToken = freezed,
    Object? accountToken = freezed,
    Object? tokenId = null,
    Object? message = null,
    Object? errorAddressText = null,
    Object? errorAmountText = null,
    Object? errorMessageText = null,
  }) {
    return _then(_value.copyWith(
      transferType: freezed == transferType
          ? _value.transferType
          : transferType // ignore: cast_nullable_to_non_nullable
              as TransferType?,
      transferProcessStep: null == transferProcessStep
          ? _value.transferProcessStep
          : transferProcessStep // ignore: cast_nullable_to_non_nullable
              as TransferProcessStep,
      feeEstimation: null == feeEstimation
          ? _value.feeEstimation
          : feeEstimation // ignore: cast_nullable_to_non_nullable
              as AsyncValue<double>,
      defineMaxAmountInProgress: null == defineMaxAmountInProgress
          ? _value.defineMaxAmountInProgress
          : defineMaxAmountInProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountConverted: null == amountConverted
          ? _value.amountConverted
          : amountConverted // ignore: cast_nullable_to_non_nullable
              as double,
      accountBalance: null == accountBalance
          ? _value.accountBalance
          : accountBalance // ignore: cast_nullable_to_non_nullable
              as AccountBalance,
      recipient: null == recipient
          ? _value.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as TransferRecipient,
      aeToken: freezed == aeToken
          ? _value.aeToken
          : aeToken // ignore: cast_nullable_to_non_nullable
              as AEToken?,
      accountToken: freezed == accountToken
          ? _value.accountToken
          : accountToken // ignore: cast_nullable_to_non_nullable
              as AccountToken?,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errorAddressText: null == errorAddressText
          ? _value.errorAddressText
          : errorAddressText // ignore: cast_nullable_to_non_nullable
              as String,
      errorAmountText: null == errorAmountText
          ? _value.errorAmountText
          : errorAmountText // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessageText: null == errorMessageText
          ? _value.errorMessageText
          : errorMessageText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferRecipientCopyWith<$Res> get recipient {
    return $TransferRecipientCopyWith<$Res>(_value.recipient, (value) {
      return _then(_value.copyWith(recipient: value) as $Val);
    });
  }

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AETokenCopyWith<$Res>? get aeToken {
    if (_value.aeToken == null) {
      return null;
    }

    return $AETokenCopyWith<$Res>(_value.aeToken!, (value) {
      return _then(_value.copyWith(aeToken: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferFormStateImplCopyWith<$Res>
    implements $TransferFormStateCopyWith<$Res> {
  factory _$$TransferFormStateImplCopyWith(_$TransferFormStateImpl value,
          $Res Function(_$TransferFormStateImpl) then) =
      __$$TransferFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TransferType? transferType,
      TransferProcessStep transferProcessStep,
      AsyncValue<double> feeEstimation,
      bool defineMaxAmountInProgress,
      double amount,
      double amountConverted,
      AccountBalance accountBalance,
      TransferRecipient recipient,
      AEToken? aeToken,
      AccountToken? accountToken,
      String tokenId,
      String message,
      String errorAddressText,
      String errorAmountText,
      String errorMessageText});

  @override
  $TransferRecipientCopyWith<$Res> get recipient;
  @override
  $AETokenCopyWith<$Res>? get aeToken;
}

/// @nodoc
class __$$TransferFormStateImplCopyWithImpl<$Res>
    extends _$TransferFormStateCopyWithImpl<$Res, _$TransferFormStateImpl>
    implements _$$TransferFormStateImplCopyWith<$Res> {
  __$$TransferFormStateImplCopyWithImpl(_$TransferFormStateImpl _value,
      $Res Function(_$TransferFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferType = freezed,
    Object? transferProcessStep = null,
    Object? feeEstimation = null,
    Object? defineMaxAmountInProgress = null,
    Object? amount = null,
    Object? amountConverted = null,
    Object? accountBalance = null,
    Object? recipient = null,
    Object? aeToken = freezed,
    Object? accountToken = freezed,
    Object? tokenId = null,
    Object? message = null,
    Object? errorAddressText = null,
    Object? errorAmountText = null,
    Object? errorMessageText = null,
  }) {
    return _then(_$TransferFormStateImpl(
      transferType: freezed == transferType
          ? _value.transferType
          : transferType // ignore: cast_nullable_to_non_nullable
              as TransferType?,
      transferProcessStep: null == transferProcessStep
          ? _value.transferProcessStep
          : transferProcessStep // ignore: cast_nullable_to_non_nullable
              as TransferProcessStep,
      feeEstimation: null == feeEstimation
          ? _value.feeEstimation
          : feeEstimation // ignore: cast_nullable_to_non_nullable
              as AsyncValue<double>,
      defineMaxAmountInProgress: null == defineMaxAmountInProgress
          ? _value.defineMaxAmountInProgress
          : defineMaxAmountInProgress // ignore: cast_nullable_to_non_nullable
              as bool,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      amountConverted: null == amountConverted
          ? _value.amountConverted
          : amountConverted // ignore: cast_nullable_to_non_nullable
              as double,
      accountBalance: null == accountBalance
          ? _value.accountBalance
          : accountBalance // ignore: cast_nullable_to_non_nullable
              as AccountBalance,
      recipient: null == recipient
          ? _value.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as TransferRecipient,
      aeToken: freezed == aeToken
          ? _value.aeToken
          : aeToken // ignore: cast_nullable_to_non_nullable
              as AEToken?,
      accountToken: freezed == accountToken
          ? _value.accountToken
          : accountToken // ignore: cast_nullable_to_non_nullable
              as AccountToken?,
      tokenId: null == tokenId
          ? _value.tokenId
          : tokenId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errorAddressText: null == errorAddressText
          ? _value.errorAddressText
          : errorAddressText // ignore: cast_nullable_to_non_nullable
              as String,
      errorAmountText: null == errorAmountText
          ? _value.errorAmountText
          : errorAmountText // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessageText: null == errorMessageText
          ? _value.errorMessageText
          : errorMessageText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TransferFormStateImpl extends _TransferFormState {
  const _$TransferFormStateImpl(
      {this.transferType,
      this.transferProcessStep = TransferProcessStep.form,
      required this.feeEstimation,
      this.defineMaxAmountInProgress = false,
      this.amount = 0.0,
      this.amountConverted = 0.0,
      required this.accountBalance,
      required this.recipient,
      this.aeToken,
      this.accountToken,
      this.tokenId = '',
      this.message = '',
      this.errorAddressText = '',
      this.errorAmountText = '',
      this.errorMessageText = ''})
      : super._();

  @override
  final TransferType? transferType;
  @override
  @JsonKey()
  final TransferProcessStep transferProcessStep;
// TODO(reddwarf03): too complicated to manage by hand in [TransferFormNotifier]. Use a small dedicated [FutureProvider] (3)
  @override
  final AsyncValue<double> feeEstimation;
  @override
  @JsonKey()
  final bool defineMaxAmountInProgress;
  @override
  @JsonKey()
  final double amount;

  /// Amount converted in UCO if primary currency is native. Else in fiat currency
// TODO(reddwarf03): too complicated to manage by hand in [TransferFormNotifier]. Use a small dedicated [FutureProvider] (3)
  @override
  @JsonKey()
  final double amountConverted;
  @override
  final AccountBalance accountBalance;
  @override
  final TransferRecipient recipient;
  @override
  final AEToken? aeToken;
  @override
  final AccountToken? accountToken;
  @override
  @JsonKey()
  final String tokenId;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final String errorAddressText;
  @override
  @JsonKey()
  final String errorAmountText;
  @override
  @JsonKey()
  final String errorMessageText;

  @override
  String toString() {
    return 'TransferFormState(transferType: $transferType, transferProcessStep: $transferProcessStep, feeEstimation: $feeEstimation, defineMaxAmountInProgress: $defineMaxAmountInProgress, amount: $amount, amountConverted: $amountConverted, accountBalance: $accountBalance, recipient: $recipient, aeToken: $aeToken, accountToken: $accountToken, tokenId: $tokenId, message: $message, errorAddressText: $errorAddressText, errorAmountText: $errorAmountText, errorMessageText: $errorMessageText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferFormStateImpl &&
            (identical(other.transferType, transferType) ||
                other.transferType == transferType) &&
            (identical(other.transferProcessStep, transferProcessStep) ||
                other.transferProcessStep == transferProcessStep) &&
            (identical(other.feeEstimation, feeEstimation) ||
                other.feeEstimation == feeEstimation) &&
            (identical(other.defineMaxAmountInProgress,
                    defineMaxAmountInProgress) ||
                other.defineMaxAmountInProgress == defineMaxAmountInProgress) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.amountConverted, amountConverted) ||
                other.amountConverted == amountConverted) &&
            (identical(other.accountBalance, accountBalance) ||
                other.accountBalance == accountBalance) &&
            (identical(other.recipient, recipient) ||
                other.recipient == recipient) &&
            (identical(other.aeToken, aeToken) || other.aeToken == aeToken) &&
            (identical(other.accountToken, accountToken) ||
                other.accountToken == accountToken) &&
            (identical(other.tokenId, tokenId) || other.tokenId == tokenId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorAddressText, errorAddressText) ||
                other.errorAddressText == errorAddressText) &&
            (identical(other.errorAmountText, errorAmountText) ||
                other.errorAmountText == errorAmountText) &&
            (identical(other.errorMessageText, errorMessageText) ||
                other.errorMessageText == errorMessageText));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      transferType,
      transferProcessStep,
      feeEstimation,
      defineMaxAmountInProgress,
      amount,
      amountConverted,
      accountBalance,
      recipient,
      aeToken,
      accountToken,
      tokenId,
      message,
      errorAddressText,
      errorAmountText,
      errorMessageText);

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferFormStateImplCopyWith<_$TransferFormStateImpl> get copyWith =>
      __$$TransferFormStateImplCopyWithImpl<_$TransferFormStateImpl>(
          this, _$identity);
}

abstract class _TransferFormState extends TransferFormState {
  const factory _TransferFormState(
      {final TransferType? transferType,
      final TransferProcessStep transferProcessStep,
      required final AsyncValue<double> feeEstimation,
      final bool defineMaxAmountInProgress,
      final double amount,
      final double amountConverted,
      required final AccountBalance accountBalance,
      required final TransferRecipient recipient,
      final AEToken? aeToken,
      final AccountToken? accountToken,
      final String tokenId,
      final String message,
      final String errorAddressText,
      final String errorAmountText,
      final String errorMessageText}) = _$TransferFormStateImpl;
  const _TransferFormState._() : super._();

  @override
  TransferType? get transferType;
  @override
  TransferProcessStep
      get transferProcessStep; // TODO(reddwarf03): too complicated to manage by hand in [TransferFormNotifier]. Use a small dedicated [FutureProvider] (3)
  @override
  AsyncValue<double> get feeEstimation;
  @override
  bool get defineMaxAmountInProgress;
  @override
  double get amount;

  /// Amount converted in UCO if primary currency is native. Else in fiat currency
// TODO(reddwarf03): too complicated to manage by hand in [TransferFormNotifier]. Use a small dedicated [FutureProvider] (3)
  @override
  double get amountConverted;
  @override
  AccountBalance get accountBalance;
  @override
  TransferRecipient get recipient;
  @override
  AEToken? get aeToken;
  @override
  AccountToken? get accountToken;
  @override
  String get tokenId;
  @override
  String get message;
  @override
  String get errorAddressText;
  @override
  String get errorAmountText;
  @override
  String get errorMessageText;

  /// Create a copy of TransferFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferFormStateImplCopyWith<_$TransferFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransferRecipient _$TransferRecipientFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'address':
      return _TransferDestinationAddress.fromJson(json);
    case 'account':
      return _TransferDestinationContact.fromJson(json);
    case 'unknownContact':
      return _TransferDestinationUnknownContact.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'TransferRecipient',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$TransferRecipient {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@AddressJsonConverter() Address address) address,
    required TResult Function(@AccountConverter() Account account) account,
    required TResult Function(String name) unknownContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@AddressJsonConverter() Address address)? address,
    TResult? Function(@AccountConverter() Account account)? account,
    TResult? Function(String name)? unknownContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@AddressJsonConverter() Address address)? address,
    TResult Function(@AccountConverter() Account account)? account,
    TResult Function(String name)? unknownContact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TransferDestinationAddress value) address,
    required TResult Function(_TransferDestinationContact value) account,
    required TResult Function(_TransferDestinationUnknownContact value)
        unknownContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TransferDestinationAddress value)? address,
    TResult? Function(_TransferDestinationContact value)? account,
    TResult? Function(_TransferDestinationUnknownContact value)? unknownContact,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TransferDestinationAddress value)? address,
    TResult Function(_TransferDestinationContact value)? account,
    TResult Function(_TransferDestinationUnknownContact value)? unknownContact,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this TransferRecipient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferRecipientCopyWith<$Res> {
  factory $TransferRecipientCopyWith(
          TransferRecipient value, $Res Function(TransferRecipient) then) =
      _$TransferRecipientCopyWithImpl<$Res, TransferRecipient>;
}

/// @nodoc
class _$TransferRecipientCopyWithImpl<$Res, $Val extends TransferRecipient>
    implements $TransferRecipientCopyWith<$Res> {
  _$TransferRecipientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TransferDestinationAddressImplCopyWith<$Res> {
  factory _$$TransferDestinationAddressImplCopyWith(
          _$TransferDestinationAddressImpl value,
          $Res Function(_$TransferDestinationAddressImpl) then) =
      __$$TransferDestinationAddressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({@AddressJsonConverter() Address address});

  $AddressCopyWith<$Res> get address;
}

/// @nodoc
class __$$TransferDestinationAddressImplCopyWithImpl<$Res>
    extends _$TransferRecipientCopyWithImpl<$Res,
        _$TransferDestinationAddressImpl>
    implements _$$TransferDestinationAddressImplCopyWith<$Res> {
  __$$TransferDestinationAddressImplCopyWithImpl(
      _$TransferDestinationAddressImpl _value,
      $Res Function(_$TransferDestinationAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
  }) {
    return _then(_$TransferDestinationAddressImpl(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as Address,
    ));
  }

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressCopyWith<$Res> get address {
    return $AddressCopyWith<$Res>(_value.address, (value) {
      return _then(_value.copyWith(address: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferDestinationAddressImpl extends _TransferDestinationAddress {
  const _$TransferDestinationAddressImpl(
      {@AddressJsonConverter() required this.address, final String? $type})
      : $type = $type ?? 'address',
        super._();

  factory _$TransferDestinationAddressImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TransferDestinationAddressImplFromJson(json);

  @override
  @AddressJsonConverter()
  final Address address;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferRecipient.address(address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferDestinationAddressImpl &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, address);

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferDestinationAddressImplCopyWith<_$TransferDestinationAddressImpl>
      get copyWith => __$$TransferDestinationAddressImplCopyWithImpl<
          _$TransferDestinationAddressImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@AddressJsonConverter() Address address) address,
    required TResult Function(@AccountConverter() Account account) account,
    required TResult Function(String name) unknownContact,
  }) {
    return address(this.address);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@AddressJsonConverter() Address address)? address,
    TResult? Function(@AccountConverter() Account account)? account,
    TResult? Function(String name)? unknownContact,
  }) {
    return address?.call(this.address);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@AddressJsonConverter() Address address)? address,
    TResult Function(@AccountConverter() Account account)? account,
    TResult Function(String name)? unknownContact,
    required TResult orElse(),
  }) {
    if (address != null) {
      return address(this.address);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TransferDestinationAddress value) address,
    required TResult Function(_TransferDestinationContact value) account,
    required TResult Function(_TransferDestinationUnknownContact value)
        unknownContact,
  }) {
    return address(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TransferDestinationAddress value)? address,
    TResult? Function(_TransferDestinationContact value)? account,
    TResult? Function(_TransferDestinationUnknownContact value)? unknownContact,
  }) {
    return address?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TransferDestinationAddress value)? address,
    TResult Function(_TransferDestinationContact value)? account,
    TResult Function(_TransferDestinationUnknownContact value)? unknownContact,
    required TResult orElse(),
  }) {
    if (address != null) {
      return address(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferDestinationAddressImplToJson(
      this,
    );
  }
}

abstract class _TransferDestinationAddress extends TransferRecipient {
  const factory _TransferDestinationAddress(
          {@AddressJsonConverter() required final Address address}) =
      _$TransferDestinationAddressImpl;
  const _TransferDestinationAddress._() : super._();

  factory _TransferDestinationAddress.fromJson(Map<String, dynamic> json) =
      _$TransferDestinationAddressImpl.fromJson;

  @AddressJsonConverter()
  Address get address;

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferDestinationAddressImplCopyWith<_$TransferDestinationAddressImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransferDestinationContactImplCopyWith<$Res> {
  factory _$$TransferDestinationContactImplCopyWith(
          _$TransferDestinationContactImpl value,
          $Res Function(_$TransferDestinationContactImpl) then) =
      __$$TransferDestinationContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({@AccountConverter() Account account});
}

/// @nodoc
class __$$TransferDestinationContactImplCopyWithImpl<$Res>
    extends _$TransferRecipientCopyWithImpl<$Res,
        _$TransferDestinationContactImpl>
    implements _$$TransferDestinationContactImplCopyWith<$Res> {
  __$$TransferDestinationContactImplCopyWithImpl(
      _$TransferDestinationContactImpl _value,
      $Res Function(_$TransferDestinationContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? account = null,
  }) {
    return _then(_$TransferDestinationContactImpl(
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as Account,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferDestinationContactImpl extends _TransferDestinationContact {
  const _$TransferDestinationContactImpl(
      {@AccountConverter() required this.account, final String? $type})
      : $type = $type ?? 'account',
        super._();

  factory _$TransferDestinationContactImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TransferDestinationContactImplFromJson(json);

  @override
  @AccountConverter()
  final Account account;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferRecipient.account(account: $account)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferDestinationContactImpl &&
            (identical(other.account, account) || other.account == account));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, account);

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferDestinationContactImplCopyWith<_$TransferDestinationContactImpl>
      get copyWith => __$$TransferDestinationContactImplCopyWithImpl<
          _$TransferDestinationContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@AddressJsonConverter() Address address) address,
    required TResult Function(@AccountConverter() Account account) account,
    required TResult Function(String name) unknownContact,
  }) {
    return account(this.account);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@AddressJsonConverter() Address address)? address,
    TResult? Function(@AccountConverter() Account account)? account,
    TResult? Function(String name)? unknownContact,
  }) {
    return account?.call(this.account);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@AddressJsonConverter() Address address)? address,
    TResult Function(@AccountConverter() Account account)? account,
    TResult Function(String name)? unknownContact,
    required TResult orElse(),
  }) {
    if (account != null) {
      return account(this.account);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TransferDestinationAddress value) address,
    required TResult Function(_TransferDestinationContact value) account,
    required TResult Function(_TransferDestinationUnknownContact value)
        unknownContact,
  }) {
    return account(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TransferDestinationAddress value)? address,
    TResult? Function(_TransferDestinationContact value)? account,
    TResult? Function(_TransferDestinationUnknownContact value)? unknownContact,
  }) {
    return account?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TransferDestinationAddress value)? address,
    TResult Function(_TransferDestinationContact value)? account,
    TResult Function(_TransferDestinationUnknownContact value)? unknownContact,
    required TResult orElse(),
  }) {
    if (account != null) {
      return account(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferDestinationContactImplToJson(
      this,
    );
  }
}

abstract class _TransferDestinationContact extends TransferRecipient {
  const factory _TransferDestinationContact(
          {@AccountConverter() required final Account account}) =
      _$TransferDestinationContactImpl;
  const _TransferDestinationContact._() : super._();

  factory _TransferDestinationContact.fromJson(Map<String, dynamic> json) =
      _$TransferDestinationContactImpl.fromJson;

  @AccountConverter()
  Account get account;

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferDestinationContactImplCopyWith<_$TransferDestinationContactImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TransferDestinationUnknownContactImplCopyWith<$Res> {
  factory _$$TransferDestinationUnknownContactImplCopyWith(
          _$TransferDestinationUnknownContactImpl value,
          $Res Function(_$TransferDestinationUnknownContactImpl) then) =
      __$$TransferDestinationUnknownContactImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$TransferDestinationUnknownContactImplCopyWithImpl<$Res>
    extends _$TransferRecipientCopyWithImpl<$Res,
        _$TransferDestinationUnknownContactImpl>
    implements _$$TransferDestinationUnknownContactImplCopyWith<$Res> {
  __$$TransferDestinationUnknownContactImplCopyWithImpl(
      _$TransferDestinationUnknownContactImpl _value,
      $Res Function(_$TransferDestinationUnknownContactImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$TransferDestinationUnknownContactImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferDestinationUnknownContactImpl
    extends _TransferDestinationUnknownContact {
  const _$TransferDestinationUnknownContactImpl(
      {required this.name, final String? $type})
      : $type = $type ?? 'unknownContact',
        super._();

  factory _$TransferDestinationUnknownContactImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TransferDestinationUnknownContactImplFromJson(json);

  @override
  final String name;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TransferRecipient.unknownContact(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferDestinationUnknownContactImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferDestinationUnknownContactImplCopyWith<
          _$TransferDestinationUnknownContactImpl>
      get copyWith => __$$TransferDestinationUnknownContactImplCopyWithImpl<
          _$TransferDestinationUnknownContactImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@AddressJsonConverter() Address address) address,
    required TResult Function(@AccountConverter() Account account) account,
    required TResult Function(String name) unknownContact,
  }) {
    return unknownContact(name);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@AddressJsonConverter() Address address)? address,
    TResult? Function(@AccountConverter() Account account)? account,
    TResult? Function(String name)? unknownContact,
  }) {
    return unknownContact?.call(name);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@AddressJsonConverter() Address address)? address,
    TResult Function(@AccountConverter() Account account)? account,
    TResult Function(String name)? unknownContact,
    required TResult orElse(),
  }) {
    if (unknownContact != null) {
      return unknownContact(name);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TransferDestinationAddress value) address,
    required TResult Function(_TransferDestinationContact value) account,
    required TResult Function(_TransferDestinationUnknownContact value)
        unknownContact,
  }) {
    return unknownContact(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_TransferDestinationAddress value)? address,
    TResult? Function(_TransferDestinationContact value)? account,
    TResult? Function(_TransferDestinationUnknownContact value)? unknownContact,
  }) {
    return unknownContact?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TransferDestinationAddress value)? address,
    TResult Function(_TransferDestinationContact value)? account,
    TResult Function(_TransferDestinationUnknownContact value)? unknownContact,
    required TResult orElse(),
  }) {
    if (unknownContact != null) {
      return unknownContact(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferDestinationUnknownContactImplToJson(
      this,
    );
  }
}

abstract class _TransferDestinationUnknownContact extends TransferRecipient {
  const factory _TransferDestinationUnknownContact(
      {required final String name}) = _$TransferDestinationUnknownContactImpl;
  const _TransferDestinationUnknownContact._() : super._();

  factory _TransferDestinationUnknownContact.fromJson(
          Map<String, dynamic> json) =
      _$TransferDestinationUnknownContactImpl.fromJson;

  String get name;

  /// Create a copy of TransferRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferDestinationUnknownContactImplCopyWith<
          _$TransferDestinationUnknownContactImpl>
      get copyWith => throw _privateConstructorUsedError;
}
