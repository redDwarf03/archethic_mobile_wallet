import 'dart:ui';

import 'package:aewallet/application/account/accounts_notifier.dart';
import 'package:aewallet/ui/views/accounts/layouts/components/account_list_item.dart';
import 'package:aewallet/util/account_formatters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsList extends ConsumerStatefulWidget {
  const AccountsList({
    super.key,
  });

  @override
  ConsumerState<AccountsList> createState() => AccountsListState();
}

class AccountsListState extends ConsumerState<AccountsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final selectedAccount = ref.watch(
      accountsNotifierProvider.select(
        (accounts) => accounts.valueOrNull?.selectedAccount,
      ),
    );
    final accountsList = ref.watch(accountsNotifierProvider).valueOrNull ?? [];
    if (accountsList.isNotEmpty) {
      accountsList.sort(
        (a, b) => a.nameDisplayed.compareTo(b.nameDisplayed),
      );
    }

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
          itemCount: accountsList.length,
          itemBuilder: (BuildContext context, int index) {
            Widget item = AccountListItem(
              account: accountsList[index],
              selectedAccount: selectedAccount,
            );

            if (!kIsWeb) {
              item = item
                  .animate(delay: 100.ms)
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .shimmer(
                    blendMode: BlendMode.srcOver,
                    color: Colors.white12,
                  )
                  .move(
                    begin: const Offset(-16, 0),
                    curve: Curves.easeOutQuad,
                  );
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: item,
              ),
            );
          },
        ),
      ),
    );
  }
}
