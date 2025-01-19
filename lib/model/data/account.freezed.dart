// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Account {
  /// Account name - Primary Key
  @HiveField(0)
  String get name => throw _privateConstructorUsedError;

  /// Genesis Address
  @HiveField(1)
  String get genesisAddress => throw _privateConstructorUsedError;

  /// Last loading of transaction inputs
  @HiveField(2)
  int? get lastLoadingTransactionInputs => throw _privateConstructorUsedError;

  /// Whether this is the currently selected account
  @HiveField(3)
  bool? get selected => throw _privateConstructorUsedError;

  /// Last address
  @HiveField(4)
  @Deprecated(
      'Genesis address should be preferred instead of last address after AEIP21')
  String? get lastAddress => throw _privateConstructorUsedError;

  /// Balance
  @HiveField(5)
  AccountBalance? get balance => throw _privateConstructorUsedError;

  /// Recent transactions
//@HiveField(6) List<RecentTransaction>? recentTransactions,
  /// Tokens
  @HiveField(7)
  List<AccountToken>? get accountTokens => throw _privateConstructorUsedError;

  /// NFT
  @HiveField(8)
  List<AccountToken>? get accountNFT => throw _privateConstructorUsedError;

  /// NFT Info Off Chain
  @Deprecated('Thanks to hive, we should keep this unused property...')
  @HiveField(10)
  List<NftInfosOffChain>? get nftInfosOffChainList =>
      throw _privateConstructorUsedError;

  /// Service Type
  @HiveField(13)
  String? get serviceType => throw _privateConstructorUsedError;

  /// NFT Collections
  @HiveField(14)
  List<AccountToken>? get accountNFTCollections =>
      throw _privateConstructorUsedError;

  /// Custom Token Addresses
  @HiveField(15)
  List<String>? get customTokenAddressList =>
      throw _privateConstructorUsedError;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountCopyWith<Account> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res, Account>;
  @useResult
  $Res call(
      {@HiveField(0) String name,
      @HiveField(1) String genesisAddress,
      @HiveField(2) int? lastLoadingTransactionInputs,
      @HiveField(3) bool? selected,
      @HiveField(4)
      @Deprecated(
          'Genesis address should be preferred instead of last address after AEIP21')
      String? lastAddress,
      @HiveField(5) AccountBalance? balance,
      @HiveField(7) List<AccountToken>? accountTokens,
      @HiveField(8) List<AccountToken>? accountNFT,
      @Deprecated('Thanks to hive, we should keep this unused property...')
      @HiveField(10)
      List<NftInfosOffChain>? nftInfosOffChainList,
      @HiveField(13) String? serviceType,
      @HiveField(14) List<AccountToken>? accountNFTCollections,
      @HiveField(15) List<String>? customTokenAddressList});
}

/// @nodoc
class _$AccountCopyWithImpl<$Res, $Val extends Account>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? genesisAddress = null,
    Object? lastLoadingTransactionInputs = freezed,
    Object? selected = freezed,
    Object? lastAddress = freezed,
    Object? balance = freezed,
    Object? accountTokens = freezed,
    Object? accountNFT = freezed,
    Object? nftInfosOffChainList = freezed,
    Object? serviceType = freezed,
    Object? accountNFTCollections = freezed,
    Object? customTokenAddressList = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
      lastLoadingTransactionInputs: freezed == lastLoadingTransactionInputs
          ? _value.lastLoadingTransactionInputs
          : lastLoadingTransactionInputs // ignore: cast_nullable_to_non_nullable
              as int?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastAddress: freezed == lastAddress
          ? _value.lastAddress
          : lastAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as AccountBalance?,
      accountTokens: freezed == accountTokens
          ? _value.accountTokens
          : accountTokens // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNFT: freezed == accountNFT
          ? _value.accountNFT
          : accountNFT // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      nftInfosOffChainList: freezed == nftInfosOffChainList
          ? _value.nftInfosOffChainList
          : nftInfosOffChainList // ignore: cast_nullable_to_non_nullable
              as List<NftInfosOffChain>?,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNFTCollections: freezed == accountNFTCollections
          ? _value.accountNFTCollections
          : accountNFTCollections // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      customTokenAddressList: freezed == customTokenAddressList
          ? _value.customTokenAddressList
          : customTokenAddressList // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountImplCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$$AccountImplCopyWith(
          _$AccountImpl value, $Res Function(_$AccountImpl) then) =
      __$$AccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String name,
      @HiveField(1) String genesisAddress,
      @HiveField(2) int? lastLoadingTransactionInputs,
      @HiveField(3) bool? selected,
      @HiveField(4)
      @Deprecated(
          'Genesis address should be preferred instead of last address after AEIP21')
      String? lastAddress,
      @HiveField(5) AccountBalance? balance,
      @HiveField(7) List<AccountToken>? accountTokens,
      @HiveField(8) List<AccountToken>? accountNFT,
      @Deprecated('Thanks to hive, we should keep this unused property...')
      @HiveField(10)
      List<NftInfosOffChain>? nftInfosOffChainList,
      @HiveField(13) String? serviceType,
      @HiveField(14) List<AccountToken>? accountNFTCollections,
      @HiveField(15) List<String>? customTokenAddressList});
}

/// @nodoc
class __$$AccountImplCopyWithImpl<$Res>
    extends _$AccountCopyWithImpl<$Res, _$AccountImpl>
    implements _$$AccountImplCopyWith<$Res> {
  __$$AccountImplCopyWithImpl(
      _$AccountImpl _value, $Res Function(_$AccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? genesisAddress = null,
    Object? lastLoadingTransactionInputs = freezed,
    Object? selected = freezed,
    Object? lastAddress = freezed,
    Object? balance = freezed,
    Object? accountTokens = freezed,
    Object? accountNFT = freezed,
    Object? nftInfosOffChainList = freezed,
    Object? serviceType = freezed,
    Object? accountNFTCollections = freezed,
    Object? customTokenAddressList = freezed,
  }) {
    return _then(_$AccountImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
      lastLoadingTransactionInputs: freezed == lastLoadingTransactionInputs
          ? _value.lastLoadingTransactionInputs
          : lastLoadingTransactionInputs // ignore: cast_nullable_to_non_nullable
              as int?,
      selected: freezed == selected
          ? _value.selected
          : selected // ignore: cast_nullable_to_non_nullable
              as bool?,
      lastAddress: freezed == lastAddress
          ? _value.lastAddress
          : lastAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: freezed == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as AccountBalance?,
      accountTokens: freezed == accountTokens
          ? _value._accountTokens
          : accountTokens // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      accountNFT: freezed == accountNFT
          ? _value._accountNFT
          : accountNFT // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      nftInfosOffChainList: freezed == nftInfosOffChainList
          ? _value._nftInfosOffChainList
          : nftInfosOffChainList // ignore: cast_nullable_to_non_nullable
              as List<NftInfosOffChain>?,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNFTCollections: freezed == accountNFTCollections
          ? _value._accountNFTCollections
          : accountNFTCollections // ignore: cast_nullable_to_non_nullable
              as List<AccountToken>?,
      customTokenAddressList: freezed == customTokenAddressList
          ? _value._customTokenAddressList
          : customTokenAddressList // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

@HiveType(typeId: HiveTypeIds.account)
class _$AccountImpl extends _Account {
  _$AccountImpl(
      {@HiveField(0) required this.name,
      @HiveField(1) required this.genesisAddress,
      @HiveField(2) this.lastLoadingTransactionInputs,
      @HiveField(3) this.selected,
      @HiveField(4)
      @Deprecated(
          'Genesis address should be preferred instead of last address after AEIP21')
      this.lastAddress,
      @HiveField(5) this.balance,
      @HiveField(7) final List<AccountToken>? accountTokens,
      @HiveField(8) final List<AccountToken>? accountNFT,
      @Deprecated('Thanks to hive, we should keep this unused property...')
      @HiveField(10)
      final List<NftInfosOffChain>? nftInfosOffChainList,
      @HiveField(13) this.serviceType,
      @HiveField(14) final List<AccountToken>? accountNFTCollections,
      @HiveField(15) final List<String>? customTokenAddressList})
      : _accountTokens = accountTokens,
        _accountNFT = accountNFT,
        _nftInfosOffChainList = nftInfosOffChainList,
        _accountNFTCollections = accountNFTCollections,
        _customTokenAddressList = customTokenAddressList,
        super._();

  /// Account name - Primary Key
  @override
  @HiveField(0)
  final String name;

  /// Genesis Address
  @override
  @HiveField(1)
  final String genesisAddress;

  /// Last loading of transaction inputs
  @override
  @HiveField(2)
  final int? lastLoadingTransactionInputs;

  /// Whether this is the currently selected account
  @override
  @HiveField(3)
  final bool? selected;

  /// Last address
  @override
  @HiveField(4)
  @Deprecated(
      'Genesis address should be preferred instead of last address after AEIP21')
  final String? lastAddress;

  /// Balance
  @override
  @HiveField(5)
  final AccountBalance? balance;

  /// Recent transactions
//@HiveField(6) List<RecentTransaction>? recentTransactions,
  /// Tokens
  final List<AccountToken>? _accountTokens;

  /// Recent transactions
//@HiveField(6) List<RecentTransaction>? recentTransactions,
  /// Tokens
  @override
  @HiveField(7)
  List<AccountToken>? get accountTokens {
    final value = _accountTokens;
    if (value == null) return null;
    if (_accountTokens is EqualUnmodifiableListView) return _accountTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// NFT
  final List<AccountToken>? _accountNFT;

  /// NFT
  @override
  @HiveField(8)
  List<AccountToken>? get accountNFT {
    final value = _accountNFT;
    if (value == null) return null;
    if (_accountNFT is EqualUnmodifiableListView) return _accountNFT;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// NFT Info Off Chain
  final List<NftInfosOffChain>? _nftInfosOffChainList;

  /// NFT Info Off Chain
  @override
  @Deprecated('Thanks to hive, we should keep this unused property...')
  @HiveField(10)
  List<NftInfosOffChain>? get nftInfosOffChainList {
    final value = _nftInfosOffChainList;
    if (value == null) return null;
    if (_nftInfosOffChainList is EqualUnmodifiableListView)
      return _nftInfosOffChainList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Service Type
  @override
  @HiveField(13)
  final String? serviceType;

  /// NFT Collections
  final List<AccountToken>? _accountNFTCollections;

  /// NFT Collections
  @override
  @HiveField(14)
  List<AccountToken>? get accountNFTCollections {
    final value = _accountNFTCollections;
    if (value == null) return null;
    if (_accountNFTCollections is EqualUnmodifiableListView)
      return _accountNFTCollections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Custom Token Addresses
  final List<String>? _customTokenAddressList;

  /// Custom Token Addresses
  @override
  @HiveField(15)
  List<String>? get customTokenAddressList {
    final value = _customTokenAddressList;
    if (value == null) return null;
    if (_customTokenAddressList is EqualUnmodifiableListView)
      return _customTokenAddressList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Account(name: $name, genesisAddress: $genesisAddress, lastLoadingTransactionInputs: $lastLoadingTransactionInputs, selected: $selected, lastAddress: $lastAddress, balance: $balance, accountTokens: $accountTokens, accountNFT: $accountNFT, nftInfosOffChainList: $nftInfosOffChainList, serviceType: $serviceType, accountNFTCollections: $accountNFTCollections, customTokenAddressList: $customTokenAddressList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.genesisAddress, genesisAddress) ||
                other.genesisAddress == genesisAddress) &&
            (identical(other.lastLoadingTransactionInputs,
                    lastLoadingTransactionInputs) ||
                other.lastLoadingTransactionInputs ==
                    lastLoadingTransactionInputs) &&
            (identical(other.selected, selected) ||
                other.selected == selected) &&
            (identical(other.lastAddress, lastAddress) ||
                other.lastAddress == lastAddress) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            const DeepCollectionEquality()
                .equals(other._accountTokens, _accountTokens) &&
            const DeepCollectionEquality()
                .equals(other._accountNFT, _accountNFT) &&
            const DeepCollectionEquality()
                .equals(other._nftInfosOffChainList, _nftInfosOffChainList) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            const DeepCollectionEquality()
                .equals(other._accountNFTCollections, _accountNFTCollections) &&
            const DeepCollectionEquality().equals(
                other._customTokenAddressList, _customTokenAddressList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      genesisAddress,
      lastLoadingTransactionInputs,
      selected,
      lastAddress,
      balance,
      const DeepCollectionEquality().hash(_accountTokens),
      const DeepCollectionEquality().hash(_accountNFT),
      const DeepCollectionEquality().hash(_nftInfosOffChainList),
      serviceType,
      const DeepCollectionEquality().hash(_accountNFTCollections),
      const DeepCollectionEquality().hash(_customTokenAddressList));

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      __$$AccountImplCopyWithImpl<_$AccountImpl>(this, _$identity);
}

abstract class _Account extends Account {
  factory _Account(
      {@HiveField(0) required final String name,
      @HiveField(1) required final String genesisAddress,
      @HiveField(2) final int? lastLoadingTransactionInputs,
      @HiveField(3) final bool? selected,
      @HiveField(4)
      @Deprecated(
          'Genesis address should be preferred instead of last address after AEIP21')
      final String? lastAddress,
      @HiveField(5) final AccountBalance? balance,
      @HiveField(7) final List<AccountToken>? accountTokens,
      @HiveField(8) final List<AccountToken>? accountNFT,
      @Deprecated('Thanks to hive, we should keep this unused property...')
      @HiveField(10)
      final List<NftInfosOffChain>? nftInfosOffChainList,
      @HiveField(13) final String? serviceType,
      @HiveField(14) final List<AccountToken>? accountNFTCollections,
      @HiveField(15)
      final List<String>? customTokenAddressList}) = _$AccountImpl;
  _Account._() : super._();

  /// Account name - Primary Key
  @override
  @HiveField(0)
  String get name;

  /// Genesis Address
  @override
  @HiveField(1)
  String get genesisAddress;

  /// Last loading of transaction inputs
  @override
  @HiveField(2)
  int? get lastLoadingTransactionInputs;

  /// Whether this is the currently selected account
  @override
  @HiveField(3)
  bool? get selected;

  /// Last address
  @override
  @HiveField(4)
  @Deprecated(
      'Genesis address should be preferred instead of last address after AEIP21')
  String? get lastAddress;

  /// Balance
  @override
  @HiveField(5)
  AccountBalance? get balance;

  /// Recent transactions
//@HiveField(6) List<RecentTransaction>? recentTransactions,
  /// Tokens
  @override
  @HiveField(7)
  List<AccountToken>? get accountTokens;

  /// NFT
  @override
  @HiveField(8)
  List<AccountToken>? get accountNFT;

  /// NFT Info Off Chain
  @override
  @Deprecated('Thanks to hive, we should keep this unused property...')
  @HiveField(10)
  List<NftInfosOffChain>? get nftInfosOffChainList;

  /// Service Type
  @override
  @HiveField(13)
  String? get serviceType;

  /// NFT Collections
  @override
  @HiveField(14)
  List<AccountToken>? get accountNFTCollections;

  /// Custom Token Addresses
  @override
  @HiveField(15)
  List<String>? get customTokenAddressList;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountImplCopyWith<_$AccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
