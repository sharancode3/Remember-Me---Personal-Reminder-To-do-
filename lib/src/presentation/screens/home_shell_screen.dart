import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_app_bar.dart';
import '../../data/models/task_model.dart';
import '../providers/providers.dart';
import 'analytics_screen.dart';
import 'focus_mode_screen.dart';
import 'info_screen.dart';
import 'notification_center_sheet.dart';
import 'plan_screen.dart';
import 'profile_screen.dart';
import 'today_screen.dart';

class HomeShellScreen extends ConsumerStatefulWidget {
  const HomeShellScreen({super.key});

  @override
  ConsumerState<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends ConsumerState<HomeShellScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(plannerActionsProvider).generateCurrentWeek();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(startupInitializationProvider);
    ref.watch(notificationActionListenerProvider);
    final focus = ref.watch(focusModeProvider);
    final section = ref.watch(appSectionProvider);
    final colors = context.neo;

    Widget screen;
    String screenTitle;

    switch (section) {
      case AppSection.today:
        screen = const TodayScreen();
        screenTitle = 'TODAY';
        break;
      case AppSection.plan:
        screen = const PlanScreen();
        screenTitle = 'PLANNER';
        break;
      case AppSection.insights:
        screen = const AnalyticsScreen();
        screenTitle = 'INSIGHTS';
        break;
    }

    final tasksForDayAsync = ref.watch(tasksForSelectedDayProvider);
    final notificationCount = tasksForDayAsync.when(
      data: (tasks) => tasks
          .where((t) => !t.isArchived && t.reminderOffsetMinutes != -1 && t.status == TaskStatus.pending)
          .length,
      loading: () => 0,
      error: (_, _) => 0,
    );

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: NeoAppBar(
        title: screenTitle,
        onInfoPressed: () => InfoScreen.show(context),
        onNotificationsPressed: () => NeoNotificationCenterSheet.show(context),
        notificationCount: notificationCount,
        onMenuPressed: () => ProfileScreen.show(context),
      ),
      body: Stack(
        children: [
          // Main Body Screen
          Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppTheme.snapDuration,
                  switchInCurve: AppTheme.mechanicalCurve,
                  switchOutCurve: AppTheme.mechanicalCurve,
                  child: KeyedSubtree(
                    key: ValueKey(section),
                    child: screen,
                  ),
                ),
              ),
              // Segmented Chunky Neo-Brutalist 3-Tab Bottom Bar
              _buildNeoBottomNav(context, ref, section),
            ],
          ),

          // Focus Mode Fullscreen Overlay
          if (focus.enabled)
            const Positioned.fill(
              child: FocusModeScreen(),
            ),
        ],
      ),
    );
  }

  Widget _buildNeoBottomNav(
    BuildContext context,
    WidgetRef ref,
    AppSection currentSection,
  ) {
    final colors = context.neo;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.border, width: 4.0),
        ),
      ),
      padding: EdgeInsets.only(bottom: safeBottom),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            _buildNavTab(
              context: context,
              ref: ref,
              label: 'TODAY',
              section: AppSection.today,
              current: currentSection,
              accentColor: colors.accentYellow,
            ),
            Container(width: 3.5, color: colors.border),
            _buildNavTab(
              context: context,
              ref: ref,
              label: 'PLAN',
              section: AppSection.plan,
              current: currentSection,
              accentColor: colors.accentViolet, // Bauhaus Primary Blue
            ),
            Container(width: 3.5, color: colors.border),
            _buildNavTab(
              context: context,
              ref: ref,
              label: 'INSIGHTS',
              section: AppSection.insights,
              current: currentSection,
              accentColor: colors.accentRed, // Bauhaus Primary Red
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTab({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required AppSection section,
    required AppSection current,
    required Color accentColor,
  }) {
    final colors = context.neo;
    final isSelected = current == section;

    final bgColor = isSelected ? accentColor : colors.surface;
    final textColor = isSelected
        ? (section == AppSection.insights ? Colors.white : const Color(0xFF000000))
        : colors.textPrimary;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ref.read(appSectionProvider.notifier).state = section;
        },
        child: Container(
          color: bgColor,
          child: Center(
            child: Text(
              label,
              style: NeoTypography.label(
                color: textColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
