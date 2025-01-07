import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/repositories/dapps/dapps_repository.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
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
  final environment = ref.watch(environmentProvider);

  return ref
      .watch(dAppsRepositoryProvider)
      .getDApp(environment, code, apiService);
}

@riverpod
Future<List<DApp>> getDAppsFromNetwork(
  Ref ref,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final environment = ref.watch(environmentProvider);
  final dAppsFromNetwork = await ref
      .read(dAppsRepositoryProvider)
      .getDAppsFromNetwork(environment, apiService);
  return dAppsFromNetwork;
}
