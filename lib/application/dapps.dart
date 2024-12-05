import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/repositories/dapps_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps.g.dart';

@riverpod
DAppsRepositoryImpl dAppsRepository(
  Ref ref,
) =>
    DAppsRepositoryImpl();

@riverpod
Future<DApp?> getDApp(
  Ref ref,
  String code,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final networkSettings = ref.watch(
    SettingsProviders.settings.select((settings) => settings.network),
  );
  return ref
      .watch(dAppsRepositoryProvider)
      .getDApp(networkSettings.network, code, apiService);
}

@riverpod
Future<List<DApp>> getDAppsFromNetwork(
  Ref ref,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final networkSettings = ref.watch(
    SettingsProviders.settings.select((settings) => settings.network),
  );
  final dAppsFromNetwork = await ref
      .read(dAppsRepositoryProvider)
      .getDAppsFromNetwork(networkSettings.network, apiService);
  return dAppsFromNetwork;
}
