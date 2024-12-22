import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:aewallet/ui/views/add_custom_token/layouts/add_custom_token_sheet.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomTokenAddBtn extends ConsumerWidget {
  const CustomTokenAddBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await CupertinoScaffold.showCupertinoModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                    heightFactor: 1,
                    child: Scaffold(
                      backgroundColor: aedappfm.AppThemeBase.sheetBackground
                          .withOpacity(0.2),
                      body: const AddCustomTokenSheet(),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: aedappfm.AppThemeBase.gradientBtn,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Symbols.add,
                    color: Colors.white,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!.token,
                    style: AppTextStyles.bodyMedium(context),
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
