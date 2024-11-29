/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/application/account/providers.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/infrastructure/datasources/contacts.hive.dart';
import 'package:aewallet/model/data/account_balance.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:aewallet/service/app_service.dart';
import 'package:aewallet/ui/util/contact_formatters.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact.g.dart';

@riverpod
ContactRepository _contactRepository(Ref ref) => ContactRepository();

@riverpod
Future<List<Contact>> _fetchContacts(
  Ref ref, {
  String search = '',
}) async {
  if (search.isEmpty) {
    return ref.watch(_contactRepositoryProvider).getAllContacts();
  }
  final searchedContacts = await ref
      .watch(_contactRepositoryProvider)
      .searchContacts(search: search);
  return searchedContacts;
}

@riverpod
Future<Contact?> _getSelectedContact(Ref ref) async {
  final selectedAccount =
      await ref.watch(AccountProviders.accounts.future).selectedAccount;
  if (selectedAccount == null) {
    return null;
  }

  return ref.watch(
    _getContactWithNameProvider(
      selectedAccount.nameDisplayed,
    ).future,
  );
}

@riverpod
Future<Contact?> _getContactWithName(
  Ref ref,
  String contactName,
) async {
  final searchedContact = await ref
      .watch(
        _contactRepositoryProvider,
      )
      .getContactWithName(contactName);
  return searchedContact;
}

@riverpod
Future<Contact?> _getContactWithAddress(
  Ref ref,
  String address,
) async {
  final searchedContact =
      await ref.watch(_contactRepositoryProvider).getContactWithAddress(
            address,
            ref.watch(apiServiceProvider),
          );
  return searchedContact;
}

@riverpod
Future<Contact?> _getContactWithPublicKey(
  Ref ref,
  String publicKey,
) async {
  try {
    final searchedContact =
        await ref.watch(_contactRepositoryProvider).getContactWithPublicKey(
              publicKey,
              ref.watch(apiServiceProvider),
            );
    return searchedContact;
  } catch (e) {
    return null;
  }
}

@riverpod
Future<Contact?> _getContactWithGenesisPublicKey(
  Ref ref,
  String genesisPublicKey,
) async {
  try {
    final searchedContact = await ref
        .watch(_contactRepositoryProvider)
        .getContactWithGenesisPublicKey(genesisPublicKey);
    return searchedContact;
  } catch (e) {
    return null;
  }
}

@riverpod
Future<void> _saveContact(
  Ref ref, {
  Contact? contact,
}) async {
  if (contact == null) {
    throw Exception('Contact is null');
  }
  await ref.watch(_contactRepositoryProvider).saveContact(contact);
  ref.invalidate(_contactRepositoryProvider);
}

@riverpod
Future<void> _deleteContact(
  Ref ref, {
  Contact? contact,
}) async {
  if (contact == null) {
    throw Exception('Contact is null');
  }
  await ref.watch(_contactRepositoryProvider).deleteContact(contact);
  ref.invalidate(_contactRepositoryProvider);
}

@riverpod
Future<bool> _isContactExistsWithName(
  Ref ref, {
  String? contactName,
}) async {
  if (contactName == null) {
    throw Exception('Name is null');
  }
  return ref
      .watch(_contactRepositoryProvider)
      .isContactExistsWithName(contactName);
}

@riverpod
Future<bool> _isContactExistsWithAddress(
  Ref ref, {
  String? address,
}) async {
  if (address == null) {
    throw Exception('Address is null');
  }
  return ref.watch(_contactRepositoryProvider).isContactExistsWithAddress(
        address,
        ref.watch(apiServiceProvider),
      );
}

@riverpod
Future<AccountBalance> _getBalance(
  Ref ref, {
  String? address,
}) async {
  if (address == null) {
    throw Exception('Address is null');
  }
  final appService = ref.watch(appServiceProvider);
  return ref.watch(_contactRepositoryProvider).getBalance(
        address,
        appService,
      );
}

class ContactRepository {
  final hiveDatasource = ContactsHiveDatasource.instance();

  Future<List<Contact>> getAllContacts() async {
    return hiveDatasource.getContacts();
  }

  Future<List<Contact>> searchContacts({required String search}) async {
    final contacts = await hiveDatasource.getContacts();
    return contacts
        .where(
          (contact) =>
              contact.format.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
  }

  Future<AccountBalance> getBalance(
    String addressContact,
    AppService appService,
  ) async {
    final balanceGetResponseMap =
        await appService.getBalanceGetResponse([addressContact]);

    if (balanceGetResponseMap[addressContact] == null) {
      return AccountBalance(
        nativeTokenName: AccountBalance.cryptoCurrencyLabel,
        nativeTokenValue: 0,
      );
    }
    final balanceGetResponse = balanceGetResponseMap[addressContact]!;
    final accountBalance = AccountBalance(
      nativeTokenName: AccountBalance.cryptoCurrencyLabel,
      nativeTokenValue: fromBigInt(balanceGetResponse.uco).toDouble(),
    );

    if (balanceGetResponse.uco > 0) {
      accountBalance.tokensFungiblesNb++;
    }
    for (final token in balanceGetResponse.token) {
      if (token.tokenId != null) {
        if (token.tokenId == 0) {
          accountBalance.tokensFungiblesNb++;
        } else {
          accountBalance.nftNb++;
        }
      }
    }
    return accountBalance;
  }

  Future<void> saveContact(Contact newContact) async {
    await hiveDatasource.saveContact(newContact);
  }

  Future<void> deleteContact(Contact newContact) async {
    await hiveDatasource.deleteContact(newContact);
  }

  Future<bool> isContactExistsWithName(String contactName) async {
    return hiveDatasource.contactExistsWithName(contactName);
  }

  Future<Contact?> getContactWithName(String contactName) async {
    return hiveDatasource.getContactWithName(contactName);
  }

  Future<Contact?> getContactWithAddress(
    String address,
    ApiService apiService,
  ) async {
    return hiveDatasource.getContactWithAddress(address, apiService);
  }

  Future<bool> isContactExistsWithAddress(
    String address,
    ApiService apiService,
  ) async {
    return hiveDatasource.contactExistsWithAddress(address, apiService);
  }

  Future<Contact> getContactWithPublicKey(
    String publicKey,
    ApiService apiService,
  ) async {
    return hiveDatasource.getContactWithPublicKey(publicKey, apiService);
  }

  Future<Contact> getContactWithGenesisPublicKey(
    String genesisPublicKey,
  ) async {
    return hiveDatasource.getContactWithGenesisPublicKey(genesisPublicKey);
  }

  Future<void> clear() async {
    await hiveDatasource.clearContacts();
  }
}

abstract class ContactProviders {
  static const fetchContacts = _fetchContactsProvider;
  static const isContactExistsWithName = _isContactExistsWithNameProvider;
  static const isContactExistsWithAddress = _isContactExistsWithAddressProvider;
  static const saveContact = _saveContactProvider;
  static const deleteContact = _deleteContactProvider;
  static const getContactWithName = _getContactWithNameProvider;
  static const getContactWithAddress = _getContactWithAddressProvider;
  static const getContactWithPublicKey = _getContactWithPublicKeyProvider;
  static const getContactWithGenesisPublicKey =
      _getContactWithGenesisPublicKeyProvider;
  static final getSelectedContact = _getSelectedContactProvider;
  static const getBalance = _getBalanceProvider;

  static Future<void> reset(Ref ref) async {
    await ref.read(_contactRepositoryProvider).clear();
    ref
      ..invalidate(fetchContacts)
      ..invalidate(isContactExistsWithName)
      ..invalidate(isContactExistsWithAddress)
      ..invalidate(getContactWithName)
      ..invalidate(getContactWithAddress)
      ..invalidate(getContactWithPublicKey)
      ..invalidate(getContactWithGenesisPublicKey)
      ..invalidate(getBalance);
  }
}
