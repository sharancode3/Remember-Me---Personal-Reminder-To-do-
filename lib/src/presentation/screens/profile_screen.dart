import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_bandaid_alarm_logo.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../providers/providers.dart';

/// Full Profile & Data Management Screen (Sections 104, 105, 140, 142)
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.neo;
    final themeMode = ref.watch(selectedThemeModeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final profile = ref.watch(personalPlanningProfileProvider);

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
          'USER PROFILE & DATA',
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
            // User Header Hero Card
            NeoCard(
              backgroundColor: colors.accentYellow,
              borderColor: colors.border,
              borderWidth: 3.5,
              shadowOffset: const Offset(6, 6),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  NeoBandaidAlarmLogo(
                    size: 44,
                    alarmColor: colors.accentYellow,
                    bandaidColor: colors.accentRed,
                    borderColor: colors.border,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SHARAN',
                          style: NeoTypography.display(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Adaptive Planning Mode Active',
                          style: NeoTypography.body(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Planning Windows & Day Structure
            Text(
              'DAY STRUCTURE & WORK WINDOWS',
              style: NeoTypography.label(
                color: colors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.border, width: 2.5),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Column(
                children: [
                  _buildSettingRow(
                    context,
                    title: 'Wakeup Time',
                    value: '07:00 AM',
                  ),
                  const Divider(height: 16),
                  _buildSettingRow(
                    context,
                    title: 'Deep Work Window',
                    value: '08:30 AM – 12:30 PM',
                  ),
                  const Divider(height: 16),
                  _buildSettingRow(
                    context,
                    title: 'Sleep Commitment',
                    value: '11:00 PM',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Connected Platform Status (Interactive rows)
            Text(
              'CONNECTED PLATFORM SERVICES',
              style: NeoTypography.label(
                color: colors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.border, width: 2.5),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Column(
                children: [
                  _buildInteractiveStatusRow(
                    context,
                    title: 'GNSS Precise Location',
                    status: 'Active (Journey Only)',
                    color: colors.accentYellow,
                    onTap: () {
                      _showServiceDialog(
                        context,
                        title: 'GNSS Precise Location',
                        description:
                            'Location permissions are used solely during active Journeys for tracking speed and distance. Zero background telemetry.',
                      );
                    },
                  ),
                  const Divider(height: 16),
                  _buildInteractiveStatusRow(
                    context,
                    title: 'Health Connect Steps',
                    status: 'Ready (Local Cache)',
                    color: colors.accentViolet,
                    onTap: () {
                      _showServiceDialog(
                        context,
                        title: 'Health Connect Steps',
                        description:
                            'Step counts are read locally from the device pedometer and synced only into your on-device Isar database.',
                      );
                    },
                  ),
                  const Divider(height: 16),
                  _buildInteractiveStatusRow(
                    context,
                    title: 'Local Reminders',
                    status: 'Scheduled (On Device)',
                    color: colors.accentRed,
                    onTap: () {
                      _showServiceDialog(
                        context,
                        title: 'Local Scheduled Reminders',
                        description:
                            'Nudges and task reminders are scheduled strictly on your device using OS exact alarms with zero network communication.',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // App Preferences & Theme
            Text(
              'APPEARANCE & NOTIFICATIONS',
              style: NeoTypography.label(
                color: colors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border.all(color: colors.border, width: 2.5),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Bauhaus Dark Canvas',
                        style: NeoTypography.headline(
                          color: colors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: isDark,
                        activeColor: colors.accentYellow,
                        onChanged: (val) {
                          ref.read(selectedThemeModeProvider.notifier).state =
                              val ? ThemeMode.dark : ThemeMode.light;
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bottom De-emphasized Local Data Controls with Confirmation Dialog
            Text(
              'LOCAL DATA MANAGEMENT',
              style: NeoTypography.label(
                color: colors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            NeoCard(
              backgroundColor: colors.surface,
              borderColor: colors.border,
              borderWidth: 2.0,
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  NeoButton(
                    text: 'CREATE LOCAL DATA BACKUP',
                    variant: NeoButtonVariant.surface,
                    isFullWidth: true,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    fontSize: 11,
                    onPressed: () async {
                      final backupService = ref.read(backupServiceProvider);
                      final path = await backupService.exportNow();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              'Backup created at: $path',
                              style: NeoTypography.body(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  // Destructive Reset Button with Confirmation Dialog
                  GestureDetector(
                    onTap: () => _confirmResetDialog(context, ref),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'RESET LEARNED BEHAVIOR PROFILE',
                        style: NeoTypography.label(
                          color: colors.accentRed,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  void _showServiceDialog(BuildContext context, {required String title, required String description}) {
    final colors = context.neo;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          title.toUpperCase(),
          style: NeoTypography.headline(color: colors.textPrimary, fontSize: 16),
        ),
        content: Text(
          description,
          style: NeoTypography.body(color: colors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: NeoTypography.label(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmResetDialog(BuildContext context, WidgetRef ref) {
    final colors = context.neo;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'RESET LEARNED PROFILE?',
          style: NeoTypography.headline(color: colors.accentRed, fontSize: 16),
        ),
        content: Text(
          'This will clear all observed execution logs, duration predictions, and friction metrics. This action cannot be undone.',
          style: NeoTypography.body(color: colors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: NeoTypography.label(color: colors.textPrimary, fontSize: 12),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(observationStoreProvider).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black,
                  content: Text(
                    'Learned profile reset to defaults.',
                    style: NeoTypography.body(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            },
            child: Text(
              'RESET',
              style: NeoTypography.label(color: colors.accentRed, fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(BuildContext context, {required String title, required String value}) {
    final colors = context.neo;
    return Row(
      children: [
        Text(
          title,
          style: NeoTypography.body(color: colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Text(
          value,
          style: NeoTypography.headline(color: colors.textSecondary, fontSize: 13, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _buildInteractiveStatusRow(
    BuildContext context, {
    required String title,
    required String status,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colors = context.neo;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Text(
            title,
            style: NeoTypography.body(color: colors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            color: color,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  status,
                  style: NeoTypography.label(
                    color: color == colors.accentYellow ? Colors.black : Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.info_outline,
                  size: 11,
                  color: color == colors.accentYellow ? Colors.black : Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
