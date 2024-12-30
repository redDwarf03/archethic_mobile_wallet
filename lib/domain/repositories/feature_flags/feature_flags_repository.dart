import 'package:aewallet/domain/models/feature_flags.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

abstract class FeatureFlagsRepositoryInterface {
  Future<bool> getFeatureFlag(
    aedappfm.Environment environment,
    ApiService apiService,
    String applicationCode,
    String featureCode,
    String platform,
  );

  Future<List<FeatureFlags>> getFeatureFlagsFromNetwork(
    aedappfm.Environment environment,
    ApiService apiService,
  );
}
