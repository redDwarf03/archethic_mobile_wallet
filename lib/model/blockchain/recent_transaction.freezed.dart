// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecentTransaction {
  /// Address of transaction
  @HiveField(0)
  String? get address => throw _privateConstructorUsedError;

  /// Type of transaction : 1=Transfer/Input, 2=Transfer/Output, 3=Token creation
  @HiveField(1)
  int? get typeTx => throw _privateConstructorUsedError;

  /// Amount: asset amount
//@HiveField(2) double? amount,
  /// Recipients: For non asset transfers, the list of recipients
  /// of the transaction (e.g Smart contract interactions)
//@HiveField(3) String? recipient,
  /// Timestamp: Date time when the transaction was generated
  @HiveField(4)
  int? get timestamp => throw _privateConstructorUsedError;

  /// Fee: transaction fee (distributed over the node rewards)
  @HiveField(5)
  double? get fee => throw _privateConstructorUsedError;

  /// From: transaction which send the amount of assets
  @HiveField(6)
  String? get from => throw _privateConstructorUsedError;

  /// Content: free zone for data hosting (string or hexadecimal)
  @HiveField(9)
  String? get content => throw _privateConstructorUsedError;

  /// Type: UCO/tokens/Call
  @HiveField(10)
  String? get type => throw _privateConstructorUsedError;

  /// Token Information
//@HiveField(11) TokenInformation? tokenInformation,
  /// Contact Information
  @HiveField(12)
  @Deprecated('Thanks to hive, we should keep this unused property...')
  Contact? get contactInformation => throw _privateConstructorUsedError;

  /// Decrypted Secret
  @HiveField(14)
  List<String>? get decryptedSecret => throw _privateConstructorUsedError;

  /// Action
  @HiveField(15)
  String? get action => throw _privateConstructorUsedError;

  /// Ledger operations movements
  @HiveField(16)
  List<
      ({
        double? amount,
        String? to,
        TokenInformation? tokenInformation,
        String? type
      })>? get ledgerOperationMvtInfo => throw _privateConstructorUsedError;
  List<Ownership>? get ownerships => throw _privateConstructorUsedError;

  /// Create a copy of RecentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentTransactionCopyWith<RecentTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentTransactionCopyWith<$Res> {
  factory $RecentTransactionCopyWith(
          RecentTransaction value, $Res Function(RecentTransaction) then) =
      _$RecentTransactionCopyWithImpl<$Res, RecentTransaction>;
  @useResult
  $Res call(
      {@HiveField(0) String? address,
      @HiveField(1) int? typeTx,
      @HiveField(4) int? timestamp,
      @HiveField(5) double? fee,
      @HiveField(6) String? from,
      @HiveField(9) String? content,
      @HiveField(10) String? type,
      @HiveField(12)
      @Deprecated('Thanks to hive, we should keep this unused property...')
      Contact? contactInformation,
      @HiveField(14) List<String>? decryptedSecret,
      @HiveField(15) String? action,
      @HiveField(16)
      List<
              ({
                double? amount,
                String? to,
                TokenInformation? tokenInformation,
                String? type
              })>?
          ledgerOperationMvtInfo,
      List<Ownership>? ownerships});
}

/// @nodoc
class _$RecentTransactionCopyWithImpl<$Res, $Val extends RecentTransaction>
    implements $RecentTransactionCopyWith<$Res> {
  _$RecentTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? typeTx = freezed,
    Object? timestamp = freezed,
    Object? fee = freezed,
    Object? from = freezed,
    Object? content = freezed,
    Object? type = freezed,
    Object? contactInformation = freezed,
    Object? decryptedSecret = freezed,
    Object? action = freezed,
    Object? ledgerOperationMvtInfo = freezed,
    Object? ownerships = freezed,
  }) {
    return _then(_value.copyWith(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      typeTx: freezed == typeTx
          ? _value.typeTx
          : typeTx // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      fee: freezed == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as double?,
      from: freezed == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      contactInformation: freezed == contactInformation
          ? _value.contactInformation
          : contactInformation // ignore: cast_nullable_to_non_nullable
              as Contact?,
      decryptedSecret: freezed == decryptedSecret
          ? _value.decryptedSecret
          : decryptedSecret // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
      ledgerOperationMvtInfo: freezed == ledgerOperationMvtInfo
          ? _value.ledgerOperationMvtInfo
          : ledgerOperationMvtInfo // ignore: cast_nullable_to_non_nullable
              as List<
                  ({
                    double? amount,
                    String? to,
                    TokenInformation? tokenInformation,
                    String? type
                  })>?,
      ownerships: freezed == ownerships
          ? _value.ownerships
          : ownerships // ignore: cast_nullable_to_non_nullable
              as List<Ownership>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecentTransactionImplCopyWith<$Res>
    implements $RecentTransactionCopyWith<$Res> {
  factory _$$RecentTransactionImplCopyWith(_$RecentTransactionImpl value,
          $Res Function(_$RecentTransactionImpl) then) =
      __$$RecentTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? address,
      @HiveField(1) int? typeTx,
      @HiveField(4) int? timestamp,
      @HiveField(5) double? fee,
      @HiveField(6) String? from,
      @HiveField(9) String? content,
      @HiveField(10) String? type,
      @HiveField(12)
      @Deprecated('Thanks to hive, we should keep this unused property...')
      Contact? contactInformation,
      @HiveField(14) List<String>? decryptedSecret,
      @HiveField(15) String? action,
      @HiveField(16)
      List<
              ({
                double? amount,
                String? to,
                TokenInformation? tokenInformation,
                String? type
              })>?
          ledgerOperationMvtInfo,
      List<Ownership>? ownerships});
}

/// @nodoc
class __$$RecentTransactionImplCopyWithImpl<$Res>
    extends _$RecentTransactionCopyWithImpl<$Res, _$RecentTransactionImpl>
    implements _$$RecentTransactionImplCopyWith<$Res> {
  __$$RecentTransactionImplCopyWithImpl(_$RecentTransactionImpl _value,
      $Res Function(_$RecentTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? typeTx = freezed,
    Object? timestamp = freezed,
    Object? fee = freezed,
    Object? from = freezed,
    Object? content = freezed,
    Object? type = freezed,
    Object? contactInformation = freezed,
    Object? decryptedSecret = freezed,
    Object? action = freezed,
    Object? ledgerOperationMvtInfo = freezed,
    Object? ownerships = freezed,
  }) {
    return _then(_$RecentTransactionImpl(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      typeTx: freezed == typeTx
          ? _value.typeTx
          : typeTx // ignore: cast_nullable_to_non_nullable
              as int?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      fee: freezed == fee
          ? _value.fee
          : fee // ignore: cast_nullable_to_non_nullable
              as double?,
      from: freezed == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      contactInformation: freezed == contactInformation
          ? _value.contactInformation
          : contactInformation // ignore: cast_nullable_to_non_nullable
              as Contact?,
      decryptedSecret: freezed == decryptedSecret
          ? _value._decryptedSecret
          : decryptedSecret // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String?,
      ledgerOperationMvtInfo: freezed == ledgerOperationMvtInfo
          ? _value._ledgerOperationMvtInfo
          : ledgerOperationMvtInfo // ignore: cast_nullable_to_non_nullable
              as List<
                  ({
                    double? amount,
                    String? to,
                    TokenInformation? tokenInformation,
                    String? type
                  })>?,
      ownerships: freezed == ownerships
          ? _value._ownerships
          : ownerships // ignore: cast_nullable_to_non_nullable
              as List<Ownership>?,
    ));
  }
}

/// @nodoc

class _$RecentTransactionImpl extends _RecentTransaction {
  _$RecentTransactionImpl(
      {@HiveField(0) this.address,
      @HiveField(1) this.typeTx,
      @HiveField(4) this.timestamp,
      @HiveField(5) this.fee,
      @HiveField(6) this.from,
      @HiveField(9) this.content,
      @HiveField(10) this.type,
      @HiveField(12)
      @Deprecated('Thanks to hive, we should keep this unused property...')
      this.contactInformation,
      @HiveField(14) final List<String>? decryptedSecret,
      @HiveField(15) this.action,
      @HiveField(16)
      final List<
              ({
                double? amount,
                String? to,
                TokenInformation? tokenInformation,
                String? type
              })>?
          ledgerOperationMvtInfo,
      final List<Ownership>? ownerships})
      : _decryptedSecret = decryptedSecret,
        _ledgerOperationMvtInfo = ledgerOperationMvtInfo,
        _ownerships = ownerships,
        super._();

  /// Address of transaction
  @override
  @HiveField(0)
  final String? address;

  /// Type of transaction : 1=Transfer/Input, 2=Transfer/Output, 3=Token creation
  @override
  @HiveField(1)
  final int? typeTx;

  /// Amount: asset amount
//@HiveField(2) double? amount,
  /// Recipients: For non asset transfers, the list of recipients
  /// of the transaction (e.g Smart contract interactions)
//@HiveField(3) String? recipient,
  /// Timestamp: Date time when the transaction was generated
  @override
  @HiveField(4)
  final int? timestamp;

  /// Fee: transaction fee (distributed over the node rewards)
  @override
  @HiveField(5)
  final double? fee;

  /// From: transaction which send the amount of assets
  @override
  @HiveField(6)
  final String? from;

  /// Content: free zone for data hosting (string or hexadecimal)
  @override
  @HiveField(9)
  final String? content;

  /// Type: UCO/tokens/Call
  @override
  @HiveField(10)
  final String? type;

  /// Token Information
//@HiveField(11) TokenInformation? tokenInformation,
  /// Contact Information
  @override
  @HiveField(12)
  @Deprecated('Thanks to hive, we should keep this unused property...')
  final Contact? contactInformation;

  /// Decrypted Secret
  final List<String>? _decryptedSecret;

  /// Decrypted Secret
  @override
  @HiveField(14)
  List<String>? get decryptedSecret {
    final value = _decryptedSecret;
    if (value == null) return null;
    if (_decryptedSecret is EqualUnmodifiableListView) return _decryptedSecret;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Action
  @override
  @HiveField(15)
  final String? action;

  /// Ledger operations movements
  final List<
      ({
        double? amount,
        String? to,
        TokenInformation? tokenInformation,
        String? type
      })>? _ledgerOperationMvtInfo;

  /// Ledger operations movements
  @override
  @HiveField(16)
  List<
      ({
        double? amount,
        String? to,
        TokenInformation? tokenInformation,
        String? type
      })>? get ledgerOperationMvtInfo {
    final value = _ledgerOperationMvtInfo;
    if (value == null) return null;
    if (_ledgerOperationMvtInfo is EqualUnmodifiableListView)
      return _ledgerOperationMvtInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Ownership>? _ownerships;
  @override
  List<Ownership>? get ownerships {
    final value = _ownerships;
    if (value == null) return null;
    if (_ownerships is EqualUnmodifiableListView) return _ownerships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RecentTransaction(address: $address, typeTx: $typeTx, timestamp: $timestamp, fee: $fee, from: $from, content: $content, type: $type, contactInformation: $contactInformation, decryptedSecret: $decryptedSecret, action: $action, ledgerOperationMvtInfo: $ledgerOperationMvtInfo, ownerships: $ownerships)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentTransactionImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.typeTx, typeTx) || other.typeTx == typeTx) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.fee, fee) || other.fee == fee) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.contactInformation, contactInformation) ||
                other.contactInformation == contactInformation) &&
            const DeepCollectionEquality()
                .equals(other._decryptedSecret, _decryptedSecret) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(
                other._ledgerOperationMvtInfo, _ledgerOperationMvtInfo) &&
            const DeepCollectionEquality()
                .equals(other._ownerships, _ownerships));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      address,
      typeTx,
      timestamp,
      fee,
      from,
      content,
      type,
      contactInformation,
      const DeepCollectionEquality().hash(_decryptedSecret),
      action,
      const DeepCollectionEquality().hash(_ledgerOperationMvtInfo),
      const DeepCollectionEquality().hash(_ownerships));

  /// Create a copy of RecentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentTransactionImplCopyWith<_$RecentTransactionImpl> get copyWith =>
      __$$RecentTransactionImplCopyWithImpl<_$RecentTransactionImpl>(
          this, _$identity);
}

abstract class _RecentTransaction extends RecentTransaction {
  factory _RecentTransaction(
      {@HiveField(0) final String? address,
      @HiveField(1) final int? typeTx,
      @HiveField(4) final int? timestamp,
      @HiveField(5) final double? fee,
      @HiveField(6) final String? from,
      @HiveField(9) final String? content,
      @HiveField(10) final String? type,
      @HiveField(12)
      @Deprecated('Thanks to hive, we should keep this unused property...')
      final Contact? contactInformation,
      @HiveField(14) final List<String>? decryptedSecret,
      @HiveField(15) final String? action,
      @HiveField(16)
      final List<
              ({
                double? amount,
                String? to,
                TokenInformation? tokenInformation,
                String? type
              })>?
          ledgerOperationMvtInfo,
      final List<Ownership>? ownerships}) = _$RecentTransactionImpl;
  _RecentTransaction._() : super._();

  /// Address of transaction
  @override
  @HiveField(0)
  String? get address;

  /// Type of transaction : 1=Transfer/Input, 2=Transfer/Output, 3=Token creation
  @override
  @HiveField(1)
  int? get typeTx;

  /// Amount: asset amount
//@HiveField(2) double? amount,
  /// Recipients: For non asset transfers, the list of recipients
  /// of the transaction (e.g Smart contract interactions)
//@HiveField(3) String? recipient,
  /// Timestamp: Date time when the transaction was generated
  @override
  @HiveField(4)
  int? get timestamp;

  /// Fee: transaction fee (distributed over the node rewards)
  @override
  @HiveField(5)
  double? get fee;

  /// From: transaction which send the amount of assets
  @override
  @HiveField(6)
  String? get from;

  /// Content: free zone for data hosting (string or hexadecimal)
  @override
  @HiveField(9)
  String? get content;

  /// Type: UCO/tokens/Call
  @override
  @HiveField(10)
  String? get type;

  /// Token Information
//@HiveField(11) TokenInformation? tokenInformation,
  /// Contact Information
  @override
  @HiveField(12)
  @Deprecated('Thanks to hive, we should keep this unused property...')
  Contact? get contactInformation;

  /// Decrypted Secret
  @override
  @HiveField(14)
  List<String>? get decryptedSecret;

  /// Action
  @override
  @HiveField(15)
  String? get action;

  /// Ledger operations movements
  @override
  @HiveField(16)
  List<
      ({
        double? amount,
        String? to,
        TokenInformation? tokenInformation,
        String? type
      })>? get ledgerOperationMvtInfo;
  @override
  List<Ownership>? get ownerships;

  /// Create a copy of RecentTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentTransactionImplCopyWith<_$RecentTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
