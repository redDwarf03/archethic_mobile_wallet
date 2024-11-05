import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/repositories/dapps_repository.dart';
import 'package:aewallet/model/available_networks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps.g.dart';

@riverpod
DAppsRepositoryImpl _dAppsRepository(
  Ref ref,
) =>
    DAppsRepositoryImpl();

@riverpod
Future<DApp?> _getDApp(
  Ref ref,
  AvailableNetworks network,
  String code,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final networkSettings = ref.watch(
    SettingsProviders.settings.select((settings) => settings.network),
  );
  return ref
      .watch(_dAppsRepositoryProvider)
      .getDApp(networkSettings.network, code, apiService);
}

@riverpod
Future<List<DApp>> _getDAppsFromNetwork(
  Ref ref,
  AvailableNetworks network,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final dAppsFromNetwork = await ref
      .read(_dAppsRepositoryProvider)
      .getDAppsFromNetwork(network, apiService);
  return dAppsFromNetwork;
}

abstract class DAppsProviders {
  static const getDApp = _getDAppProvider;
  static const getDAppsFromNetwork = _getDAppsFromNetworkProvider;
}
