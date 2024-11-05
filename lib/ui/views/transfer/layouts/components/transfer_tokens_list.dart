import 'dart:ui';

import 'package:aewallet/application/tokens/tokens.dart';
import 'package:aewallet/ui/views/transfer/layouts/components/transfer_token_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferTokensList extends ConsumerStatefulWidget {
  const TransferTokensList({
    this.withUCO = true,
    this.withVerified = true,
    this.withNotVerified = false,
    this.withLPToken = false,
    this.withCustomToken = true,
    super.key,
  });

  final bool withUCO;
  final bool withVerified;
  final bool withNotVerified;
  final bool withLPToken;
  final bool withCustomToken;

  @override
  ConsumerState<TransferTokensList> createState() => TransferTokensListState();
}

class TransferTokensListState extends ConsumerState<TransferTokensList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tokensListAsync = ref.watch(
      tokensFromUserBalanceProvider(
        withUCO: widget.withUCO,
        withVerified: widget.withVerified,
        withNotVerified: widget.withNotVerified,
        withLPToken: widget.withLPToken,
        withCustomToken: widget.withCustomToken,
      ),
    );

    return tokensListAsync.when(
      data: (tokensList) {
        if (tokensList.isEmpty) {
          return const SizedBox.shrink();
        }

        tokensList.sort((a, b) {
          if (a.address == null && b.address != null) return -1;
          if (a.address != null && b.address == null) return 1;

          if (a.isVerified && !b.isVerified) return -1;
          if (!a.isVerified && b.isVerified) return 1;

          if (a.isLpToken && !b.isLpToken) return -1;
          if (!a.isLpToken && b.isLpToken) return 1;

          final symbolComparison = a.symbol.compareTo(b.symbol);
          if (symbolComparison != 0) return symbolComparison;

          return 0;
        });

        return Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: MediaQuery.of(context).padding.bottom + 70,
              ),
              itemCount: tokensList.length,
              itemBuilder: (BuildContext context, int index) {
                return TransferTokenDetail(
                  aeToken: tokensList[index],
                );
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 10,
        width: 10,
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
