import 'dart:async';

import 'package:aewallet/infrastructure/rpc/add_service/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/decrypt_payloads/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/dto/rpc_command_handler.dart';
import 'package:aewallet/infrastructure/rpc/encrypt_payloads/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/get_accounts/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/get_current_account/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/get_endpoint/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/get_services_from_keychain/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/keychain_derive_address/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/keychain_derive_keypair/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/refresh_current_account/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/remove_service/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/send_transaction/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/sign_payloads/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/sign_transactions/command_handler.dart';
import 'package:deeplink_rpc/deeplink_rpc.dart';
import 'package:logging/logging.dart';

class ArchethicDeeplinkRPCServer extends DeeplinkRpcRequestReceiver {
  ArchethicDeeplinkRPCServer() {
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('send_transaction'),
        handle: (request) => _handle(
          RPCSendTransactionCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('get_endpoint'),
        handle: (request) => _handle(
          RPCGetEndpointCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('refresh_current_account'),
        handle: (request) => _handle(
          RPCRefreshCurrentAccountCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('get_current_account'),
        handle: (request) => _handle(
          RPCGetCurrentAccountCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('get_accounts'),
        handle: (request) => _handle(
          RPCGetAccountsCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('add_service'),
        handle: (request) => _handle(
          RPCAddServiceCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('remove_service'),
        handle: (request) => _handle(
          RPCRemoveServiceCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('get_services_from_keychain'),
        handle: (request) => _handle(
          RPCGetServicesFromKeychainCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('keychain_derive_keypair'),
        handle: (request) => _handle(
          RPCKeychainDeriveKeypairCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('keychain_derive_address'),
        handle: (request) => _handle(
          RPCKeychainDeriveAddressCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('sign_transactions'),
        handle: (request) => _handle(
          RPCSignTransactionsCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('sign_payload'),
        handle: (request) => _handle(
          RPCSignPayloadsCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('encrypt_payloads'),
        handle: (request) => _handle(
          RPCEncryptPayloadsCommandHandler(),
          request,
        ),
      ),
    );
    registerHandler(
      DeeplinkRpcRequestHandler(
        route: const DeeplinkRpcRoute('decrypt_payloads'),
        handle: (request) => _handle(
          RPCDecryptPayloadsCommandHandler(),
          request,
        ),
      ),
    );
  }

  static Future<Map<String, dynamic>> _handle(
    RPCCommandHandler commandHandler,
    DeeplinkRpcRequest request,
  ) async {
    final _logger = Logger('DeeplinkRpcHandler');

    final result = await commandHandler.handle(request.params);

    return result.map(
      success: commandHandler.resultFromModel,
      failure: (failure) {
        _logger.severe(
          'Command failed',
          failure,
        );

        throw DeeplinkRpcFailure(
          code: failure.code,
          message: failure.message,
        );
      },
    );
  }
}
