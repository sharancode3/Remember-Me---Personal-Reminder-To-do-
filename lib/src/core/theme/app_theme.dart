import 'package:flutter/material.dart';

import 'neo_colors.dart';

class AppTheme {
  static const background = Color(0xFF121212);
  static const surface = Color(0xFF1E1E1E);
  static const elevated = Color(0xFF282828);
  static const textPrimary = Color(0xFFFFFDF5);
  static const textSecondary = Color(0xFFAAAAAA);
  static const textMuted = Color(0xFF707070);

  static const success = Color(0xFFFFD93D);
  static const warning = Color(0xFFFF6B6B);
  static const danger = Color(0xFFFF5252);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD93D), Color(0xFFFF6B6B)],
  );

  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s32 = 32.0;

  static const micro = Duration(milliseconds: 100);
  static const medium = Duration(milliseconds: 200);
  static const large = Duration(milliseconds: 300);

  static const snapDuration = Duration(milliseconds: 100);
  static const normalDuration = Duration(milliseconds: 200);
  static const mechanicalCurve = Curves.easeOutCubic;

  static ThemeData get light {
    const colors = NeoColors.light;
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);

    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7F9F8),
      cardColor: colors.surface,
      dividerColor: colors.border,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF18765C),
        onPrimary: Colors.white,
        secondary: const Color(0xFF3577B5),
        tertiary: const Color(0xFFB45D72),
        error: colors.accentRed,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      extensions: [colors],
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF202B27),
        displayColor: const Color(0xFF202B27),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE5E1)),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFE0F1EA),
        height: 72,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData get dark {
    const colors = NeoColors.dark;
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);

    return base.copyWith(
      scaffoldBackgroundColor: colors.canvas,
      cardColor: colors.surface,
      dividerColor: colors.border,
      colorScheme: ColorScheme.dark(
        primary: colors.accentYellow,
        secondary: colors.accentRed,
        tertiary: colors.accentViolet,
        error: colors.accentRed,
        surface: colors.surface,
        onSurface: colors.textPrimary,
      ),
      extensions: [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.canvas,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
