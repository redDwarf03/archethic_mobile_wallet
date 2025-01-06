import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/domain/repositories/dapps/my_dapps_repository.dart';
import 'package:aewallet/infrastructure/datasources/dapp_dto.hive.dart';
import 'package:aewallet/infrastructure/datasources/my_dapps.hive.dart';

class MyDAppsRepositoryImpl implements MyDAppsRepositoryInterface {
  @override
  Future<List<DApp>> getMyDApps() async {
    final myDApps = <DApp>[];

    final myDAppsHiveDatasource = await MyDAppsHiveDatasource.getInstance();
    final myDAppsDTO = myDAppsHiveDatasource.getMyDApps();

    for (final myDAppDTO in myDAppsDTO) {
      myDApps.add(myDAppDTO.toModel());
    }

    return myDApps;
  }

  @override
  Future<DApp?> getMyDApp(String url) async {
    final myDAppsHiveDatasource = await MyDAppsHiveDatasource.getInstance();
    return myDAppsHiveDatasource.getMydApp(url)?.toModel();
  }

  @override
  Future<void> addMyDApp(DApp myDApp) async {
    final myDAppsHiveDatasource = await MyDAppsHiveDatasource.getInstance();
    return myDAppsHiveDatasource.setMydApp(myDApp.toHive());
  }

  @override
  Future<void> removeMyDApp(String url) async {
    final myDAppsHiveDatasource = await MyDAppsHiveDatasource.getInstance();
    return myDAppsHiveDatasource.removeMydApp(url);
  }
}
