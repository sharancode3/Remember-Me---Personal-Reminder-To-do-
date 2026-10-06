import 'dart:math' as math;
import '../../services/daily_trail_service.dart';

/// High-performance Ramer-Douglas-Peucker (RDP) polyline simplification in Dart.
class TrailDecimator {
  const TrailDecimator._();

  /// Simplifies a polyline of [TrailFix] points using perpendicular distance in meters.
  /// Points closer than [epsilonMeters] to the chord are eliminated.
  static List<TrailFix> decimate(
    List<TrailFix> points, {
    double epsilonMeters = 3.0,
  }) {
    if (points.length <= 2) return points;

    final keep = List<bool>.filled(points.length, false);
    keep[0] = true;
    keep[points.length - 1] = true;

    // Use explicit stack to avoid stack overflow on huge polylines (20k+ points)
    final stack = <(int, int)>[(0, points.length - 1)];

    while (stack.isNotEmpty) {
      final (startIndex, endIndex) = stack.removeLast();
      if (endIndex <= startIndex + 1) continue;

      final start = points[startIndex];
      final end = points[endIndex];

      final latMidRad = ((start.lat + end.lat) / 2.0) * math.pi / 180.0;
      final cosLat = math.cos(latMidRad);

      final dx = (end.lng - start.lng) * cosLat * 111320.0;
      final dy = (end.lat - start.lat) * 110540.0;
      final lineLenSq = dx * dx + dy * dy;

      var maxDist = 0.0;
      var maxIndex = startIndex;

      for (var i = startIndex + 1; i < endIndex; i++) {
        final p = points[i];
        final px = (p.lng - start.lng) * cosLat * 111320.0;
        final py = (p.lat - start.lat) * 110540.0;

        double dist;
        if (lineLenSq < 1e-6) {
          dist = math.sqrt(px * px + py * py);
        } else {
          // Perpendicular distance = |dx*py - dy*px| / sqrt(dx^2 + dy^2)
          dist = (dx * py - dy * px).abs() / math.sqrt(lineLenSq);
        }

        if (dist > maxDist) {
          maxDist = dist;
          maxIndex = i;
        }
      }

      if (maxDist > epsilonMeters) {
        keep[maxIndex] = true;
        stack.add((startIndex, maxIndex));
        stack.add((maxIndex, endIndex));
      }
    }

    final result = <TrailFix>[];
    for (var i = 0; i < points.length; i++) {
      if (keep[i]) result.add(points[i]);
    }
    return result;
  }
}
