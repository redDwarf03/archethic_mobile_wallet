import 'dart:convert';

import 'package:aewallet/domain/models/feature_flags.dart';
import 'package:aewallet/domain/repositories/feature_flags/feature_flags_repository.dart';
import 'package:aewallet/model/available_networks.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/services.dart';

class FeatureFlagsRepositoryImpl implements FeatureFlagsRepositoryInterface {
  @override
  Future<bool> getFeatureFlag(
    AvailableNetworks network,
    ApiService apiService,
    String applicationCode,
    String featureCode,
    String platform,
  ) async {
    final featureFlags = await getFeatureFlagsFromNetwork(network, apiService);
    final application = featureFlags.firstWhere(
      (flag) => flag.applicationCode == applicationCode,
      orElse: () => const FeatureFlags(applicationCode: '', features: {}),
    );
    if (application.applicationCode.isEmpty) {
      return false;
    }

    final platformFeatures = application.features[platform];

    if (platformFeatures == null) {
      return false;
    }

    return platformFeatures[featureCode] ?? false;
  }

  Future<List<FeatureFlags>> _getFeatureFlagsLocal() async {
    final featureFlags = <FeatureFlags>[];
    final jsonContent = await rootBundle
        .loadString('lib/domain/repositories/feature_flags/feature_flags.json');

    final Map<String, dynamic> jsonMap = jsonDecode(jsonContent);
    if (jsonMap['applications'] != null) {
      for (final featureFlag in jsonMap['applications'] as List) {
        featureFlags.add(
          FeatureFlags(
            applicationCode: featureFlag['applicationCode'],
            features: (featureFlag['features'] as Map<String, dynamic>).map(
              (platform, features) => MapEntry(
                platform,
                (features as Map<String, dynamic>).map(
                  (key, value) => MapEntry(key, value as bool),
                ),
              ),
            ),
          ),
        );
      }
    }

    return featureFlags;
  }

  @override
  Future<List<FeatureFlags>> getFeatureFlagsFromNetwork(
    AvailableNetworks network,
    ApiService apiService,
  ) async {
    switch (network) {
      case AvailableNetworks.archethicTestNet:
        return _getFeatureFlagsFromBlockchain(
          '000052BA03493517C72F56960F2218873E710689EA5D702CF3BC28E84A8A4F79C78A',
          apiService,
        );
      case AvailableNetworks.archethicMainNet:
        return _getFeatureFlagsFromBlockchain(
          '0000cf5e09b68d4d873e6cade7b4a951ea2eeadc148ce346120dfc96cf5879448d8c',
          apiService,
        );
      case AvailableNetworks.archethicDevNet:
        final featureFlags = await _getFeatureFlagsLocal();
        return featureFlags;
    }
  }

  Future<List<FeatureFlags>> _getFeatureFlagsFromBlockchain(
    String txAddress,
    ApiService apiService,
  ) async {
    final featureFlags = <FeatureFlags>[];

    final lastAddressMap = await apiService
        .getLastTransaction([txAddress], request: 'data { content }');
    if (lastAddressMap[txAddress] != null &&
        lastAddressMap[txAddress]!.data != null &&
        lastAddressMap[txAddress]!.data!.content != null) {
      final Map<String, dynamic> jsonMap =
          jsonDecode(lastAddressMap[txAddress]!.data!.content!);
      if (jsonMap['applications'] != null) {
        for (final featureFlag in jsonMap['applications'] as List) {
          featureFlags.add(
            FeatureFlags(
              applicationCode: featureFlag['applicationCode'],
              features: (featureFlag['features'] as Map<String, dynamic>).map(
                (platform, features) => MapEntry(
                  platform,
                  (features as Map<String, dynamic>).map(
                    (key, value) => MapEntry(key, value as bool),
                  ),
                ),
              ),
            ),
          );
        }
      }
    }
    return featureFlags;
  }
}
