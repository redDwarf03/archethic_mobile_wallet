import 'package:aewallet/domain/models/dapp.dart';
import 'package:aewallet/infrastructure/datasources/appdb.hive.dart';
import 'package:hive/hive.dart';

part 'dapp_dto.hive.g.dart';

@HiveType(typeId: HiveTypeIds.myDApps)
class DAppHiveDto extends HiveObject {
  DAppHiveDto({
    required this.code,
    required this.url,
    this.category,
    this.description,
    this.name,
    this.iconUrl,
    this.accessToken,
  });

  factory DAppHiveDto.fromModel(DApp dApp) {
    return DAppHiveDto(
      code: dApp.code,
      url: dApp.url,
      category: dApp.category,
      description: dApp.description,
      name: dApp.name,
      iconUrl: dApp.iconUrl,
      accessToken: dApp.accessToken,
    );
  }

  @HiveField(0)
  String code;

  @HiveField(1)
  String url;

  @HiveField(2)
  String? category;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? name;

  @HiveField(5)
  String? iconUrl;

  @HiveField(6)
  String? accessToken;

  DApp toModel() {
    return DApp(
      code: code,
      url: url,
      name: name,
      category: category,
      description: description,
      iconUrl: iconUrl,
      accessToken: accessToken,
    );
  }
}

extension DAppHiveConversionExt on DApp {
  DAppHiveDto toHive() => DAppHiveDto(
        code: code,
        url: url,
        name: name,
        category: category,
        description: description,
        iconUrl: iconUrl,
        accessToken: accessToken,
      );
}
