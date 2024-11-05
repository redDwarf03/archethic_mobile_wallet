import 'package:flutter/material.dart';

class CommandHandlerLoadingSnackbar extends SnackBar {
  CommandHandlerLoadingSnackbar({super.key, required String message})
      : super(
          duration: const Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              const CircularProgressIndicator(
                strokeWidth: 2,
              ),
              const SizedBox(
                width: 21,
              ),
              Text(message),
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
