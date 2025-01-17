import 'package:aewallet/application/app_version_update_info.dart';
import 'package:aewallet/application/connectivity_status.dart';
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/widgets/components/dialog.dart';
import 'package:aewallet/util/universal_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppUpdateButton extends ConsumerWidget {
  const AppUpdateButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (UniversalPlatform.isWeb ||
        UniversalPlatform.isWindows ||
        UniversalPlatform.isLinux) {
      return const SizedBox();
    }

    final connectivityStatusProvider = ref.watch(connectivityStatusProviders);
    if (connectivityStatusProvider == ConnectivityStatus.isDisconnected) {
      return const SizedBox();
    }

    final localizations = AppLocalizations.of(context)!;
    final appVersionInfo = ref.watch(AppVersionInfoProviders.getAppVersionInfo);

    return appVersionInfo.map(
      data: (data) {
        return data.value.canUpdate
            ? Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height - 120,
                  left: MediaQuery.of(context).size.width - 60,
                ),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: FittedBox(
                    child: FloatingActionButton(
                      backgroundColor: ArchethicTheme.background,
                      foregroundColor: ArchethicTheme.textFieldIcon,
                      splashColor: ArchethicTheme.textFieldIcon,
                      onPressed: () {
                        AppDialogs.showInfoDialog(
                          context,
                          ref,
                          localizations.updateAvailableTitle,
                          localizations.updateAvailableDesc
                              .replaceFirst('%1', data.value.storeVersion),
                        );
                      },
                      child: const Icon(
                        Symbols.warning,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
      error: (error) => const SizedBox(),
      loading: (lading) => const SizedBox(),
    );
  }
}
