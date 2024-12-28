// ignore_for_file: file_names

part of 'migration_manager.dart';

/// Destroy contact hive
final migration_603 = LocalDataMigration(
  minAppVersion: 605,
  run: (ref) async {
    final logger = Logger('DestroyHives');

    const boxNameContacts = 'contacts';
    try {
      await Hive.deleteBoxFromDisk(boxNameContacts);
      logger.info('$boxNameContacts deleted');
    } catch (e) {
      logger.severe("$boxNameContacts can't be deleted");
    }

    const boxNamePrice = 'price';
    try {
      await Hive.deleteBoxFromDisk(boxNamePrice);
      logger.info('$boxNamePrice deleted');
    } catch (e) {
      logger.severe("$boxNamePrice can't be deleted");
    }
  },
);
