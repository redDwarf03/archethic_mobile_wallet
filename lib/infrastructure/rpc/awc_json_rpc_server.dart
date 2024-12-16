import 'dart:async';
import 'dart:convert';

import 'package:aewallet/domain/rpc/subscription.dart';
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
import 'package:aewallet/infrastructure/rpc/sub_account/command_handler.dart';
import 'package:aewallet/infrastructure/rpc/sub_current_account/command_handler.dart';
import 'package:archethic_wallet_client/archethic_wallet_client.dart' as awc;
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:logging/logging.dart';
import 'package:stream_channel/stream_channel.dart';

class AWCJsonRPCServer {
  AWCJsonRPCServer(this.channel) {
    _peer = SubscribablePeer(Peer(channel.cast<String>()))
      ..registerMethod(
        'sendTransaction',
        (params) => _handle(RPCSendTransactionCommandHandler(), params),
      )
      ..registerMethod(
        'getEndpoint',
        (params) => _handle(RPCGetEndpointCommandHandler(), params),
      )
      ..registerMethod(
        'refreshCurrentAccount',
        (params) => _handle(RPCRefreshCurrentAccountCommandHandler(), params),
      )
      ..registerMethod(
        'getCurrentAccount',
        (params) => _handle(RPCGetCurrentAccountCommandHandler(), params),
      )
      ..registerMethod(
        'getAccounts',
        (params) => _handle(RPCGetAccountsCommandHandler(), params),
      )
      ..registerSubscriptionMethod(
        'subscribeAccount',
        (params) => _handleSubscription(
          RPCSubscribeAccountCommandHandler(),
          params,
        ),
      )
      ..registerUnsubscriptionMethod(
        'unsubscribeAccount',
      )
      ..registerSubscriptionMethod(
        'subscribeCurrentAccount',
        (params) => _handleSubscription(
          RPCSubscribeCurrentAccountCommandHandler(),
          params,
        ),
      )
      ..registerUnsubscriptionMethod(
        'unsubscribeCurrentAccount',
      )
      ..registerMethod(
        'addService',
        (params) => _handle(RPCAddServiceCommandHandler(), params),
      )
      ..registerMethod(
        'removeService',
        (params) => _handle(RPCRemoveServiceCommandHandler(), params),
      )
      ..registerMethod(
        'getServicesFromKeychain',
        (params) => _handle(RPCGetServicesFromKeychainCommandHandler(), params),
      )
      ..registerMethod(
        'keychainDeriveKeypair',
        (params) => _handle(RPCKeychainDeriveKeypairCommandHandler(), params),
      )
      ..registerMethod(
        'keychainDeriveAddress',
        (params) => _handle(RPCKeychainDeriveAddressCommandHandler(), params),
      )
      ..registerMethod(
        'signTransactions',
        (params) => _handle(RPCSignTransactionsCommandHandler(), params),
      )
      ..registerMethod(
        'signPayloads',
        (params) => _handle(RPCSignPayloadsCommandHandler(), params),
      )
      ..registerMethod(
        'encryptPayloads',
        (params) => _handle(RPCEncryptPayloadsCommandHandler(), params),
      )
      ..registerMethod(
        'decryptPayloads',
        (params) => _handle(RPCDecryptPayloadsCommandHandler(), params),
      );
  }

  static final _logger = Logger('AWS-JsonRPCServer');
  final StreamChannel<String> channel;
  late final SubscribablePeer _peer;

  Future<void> listen() => _peer.listen();

  Future<void> close() => _peer.close();

  Future<Map<String, dynamic>> _handle(
    RPCCommandHandler commandHandler,
    Parameters params,
  ) async {
    final result = await commandHandler.handle(params.value);
    return result.map(
      success: (success) {
        final result = commandHandler.resultFromModel(success);
        _logger.info('Command result : ${jsonEncode(result)}');
        return result;
      },
      failure: (failure) {
        _logger.severe(
          'Command failed',
          failure,
        );

        throw RpcException(
          failure.code,
          failure.message,
        );
      },
    );
  }

  Future<awc.Subscription> _handleSubscription(
    RPCSubscriptionHandler commandHandler,
    Parameters params,
  ) async {
    final result = await commandHandler.handle(params.value);
    return result.map(
      success: (success) {
        success as RPCSubscription;

        final subscription = awc.Subscription(
          id: success.id,
          updates: success.updates
              .map(
                (update) => awc.SubscriptionUpdate(
                  subscriptionId: success.id,
                  data: commandHandler.notificationFromModel(update),
                ),
              )
              .distinct()
              .map((dto) {
            final update = dto.toJson();
            _logger.info(
              'Subscription update : ${jsonEncode(update)}',
            );

            return update;
          }),
        );

        _logger.info(
          'Subscription result : ${jsonEncode(subscription.toJson())}',
        );

        return subscription;
      },
      failure: (failure) {
        _logger.severe('Subscription failed', failure);

        throw RpcException(
          failure.code,
          failure.message,
        );
      },
    );
  }
}

/// A [Peer] composition which handles subscription requests
class SubscribablePeer {
  SubscribablePeer(this._peer);

  final Peer _peer;

  final Map<String, StreamSubscription> _subscriptions = {};

  Future<void> close() => _peer.close();

  void registerMethod(String name, Function callback) =>
      _peer.registerMethod(name, callback);

  void registerSubscriptionMethod(
    String name,
    Future<awc.Subscription> Function(dynamic params) subscriptionCallback,
  ) {
    registerMethod(
      name,
      (params) async {
        final result = await subscriptionCallback(params);

        final streamSubscription = result.updates.listen((value) {
          _peer.sendNotification('addSubscriptionNotification', value);
        });
        _registerSubscription(result.id, streamSubscription);

        return result.toJson();
      },
    );
  }

  void registerUnsubscriptionMethod(
    String name,
  ) {
    registerMethod(
      name,
      (params) async {
        final requestDTO = awc.Request.fromJson(
          params.value,
        );

        final unsubscribeCommand = awc.UnsubscribeRequest.fromJson(
          requestDTO.payload,
        );
        _removeSubscription(unsubscribeCommand.subscriptionId);
        return {};
      },
    );
  }

  void registerFallback(Function(Parameters parameters) callback) =>
      _peer.registerFallback(callback);

  void _removeSubscription(String subscriptionId) {
    _subscriptions.remove(subscriptionId);
  }

  void _registerSubscription(String subscriptionId, StreamSubscription sub) {
    _subscriptions[subscriptionId] = sub;
  }

  void _cleanupSubscriptions() {
    for (final subscription in _subscriptions.entries) {
      subscription.value.cancel();
    }
    _subscriptions.clear();
  }

  Future listen() async {
    await _peer.listen();
    _cleanupSubscriptions();
  }
}
