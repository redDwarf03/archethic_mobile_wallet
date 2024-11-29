import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/service/app_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_service.g.dart';

@riverpod
AppService appService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AppService(apiService: apiService);
}
