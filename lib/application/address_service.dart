import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_service.g.dart';

@riverpod
AddressService addressService(Ref ref) {
  final environment = ref.watch(environmentProvider);
  return AddressService(environment.endpoint);
}

@riverpod
Future<String> genesisAddress(Ref ref, String address) async {
  final apiService = ref.watch(apiServiceProvider);
  var genesisAddress = address;
  try {
    genesisAddress =
        (await apiService.getGenesisAddress(address)).address ?? address;
  } catch (e)
  // ignore: empty_catches
  {}

  return genesisAddress;
}
