/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/domain/models/app_version_info.dart';
import 'package:aewallet/infrastructure/repositories/app_version_update_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_version_update_info.g.dart';

@Riverpod(keepAlive: true)
AppVersionInfoRepository _appVersionInfoRepository(
  Ref ref,
) =>
    AppVersionInfoRepository();

@Riverpod(keepAlive: true)
Future<AppVersionInfo> _getAppVersionInfo(
  Ref ref,
) async {
  final appVersionInfo =
      await ref.watch(_appVersionInfoRepositoryProvider).getAppVersionInfo();
  return appVersionInfo;
}

class AppVersionInfoRepository {
  Future<AppVersionInfo> getAppVersionInfo() async {
    return AppVersionUpdateInfo().getAppVersionInfo();
  }
}

abstract class AppVersionInfoProviders {
  static final getAppVersionInfo = _getAppVersionInfoProvider;
}
