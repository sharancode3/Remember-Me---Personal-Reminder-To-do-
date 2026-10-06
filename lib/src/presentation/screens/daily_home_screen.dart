import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/daily_theme.dart';
import '../../services/reminder_recurrence.dart';
import 'dart:convert';
import '../../data/models/task_model.dart';
import '../../data/repositories/daily_repository.dart';
import '../../services/daily_trail_service.dart';
import '../providers/providers.dart';
import 'daily_focus_screen.dart';
import 'daily_trail_screen.dart';
import 'reliability_check_screen.dart';

final dailyRepositoryProvider = Provider<DailyRepository>((ref) {
  final repository = DailyRepository(
    kIsWeb ? null : ref.watch(isarServiceProvider),
    ref.watch(reminderSchedulerProvider),
    ref.watch(localNotificationServiceProvider),
  );
  ref.onDispose(repository.dispose);
  return repository;
});

final dailyTrailProvider = ChangeNotifierProvider<DailyTrailService>(
  (ref) => DailyTrailService(),
);
final dailyDateProvider = StateProvider<DateTime>(
  (ref) => dayOnly(DateTime.now()),
);
final dailyTasksProvider = StreamProvider<List<TaskModel>>(
  (ref) =>
      ref.watch(dailyRepositoryProvider).watchDay(ref.watch(dailyDateProvider)),
);
final dailyMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);
final dailyCountsProvider = FutureProvider<Map<DateTime, int>>((ref) {
  ref.watch(dailyTasksProvider);
  return ref
      .watch(dailyRepositoryProvider)
      .monthCounts(ref.watch(dailyMonthProvider));
});
final dailyFocusMinutesProvider = FutureProvider<int>((ref) async {
  final day = ref.watch(dailyDateProvider);
  final repository = ref.watch(dailyRepositoryProvider);
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    final nativeMinutes =
        await DailyTrailService.channel.invokeMethod<int>('focusMinutes', {
          'start': day.millisecondsSinceEpoch,
          'end': DateTime(
            day.year,
            day.month,
            day.day + 1,
          ).millisecondsSinceEpoch,
        }) ??
        0;
    return nativeMinutes + await repository.focusMinutes(day);
  }
  return repository.focusMinutes(day);
});

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
      final tab = await DailyTrailService.channel.invokeMethod<String>(
        'consumeNavigation',
      );
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
      await DailyTrailService.channel.invokeMethod<void>('updateWidget', {
        'data': jsonEncode({
          'date': DateFormat('yyyy-MM-dd').format(now),
          'summary': '$done of ${tasks.length} done',
          'next': next == null
              ? 'Your day is clear'
              : '${next.title} - ${DateFormat.jm().format(next.startAt)}',
        }),
      });
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
      final action = await DailyTrailService.channel
          .invokeMapMethod<String, dynamic>('consumeRepeatAction');
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
                  _DayView(
                    onTrail: () {
                      ref.read(dailyTrailProvider).setViewing(true);
                      ref
                          .read(dailyTrailProvider)
                          .select(ref.read(dailyDateProvider));
                      _selectTab(3);
                    },
                  ),
                  _CalendarView(
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
                final added = await DailyTrailService.channel
                    .invokeMethod<bool>('pinWidget');
                if (context.mounted && added != true) {
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
              subtitle: const Text('Diagnose wakeups, permissions, & alarm volume'),
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

class _DayView extends ConsumerWidget {
  const _DayView({required this.onTrail});
  final VoidCallback onTrail;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(dailyDateProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day == dayOnly(DateTime.now())
                        ? 'Today'
                        : DateFormat('EEEE').format(day),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMMM d, yyyy').format(day),
                    style: const TextStyle(
                      color: Color(0xFF68756E),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Choose day',
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: day,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (selected != null) {
                  ref.read(dailyDateProvider.notifier).state = selected;
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        _DaySummary(onTrail: onTrail),
        const SizedBox(height: 28),
        const _TaskLists(),
      ],
    );
  }
}

class _DaySummary extends ConsumerWidget {
  const _DaySummary({required this.onTrail});
  final VoidCallback onTrail;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(dailyTasksProvider).valueOrNull ?? [];
    final completed = tasks
        .where((t) => t.status == TaskStatus.completed)
        .length;
    final minutes = ref.watch(dailyFocusMinutesProvider).valueOrNull ?? 0;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _metric(
                '$completed / ${tasks.length}',
                'Done',
                Icons.check_circle_outline,
                const Color(0xFF18765C),
              ),
            ),
            Expanded(
              child: _metric(
                '${minutes}m',
                'Focused',
                Icons.timelapse,
                const Color(0xFF3577B5),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: onTrail,
                borderRadius: BorderRadius.circular(8),
                child: _metric(
                  'View',
                  'Daily trail',
                  Icons.route,
                  const Color(0xFFB45D72),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: tasks.isEmpty ? 0 : completed / tasks.length,
            minHeight: 5,
            backgroundColor: const Color(0xFFE4EBE7),
          ),
        ),
      ],
    );
  }

  Widget _metric(String value, String label, IconData icon, Color color) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(color: Color(0xFF68756E), fontSize: 12),
            ),
          ],
        ),
      );
}

class _TaskLists extends ConsumerWidget {
  const _TaskLists();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(dailyTasksProvider)
      .when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Could not load this day. ${readableError(e)}'),
        data: (tasks) {
          final reminders = tasks
              .where((t) => t.reminderOffsetMinutes >= 0)
              .toList();
          final todos = tasks
              .where((t) => t.reminderOffsetMinutes < 0)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section('Reminders', reminders.length),
              if (reminders.isEmpty)
                const _EmptyLine(
                  icon: Icons.notifications_none_rounded,
                  text: 'No reminders for this day.',
                ),
              ...reminders.map((t) => _TaskRow(task: t)),
              const SizedBox(height: 28),
              _section('To-do', todos.length),
              if (todos.isEmpty)
                const _EmptyLine(
                  icon: Icons.checklist_rounded,
                  text: 'A little space for what needs doing.',
                ),
              ...todos.map((t) => _TaskRow(task: t)),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () => showDailyEditor(context, ref),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add something'),
              ),
            ],
          );
        },
      );
  Widget _section(String label, int count) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 8),
        Text('$count', style: const TextStyle(color: Color(0xFF68756E))),
      ],
    ),
  );
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Row(
      children: [
        Icon(icon, color: const Color(0xFF81958A)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(color: Color(0xFF68756E))),
        ),
      ],
    ),
  );
}

class _TaskRow extends ConsumerWidget {
  const _TaskRow({required this.task});
  final TaskModel task;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = task.status == TaskStatus.completed;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: done
            ? Theme.of(context).colorScheme.primary.withValues(alpha: .06)
            : Colors.white.withValues(alpha: .82),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E9E5)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: done,
            onChanged: (_) async {
              try {
                await ref.read(dailyRepositoryProvider).toggle(task);
              } catch (e) {
                if (context.mounted) showMessage(context, readableError(e));
              }
            },
          ),
          Expanded(
            child: InkWell(
              onTap: () => showDailyEditor(context, ref, task: task),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: done ? TextDecoration.lineThrough : null,
                        color: done
                            ? const Color(0xFF7D8A83)
                            : const Color(0xFF202B27),
                      ),
                    ),
                    if (task.reminderOffsetMinutes >= 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          DateFormat.jm().format(task.startAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF3577B5),
                          ),
                        ),
                      ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF68756E),
                          ),
                        ),
                      ),
                    if (task.recurrenceRule == 'occurrence')
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Icon(Icons.repeat, size: 12),
                            SizedBox(width: 4),
                            Text('Repeating', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    if (task.resolvedPlaceTag != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.place, size: 12, color: Color(0xFF107C41)),
                            const SizedBox(width: 4),
                            Text(
                              task.resolvedPlaceTag!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF107C41),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Reminder options',
            icon: const Icon(Icons.more_horiz, size: 20),
            onSelected: (value) async {
              if (value == 'edit') {
                unawaited(showDailyEditor(context, ref, task: task));
                return;
              }
              try {
                final repository = ref.read(dailyRepositoryProvider);
                if (value == 'stop') {
                  final root = await repository.find(task.templateId!);
                  if (root != null) await repository.remove(root);
                } else {
                  await repository.remove(task);
                }
              } catch (e) {
                if (context.mounted) showMessage(context, readableError(e));
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Text(
                  task.recurrenceRule == 'occurrence'
                      ? 'Edit repeating item'
                      : 'Edit',
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  task.recurrenceRule == 'occurrence'
                      ? 'Skip this day'
                      : 'Delete',
                ),
              ),
              if (task.recurrenceRule == 'occurrence')
                const PopupMenuItem(
                  value: 'stop',
                  child: Text('Stop repeating'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarView extends ConsumerWidget {
  const _CalendarView({required this.onTrail});
  final VoidCallback onTrail;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(dailyMonthProvider);
    final selected = ref.watch(dailyDateProvider);
    final counts = ref.watch(dailyCountsProvider).valueOrNull ?? {};
    final firstOffset = (month.weekday + 6) % 7;
    final length = DateTime(month.year, month.month + 1, 0).day;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      children: [
        const Text(
          'Calendar',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat('MMMM yyyy').format(month),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Previous month',
              onPressed: () => ref.read(dailyMonthProvider.notifier).state =
                  DateTime(month.year, month.month - 1),
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: 'Next month',
              onPressed: () => ref.read(dailyMonthProvider.notifier).state =
                  DateTime(month.year, month.month + 1),
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: const TextStyle(
                        color: Color(0xFF68756E),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ((firstOffset + length) / 7).ceil() * 7,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            mainAxisExtent: 47,
          ),
          itemBuilder: (context, index) {
            final number = index - firstOffset + 1;
            if (number < 1 || number > length) return const SizedBox.shrink();
            final day = DateTime(month.year, month.month, number);
            final active = selected == day;
            return Semantics(
              label: DateFormat.yMMMMd().format(day),
              selected: active,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => ref.read(dailyDateProvider.notifier).state = day,
                child: Container(
                  decoration: BoxDecoration(
                    color: active
                        ? Theme.of(context).colorScheme.primary
                        : day == dayOnly(DateTime.now())
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$number',
                        style: TextStyle(
                          color: active
                              ? Colors.white
                              : const Color(0xFF202B27),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: counts.containsKey(day)
                              ? (active
                                    ? Colors.white
                                    : const Color(0xFF3577B5))
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          DateFormat('EEEE, MMMM d').format(selected),
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _DaySummary(onTrail: onTrail),
        const SizedBox(height: 24),
        const _TaskLists(),
      ],
    );
  }
}

Future<void> showDailyEditor(
  BuildContext context,
  WidgetRef ref, {
  TaskModel? task,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _DailyEditor(day: ref.read(dailyDateProvider), task: task),
  );
}

class _DailyEditor extends ConsumerStatefulWidget {
  const _DailyEditor({required this.day, this.task});
  final DateTime day;
  final TaskModel? task;
  @override
  ConsumerState<_DailyEditor> createState() => _DailyEditorState();
}

class _DailyEditorState extends ConsumerState<_DailyEditor> {
  late final TaskModel _draftTask = widget.task ?? TaskModel();
  late final bool _isOccurrence = widget.task != null &&
      widget.task!.templateId != null &&
      widget.task!.templateId != widget.task!.id;
  late EditRecurrenceScope _editScope = EditRecurrenceScope.thisOccurrenceOnly;
  late final TextEditingController _title = TextEditingController(
    text: widget.task?.title,
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.task?.description,
  );
  late DateTime _date = dayOnly(widget.task?.startAt ?? widget.day);
  late TimeOfDay _time = TimeOfDay.fromDateTime(
    widget.task?.startAt ?? DateTime.now().add(const Duration(hours: 1)),
  );
  late bool _reminder =
      widget.task == null || widget.task!.reminderOffsetMinutes >= 0;
  late bool _isAlarmStyle = widget.task?.isAlarmStyle ?? false;
  late int _nagMinutes = widget.task?.nagMinutes ?? 0;
  late String? _placeId = widget.task?.placeId;
  bool _saving = false;
  late RepeatKind _repeat = ReminderRecurrence.decode(
    widget.task?.recurrenceRule ?? 'none',
  ).kind;
  late Set<int> _days = ReminderRecurrence.decode(
    widget.task?.recurrenceRule ?? 'none',
  ).days.toSet();
  bool _timeOpen = false;
  String? _error;
  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final savedPlaces = ref.watch(dailyTrailProvider).places;
    return SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.task == null ? 'Add something' : 'Edit',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                icon: Icon(Icons.notifications_none),
                label: Text('Reminder'),
              ),
              ButtonSegment(
                value: false,
                icon: Icon(Icons.checklist),
                label: Text('To-do'),
              ),
            ],
            selected: {_reminder},
            onSelectionChanged: _saving
                ? null
                : (value) => setState(() => _reminder = value.first),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            maxLength: 120,
            decoration: const InputDecoration(labelText: 'What needs doing?'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(labelText: 'Note (optional)'),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(DateFormat.yMMMd().format(_date)),
            trailing: const Icon(Icons.chevron_right),
            onTap: _saving
                ? null
                : () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (date != null && mounted) setState(() => _date = date);
                  },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                if (_reminder)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time_rounded),
                    title: Text(_time.format(context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _saving
                        ? null
                        : () => setState(() => _timeOpen = !_timeOpen),
                  ),
                if (_reminder && _timeOpen)
                  SizedBox(
                    height: 160,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            fontFamily:
                                Theme.of(
                                  context,
                                ).textTheme.bodyLarge?.fontFamily ??
                                'Roboto',
                            fontSize: 20,
                            letterSpacing: 0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.time,
                        initialDateTime: DateTime(
                          2026,
                          1,
                          1,
                          _time.hour,
                          _time.minute,
                        ),
                        use24hFormat: MediaQuery.alwaysUse24HourFormatOf(
                          context,
                        ),
                        onDateTimeChanged: (time) => setState(
                          () => _time = TimeOfDay.fromDateTime(time),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          DropdownButtonFormField<RepeatKind>(
            isExpanded: true,
            initialValue: _repeat,
            decoration: const InputDecoration(
              labelText: 'Repeat',
              prefixIcon: Icon(Icons.repeat),
            ),
            items: RepeatKind.values
                .map(
                  (kind) => DropdownMenuItem(
                    value: kind,
                    child: Text(switch (kind) {
                      RepeatKind.none => 'Does not repeat',
                      RepeatKind.daily => 'Every day',
                      RepeatKind.weekly => 'Days of the week',
                      RepeatKind.monthly => 'Dates of the month',
                    }),
                  ),
                )
                .toList(),
            onChanged: _saving
                ? null
                : (kind) => setState(() {
                    _repeat = kind!;
                    _days = {
                      kind == RepeatKind.weekly ? _date.weekday : _date.day,
                    };
                  }),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            child: _repeat == RepeatKind.weekly || _repeat == RepeatKind.monthly
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: List.generate(
                        _repeat == RepeatKind.weekly ? 7 : 31,
                        (index) {
                          final day = index + 1;
                          return FilterChip(
                            label: Text(
                              _repeat == RepeatKind.weekly
                                  ? [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun',
                                    ][index]
                                  : '$day',
                            ),
                            selected: _days.contains(day),
                            onSelected: _saving
                                ? null
                                : (value) => setState(
                                    () => value
                                        ? _days.add(day)
                                        : _days.remove(day),
                                  ),
                          );
                        },
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (_reminder) ...[
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Alarm-style (wake screen)'),
              subtitle: const Text('Plays alarm sound and wakes screen with alert'),
              value: _isAlarmStyle,
              onChanged: _saving ? null : (v) => setState(() => _isAlarmStyle = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              isExpanded: true,
              initialValue: _nagMinutes,
              decoration: const InputDecoration(
                labelText: 'Nag until done',
                prefixIcon: Icon(Icons.repeat_one),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Off (fire once)')),
                DropdownMenuItem(value: 1, child: Text('Repeat every 1 min until done')),
                DropdownMenuItem(value: 5, child: Text('Repeat every 5 min until done')),
                DropdownMenuItem(value: 10, child: Text('Repeat every 10 min until done')),
              ],
              onChanged: _saving ? null : (v) => setState(() => _nagMinutes = v ?? 0),
            ),
          ],
          if (savedPlaces.isNotEmpty) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              isExpanded: true,
              initialValue: savedPlaces.any((p) => p.id == _placeId) ? _placeId : null,
              decoration: const InputDecoration(
                labelText: 'Linked Place (Proximity alert)',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('No place linked'),
                ),
                ...savedPlaces.map(
                  (p) => DropdownMenuItem<String?>(
                    value: p.id,
                    child: Text('${p.name} (${p.radius.toInt()}m)'),
                  ),
                ),
              ],
              onChanged: _saving ? null : (v) => setState(() => _placeId = v),
            ),
          ],
          if (_isOccurrence) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<EditRecurrenceScope>(
              isExpanded: true,
              initialValue: _editScope,
              decoration: const InputDecoration(
                labelText: 'Apply changes to',
                prefixIcon: Icon(Icons.edit_calendar),
              ),
              items: const [
                DropdownMenuItem(
                  value: EditRecurrenceScope.thisOccurrenceOnly,
                  child: Text('This occurrence only'),
                ),
                DropdownMenuItem(
                  value: EditRecurrenceScope.thisAndFuture,
                  child: Text('This and future occurrences'),
                ),
                DropdownMenuItem(
                  value: EditRecurrenceScope.all,
                  child: Text('All occurrences (series)'),
                ),
              ],
              onChanged: _saving ? null : (v) => setState(() => _editScope = v ?? EditRecurrenceScope.thisOccurrenceOnly),
            ),
          ],
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_saving ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
    ),
  );
}

  Future<void> _save() async {
    final title = _title.text.trim();
    final start = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _reminder ? _time.hour : 0,
      _reminder ? _time.minute : 0,
    );
    if (title.isEmpty) {
      setState(() => _error = 'Add a name first.');
      return;
    }
    if ((_repeat == RepeatKind.weekly || _repeat == RepeatKind.monthly) &&
        _days.isEmpty) {
      setState(() => _error = 'Choose at least one day.');
      return;
    }
    if (_reminder &&
        _repeat == RepeatKind.none &&
        !start.isAfter(DateTime.now()) &&
        widget.task?.status != TaskStatus.completed) {
      setState(() => _error = 'Choose a future time for the notification.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_reminder) {
        await ref.read(localNotificationServiceProvider).requestPermissions();
      }
      final task = _draftTask;
      task
        ..title = title
        ..description = _note.text.trim()
        ..startAt = start
        ..endAt = start.add(const Duration(minutes: 1))
        ..reminderOffsetMinutes = _reminder ? 0 : -1
        ..isAlarmStyle = _isAlarmStyle
        ..nagMinutes = _nagMinutes
        ..placeId = _placeId
        ..recurrenceRule = ReminderRecurrence(
          kind: _repeat,
          days: _days.toList(),
        ).encode();
      await ref.read(dailyRepositoryProvider).save(task, scope: _editScope);
      await ref.read(dailyRepositoryProvider).syncTasksByPlace();
      ref.read(dailyDateProvider.notifier).state = _date;
      ref.invalidate(dailyCountsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = readableError(e);
          _saving = false;
        });
      }
    }
  }
}

String readableError(Object error) => error
    .toString()
    .replaceFirst('Bad state: ', '')
    .replaceFirst('Exception: ', '');
void showMessage(BuildContext context, String message) => ScaffoldMessenger.of(
  context,
).showSnackBar(SnackBar(content: Text(message)));
