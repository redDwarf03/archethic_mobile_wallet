/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dapp.freezed.dart';
part 'dapp.g.dart';

@freezed
class DApp with _$DApp {
  const factory DApp({
    required String code,
    required String url,
    String? category,
    String? description,
    String? name,
    String? iconUrl,
    String? accessToken,
  }) = _DApp;

  factory DApp.fromJson(Map<String, dynamic> json) => _$DAppFromJson(json);
}
