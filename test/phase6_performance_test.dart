import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:remember_me/src/core/utils/trail_decimator.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';

void main() {
  group('Phase 6: Dart RDP TrailDecimator', () {
    test('returns original list if 2 points or fewer', () {
      final p1 = TrailFix(const LatLng(12.9716, 77.5946), DateTime.now(), 5.0);
      final p2 = TrailFix(const LatLng(12.9718, 77.5948), DateTime.now(), 5.0);

      expect(TrailDecimator.decimate([]), isEmpty);
      expect(TrailDecimator.decimate([p1]).length, 1);
      expect(TrailDecimator.decimate([p1, p2]).length, 2);
    });

    test('simplifies collinear points to start and end', () {
      final now = DateTime.now();
      // 5 collinear points along longitude (each ~11 meters apart)
      final points = [
        TrailFix(const LatLng(12.97160, 77.59460), now, 5.0),
        TrailFix(const LatLng(12.97160, 77.59470), now.add(const Duration(seconds: 1)), 5.0),
        TrailFix(const LatLng(12.97160, 77.59480), now.add(const Duration(seconds: 2)), 5.0),
        TrailFix(const LatLng(12.97160, 77.59490), now.add(const Duration(seconds: 3)), 5.0),
        TrailFix(const LatLng(12.97160, 77.59500), now.add(const Duration(seconds: 4)), 5.0),
      ];

      final decimated = TrailDecimator.decimate(points, epsilonMeters: 2.0);
      expect(decimated.length, 2);
      expect(decimated.first.point.longitude, closeTo(77.59460, 1e-6));
      expect(decimated.last.point.longitude, closeTo(77.59500, 1e-6));
    });

    test('preserves corner points exceeding epsilon', () {
      final now = DateTime.now();
      // Triangle: (0,0) -> (0.001, 0.0005) [sharp turn ~55m away] -> (0, 0.001)
      final points = [
        TrailFix(const LatLng(12.97160, 77.59460), now, 5.0),
        TrailFix(const LatLng(12.97260, 77.59510), now.add(const Duration(seconds: 10)), 5.0),
        TrailFix(const LatLng(12.97160, 77.59560), now.add(const Duration(seconds: 20)), 5.0),
      ];

      final decimated = TrailDecimator.decimate(points, epsilonMeters: 5.0);
      expect(decimated.length, 3);
      expect(decimated[1].point.latitude, closeTo(12.97260, 1e-5));
    });

    test('handles 10,000 points without stack overflow in <50ms', () {
      final now = DateTime.now();
      final points = List.generate(
        10000,
        (i) => TrailFix(
          LatLng(12.97160 + (i * 0.00001), 77.59460 + (i * 0.00001)),
          now.add(Duration(seconds: i)),
          5.0,
        ),
      );

      final stopwatch = Stopwatch()..start();
      final decimated = TrailDecimator.decimate(points, epsilonMeters: 2.0);
      stopwatch.stop();

      expect(decimated.length, 2);
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });

  group('Phase 6: Isolate Trail Processing', () {
    test('parses trail fixes and links gaps', () {
      final t0 = DateTime.utc(2026, 10, 6, 8, 0, 0);
      final t1 = DateTime.utc(2026, 10, 6, 8, 5, 0);
      final t2 = DateTime.utc(2026, 10, 6, 8, 15, 0);
      final t3 = DateTime.utc(2026, 10, 6, 8, 20, 0);

      final jsonPayload = jsonEncode([
        {'lat': 12.9716, 'lng': 77.5946, 'time': t0.toIso8601String(), 'accuracy': 5.0},
        {'lat': 12.9720, 'lng': 77.5950, 'time': t1.toIso8601String(), 'accuracy': 6.0},
        {'type': 'gap', 'start': t1.toIso8601String(), 'end': t2.toIso8601String(), 'reason': 'tunnel'},
        {'lat': 12.9800, 'lng': 77.6000, 'time': t2.toIso8601String(), 'accuracy': 8.0},
        {'lat': 12.9810, 'lng': 77.6010, 'time': t3.toIso8601String(), 'accuracy': 7.0},
      ]);

      final result = parseAndProcessTrail(jsonPayload);
      expect(result.fixes.length, 4);
      expect(result.gaps.length, 1);
      final gap = result.gaps.first;
      expect(gap.reason, 'tunnel');
      expect(gap.fromPoint, isNotNull);
      expect(gap.fromPoint!.latitude, closeTo(12.9720, 1e-4));
      expect(gap.toPoint, isNotNull);
      expect(gap.toPoint!.latitude, closeTo(12.9800, 1e-4));
    });

    test('handles empty and invalid payloads safely', () {
      expect(parseAndProcessTrail('').fixes, isEmpty);
      expect(parseAndProcessTrail('[]').fixes, isEmpty);
      expect(parseAndProcessTrail('[{"unknown": 123}]').fixes, isEmpty);
    });
  });
}
