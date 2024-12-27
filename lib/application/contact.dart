/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/account/account_notifier.dart';
import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/infrastructure/repositories/contact.repository.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact.g.dart';

@riverpod
ContactRepositoryImpl contactRepository(Ref ref) => ContactRepositoryImpl();

@riverpod
Future<List<Contact>> fetchContacts(
  Ref ref, {
  String search = '',
}) async {
  if (search.isEmpty) {
    return ref.watch(contactRepositoryProvider).getAllContacts();
  }
  final searchedContacts =
      await ref.watch(contactRepositoryProvider).searchContacts(search: search);
  return searchedContacts;
}

@riverpod
Future<Contact?> getSelectedContact(Ref ref) async {
  final selectedAccount =
      await ref.watch(accountsNotifierProvider.future).selectedAccount;
  if (selectedAccount == null) {
    return null;
  }

  return ref.watch(
    getContactWithNameProvider(
      selectedAccount.nameDisplayed,
    ).future,
  );
}

@riverpod
Future<Contact?> getContactWithName(
  Ref ref,
  String contactName,
) async {
  final searchedContact = await ref
      .watch(
        contactRepositoryProvider,
      )
      .getContactWithName(contactName);
  return searchedContact;
}

@riverpod
Future<Contact?> getContactWithAddress(
  Ref ref,
  String address,
) async {
  final searchedContact =
      await ref.watch(contactRepositoryProvider).getContactWithAddress(
            address,
            ref.watch(apiServiceProvider),
          );
  return searchedContact;
}

@riverpod
Future<void> contactProviderReset(
  Ref ref,
) async {
  await ref.read(contactRepositoryProvider).clear();
  ref
    ..invalidate(fetchContactsProvider)
    ..invalidate(getContactWithAddressProvider);
}
