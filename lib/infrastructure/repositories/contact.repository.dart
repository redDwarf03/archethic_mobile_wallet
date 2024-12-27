import 'package:aewallet/domain/repositories/contact.repository.dart';
import 'package:aewallet/infrastructure/datasources/contacts.hive.dart';
import 'package:aewallet/model/data/contact.dart';
import 'package:aewallet/ui/util/contact_formatters.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

class ContactRepositoryImpl implements ContactRepositoryInterface {
  final hiveDatasource = ContactsHiveDatasource.instance();

  @override
  Future<List<Contact>> getAllContacts() async {
    return hiveDatasource.getContacts();
  }

  @override
  Future<List<Contact>> searchContacts({required String search}) async {
    final contacts = await hiveDatasource.getContacts();
    return contacts
        .where(
          (contact) =>
              contact.format.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<Contact?> getContactWithName(String contactName) async {
    return hiveDatasource.getContactWithName(contactName);
  }

  @override
  Future<Contact?> getContactWithAddress(
    String address,
    ApiService apiService,
  ) async {
    return hiveDatasource.getContactWithAddress(address, apiService);
  }

  @override
  Future<void> clear() async {
    await hiveDatasource.clearContacts();
  }
}
