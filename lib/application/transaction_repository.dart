import 'package:aewallet/application/api_service.dart';
import 'package:aewallet/infrastructure/repositories/transaction/archethic_transaction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_repository.g.dart';

@riverpod
ArchethicTransactionRepository archethicTransactionRepository(
  Ref ref,
) {
  final apiService = ref.watch(apiServiceProvider);
  return ArchethicTransactionRepository(
    apiService: apiService,
  );
}
