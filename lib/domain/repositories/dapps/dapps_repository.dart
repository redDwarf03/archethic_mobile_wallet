/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/domain/models/dapp.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

abstract class DAppsRepositoryInterface {
  Future<List<DApp>> getDAppsFromNetwork(
    aedappfm.Environment environment,
    ApiService apiService,
  );

  Future<DApp?> getDApp(
    aedappfm.Environment environment,
    String code,
    ApiService apiService,
  );
}
