import 'package:flutter/material.dart';

@immutable
class NeoColors extends ThemeExtension<NeoColors> {
  const NeoColors({
    required this.canvas,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.accentRed,
    required this.accentYellow,
    required this.accentViolet,
    required this.border,
    required this.borderMuted,
    required this.shadow,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color accentRed;
  final Color accentYellow;
  final Color accentViolet;
  final Color border;
  final Color borderMuted;
  final Color shadow;

  Color get accentBlue => accentViolet; // Bauhaus Primary Blue (#1040C0 / #2060E0)

  // Bauhaus Design System (Off-White Canvas, Black Ink, Bauhaus Red, Bauhaus Blue, Bauhaus Yellow)
  static const light = NeoColors(
    canvas: Color(0xFFF0F0F0), // Authentic Bauhaus Off-White / Light Grey
    surface: Color(0xFFFFFFFF), // Pure white functional card
    surfaceElevated: Color(0xFFE8E8E8),
    textPrimary: Color(0xFF121212), // Solid ink black
    textSecondary: Color(0xFF555555),
    accentRed: Color(0xFFD02020), // Bauhaus Primary Red
    accentYellow: Color(0xFFF0C020), // Bauhaus Primary Yellow
    accentViolet: Color(0xFF1040C0), // Bauhaus Primary Blue
    border: Color(0xFF121212), // Solid ink black borders (2-4px)
    borderMuted: Color(0xFFCCCCCC),
    shadow: Color(0xFF121212), // Hard offset solid ink shadow
  );

  // Bauhaus Dark Mode (Deep Black & High-Contrast Bauhaus Primaries)
  static const dark = NeoColors(
    canvas: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    surfaceElevated: Color(0xFF282828),
    textPrimary: Color(0xFFF0F0F0),
    textSecondary: Color(0xFFAAAAAA),
    accentRed: Color(0xFFE03030),
    accentYellow: Color(0xFFFFD030),
    accentViolet: Color(0xFF2060E0),
    border: Color(0xFFF0F0F0),
    borderMuted: Color(0xFF444444),
    shadow: Color(0xFF000000),
  );

  @override
  NeoColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? accentRed,
    Color? accentYellow,
    Color? accentViolet,
    Color? border,
    Color? borderMuted,
    Color? shadow,
  }) {
    return NeoColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      accentRed: accentRed ?? this.accentRed,
      accentYellow: accentYellow ?? this.accentYellow,
      accentViolet: accentViolet ?? this.accentViolet,
      border: border ?? this.border,
      borderMuted: borderMuted ?? this.borderMuted,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  NeoColors lerp(ThemeExtension<NeoColors>? other, double t) {
    if (other is! NeoColors) return this;
    return NeoColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      accentYellow: Color.lerp(accentYellow, other.accentYellow, t)!,
      accentViolet: Color.lerp(accentViolet, other.accentViolet, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderMuted: Color.lerp(borderMuted, other.borderMuted, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension NeoThemeContext on BuildContext {
  NeoColors get neo => Theme.of(this).extension<NeoColors>() ?? NeoColors.light;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
