import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_bandaid_alarm_logo.dart';
import '../../core/widgets/neo_card.dart';
import '../providers/providers.dart';

class NeoProfileModal extends ConsumerWidget {
  const NeoProfileModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NeoProfileModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.neo;
    final themeMode = ref.watch(selectedThemeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final remindersEnabled = ref.watch(remindersEnabledProvider);
    final autoCarry = ref.watch(autoCarryForwardProvider);
    final aiScheduling = ref.watch(aiSchedulingProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.canvas,
        border: Border(
          top: BorderSide(color: colors.border, width: 4),
          left: BorderSide(color: colors.border, width: 3),
          right: BorderSide(color: colors.border, width: 3),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        24 + MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 52,
              height: 6,
              decoration: BoxDecoration(
                color: colors.border,
                border: Border.all(color: colors.border, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              NeoBandaidAlarmLogo(
                size: 28,
                alarmColor: colors.accentYellow,
                bandaidColor: colors.accentRed,
                borderColor: colors.border,
              ),
              const SizedBox(width: 10),
              Text(
                'SETTINGS & THEME',
                style: NeoTypography.headline(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: colors.accentRed,
                    border: Border.all(color: colors.border, width: 2.5),
                    boxShadow: NeoShadows.small(colors.shadow),
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Theme Switcher (2 Themes: Neo Light & Neo Dark)
          Text(
            'THEME MODE (2 THEMES ONLY)',
            style: NeoTypography.label(
              color: colors.textSecondary,
              fontSize: 11,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(selectedThemeModeProvider.notifier).state = ThemeMode.light,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !isDark ? const Color(0xFFFFD93D) : colors.surface,
                      border: Border.all(
                        color: colors.border,
                        width: !isDark ? 3.5 : 2.0,
                      ),
                      boxShadow: !isDark ? NeoShadows.small(colors.shadow) : null,
                    ),
                    child: Center(
                      child: Text(
                        '⚡ NEO LIGHT',
                        style: NeoTypography.label(
                          color: Colors.black,
                          fontWeight: !isDark ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(selectedThemeModeProvider.notifier).state = ThemeMode.dark,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : colors.surface,
                      border: Border.all(
                        color: colors.border,
                        width: isDark ? 3.5 : 2.0,
                      ),
                      boxShadow: isDark ? NeoShadows.small(colors.shadow) : null,
                    ),
                    child: Center(
                      child: Text(
                        '🌙 NEO DARK',
                        style: NeoTypography.label(
                          color: isDark ? const Color(0xFFFFFDF5) : colors.textPrimary,
                          fontWeight: isDark ? FontWeight.w900 : FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Planning Preferences
          Text(
            'PLANNING PREFERENCES',
            style: NeoTypography.label(
              color: colors.textSecondary,
              fontSize: 11,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),

          NeoCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            hasShadow: false,
            child: Column(
              children: [
                _toggleRow(
                  context,
                  title: 'LOCAL NOTIFICATIONS',
                  value: remindersEnabled,
                  onChanged: (val) {
                    ref.read(plannerActionsProvider).updateNotificationSettings(remindersEnabled: val);
                  },
                ),
                Divider(color: colors.borderMuted, thickness: 1.5),
                _toggleRow(
                  context,
                  title: 'AUTO CARRY FORWARD',
                  value: autoCarry,
                  onChanged: (val) {
                    ref.read(plannerActionsProvider).updateNotificationSettings(autoCarryForwardEnabled: val);
                  },
                ),
                Divider(color: colors.borderMuted, thickness: 1.5),
                _toggleRow(
                  context,
                  title: 'ADAPTIVE TIME ESTIMATES',
                  value: aiScheduling,
                  onChanged: (val) {
                    ref.read(aiSchedulingProvider.notifier).state = val;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Local-First Badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.accentViolet.withValues(alpha: 0.25),
              border: Border.all(color: colors.border, width: 2.5),
              boxShadow: NeoShadows.small(colors.shadow),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline, size: 20, color: colors.border),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Remember Me is 100% local-first and private. Your schedule stays entirely on this device.',
                    style: NeoTypography.body(
                      color: colors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = context.neo;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: NeoTypography.body(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colors.accentYellow,
            activeTrackColor: colors.border,
            inactiveThumbColor: colors.borderMuted,
            inactiveTrackColor: colors.surface,
          ),
        ],
      ),
    );
  }
}
