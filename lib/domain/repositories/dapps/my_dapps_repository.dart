import 'package:aewallet/domain/models/dapp.dart';

abstract class MyDAppsRepositoryInterface {
  Future<List<DApp>> getMyDApps();

  Future<DApp?> getMyDApp(String url);

  Future<void> addMyDApp(DApp myDApp);

  Future<void> removeMyDApp(String url);
}
