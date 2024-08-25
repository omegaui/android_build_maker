import 'package:flutter/material.dart';

class _AppTextTheme {
  _AppTextTheme._();

  static const Color foreground = Colors.black;
}

extension ConfigurableTextStyle on TextStyle {
  static Text generate(String text, double size) {
    return Text(
      text,
      style: withFontSize(size),
    );
  }

  static TextStyle withFontSize(double size) {
    return TextStyle(
      fontSize: size,
      color: _AppTextTheme.foreground,
    ).useSen().makeMedium();
  }

  TextStyle useBubbleGumSans() {
    return copyWith(
      fontFamily: "BubbleGumSans",
      fontWeight: FontWeight.normal,
    );
  }

  TextStyle useFuzzyBubbles() {
    return copyWith(
      fontFamily: "FuzzyBubbles",
    );
  }

  TextStyle useSen() {
    return copyWith(
      fontFamily: "Sen",
    );
  }

  TextStyle withColor(Color color) {
    return copyWith(
      color: color,
    );
  }

  TextStyle makeBold() {
    return copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle makeSemiBold() {
    return copyWith(
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle makeItalic() {
    return copyWith(
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle makeExtraBold() {
    return copyWith(
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle makeMedium() {
    return copyWith(
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle fontSize(double size) {
    return copyWith(
      fontSize: size,
    );
  }

  static TextStyle forButton() {
    return withFontSize(16).withColor(Colors.white).makeMedium().useSen();
  }
}
