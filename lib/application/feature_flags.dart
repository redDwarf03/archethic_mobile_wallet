import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/infrastructure/repositories/feature_flags_repository.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feature_flags.g.dart';

@riverpod
FeatureFlagsRepositoryImpl _featureFlagsRepository(
  Ref ref,
) =>
    FeatureFlagsRepositoryImpl();

@riverpod
Future<bool?> getFeatureFlag(
  Ref ref,
  String applicationCode,
  String featureCode,
) async {
  final apiService = ref.watch(apiServiceProvider);
  final networkSettings = ref.watch(
    SettingsProviders.settings.select((settings) => settings.network),
  );
  return ref.watch(_featureFlagsRepositoryProvider).getFeatureFlag(
        networkSettings.network,
        apiService,
        applicationCode,
        featureCode,
        UniversalPlatform.value.name.toLowerCase(),
      );
}
