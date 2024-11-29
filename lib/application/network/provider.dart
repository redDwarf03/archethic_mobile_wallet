/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aewallet/model/available_networks.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
String _networkLink(
  Ref ref, {
  required AvailableNetworks network,
}) {
  final networkSetting = NetworksSetting(
    network: network,
    networkDevEndpoint: '',
  );

  final link = networkSetting.getLink();

  return link;
}

@riverpod
Future<List<Node>> _networkNodes(
  Ref ref, {
  required AvailableNetworks network,
}) async {
  final link = ref.read(
    _networkLinkProvider(
      network: network,
    ),
  );

  final nodeListMain = await ApiService(
    link,
  ).getNodeList();

  return nodeListMain;
}

@riverpod
Future<bool> _isReservedNodeUri(
  Ref ref, {
  required Uri uri,
}) async {
  // Check if default uri is used
  if (DefaultNetworksHost.archethicMainNetHost.value == uri.host) return true;
  if (DefaultNetworksHost.archethicTestNetHost.value == uri.host) return true;

  // Check if reserved nodes of network is used
  var nodeListMain = <Node>[];
  try {
    nodeListMain = await ref.watch(
      _networkNodesProvider(
        network: AvailableNetworks.archethicMainNet,
      ).future,
    );
    // ignore: empty_catches
  } catch (e) {}

  var nodeListTest = <Node>[];
  try {
    nodeListTest = await ref.watch(
      _networkNodesProvider(
        network: AvailableNetworks.archethicTestNet,
      ).future,
    );
    // ignore: empty_catches
  } catch (e) {}

  return nodeListMain.followedBy(nodeListTest).any(
        (node) => node.ip == uri.host && node.port == uri.port,
      );
}

abstract class NetworkProvider {
  static const networkLink = _networkLinkProvider;
  static const networkNodes = _networkNodesProvider;
  static const isReservedNodeUri = _isReservedNodeUriProvider;
}
