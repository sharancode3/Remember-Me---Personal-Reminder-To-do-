import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';

void main() {
  group('Phase 2 - Trail Engine & Gap Visualization Tests', () {
    test('FlutterMap StrokePattern works with dashed line', () {
      final poly = Polyline(
        points: const [LatLng(12.0, 77.0), LatLng(12.1, 77.1)],
        pattern: StrokePattern.dashed(segments: const [6, 6]),
        color: Colors.grey,
        strokeWidth: 2,
      );
      expect(poly.pattern, isNotNull);
    });

    test('TrailGap serializes and deserializes correctly', () {
      final start = DateTime(2026, 10, 6, 12, 0);
      final end = DateTime(2026, 10, 6, 12, 12);
      final gap = TrailGap(
        start: start,
        end: end,
        reason: 'tunnel_or_loss',
        fromPoint: const LatLng(12.0, 77.0),
        toPoint: const LatLng(12.072, 77.0),
      );

      final json = gap.toJson();
      expect(json['type'], 'gap');
      expect(json['start'], start.millisecondsSinceEpoch);
      expect(json['end'], end.millisecondsSinceEpoch);
      expect(json['reason'], 'tunnel_or_loss');

      final restored = TrailGap.fromJson(json);
      expect(restored.start, start);
      expect(restored.end, end);
      expect(restored.duration.inMinutes, 12);
    });

    test('TrailStats does not accumulate distance across gaps', () {
      const geo = Distance();
      final p1 = const LatLng(12.0, 77.0);
      final p2 = const LatLng(12.001, 77.0); // ~111m away
      // 12-minute tunnel blackout to p3
      final p3 = const LatLng(12.072, 77.0); // ~8km away
      final p4 = const LatLng(12.073, 77.0); // ~111m away

      final t1 = DateTime(2026, 10, 6, 12, 0, 0);
      final t2 = DateTime(2026, 10, 6, 12, 0, 5);
      final t3 = DateTime(2026, 10, 6, 12, 12, 0); // gap of 715s!
      final t4 = DateTime(2026, 10, 6, 12, 12, 5);

      final fixes = [
        TrailFix(p1, t1, 5.0, speed: 20.0, gap: false),
        TrailFix(p2, t2, 5.0, speed: 20.0, gap: false),
        TrailFix(p3, t3, 60.0, speed: 20.0, gap: true),
        TrailFix(p4, t4, 20.0, speed: 20.0, gap: false),
      ];

      final stats = TrailStats(fixes);
      final expectedSegment1 = geo(p1, p2);
      final expectedSegment2 = geo(p3, p4);
      final expectedTotal = expectedSegment1 + expectedSegment2;

      // Distance across the 8km tunnel gap must NOT be included in recorded walking/travel distance!
      expect(stats.distance, closeTo(expectedTotal, 5.0));
      expect(stats.distance, lessThan(500.0));
    });

    test('Segment splitting separates points at gaps or long intervals', () {
      final t0 = DateTime(2026, 10, 6, 10, 0, 0);
      final fixes = [
        TrailFix(const LatLng(12.0, 77.0), t0, 5.0),
        TrailFix(const LatLng(12.001, 77.0), t0.add(const Duration(seconds: 5)), 5.0),
        // Gap here:
        TrailFix(const LatLng(12.05, 77.0), t0.add(const Duration(minutes: 10)), 50.0, gap: true),
        TrailFix(const LatLng(12.051, 77.0), t0.add(const Duration(minutes: 10, seconds: 5)), 20.0),
      ];

      final segments = <List<LatLng>>[];
      for (var i = 0; i < fixes.length; i++) {
        if (i == 0 ||
            fixes[i].gap ||
            fixes[i].time.difference(fixes[i - 1].time).inSeconds > 60) {
          segments.add([]);
        }
        segments.last.add(fixes[i].point);
      }

      expect(segments.length, 2);
      expect(segments[0].length, 2);
      expect(segments[1].length, 2);
    });
  });
}
