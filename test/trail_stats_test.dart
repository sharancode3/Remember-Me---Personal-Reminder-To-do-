import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';

void main() {
  final start = DateTime(2026, 10, 3, 12);
  TrailFix fix(double latitude, int seconds, {bool gap = false}) => TrailFix(
    LatLng(latitude, 77),
    start.add(Duration(seconds: seconds)),
    5,
    gap: gap,
  );

  test('Empty and single-point trails have finite zero statistics', () {
    for (final points in <List<TrailFix>>[[], [fix(12, 0)]]) {
      final stats = TrailStats(points);
      expect(stats.distance, 0);
      expect(stats.averageSpeed, 0);
      expect(stats.maximumSpeed, 0);
      expect(stats.metersPerMinute, 0);
    }
  });

  test('Duplicate timestamps do not divide by zero or add distance', () {
    final stats = TrailStats([fix(12, 0), fix(12.001, 0)]);
    expect(stats.distance, 0);
    expect(stats.duration, 0);
    expect(stats.averageSpeed.isFinite, isTrue);
  });

  test('Recording resumes after a gap without counting the missing route', () {
    final stats = TrailStats([
      fix(12, 0),
      fix(12.0001, 10),
      fix(13, 200, gap: true),
      fix(13.0001, 210),
    ]);
    expect(stats.distance, closeTo(22.24, .3));
    expect(stats.duration, 20);
    expect(stats.averageSpeed, closeTo(1.112, .02));
  });

  test('A short explicitly marked service gap is also excluded', () {
    final stats = TrailStats([fix(12, 0), fix(12.001, 10, gap: true)]);
    expect(stats.distance, 0);
    expect(stats.maximumSpeed, 0);
  });
}
