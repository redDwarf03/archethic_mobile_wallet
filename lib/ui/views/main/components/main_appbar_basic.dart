import 'package:aewallet/ui/themes/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainAppBarBasic extends ConsumerWidget {
  const MainAppBarBasic({required this.header, super.key});

  final String header;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: AutoSizeText(
        header,
        style: ArchethicThemeStyles.textStyleSize24W700Primary,
      ),
    ).animate().fade(duration: const Duration(milliseconds: 300));
  }
}
