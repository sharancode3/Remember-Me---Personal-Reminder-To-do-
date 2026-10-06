import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';
import 'src/core/bootstrap/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };

  await _launchApp();
}

Future<void> _launchApp() async {
  try {
    final container = await bootstrap();
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const RememberMeApp(),
      ),
    );
  } catch (error, stackTrace) {
    debugPrintStack(
      label: 'Remember Me startup failed: $error',
      stackTrace: stackTrace,
    );
    runApp(StartupErrorApp(message: error.toString(), onRetry: _launchApp));
  }
}

class StartupErrorApp extends StatefulWidget {
  const StartupErrorApp({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  State<StartupErrorApp> createState() => _StartupErrorAppState();
}

class _StartupErrorAppState extends State<StartupErrorApp> {
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    try {
      await widget.onRetry();
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF147D65)),
        scaffoldBackgroundColor: const Color(0xFFF6FAF8),
      ),
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 48),
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.refresh_rounded,
                  size: 36,
                  color: Color(0xFF147D65),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Couldn't open Remember Me",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const Text('Try again. Your saved data has not been cleared.'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _retrying ? null : _retry,
                icon: _retrying
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded),
                label: Text(_retrying ? 'Opening...' : 'Try again'),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Error details'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(widget.message),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
