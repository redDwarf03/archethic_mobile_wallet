import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/repositories/dapps/my_dapps.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_dapps.g.dart';

@riverpod
MyDAppsRepositoryImpl myDAppsRepository(
  Ref ref,
) =>
    MyDAppsRepositoryImpl();

@riverpod
Future<List<DApp>> getMyDApps(
  Ref ref,
) async {
  return ref.watch(myDAppsRepositoryProvider).getMyDApps();
}

@riverpod
Future<DApp?> getMyDApp(
  Ref ref,
  String url,
) async {
  if (Uri.tryParse(url) == null) return null;
  return ref.watch(myDAppsRepositoryProvider).getMyDApp(url);
}

@riverpod
Future<void> clearMyDApps(
  Ref ref,
) async {
  await ref.watch(myDAppsRepositoryProvider).clearMyDApps();
}
