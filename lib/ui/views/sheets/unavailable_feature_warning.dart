import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/views/main/components/sheet_appbar.dart';
import 'package:aewallet/ui/widgets/components/sheet_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class UnavailableFeatureWarning extends ConsumerWidget {
  const UnavailableFeatureWarning({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetSkeleton(
      appBar: getAppBar(context, ref),
      sheetContent: getSheetContent(
        context,
        ref,
        title: title,
        description: description,
      ),
    );
  }

  PreferredSizeWidget getAppBar(BuildContext context, WidgetRef ref) {
    return SheetAppBar(
      title: AppLocalizations.of(context)!.information,
    );
  }

  Widget getSheetContent(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            const Icon(Symbols.warning, color: Colors.red),
            const SizedBox(width: 10),
            Text(
              title,
              style: ArchethicThemeStyles.textStyleSize14W600Primary,
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          description,
          style: ArchethicThemeStyles.textStyleSize12W100Primary,
        ),
      ],
    );
  }
}
