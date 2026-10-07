import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../core/theme/daily_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../data/models/task_model.dart';
import '../../features/calendar/presentation/calendar_tab.dart';
import '../../features/tasks/presentation/task_editor_sheet.dart';
import '../../features/today/presentation/today_tab.dart';
import '../providers/providers.dart';
import 'daily_focus_screen.dart';
import 'daily_trail_screen.dart';
import 'reliability_check_screen.dart';

// Re-export UI helpers and editor for backward compatibility
export '../../core/utils/ui_helpers.dart';
export '../../features/tasks/presentation/task_editor_sheet.dart'
    show showDailyEditor;

class DailyHomeScreen extends ConsumerStatefulWidget {
  const DailyHomeScreen({super.key});

  @override
  ConsumerState<DailyHomeScreen> createState() => _DailyHomeScreenState();
}

class _DailyHomeScreenState extends ConsumerState<DailyHomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  )..forward();

  int _tab = 0;
  bool _trailVisited = false;
  bool _focusActive = false;
  StreamSubscription<dynamic>? _actions;
  Timer? _dayTimer;
  DateTime _today = dayOnly(DateTime.now());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dailyTrailProvider).initialize().catchError((Object e) {
        ref.read(dailyTrailProvider).error = readableError(e);
      });
      _consumeNavigation();
      _consumeRepeatAction();
      _syncWidget();
      unawaited(ref.read(dailyRepositoryProvider).drainAndProcessOutbox());
      unawaited(ref.read(dailyRepositoryProvider).reconcile());
      _actions = ref.read(localNotificationServiceProvider).actionEvents.listen(
        (event) async {
          final repository = ref.read(dailyRepositoryProvider);
          final task = await repository.notificationOccurrence(
            event.taskId,
            event.date ?? DateTime.now(),
          );
          if (task == null ||
              task.isArchived ||
              task.status == TaskStatus.completed) {
            return;
          }
          if (event.actionId == 'mark_done') {
            await repository.toggle(task);
          } else if (event.actionId == 'snooze_10') {
            await ref
                .read(localNotificationServiceProvider)
                .scheduleSnooze(task, minutes: 10);
          }
        },
      );
    });
    _dayTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _refreshDay(),
    );
  }

  void _selectTab(int value) {
    ref.read(dailyTrailProvider).setViewing(value == 3);
    setState(() {
      _tab = value;
      if (value == 3) _trailVisited = true;
    });
    if (!MediaQuery.disableAnimationsOf(context)) _entrance.forward(from: 0);
  }

  Future<void> _consumeNavigation() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final tab = await ref.read(nativeDailyBridgeProvider).consumeNavigation();
      if (!mounted || tab == null || _focusActive) return;
      _selectTab(
        tab == 'focus'
            ? 2
            : tab == 'trail'
            ? 3
            : 0,
      );
      if (tab == 'add') unawaited(showDailyEditor(context, ref));
    } catch (_) {
      /* Widget navigation is optional on other hosts. */
    }
  }

  Future<void> _syncWidget() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final now = DateTime.now();
      final tasks = await ref.read(dailyRepositoryProvider).watchDay(now).first;
      if (!mounted) return;
      final done = tasks.where((t) => t.status == TaskStatus.completed).length;
      final next = tasks
          .where(
            (t) =>
                t.status != TaskStatus.completed &&
                t.reminderOffsetMinutes >= 0 &&
                t.startAt.isAfter(now),
          )
          .firstOrNull;
      await ref
          .read(nativeDailyBridgeProvider)
          .updateWidget(
            jsonEncode({
              'date': DateFormat('yyyy-MM-dd').format(now),
              'summary': '$done of ${tasks.length} done',
              'next': next == null
                  ? 'Your day is clear'
                  : '${next.title} - ${DateFormat.jm().format(next.startAt)}',
            }),
          );
    } catch (_) {
      /* The launcher widget is an Android enhancement. */
    }
  }

  void _refreshDay() {
    final now = dayOnly(DateTime.now());
    if (now != _today) {
      if (ref.read(dailyDateProvider) == _today) {
        ref.read(dailyDateProvider.notifier).state = now;
      }
      if (ref.read(dailyTrailProvider).selectedDay == _today) {
        ref.read(dailyTrailProvider).select(now);
      }
      _today = now;
    }
    ref.invalidate(dailyFocusMinutesProvider);
  }

  Future<void> _consumeRepeatAction() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final action = await ref
          .read(nativeDailyBridgeProvider)
          .consumeRepeatAction();
      if (action == null || action['id'] == null || !mounted) return;
      final day =
          DateTime.tryParse(action['day'] as String? ?? '') ?? DateTime.now();
      final task = await ref
          .read(dailyRepositoryProvider)
          .notificationOccurrence((action['id'] as num).toInt(), day);
      if (task == null || !mounted) return;
      if (action['action'] == 'mark_done' &&
          task.status != TaskStatus.completed) {
        await ref.read(dailyRepositoryProvider).toggle(task);
      }
      if (action['action'] == 'snooze_10' &&
          task.status != TaskStatus.completed) {
        await ref
            .read(localNotificationServiceProvider)
            .scheduleSnooze(task, minutes: 10);
      }
      ref.read(dailyDateProvider.notifier).state = dayOnly(day);
      if (!_focusActive) _selectTab(0);
    } catch (e) {
      if (mounted) showMessage(context, readableError(e));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    ref
        .read(dailyTrailProvider)
        .setViewing(state == AppLifecycleState.resumed && _tab == 3);
    if (state == AppLifecycleState.resumed) {
      _refreshDay();
      ref.read(dailyTrailProvider).refresh();
      _consumeNavigation();
      _consumeRepeatAction();
      _syncWidget();
      unawaited(ref.read(dailyRepositoryProvider).drainAndProcessOutbox());
      unawaited(ref.read(dailyRepositoryProvider).reconcile());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _actions?.cancel();
    _dayTimer?.cancel();
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(dailyTasksProvider, (_, _) => _syncWidget());
    final titles = ['Today', 'Calendar', 'Focus', 'Your trail'];
    return Scaffold(
      extendBody: true,
      appBar: _focusActive || _tab == 3
          ? null
          : AppBar(
              title: const Row(
                children: [
                  RememberMark(),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Remember Me',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () => _settings(context),
                ),
              ],
            ),
      body: SafeArea(
        top: _focusActive,
        bottom: _tab != 3,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _tab == 3 ? double.infinity : 760,
            ),
            child: FadeTransition(
              opacity: _entrance,
              child: IndexedStack(
                index: _tab,
                children: [
                  TodayTab(
                    onTrail: () {
                      ref.read(dailyTrailProvider).setViewing(true);
                      ref
                          .read(dailyTrailProvider)
                          .select(ref.read(dailyDateProvider));
                      _selectTab(3);
                    },
                  ),
                  CalendarTab(
                    onTrail: () {
                      ref.read(dailyTrailProvider).setViewing(true);
                      ref
                          .read(dailyTrailProvider)
                          .select(ref.read(dailyDateProvider));
                      _selectTab(3);
                    },
                  ),
                  DailyFocusScreen(
                    onFinished: () => ref.invalidate(dailyFocusMinutesProvider),
                    onActiveChanged: (active) {
                      if (mounted) {
                        setState(() {
                          _focusActive = active;
                          if (active) _tab = 2;
                        });
                      }
                    },
                  ),
                  _trailVisited
                      ? const DailyTrailScreen()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _tab < 2
          ? FloatingActionButton(
              tooltip: 'Add reminder or to-do',
              onPressed: () => showDailyEditor(context, ref),
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: _focusActive
          ? null
          : GlassPanel(
              radius: 0,
              child: NavigationBar(
                selectedIndex: _tab,
                onDestinationSelected: (value) {
                  if (value == 0) {
                    ref.read(dailyDateProvider.notifier).state = dayOnly(
                      DateTime.now(),
                    );
                  }
                  _selectTab(value);
                },
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    selectedIcon: const Icon(Icons.check_circle_rounded),
                    label: titles[0],
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.calendar_month_outlined),
                    selectedIcon: const Icon(Icons.calendar_month_rounded),
                    label: titles[1],
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.timelapse_rounded),
                    label: titles[2],
                  ),
                  const NavigationDestination(
                    icon: Icon(Icons.route_outlined),
                    selectedIcon: Icon(Icons.route_rounded),
                    label: 'Trail',
                  ),
                ],
              ),
            ),
    );
  }

  void _settings(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, _) => Row(
                children: DailyStyle.values
                    .map(
                      (style) => Expanded(
                        child: Column(
                          children: [
                            IconButton(
                              tooltip: '${style.name} theme',
                              onPressed: () => ref
                                  .read(dailyStyleProvider.notifier)
                                  .select(style),
                              icon: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: DailyTheme.accent(style),
                                  shape: BoxShape.circle,
                                ),
                                child: ref.watch(dailyStyleProvider) == style
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      )
                                    : null,
                              ),
                            ),
                            Text(
                              style.name[0].toUpperCase() +
                                  style.name.substring(1),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.widgets_outlined),
              title: const Text('Add home screen widget'),
              trailing: const Icon(Icons.add),
              onTap: () async {
                final added = await ref
                    .read(nativeDailyBridgeProvider)
                    .pinWidget();
                if (context.mounted && !added) {
                  showMessage(
                    context,
                    'Add Remember Me from your launcher\'s widget menu.',
                  );
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.verified_user_outlined),
              title: const Text('Reliability check & sound'),
              subtitle: const Text(
                'Diagnose wakeups, permissions, & alarm volume',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ReliabilityCheckScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Location permissions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await Geolocator.openAppSettings();
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.lock_outline_rounded),
              title: Text('Stored on your device'),
              subtitle: Text(
                'Reminders, focus history, and trails stay on this device. Map tiles use the internet.',
              ),
            ),
            if (kIsWeb)
              const Text(
                'Browser preview: data lasts for this session. Phone notifications and screen pinning are available in the Android app.',
              ),
            if (!kIsWeb && defaultTargetPlatform != TargetPlatform.android)
              const Text(
                'Trail recording on this platform works while the app is open. Background daily trails and screen pinning require Android.',
              ),
          ],
        ),
      ),
    ),
  );
}
