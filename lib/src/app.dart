import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/daily_theme.dart';
import 'features/splash/presentation/entrance_reveal.dart';
import 'presentation/screens/daily_home_screen.dart';

class RememberMeApp extends ConsumerWidget {
  const RememberMeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Enforce portrait phone orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Remember Me',
      debugShowCheckedModeBanner: false,
      theme: DailyTheme.build(ref.watch(dailyStyleProvider)),
      themeMode: ThemeMode.light,
      home: const EntranceReveal(child: DailyHomeScreen()),
    );
  }
}
