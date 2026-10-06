import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/daily_trail_service.dart';

enum DailyStyle { mint, ocean, rose }

class ThemePreferences extends StateNotifier<DailyStyle> {
  ThemePreferences() : super(DailyStyle.mint) {
    _load();
  }
  Future<void> _load() async {
    try {
      final value = await DailyTrailService.channel.invokeMethod<String>(
        'readTheme',
      );
      if (value != null && mounted) state = DailyStyle.values.byName(value);
    } catch (_) {}
  }

  Future<void> select(DailyStyle style) async {
    state = style;
    try {
      await DailyTrailService.channel.invokeMethod<void>('writeTheme', {
        'value': style.name,
      });
    } catch (_) {}
  }
}

final dailyStyleProvider = StateNotifierProvider<ThemePreferences, DailyStyle>(
  (ref) => ThemePreferences(),
);

class DailyTheme {
  static Color accent(DailyStyle style) => switch (style) {
    DailyStyle.mint => const Color(0xFF16775E),
    DailyStyle.ocean => const Color(0xFF226CAF),
    DailyStyle.rose => const Color(0xFFA84A6B),
  };
  static ThemeData build(DailyStyle style) {
    final primary = accent(style);
    final canvas = switch (style) {
      DailyStyle.mint => const Color(0xFFF0F7F4),
      DailyStyle.ocean => const Color(0xFFF0F5FA),
      DailyStyle.rose => const Color(0xFFFBF2F5),
    };
    final scheme = ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      surface: Colors.white,
      onSurface: const Color(0xFF202B27),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: AppBarTheme(
        backgroundColor: canvas.withValues(alpha: .85),
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: .75),
        indicatorColor: primary.withValues(alpha: .12),
        height: 72,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFFF9FBFC),
        showDragHandle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: .75),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDCE6E1)),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 8,
  });
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .82),
          border: Border.all(color: Colors.white.withValues(alpha: .8)),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class RememberMark extends StatelessWidget {
  const RememberMark({super.key, this.size = 28});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Icon(
      Icons.notifications_active_rounded,
      size: size * .63,
      color: Colors.white,
    ),
  );
}
