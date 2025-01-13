/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math';

import 'package:flutter/services.dart';

/// Ensures input is always uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

/// Ensures input is always lowercase
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class AmountTextInputFormatter extends TextInputFormatter {
  AmountTextInputFormatter({
    this.thousandsSeparator = ' ',
    this.decimalSeparator = '.',
    this.precision = 2,
  });

  String thousandsSeparator;
  String decimalSeparator;
  int precision;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value =
        newValue.text.unifyDecimalSeparator().removeIllegalNumberCharacters();

    if (!value.isValidNumber()) {
      return oldValue;
    }

    final formattedNumberBuilder = StringBuffer()
      ..write(
        value
            .integerPart(decimalSeparator)
            .splitFromRight(3, thousandsSeparator),
      );

    if (value.hasDecimalPart(decimalSeparator)) {
      formattedNumberBuilder
        ..write(decimalSeparator)
        ..write(value.decimalPart(decimalSeparator).limitLength(precision));
    }

    final diff = formattedNumberBuilder.length - newValue.text.length;
    final newOffset = newValue.selection.baseOffset + diff;

    return newValue.copyWith(
      text: formattedNumberBuilder.toString(),
      selection: TextSelection.collapsed(
        offset: newOffset.clamp(0, formattedNumberBuilder.length),
      ),
    );
  }
}

extension _StringNumberExt on String {
  static final illegalCharacters = RegExp('[^0-9.]');
  String removeIllegalNumberCharacters() => replaceAll(illegalCharacters, '');

  String unifyDecimalSeparator() => replaceAll(',', '.');

  bool isValidNumber() => double.tryParse(this) != null;

  String integerPart(String separator) {
    final parts = split(separator);
    if (parts.isEmpty) return '';

    return parts.first;
  }

  bool hasDecimalPart(String separator) => contains(separator);

  String decimalPart(String separator) {
    final parts = split(separator);
    if (parts.length < 2) return '';

    return parts[1];
  }

  String limitLength(int maxLength) {
    return substring(0, min(length, maxLength));
  }

  String splitFromRight(int interval, String separator) {
    final leftPartLength = length % interval;
    final parts = length ~/ interval;

    final resultBuilder = StringBuffer();

    if (leftPartLength > 0) {
      resultBuilder.write(substring(0, leftPartLength));

      if (parts > 0) resultBuilder.write(separator);
    }

    for (var i = 0; i < parts; i++) {
      final offset = leftPartLength + i * interval;
      resultBuilder.write(substring(offset, offset + interval));
      if (i < parts - 1) {
        resultBuilder.write(separator);
      }
    }
    return resultBuilder.toString();
  }
}
