import 'package:aewallet/model/data/contact.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

abstract class ContactRepositoryInterface {
  Future<List<Contact>> getAllContacts();

  Future<List<Contact>> searchContacts({required String search});

  Future<Contact?> getContactWithName(String contactName);

  Future<Contact?> getContactWithAddress(
    String address,
    ApiService apiService,
  );

  Future<void> clear();
}
