import 'package:aewallet/modules/aeswap/application/session/provider.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:aewallet/ui/widgets/components/picker_item.dart';
import 'package:aewallet/ui/widgets/components/popup_dialog.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnvironmentDialog extends ConsumerWidget {
  const EnvironmentDialog({
    super.key,
  });

  static const routerPage = '/network_dialog';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentEnvironment = ref.watch(environmentProvider);

    final localizations = AppLocalizations.of(context)!;

    final pickerItemsList = List<PickerItem>.empty(growable: true);
    for (final environment in aedappfm.Environment.values) {
      pickerItemsList.add(
        PickerItem(
          environment.displayName,
          environment.endpoint,
          '${ArchethicTheme.assetsFolder}logo_white.png',
          null,
          environment,
          true,
        ),
      );
    }

    return PopupDialog(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          localizations.networksHeader,
          style: ArchethicThemeStyles.textStyleSize24W700Primary,
        ),
      ),
      content: PickerWidget(
        pickerItems: pickerItemsList,
        selectedIndexes: [currentEnvironment.index],
        onSelected: (value) async {
          final environment = value.value;
          context.pop(environment);
        },
      ),
    );
  }
}
