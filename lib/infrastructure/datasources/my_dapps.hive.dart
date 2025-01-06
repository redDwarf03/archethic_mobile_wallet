import 'package:aewallet/infrastructure/datasources/dapp_dto.hive.dart';
import 'package:aewallet/infrastructure/datasources/hive.extension.dart';
import 'package:hive/hive.dart';

class MyDAppsHiveDatasource {
  MyDAppsHiveDatasource._(this._box);

  static const String _myDAppsBox = '_myDAppsBox';
  final Box<DAppHiveDto> _box;

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static MyDAppsHiveDatasource? _instance;

  static Future<MyDAppsHiveDatasource> getInstance() async {
    if (_instance?._box.isOpen == true) return _instance!;
    final box = await Hive.openBox<DAppHiveDto>(_myDAppsBox);
    return _instance = MyDAppsHiveDatasource._(box);
  }

  Future<void> setMydApp(DAppHiveDto v) async {
    await _box.put(v.url.toLowerCase(), v);
  }

  DAppHiveDto? getMydApp(String url) {
    return _box.get(url.toLowerCase());
  }

  Future<void> removeMydApp(String url) async {
    await _box.delete(url.toLowerCase());
  }

  List<DAppHiveDto> getMyDApps() {
    return _box.values.toList();
  }

  static Future<void> clear() => Hive.deleteBox<DAppHiveDto>(_myDAppsBox);
}
