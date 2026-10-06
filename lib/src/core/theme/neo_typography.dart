import 'package:flutter/material.dart';

class NeoTypography {
  static const String _primaryFamily = 'sans-serif';

  static TextStyle display({
    required Color color,
    double fontSize = 38,
    FontWeight fontWeight = FontWeight.w900,
    double letterSpacing = -0.5,
  }) {
    return TextStyle(
      fontFamily: _primaryFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.05,
    );
  }

  static TextStyle headline({
    required Color color,
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w900,
    double letterSpacing = -0.3,
  }) {
    return TextStyle(
      fontFamily: _primaryFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.15,
    );
  }

  static TextStyle subheadline({
    required Color color,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    double letterSpacing = 0.0,
  }) {
    return TextStyle(
      fontFamily: _primaryFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.2,
    );
  }

  static TextStyle body({
    required Color color,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w700,
    double? height = 1.35,
  }) {
    return TextStyle(
      fontFamily: _primaryFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle label({
    required Color color,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w900,
    double letterSpacing = 1.2,
  }) {
    return TextStyle(
      fontFamily: _primaryFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.0,
    );
  }
}
