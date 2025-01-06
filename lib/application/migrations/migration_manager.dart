import 'dart:convert';
import 'dart:typed_data';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/infrastructure/datasources/preferences.hive.dart';
import 'package:aewallet/util/string_encryption.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '437.dart';
part '526.dart';
part '540.dart';
part '541.dart';
part '603.dart';
part 'migration_manager.freezed.dart';
part 'migration_manager.g.dart';

@freezed
class LocalDataMigrationState with _$LocalDataMigrationState {
  const factory LocalDataMigrationState({
    @Default(false) bool migrationInProgress,
  }) = _LocalDataMigrationState;
  const LocalDataMigrationState._();
}

final _localDataMigrationProvider = NotifierProvider.autoDispose<
    LocalDataMigrationNotifier, LocalDataMigrationState>(
  () {
    return LocalDataMigrationNotifier();
  },
);

class LocalDataMigrationNotifier
    extends AutoDisposeNotifier<LocalDataMigrationState> {
  LocalDataMigrationNotifier();

  static final _logger = Logger('DataMigration');

  @override
  LocalDataMigrationState build() {
    return const LocalDataMigrationState();
  }

  void _setMigrationInProgress(bool migrationInProgress) {
    state = state.copyWith(migrationInProgress: migrationInProgress);
  }

  Future<void> migrateLocalData() async {
    final preferences = await PreferencesHiveDatasource.getInstance();
    final currentDataVersion = await preferences.getCurrentDataVersion();

    if (currentDataVersion == null) {
      _logger.info('Application freshly installed. No migration to run');
      await _updateCurrentDataVersion();
      return;
    }

    _logger.info('Current data version: $currentDataVersion');

    final migrations = ref.read(_migrationsProvider)
      ..sort(
        (a, b) => a.minAppVersion.compareTo(b.minAppVersion),
      );

    for (final migration in migrations) {
      if (migration.shouldSkip(currentDataVersion)) {
        _logger.info(
          'Skipping migration from version ${migration.minAppVersion}',
        );
        continue;
      }

      _logger.info(
        'Running migration from version ${migration.minAppVersion}',
      );

      _setMigrationInProgress(true);

      await migration.run(ref);

      _setMigrationInProgress(false);
    }

    _logger.info('Migrations successfully executed');
    await _updateCurrentDataVersion();
  }

  Future<void> _updateCurrentDataVersion() async {
    final preferences = await PreferencesHiveDatasource.getInstance();

    final currentAppVersion =
        await CurrentVersionRepository().getCurrentAppVersion();
    final currentAppBuildNumber = int.tryParse(currentAppVersion.$2);
    if (currentAppBuildNumber == null) {
      _logger.info(
        'Failed to update current data version : Unable to determine application build number ($currentAppVersion).',
      );
      return;
    }
    await preferences.setCurrentDataVersion(currentAppBuildNumber);
    _logger.info(
      'Current data version updated to $currentAppBuildNumber.',
    );
  }
}

class LocalDataMigration {
  LocalDataMigration({
    required this.minAppVersion,
    required this.run,
  });

  final int minAppVersion;

  final Future<void> Function(Ref ref) run;

  bool shouldRun(int currentDataVersion) {
    return currentDataVersion < minAppVersion;
  }

  bool shouldSkip(int currentDataVersion) {
    return !shouldRun(currentDataVersion);
  }
}

@riverpod
List<LocalDataMigration> _migrations(Ref ref) => [
      migration_437,
      migration_526,
      migration_540,
      migration_541,
      migration_603,
    ];

class CurrentVersionRepository {
  Future<(String, String)> getCurrentAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return (packageInfo.version, packageInfo.buildNumber);
  }
}

abstract class LocalDataMigrationProviders {
  static final localDataMigration = _localDataMigrationProvider;
}
