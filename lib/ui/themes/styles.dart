import 'package:aewallet/ui/themes/archethic_theme.dart';
import 'package:aewallet/ui/themes/archethic_theme_base.dart';
import 'package:flutter/material.dart';

class ArchethicThemeStyles {
  static TextStyle get textStyleSize16W100Primary {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w200,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize16W400Primary60 {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w400,
      color: ArchethicTheme.text60,
    );
  }

  static TextStyle get textStyleSize16W700Primary {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize14W600Primary {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize12W400UnderlinePrimary {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w400,
      color: ArchethicTheme.text,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle get textStyleSize14W600PrimaryRed {
    return const TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w600,
      color: Colors.red,
    );
  }

  static TextStyle get textStyleSize14W600PrimaryDisabled {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.text.withOpacity(0.3),
    );
  }

  static TextStyle get textStyleSize18W600MainButtonLabelDisabled {
    return TextStyle(
      fontSize: AppFontSizes.size18,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.mainButtonLabel.withOpacity(0.3),
    );
  }

  static TextStyle get textStyleSize16W400MainButtonLabelDisabled {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w400,
      color: ArchethicTheme.mainButtonLabel.withOpacity(0.3),
    );
  }

  static TextStyle get textStyleSize14W700Background {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.background,
    );
  }

  static TextStyle get textStyleSize20W700Primary {
    return TextStyle(
      fontSize: AppFontSizes.size20,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize14W700Primary {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize14W200Text60 {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w200,
      color: ArchethicTheme.text60,
    );
  }

  static TextStyle get textStyleSize14W200Primary {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w200,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize14W200PrimaryPositiveValue {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w200,
      color: ArchethicTheme.positiveValue,
    );
  }

  static TextStyle get textStyleSize14W200Background {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w400,
      color: ArchethicTheme.background,
    );
  }

  static TextStyle get textStyleSize25W900Primary {
    return TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w900,
      letterSpacing: 1,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize25W900Primary60 {
    return TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w900,
      letterSpacing: 1,
      color: ArchethicTheme.text.withOpacity(0.6),
    );
  }

  static TextStyle get textStyleSize35W900Primary {
    return TextStyle(
      fontSize: 35,
      fontWeight: FontWeight.w900,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize12W100PositiveValue {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w100,
      color: ArchethicTheme.positiveValue,
    );
  }

  static TextStyle get textStyleSize12W100NegativeValue {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w100,
      color: ArchethicTheme.negativeValue,
    );
  }

  static TextStyle get textStyleSize12W100Primary60 {
    return TextStyle(
      color: ArchethicTheme.text60,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get textStyleSize12W100Primary {
    return TextStyle(
      color: ArchethicTheme.text,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get textStyleSize12W100PrimaryWarning {
    return TextStyle(
      color: ArchethicTheme.warning,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get textStyleSize12W100Background {
    return TextStyle(
      color: ArchethicTheme.background,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get textStyleSize12W300PrimaryRed {
    return const TextStyle(
      color: Colors.red,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get textStyleSize12W100Primary30 {
    return TextStyle(
      color: ArchethicTheme.text,
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle get textStyleSize10W100Primary {
    return TextStyle(
      color: ArchethicTheme.text,
      fontSize: AppFontSizes.size10,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle get textStyleSize10W400Primary {
    return TextStyle(
      color: ArchethicTheme.text,
      fontSize: AppFontSizes.size10,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle get textStyleSize10W600Primary {
    return TextStyle(
      color: ArchethicTheme.text,
      fontSize: AppFontSizes.size10,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get textStyleSize16W600Primary {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize16W600Red {
    return const TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: Colors.red,
    );
  }

  static TextStyle get textStyleSize16W600Primary30 {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.text30,
    );
  }

  static TextStyle get textStyleSize12W600Primary {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize12W600Primary60 {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.text.withOpacity(0.6),
    );
  }

  static TextStyle get textStyleSize24W700Primary {
    return TextStyle(
      fontSize: AppFontSizes.size24,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize24W700PrimaryRed {
    return const TextStyle(
      fontSize: AppFontSizes.size24,
      fontWeight: FontWeight.w700,
      color: Colors.red,
    );
  }

  static TextStyle get textStyleSize28W700Primary {
    return TextStyle(
      fontSize: AppFontSizes.size28,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.text,
    );
  }

  static TextStyle get textStyleSize20W700Warning {
    return TextStyle(
      fontSize: AppFontSizes.size20,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.warning,
    );
  }

  static TextStyle get textStyleSize18W600MainButtonLabel {
    return TextStyle(
      fontSize: AppFontSizes.size18,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.mainButtonLabel,
    );
  }

  static TextStyle get textStyleSize16W400MainButtonLabel {
    return TextStyle(
      fontSize: AppFontSizes.size16,
      fontWeight: FontWeight.w600,
      color: ArchethicTheme.mainButtonLabel,
    );
  }

  static TextStyle get textStyleSize12W400Highlighted {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w400,
      color: ArchethicThemeBase.raspberry300,
    );
  }

  static TextStyle get textStyleSize12W400Primary45 {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w400,
      color: ArchethicTheme.text45,
    );
  }

  static TextStyle get textStyleSize14W400Highlighted {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w400,
      color: ArchethicThemeBase.raspberry300,
    );
  }

  static TextStyle get textStyleSize14W600Highlighted {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w600,
      color: ArchethicThemeBase.raspberry300,
    );
  }

  static TextStyle get textStyleSize14W700Primary60 {
    return TextStyle(
      fontSize: AppFontSizes.size14,
      fontWeight: FontWeight.w700,
      color: ArchethicTheme.text60,
    );
  }

  static TextStyle get textStyleSize12W400ConnectivityBanner {
    return TextStyle(
      fontSize: AppFontSizes.size12,
      fontWeight: FontWeight.w400,
      color: ArchethicTheme.bannerTextColor,
    );
  }
}

class AppFontSizes {
  static const double size10 = 10;
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;
  static const double size22 = 22;
  static const double size24 = 24;
  static const double size28 = 28;

  static double largest(BuildContext context) {
    if (smallScreen(context)) {
      return size22;
    }
    return size28;
  }

  static double large(BuildContext context) {
    if (smallScreen(context)) {
      return size18;
    }
    return size20;
  }

  static double smallText(BuildContext context) {
    if (smallScreen(context)) {
      return size12;
    }
    return size14;
  }
}

bool smallScreen(BuildContext context) {
  if (MediaQuery.of(context).size.height < 800) {
    return true;
  } else {
    return false;
  }
}

class IconSize {
  static const double weightM = 300;
  static const double opticalSizeM = 48;
  static const double gradeM = -25;
}
