import 'package:flutter/material.dart';
import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_card.dart';
import 'neo_task_capture_sheet.dart';
import 'notification_center_sheet.dart';
import 'profile_screen.dart';

/// Comprehensive Info / How Remember Me Works Screen (Sections 107, 108, 168)
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const InfoScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        backgroundColor: colors.canvas,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'HOW REMEMBER ME WORKS',
          style: NeoTypography.headline(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.5),
          child: Container(color: colors.border, height: 3.5),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Core Identity Hero
            NeoCard(
              backgroundColor: colors.accentYellow,
              borderColor: colors.border,
              borderWidth: 3.5,
              shadowOffset: const Offset(6, 6),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRODUCT PHILOSOPHY',
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'PLAN LESS. LIVE MORE.',
                    style: NeoTypography.display(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remember Me is an adaptive planning instrument. It learns the difference between what you planned and what actually happened, creating increasingly realistic schedules without guilt or micromanagement.',
                    style: NeoTypography.body(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Guide Sections with "Try It" Deep Links & Animated Badges
            _buildSection(
              context,
              tag: 'COCKPIT',
              title: 'TODAY SCREEN',
              icon: Icons.dashboard_outlined,
              description:
                  'Your daily command center answering what to do right now, what comes next, your high-priority commitments (P1/P2), and your realistic schedulable capacity.',
              tryItLabel: 'OPEN TODAY',
              onTryIt: () => Navigator.pop(context),
            ),
            _buildSection(
              context,
              tag: 'CREATION',
              title: 'FAST NATURAL CAPTURE',
              icon: Icons.edit_note_rounded,
              description:
                  'Type or dictate naturally: "Study physics tomorrow at 7 for 2 hours !P1 #study". Remember Me parses the title, date, time, duration, and priority instantly.',
              tryItLabel: 'CREATE TASK',
              onTryIt: () {
                Navigator.pop(context);
                NeoTaskCaptureSheet.show(context);
              },
            ),
            _buildSection(
              context,
              tag: 'ADAPTIVE',
              title: 'SMART & CONTEXT REMINDERS',
              icon: Icons.notifications_active_outlined,
              description:
                  'Never spammed with useless alerts. Reminders adapt to preparation time, leave-now travel estimates, weather conditions, and whether you tend to start on time.',
              tryItLabel: 'VIEW ALERTS',
              onTryIt: () {
                Navigator.pop(context);
                NeoNotificationCenterSheet.show(context);
              },
            ),
            _buildSection(
              context,
              tag: 'CALENDAR',
              title: 'PLAN & REALITY MIRROR',
              icon: Icons.calendar_view_week_outlined,
              description:
                  'View your workload across Day, Week, and Month lenses. Past days reveal your Reality Mirror—a side-by-side comparison of planned versus executed hours.',
              tryItLabel: 'OPEN PLANNER',
              onTryIt: () => Navigator.pop(context),
            ),
            _buildSection(
              context,
              tag: 'MOVEMENT',
              title: 'JOURNEY & REAL MAP TRACKING',
              icon: Icons.map_outlined,
              description:
                  'Built-in GNSS movement tracking for walking, running, and cycling with genuine street maps, GPS spike filtering, stationary jitter rejection, kilometer splits, and replay.',
              tryItLabel: 'START JOURNEY',
              onTryIt: () => Navigator.pop(context),
            ),
            _buildSection(
              context,
              tag: 'LOCAL-FIRST',
              title: 'PRIVACY & OFFLINE INTELLIGENCE',
              icon: Icons.lock_outline_rounded,
              description:
                  'All tasks, observations, learning profiles, and journey routes are stored strictly on your device in Isar database. Zero external telemetry. Works 100% offline.',
              tryItLabel: 'DATA SETTINGS',
              onTryIt: () {
                Navigator.pop(context);
                ProfileScreen.show(context);
              },
            ),
            const SizedBox(height: 20),

            // Creator Credit Box (Section 168) - Responsive and safe for narrow 360x800
            SafeArea(
              top: false,
              child: Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    border: Border.all(color: colors.border, width: 2.5),
                    boxShadow: NeoShadows.small(colors.shadow),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'BUILT BY SHARAN',
                        style: NeoTypography.label(
                          color: colors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Instagram: @sharans7_',
                        style: NeoTypography.body(
                          color: colors.accentViolet,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String tag,
    required String title,
    required String description,
    required IconData icon,
    required String tryItLabel,
    required VoidCallback onTryIt,
  }) {
    final colors = context.neo;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border, width: 2.5),
        boxShadow: NeoShadows.small(colors.shadow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                color: colors.accentRed,
                child: Text(
                  tag,
                  style: NeoTypography.label(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Spacer(),
              Icon(icon, size: 20, color: colors.textSecondary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: NeoTypography.headline(
              color: colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: NeoTypography.body(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTryIt,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colors.accentYellow,
                border: Border.all(color: colors.border, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tryItLabel,
                    style: NeoTypography.label(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 12, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
