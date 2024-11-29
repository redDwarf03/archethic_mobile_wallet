import 'package:aewallet/application/address_service.dart';
import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/application/app_service.dart';
import 'package:aewallet/application/settings/settings.dart';
import 'package:aewallet/infrastructure/repositories/transaction/archethic_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_repository.g.dart';

@riverpod
ArchethicTransactionRepository archethicTransactionRepository(
  Ref ref,
) {
  final networkSettings = ref.watch(
    SettingsProviders.settings.select((settings) => settings.network),
  );
  final appService = ref.watch(appServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  final addressService = ref.watch(addressServiceProvider);
  return ArchethicTransactionRepository(
    phoenixHttpEndpoint: networkSettings.getPhoenixHttpLink(),
    websocketEndpoint: networkSettings.getWebsocketUri(),
    apiService: apiService,
    appService: appService,
    addressService: addressService,
  );
}
