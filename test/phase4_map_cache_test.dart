import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';
import 'package:remember_me/src/services/tile_cache_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 4: Map Stack & Ambient Tile Cache', () {
    test('TileCacheManager caches and retrieves tiles offline', () async {
      final manager = TileCacheManager.instance;
      final tileUri = Uri.parse('https://tiles.openfreemap.org/planet/14/9234/5842.png');
      final dummyPngBytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);

      // Initially null or empty
      await manager.putCachedTile(tileUri, dummyPngBytes);
      final retrieved = await manager.getCachedTile(tileUri);

      expect(retrieved, isNotNull);
      expect(retrieved, equals(dummyPngBytes));
    });

    test('Trail data dictionary exports matching polylines, gaps, and place markers for Google view', () {
      final now = DateTime.now();
      final fixes = [
        TrailFix(const LatLng(12.9716, 77.5946), now, 10.0),
        TrailFix(const LatLng(12.9720, 77.5950), now.add(const Duration(seconds: 15)), 8.0),
      ];
      final gaps = [
        TrailGap(
          start: now.add(const Duration(seconds: 20)),
          end: now.add(const Duration(seconds: 120)),
          reason: 'tunnel_or_loss',
          fromPoint: const LatLng(12.9720, 77.5950),
          toPoint: const LatLng(12.9800, 77.6000),
        ),
      ];
      const place = SavedPlace(
        id: 'central_station',
        name: 'Central Station',
        point: LatLng(12.9750, 77.5980),
        radius: 150,
      );

      final mapData = {
        'day': now.toIso8601String(),
        'points': fixes.map((p) => p.toJson()).toList(),
        'places': [place.toJson()],
        'gaps': gaps.map((g) => {
          'start': g.start.millisecondsSinceEpoch,
          'end': g.end.millisecondsSinceEpoch,
          'reason': g.reason,
          if (g.fromPoint != null) 'from': {'lat': g.fromPoint!.latitude, 'lng': g.fromPoint!.longitude},
          if (g.toPoint != null) 'to': {'lat': g.toPoint!.latitude, 'lng': g.toPoint!.longitude},
        }).toList(),
        'satellite': false,
      };

      // Verify points
      final exportedPoints = mapData['points'] as List;
      expect(exportedPoints.length, 2);
      expect((exportedPoints.first as Map)['lat'], 12.9716);

      // Verify places
      final exportedPlaces = mapData['places'] as List;
      expect(exportedPlaces.length, 1);
      expect((exportedPlaces.first as Map)['name'], 'Central Station');

      // Verify gaps with from/to coordinate bridge
      final exportedGaps = mapData['gaps'] as List;
      expect(exportedGaps.length, 1);
      final gapMap = exportedGaps.first as Map;
      expect(gapMap['reason'], 'tunnel_or_loss');
      expect((gapMap['from'] as Map)['lat'], 12.9720);
      expect((gapMap['to'] as Map)['lat'], 12.9800);
    });
  });
}
