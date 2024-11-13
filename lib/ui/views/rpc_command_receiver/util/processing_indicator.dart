import 'package:aewallet/modules/aeswap/ui/views/util/app_styles.dart';
import 'package:flutter/material.dart';

class CommandHandlerLoadingSnackbar extends SnackBar {
  CommandHandlerLoadingSnackbar({
    super.key,
    required BuildContext context,
    required String message,
  }) : super(
          duration: const Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                message,
                style: AppTextStyles.bodySmall(context)
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
        );

  void show(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(this);
  }

  static void hide(BuildContext context) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
