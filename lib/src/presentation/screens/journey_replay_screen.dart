import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import '../../core/theme/neo_colors.dart';
import '../../core/theme/neo_shadows.dart';
import '../../core/theme/neo_typography.dart';
import '../../core/widgets/neo_card.dart';
import '../../data/models/journey_record_model.dart';

class JourneyReplayScreen extends StatelessWidget {
  const JourneyReplayScreen({super.key, required this.journey});

  final JourneyRecord journey;

  static Future<void> show(BuildContext context, JourneyRecord journey) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JourneyReplayScreen(journey: journey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.neo;
    final distKm = journey.totalDistanceMeters / 1000.0;
    final duration = Duration(seconds: journey.totalDurationSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    final timeStr = hours > 0
        ? '${hours}h ${minutes}m ${seconds}s'
        : '${minutes}m ${seconds.toString().padLeft(2, "0")}s';

    final points = journey.routePoints
        .map((p) => ll.LatLng(p.latitude, p.longitude))
        .toList();

    final centerCoord = points.isNotEmpty
        ? points[points.length ~/ 2]
        : const ll.LatLng(12.9716, 77.5946);

    final paceMinPerKm = distKm > 0.05 && journey.movingDurationSeconds > 0
        ? (journey.movingDurationSeconds / 60.0) / distKm
        : 0.0;

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
          journey.title?.toUpperCase() ?? 'ROUTE REPLAY',
          style: NeoTypography.headline(
            color: colors.textPrimary,
            fontSize: 17,
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
            // Map Container
            Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E9EC),
                border: Border.all(color: colors.border, width: 3.5),
                boxShadow: NeoShadows.small(colors.shadow),
              ),
              child: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: centerCoord,
                      initialZoom: 15.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.rememberme.app',
                        maxZoom: 19,
                      ),
                      if (points.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: points,
                              strokeWidth: 5.0,
                              color: colors.accentRed,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          if (points.isNotEmpty)
                            Marker(
                              point: points.first,
                              width: 32,
                              height: 32,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors.accentYellow,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: colors.border, width: 2.5),
                                ),
                                child: const Icon(Icons.flag, size: 16, color: Colors.black),
                              ),
                            ),
                          if (points.length > 1)
                            Marker(
                              point: points.last,
                              width: 32,
                              height: 32,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colors.accentRed,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                ),
                                child: const Icon(Icons.check, size: 16, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: colors.border, width: 2),
                      ),
                      child: Text(
                        'SAVED ROUTE (${points.length} GPS POINTS)',
                        style: NeoTypography.label(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Performance Stat Cards Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'TOTAL DISTANCE',
                    value: '${distKm.toStringAsFixed(2)} km',
                    accent: colors.accentYellow,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'TOTAL TIME',
                    value: timeStr,
                    accent: colors.surface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'AVG SPEED',
                    value: '${journey.averageSpeedKmh.toStringAsFixed(1)} km/h',
                    accent: colors.surface,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    title: 'AVG PACE',
                    value: '${paceMinPerKm.toStringAsFixed(1)} m/km',
                    accent: colors.surface,
                  ),
                ),
              ],
            ),

            if (journey.kmSplits.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'KILOMETER SPLITS',
                style: NeoTypography.headline(
                  color: colors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              NeoCard(
                backgroundColor: colors.surface,
                borderColor: colors.border,
                borderWidth: 3,
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: journey.kmSplits.map((split) {
                    final splitDuration = Duration(seconds: split.elapsedSeconds);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'KM ${split.km}',
                            style: NeoTypography.headline(
                              color: colors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '${splitDuration.inMinutes}m ${(splitDuration.inSeconds % 60).toString().padLeft(2, "0")}s',
                            style: NeoTypography.body(
                              color: colors.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String title,
    required String value,
    required Color accent,
  }) {
    final colors = context.neo;

    return NeoCard(
      backgroundColor: accent,
      borderColor: colors.border,
      borderWidth: 2.5,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: NeoTypography.label(
              color: accent == colors.accentYellow ? Colors.black : colors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: NeoTypography.headline(
              color: accent == colors.accentYellow ? Colors.black : colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
