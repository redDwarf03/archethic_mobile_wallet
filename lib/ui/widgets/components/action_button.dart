import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionButton extends ConsumerWidget {
  const ActionButton({
    this.onTap,
    required this.text,
    required this.icon,
    this.enabled = true,
    super.key,
  });

  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: onTap != null
          ? InkWell(
              onTap: enabled ? onTap : null,
              child: Column(
                children: <Widget>[
                  ShaderMask(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        icon,
                        weight: 800,
                        opticalSize: IconSize.opticalSizeM,
                        grade: IconSize.gradeM,
                        color: enabled
                            ? Colors.white
                            : ArchethicTheme.text.withOpacity(0.3),
                        size: 38,
                      ),
                    ),
                    shaderCallback: (Rect bounds) {
                      const rect = Rect.fromLTRB(0, 0, 40, 40);
                      return ArchethicTheme.gradient.createShader(rect);
                    },
                  ),
                  const SizedBox(height: 5),
                  if (enabled)
                    AutoSizeText(
                      text,
                      textAlign: TextAlign.center,
                      style: ArchethicThemeStyles.textStyleSize14W600Primary,
                    )
                  else
                    AutoSizeText(
                      text,
                      textAlign: TextAlign.center,
                      style: ArchethicThemeStyles
                          .textStyleSize14W600PrimaryDisabled,
                    ),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                ShaderMask(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      icon,
                      color: enabled
                          ? Colors.white
                          : ArchethicTheme.text.withOpacity(0.3),
                      size: 38,
                    ),
                  ),
                  shaderCallback: (Rect bounds) {
                    const rect = Rect.fromLTRB(0, 0, 40, 40);
                    return ArchethicTheme.gradient.createShader(rect);
                  },
                ),
                const SizedBox(height: 5),
                if (enabled)
                  Text(
                    text,
                    style: ArchethicThemeStyles.textStyleSize14W600Primary,
                  )
                else
                  Text(
                    text,
                    style:
                        ArchethicThemeStyles.textStyleSize14W600PrimaryDisabled,
                  ),
              ],
            ),
    );
  }
}
