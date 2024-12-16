import 'dart:async';

import 'package:aewallet/application/session/session.dart';
import 'package:aewallet/domain/repositories/settings.dart';
import 'package:aewallet/domain/rpc/command_dispatcher.dart';
import 'package:aewallet/infrastructure/rpc/browser_extension_aws.dart';
import 'package:aewallet/infrastructure/rpc/websocket_server.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/add_service/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/decrypt_payload/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/encrypt_payload/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/get_accounts/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/get_current_account/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/get_endpoint/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/get_services_from_keychain/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/keychain_derive_address/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/keychain_derive_keypair/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/refresh_current_account/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/remove_service/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/send_transaction/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/sign_payload/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/sign_transactions/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/sub_account/command_handler.dart';
import 'package:aewallet/ui/views/rpc_command_receiver/sub_current_account/command_handler.dart';
import 'package:aewallet/util/get_it_instance.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

class RPCCommandReceiver extends ConsumerStatefulWidget {
  const RPCCommandReceiver({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RPCCommandReceiverState();
}

class _RPCCommandReceiverState extends ConsumerState<RPCCommandReceiver> {
  final _browserExtensionAWS =
      BrowserExtensionAWS.isPlatformCompatible ? BrowserExtensionAWS() : null;
  static final logger = Logger('RPCCommandReceiver');
  @override
  void initState() {
    _initCommandDispatcher();
    _initWebsocketRPC();
    _initBrowserExtensionRPC();
    super.initState();
  }

  void _initCommandDispatcher() {
    logger.info('Init RPC Command dispatcher');
    sl.get<CommandDispatcher>()
      ..clear()
      ..addGuard((command) async {
        if (ref.read(sessionNotifierProvider).isLoggedOut) {
          return awc.Failure.connectivity;
        }
        return null;
      })
      ..addHandler(
        SendTransactionHandler(context: context, ref: ref),
      )
      ..addHandler(
        GetEndpointHandler(),
      )
      ..addHandler(
        RefreshCurrentAccountHandler(ref: ref),
      )
      ..addHandler(
        GetCurrentAccountCommandHandler(ref: ref),
      )
      ..addHandler(
        GetAccountsCommandHandler(),
      )
      ..addHandler(
        SubscribeAccountHandler(ref: ref),
      )
      ..addHandler(
        SubscribeCurrentAccountHandler(ref: ref),
      )
      ..addHandler(
        AddServiceHandler(context: context, ref: ref),
      )
      ..addHandler(
        RemoveServiceHandler(context: context, ref: ref),
      )
      ..addHandler(
        GetServicesFromKeychainCommandHandler(ref: ref),
      )
      ..addHandler(
        KeychainDeriveKeypairCommandHandler(ref: ref),
      )
      ..addHandler(
        KeychainDeriveAddressCommandHandler(ref: ref),
      )
      ..addHandler(
        SignTransactionsCommandHandler(context: context, ref: ref),
      )
      ..addHandler(
        SignPayloadsCommandHandler(context: context, ref: ref),
      )
      ..addHandler(
        EncryptPayloadsCommandHandler(ref: ref),
      )
      ..addHandler(
        DecryptPayloadsCommandHandler(context: context, ref: ref),
      );
  }

  Future<void> _initWebsocketRPC() async {
    logger.info('Init websocket RPC');
    final isRpcEnabled = (await sl
            .get<SettingsRepositoryInterface>()
            .getSettings(const Locale('fr')))
        .activeRPCServer;
    final rpcWebsocketServer = sl.get<ArchethicWebsocketRPCServer>();
    if (isRpcEnabled && ArchethicWebsocketRPCServer.isPlatformCompatible) {
      unawaited(rpcWebsocketServer.run());
    }
  }

  void _initBrowserExtensionRPC() {
    logger.info('Init Browser extension RPC');
    unawaited(_browserExtensionAWS?.run());
  }

  @override
  void dispose() {
    super.dispose();
    _disposeWebsocketRPC();
    _disposeBrowserExtensionRPC();
    _disposeCommandDispatcher();
  }

  Future<void> _disposeWebsocketRPC() async {
    logger.info('Dispose websocket RPC');
    await sl.get<ArchethicWebsocketRPCServer>().stop();
  }

  Future<void> _disposeBrowserExtensionRPC() async {
    logger.info('Dispose Browser extension RPC');
    await _browserExtensionAWS?.stop();
  }

  void _disposeCommandDispatcher() {
    logger.info('Dispose RPC command dispatcher');
    sl.get<CommandDispatcher>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
