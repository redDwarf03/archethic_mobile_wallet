import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/repositories/dapps_repository.dart';
import 'package:aewallet/model/available_networks.dart';
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
  AvailableNetworks network,
  String code,
) async {
  final apiService = ref.watch(apiServiceProvider);
  return ref.watch(dAppsRepositoryProvider).getDApp(network, code, apiService);
}

@riverpod
Future<List<DApp>> getDAppsFromNetwork(
  Ref ref,
  AvailableNetworks network,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final dAppsFromNetwork = await ref
      .read(dAppsRepositoryProvider)
      .getDAppsFromNetwork(network, apiService);
  return dAppsFromNetwork;
}
