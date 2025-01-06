import 'package:aewallet/application/dapps/my_dapps.dart';
import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/repositories/dapps/my_dapps.repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_dapp_notifier.g.dart';

@riverpod
class MyDAppNotifier extends _$MyDAppNotifier {
  @override
  FutureOr<DApp?> build(String url) async {
    return await MyDAppsRepositoryImpl().getMyDApp(url);
  }

  Future<void> addMyDApp(
    DApp myDApp,
  ) async {
    if (Uri.tryParse(myDApp.url) == null) throw Exception();
    await ref.read(myDAppsRepositoryProvider).addMyDApp(myDApp);
    return;
  }

  Future<void> removeMyDApp() async {
    if (Uri.tryParse(url) == null) throw Exception();
    await ref.read(myDAppsRepositoryProvider).removeMyDApp(url);
    return;
  }
}
