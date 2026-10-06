import 'package:flutter/material.dart';

class NeoShadows {
  static List<BoxShadow> small(Color shadowColor) => [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(4, 4),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> medium(Color shadowColor) => [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(6, 6),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> large(Color shadowColor) => [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(8, 8),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> massive(Color shadowColor) => [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(12, 12),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];
}
