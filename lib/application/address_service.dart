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
