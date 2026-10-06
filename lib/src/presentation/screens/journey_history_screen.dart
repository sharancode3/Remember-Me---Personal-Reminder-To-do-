import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_button.dart';
import '../../core/widgets/neo_card.dart';
import '../../data/models/journey_record_model.dart';
import '../providers/providers.dart';
import 'journey_replay_screen.dart';

class JourneyHistoryScreen extends ConsumerWidget {
  const JourneyHistoryScreen({super.key});

  static Future<void> show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const JourneyHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.neo;
    final journeysAsync = ref.watch(journeysListStreamProvider);

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
          'WALK / RUN HISTORY',
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
      body: journeysAsync.when(
        data: (journeys) {
          if (journeys.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.accentYellow,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.border, width: 3),
                      ),
                      child: const Icon(Icons.directions_walk, size: 36, color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'NO JOURNEYS RECORDED YET',
                      style: NeoTypography.headline(
                        color: colors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete your first walk, run, or cycle to trace your route on the world map and review your history.',
                      textAlign: TextAlign.center,
                      style: NeoTypography.body(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: journeys.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final journey = journeys[index];
              return _buildJourneyCard(context, ref, journey);
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: colors.accentYellow),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error loading history: $err',
            style: NeoTypography.body(color: colors.accentRed),
          ),
        ),
      ),
    );
  }

  Widget _buildJourneyCard(BuildContext context, WidgetRef ref, JourneyRecord journey) {
    final colors = context.neo;
    final distKm = journey.totalDistanceMeters / 1000.0;
    final duration = Duration(seconds: journey.totalDurationSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final timeStr = hours > 0
        ? '${hours}h ${minutes}m'
        : '${minutes}m ${seconds.toString().padLeft(2, "0")}s';

    final icon = switch (journey.activityType.toLowerCase()) {
      'run' => Icons.directions_run,
      'cycle' || 'cycling' => Icons.directions_bike,
      _ => Icons.directions_walk,
    };

    final dateStr = DateFormat('EEE, MMM d, yyyy • h:mm a').format(journey.startTime);

    return GestureDetector(
      onTap: () {
        JourneyReplayScreen.show(context, journey);
      },
      child: NeoCard(
        backgroundColor: colors.surface,
        borderColor: colors.border,
        borderWidth: 3,
        shadowOffset: const Offset(4, 4),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.accentYellow,
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: Icon(icon, color: Colors.black, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (journey.title?.isNotEmpty == true)
                            ? journey.title!.toUpperCase()
                            : '${journey.activityType.toUpperCase()} SESSION',
                        style: NeoTypography.headline(
                          color: colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        dateStr,
                        style: NeoTypography.body(
                          color: colors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: const Color(0xFF1040C0),
                  child: Text(
                    'REPLAY →',
                    style: NeoTypography.label(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(color: colors.border, height: 1.5),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat(context, 'DISTANCE', '${distKm.toStringAsFixed(2)} KM'),
                _buildStat(context, 'DURATION', timeStr),
                _buildStat(context, 'AVG SPEED', '${journey.averageSpeedKmh.toStringAsFixed(1)} KM/H'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    final colors = context.neo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: NeoTypography.label(
            color: colors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: NeoTypography.headline(
            color: colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
