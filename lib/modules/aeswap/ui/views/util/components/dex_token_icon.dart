/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aewallet/application/aeswap/dex_token.dart';
import 'package:aewallet/modules/aeswap/domain/models/dex_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class DexTokenIcon extends ConsumerWidget {
  const DexTokenIcon({
    required this.tokenAddress,
    this.iconSize = 20,
    super.key,
  });

  final String tokenAddress;
  final double? iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenIcon = ref.watch(
      DexTokensProviders.getTokenIcon(
        tokenAddress.isEmpty ? kUCOAddress : tokenAddress,
      ),
    );
    return tokenIcon.map(
      data: (data) {
        if (data.value == null) {
          return _noIcon();
        }
        return SvgPicture.string(
          data.value!,
          width: iconSize,
        );
      },
      error: (error) => _noIcon(),
      loading: (loading) => _noIcon(),
    );
  }

  Widget _noIcon() {
    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}
