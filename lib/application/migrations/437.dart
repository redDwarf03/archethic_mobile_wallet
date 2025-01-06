// ignore_for_file: file_names

part of 'migration_manager.dart';

final migration_437 = LocalDataMigration(
  minAppVersion: 437,
  run: (ref) async {
    final logger = Logger('DataMigration - 437');
    // We need to reload keychain because of account's name structure change
    // https://github.com/archethic-foundation/archethic-wallet/pull/759
    if (ref.read(sessionNotifierProvider).isLoggedOut) {
      logger.info(
        'Skipping migration 437 process : user logged out.',
      );
      return;
    }
    await ref.read(sessionNotifierProvider.notifier).refresh();
    final selectedAccount =
        await ref.read(accountsNotifierProvider.future).selectedAccount;
    if (selectedAccount != null) {
      await (await ref
              .read(accountsNotifierProvider.notifier)
              .selectedAccountNotifier)
          ?.refreshAll();
    }
  },
);
