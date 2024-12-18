// Project imports:
import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/styles.dart';
import 'package:flutter/material.dart';

class PinScreenButton extends StatelessWidget {
  const PinScreenButton({
    required this.buttonText,
    required this.buttonSize,
    required this.onTapDownbuttonPin,
    super.key,
  });
  final String buttonText;
  final double buttonSize;
  final Function onTapDownbuttonPin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: smallScreen(context) ? buttonSize - 15 : buttonSize,
      width: smallScreen(context) ? buttonSize - 15 : buttonSize,
      child: InkWell(
        key: Key('pinButton$buttonText'),
        borderRadius: BorderRadius.circular(200),
        highlightColor: ArchethicTheme.text15,
        splashColor: ArchethicTheme.text30,
        onTap: () {},
        onTapDown: (details) => onTapDownbuttonPin(
          details,
          buttonText,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: ArchethicTheme.background40,
                blurRadius: 15,
                spreadRadius: -15,
              ),
            ],
          ),
          alignment: AlignmentDirectional.center,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: ArchethicThemeStyles.textStyleSize20W700Primary,
          ),
        ),
      ),
    );
  }
}
