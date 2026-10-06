import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_card.dart';
import '../providers/providers.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.neo;
    final statsAsync = ref.watch(weeklyStatsProvider);
    final productivityAsync = ref.watch(weeklyProductivityProvider);
    final completionByDayAsync = ref.watch(weekDayCompletionProvider);
    final insightsAsync = ref.watch(behavioralInsightsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Planning Accuracy Anti-Guilt Hero Card
          statsAsync.when(
            data: (stats) {
              final accuracy = (stats.completionRate * 100).round().clamp(0, 100);
              final isHigh = accuracy >= 75;

              return NeoCard(
                backgroundColor: isHigh ? colors.accentYellow : colors.surface,
                borderColor: colors.border,
                borderWidth: 3.5,
                shadowOffset: const Offset(8, 8),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: isHigh ? Colors.black : colors.accentViolet,
                          child: Text(
                            'WEEK ACCURACY',
                            style: NeoTypography.label(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$accuracy%',
                          style: NeoTypography.display(
                            color: colors.textPrimary,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'REALISTIC PLANNING SCORE',
                      style: NeoTypography.headline(
                        color: colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isHigh
                        ? 'Great job! Your planned workloads align well with your actual available focus hours.'
                        : 'You tended to schedule slightly more than your historical 6h daily focus limit. Consider leaving 15m buffers.',
                      style: NeoTypography.body(
                        color: colors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 18),

          // 3. Weekly Workload Distribution Bars
          completionByDayAsync.when(
            data: (map) => NeoCard(
              backgroundColor: colors.surface,
              borderColor: colors.border,
              borderWidth: 3.5,
              padding: const EdgeInsets.all(16),
              shadowOffset: const Offset(6, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WEEKLY COMPLETION BREAKDOWN',
                    style: NeoTypography.label(color: colors.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: _buildNeoWeeklyBars(context, map),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 18),

          // 4. Learned Personal Planning Profile & Duration Bias
          Consumer(
            builder: (context, ref, _) {
              final profile = ref.watch(personalPlanningProfileProvider);
              final obsStore = ref.watch(observationStoreProvider);
              final totalObs = obsStore.allObservations.length;
              final biasPct = ((profile.overallDurationBias - 1.0) * 100).round();
              final biasStr = biasPct >= 0 ? '+$biasPct%' : '$biasPct%';

              return NeoCard(
                backgroundColor: colors.surface,
                borderColor: colors.border,
                borderWidth: 3.5,
                padding: const EdgeInsets.all(16),
                shadowOffset: const Offset(6, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'LEARNED PLANNING PROFILE',
                          style: NeoTypography.label(
                            color: colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          color: colors.accentViolet,
                          child: Text(
                            '$totalObs OBSERVATIONS',
                            style: NeoTypography.label(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _insightRow(
                      context,
                      icon: Icons.timer_outlined,
                      title: 'DURATION UNDERESTIMATION BIAS',
                      subtitle: '$biasStr vs Planned (Multiplier: ${profile.overallDurationBias.toStringAsFixed(2)}x)',
                      badgeColor: colors.accentYellow,
                    ),
                    Divider(color: colors.borderMuted, thickness: 1.5, height: 20),
                    _insightRow(
                      context,
                      icon: Icons.hourglass_top_rounded,
                      title: 'AVERAGE START FRICTION DELAY',
                      subtitle: '+${profile.averageStartDelayMinutes.round()} Minutes to begin after schedule',
                      badgeColor: colors.accentRed,
                    ),
                    Divider(color: colors.borderMuted, thickness: 1.5, height: 20),
                    _insightRow(
                      context,
                      icon: Icons.bolt_rounded,
                      title: 'TRANSITION & CONTEXT SWITCH COST',
                      subtitle: '${profile.learnedTransitionTimeMinutes}m required between focus blocks',
                      badgeColor: colors.accentViolet,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          // 5. Friction & Peak Hours Analysis Card
          NeoCard(
            backgroundColor: colors.surface,
            borderColor: colors.border,
            borderWidth: 3.5,
            padding: const EdgeInsets.all(16),
            shadowOffset: const Offset(6, 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OBSERVED FRICTION & PEAK WINDOWS',
                  style: NeoTypography.label(color: colors.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 12),
                productivityAsync.when(
                  data: (prod) {
                    return Column(
                      children: [
                        _insightRow(
                          context,
                          icon: Icons.wb_sunny_rounded,
                          title: 'PEAK FOCUS WINDOW',
                          subtitle: prod.mostProductive2HourWindow,
                          badgeColor: colors.accentYellow,
                        ),
                        Divider(color: colors.borderMuted, thickness: 1.5, height: 20),
                        _insightRow(
                          context,
                          icon: Icons.schedule_rounded,
                          title: 'AVG TASK DURATION',
                          subtitle: '${_avgCompletionMinutes(prod)} Minutes',
                          badgeColor: colors.accentViolet,
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 6. Actionable Guidance Advice
          insightsAsync.when(
            data: (insights) => NeoCard(
              backgroundColor: colors.surface,
              borderColor: colors.border,
              borderWidth: 3.5,
              padding: const EdgeInsets.all(16),
              shadowOffset: const Offset(6, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.accentRed,
                      border: Border.all(color: colors.border, width: 2),
                    ),
                    child: const Icon(Icons.lightbulb_outline, size: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIONABLE SUGGESTION',
                          style: NeoTypography.label(
                            color: colors.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insights.suggestedWindow,
                          style: NeoTypography.headline(
                            color: colors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _insightRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color badgeColor,
  }) {
    final colors = context.neo;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: badgeColor,
            border: Border.all(color: colors.border, width: 2),
          ),
          child: Icon(icon, size: 18, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: NeoTypography.label(color: colors.textSecondary, fontSize: 10),
              ),
              Text(
                subtitle,
                style: NeoTypography.headline(color: colors.textPrimary, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNeoWeeklyBars(BuildContext context, Map<DateTime, double> data) {
    final colors = context.neo;
    final entries = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: entries.map((entry) {
        final comp = entry.value.clamp(0.0, 1.0);
        final dayLabel = DateFormat('E').format(entry.key).substring(0, 1);

        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 22,
                    height: (100 * (comp == 0 ? 0.08 : comp)),
                    decoration: BoxDecoration(
                      color: comp >= 0.7 ? colors.accentYellow : colors.accentViolet,
                      border: Border.all(color: colors.border, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                dayLabel,
                style: NeoTypography.label(
                  color: colors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  int _avgCompletionMinutes(dynamic productivity) {
    if (productivity.totalCompletedMinutes == 0) return 35;
    final estimateCount = (productivity.totalCompletedMinutes / 45).round().clamp(1, 999);
    return (productivity.totalCompletedMinutes / estimateCount).round();
  }
}
