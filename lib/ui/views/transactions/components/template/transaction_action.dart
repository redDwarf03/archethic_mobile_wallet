import 'package:aewallet/ui/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionAction extends ConsumerWidget {
  const TransactionAction({super.key, required this.action});

  final String? action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (action == null) return const SizedBox();

    return Row(
      children: <Widget>[
        Text(
          action!,
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        ),
      ],
    );
  }
}
