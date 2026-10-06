import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/daily_trail_service.dart';
import '../providers/providers.dart';
import 'daily_home_screen.dart';

class DailyFocusScreen extends ConsumerStatefulWidget {
  const DailyFocusScreen({
    super.key,
    required this.onFinished,
    required this.onActiveChanged,
  });
  final VoidCallback onFinished;
  final ValueChanged<bool> onActiveChanged;
  @override
  ConsumerState<DailyFocusScreen> createState() => _DailyFocusScreenState();
}

class _DailyFocusScreenState extends ConsumerState<DailyFocusScreen>
    with WidgetsBindingObserver {
  int _minutes = 25;
  bool _pin = false;
  bool _block = false;
  bool _guardReady = false;
  List<Map<String, String>> _apps = [];
  Set<String> _allowed = {};
  bool _busy = false;
  DateTime? _start;
  DateTime? _end;
  Timer? _timer;
  bool get _android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  int get _remaining => _end == null
      ? _minutes * 60
      : _end!.difference(DateTime.now()).inSeconds.clamp(0, _minutes * 60);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restore();
    _loadApps();
  }

  Future<void> _loadApps() async {
    if (!_android) return;
    try {
      final apps =
          await DailyTrailService.channel.invokeListMethod<dynamic>(
            'installedApps',
          ) ??
          [];
      final allowed =
          await DailyTrailService.channel.invokeListMethod<String>(
            'allowedApps',
          ) ??
          [];
      final ready =
          await DailyTrailService.channel.invokeMethod<bool>(
            'focusGuardEnabled',
          ) ??
          false;
      if (mounted) {
        setState(() {
          _apps = apps.map((a) => Map<String, String>.from(a as Map)).toList();
          _allowed = allowed.toSet();
          _guardReady = ready;
        });
      }
    } catch (_) {}
  }

  Future<void> _permission() async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allow focus app blocking?'),
        content: const Text(
          'Remember Me uses Android Accessibility to detect which app is open and cover blocked apps during your timer. It does not read screen content, typed text, or passwords. Phone, Home, and Settings stay available for safety. You can disable access in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
    if (accepted == true) {
      await DailyTrailService.channel.invokeMethod<void>('openFocusPermission');
    }
  }

  Future<void> _chooseApps() async {
    final chosen = {..._allowed};
    var query = '';
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Allowed during focus'),
          content: SizedBox(
            width: 400,
            height: 350,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search apps',
                  ),
                  onChanged: (value) =>
                      update(() => query = value.toLowerCase()),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: _apps
                        .where((a) => a['name']!.toLowerCase().contains(query))
                        .map(
                          (a) => CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(a['name']!),
                            value: chosen.contains(a['package']),
                            onChanged: (value) => update(
                              () => value == true
                                  ? chosen.add(a['package']!)
                                  : chosen.remove(a['package']),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, chosen),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    await DailyTrailService.channel.invokeMethod<void>('saveAllowedApps', {
      'packages': result.toList(),
    });
    if (mounted) setState(() => _allowed = result);
  }

  Future<void> _restore() async {
    if (!_android) return;
    try {
      final state = await DailyTrailService.channel
          .invokeMapMethod<String, dynamic>('readFocus');
      if (!mounted || state?['start'] == null) return;
      setState(() {
        _start = DateTime.fromMillisecondsSinceEpoch(
          (state!['start'] as num).toInt(),
        );
        _end = DateTime.fromMillisecondsSinceEpoch(
          (state['end'] as num).toInt(),
        );
        _minutes = _end!.difference(_start!).inMinutes;
        _pin = state['pin'] == true;
        _block = state['block'] == true;
      });
      _startTicker();
      widget.onActiveChanged(true);
    } catch (e) {
      if (mounted) {
        showMessage(context, 'Could not restore focus. ${readableError(e)}');
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadApps();
    if (state == AppLifecycleState.resumed && _end != null) _tick();
  }

  void _startTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted || _busy) return;
    if (_remaining == 0) {
      _finish(completed: true);
    } else {
      setState(() {});
    }
  }

  Future<void> _begin() async {
    setState(() => _busy = true);
    final now = DateTime.now();
    final end = now.add(Duration(minutes: _minutes));
    try {
      if (_android) {
        await DailyTrailService.channel.invokeMethod<void>('startFocus', {
          'start': now.millisecondsSinceEpoch,
          'end': end.millisecondsSinceEpoch,
          'pin': _pin,
          'block': _block,
        });
      }
      if (!mounted) return;
      setState(() {
        _start = now;
        _end = end;
        _busy = false;
      });
      _startTicker();
      widget.onActiveChanged(true);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showMessage(context, readableError(e));
      }
    }
  }

  Future<void> _finish({required bool completed}) async {
    if (_busy || _start == null) return;
    setState(() => _busy = true);
    final start = _start!;
    final end = completed ? _end! : DateTime.now();
    try {
      if (_android) {
        await DailyTrailService.channel.invokeMethod<void>('stopFocus');
      } else {
        await ref.read(dailyRepositoryProvider).recordFocus(start, end, false);
      }
      _timer?.cancel();
      if (!mounted) return;
      setState(() {
        _start = null;
        _end = null;
        _busy = false;
      });
      widget.onFinished();
      widget.onActiveChanged(false);
      showMessage(
        context,
        completed ? 'Focus complete. Nice work.' : 'Focus session saved.',
      );
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showMessage(context, readableError(e));
      }
    }
  }

  Future<void> _exit() async {
    final end = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End this focus session?'),
        content: const Text('Your time so far will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep focusing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('End session'),
          ),
        ],
      ),
    );
    if (end == true) await _finish(completed: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = _end != null;
    final remaining = _remaining;
    final label =
        '${(remaining ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';
    return PopScope(
      canPop: !active,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && active) _exit();
      },
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                Text(
                  active ? 'One thing at a time.' : 'Focus',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  active
                      ? 'This time is yours.'
                      : 'Make a little room for your work.',
                  style: const TextStyle(color: Color(0xFF68756E)),
                ),
                const SizedBox(height: 36),
                Center(
                  child: SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: active ? 1 - remaining / (_minutes * 60) : 0,
                            strokeWidth: 7,
                            backgroundColor: const Color(0xFFE1EBE6),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w500,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              active ? 'remaining' : 'minutes of focus',
                              style: const TextStyle(color: Color(0xFF68756E)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                if (!active) ...[
                  const Text(
                    'Duration',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: _minutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: '$_minutes minutes',
                    onChanged: _busy
                        ? null
                        : (value) => setState(() => _minutes = value.round()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$_minutes minutes'),
                      const Text(
                        '120 max',
                        style: TextStyle(
                          color: Color(0xFF68756E),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_android)
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Block distracting apps'),
                      value: _block,
                      onChanged: _busy
                          ? null
                          : (value) => setState(() {
                              _block = value;
                              if (value) _pin = false;
                            }),
                    ),
                  if (_android && _block) ...[
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        _guardReady
                            ? Icons.verified_user_outlined
                            : Icons.lock_open,
                      ),
                      title: Text(
                        _guardReady
                            ? 'Focus access enabled'
                            : 'Enable focus access',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _permission,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.apps),
                      title: const Text('Allowed apps'),
                      subtitle: Text('${_allowed.length} selected'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _chooseApps,
                    ),
                  ],
                  if (_android && !_block)
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Pin the focus screen'),
                      subtitle: const Text(
                        'Android asks you to confirm. Its unpin gesture remains available for emergencies.',
                      ),
                      value: _pin,
                      onChanged: _busy
                          ? null
                          : (value) => setState(() => _pin = value),
                    ),
                  const SizedBox(height: 20),
                ] else ...[
                  if (_block)
                    Wrap(
                      spacing: 8,
                      children: _apps
                          .where((a) => _allowed.contains(a['package']))
                          .map(
                            (a) => ActionChip(
                              avatar: const Icon(Icons.open_in_new, size: 16),
                              label: Text(a['name']!),
                              onPressed: () async {
                                try {
                                  await DailyTrailService.channel
                                      .invokeMethod<void>('launchAllowedApp', {
                                        'package': a['package'],
                                      });
                                } catch (e) {
                                  if (context.mounted) {
                                    showMessage(context, readableError(e));
                                  }
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  const Center(
                    child: Icon(
                      Icons.spa_outlined,
                      color: Color(0xFF18765C),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: _busy ? null : _exit,
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text('End session'),
                  ),
                ],
              ],
            ),
          ),
          if (!active)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _busy || (_block && !_guardReady) ? null : _begin,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start focus'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
