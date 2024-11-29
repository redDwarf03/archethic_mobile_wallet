import 'package:aewallet/domain/models/feature_flags.dart';
import 'package:aewallet/model/available_networks.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';

abstract class FeatureFlagsRepositoryInterface {
  Future<bool> getFeatureFlag(
    AvailableNetworks network,
    ApiService apiService,
    String applicationCode,
    String featureCode,
    String platform,
  );

  Future<List<FeatureFlags>> getFeatureFlagsFromNetwork(
    AvailableNetworks network,
    ApiService apiService,
  );
}
