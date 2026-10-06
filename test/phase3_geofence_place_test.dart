import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:remember_me/src/data/models/task_model.dart';
import 'package:remember_me/src/services/daily_trail_service.dart';

void main() {
  group('Phase 3: Place & Task Proximity Linking', () {
    test('TaskModel resolves explicit placeId', () {
      final task = TaskModel()
        ..title = 'Buy organic apples'
        ..placeId = 'store_42';

      expect(task.resolvedPlaceTag, 'store_42');
    });

    test('TaskModel extracts @tag from title when placeId is not set', () {
      final task = TaskModel()
        ..title = 'Pick up packages @postoffice'
        ..description = 'Bring ID';

      expect(task.resolvedPlaceTag, 'postoffice');
    });

    test('TaskModel extracts #tag from title when placeId is not set', () {
      final task = TaskModel()
        ..title = 'Submit project report #office';

      expect(task.resolvedPlaceTag, 'office');
    });

    test('TaskModel extracts @tag from description when title has no tag', () {
      final task = TaskModel()
        ..title = 'Gym workout'
        ..description = 'Leg day session @fitnesscenter';

      expect(task.resolvedPlaceTag, 'fitnesscenter');
    });

    test('TaskModel returns null when neither placeId nor tags are present', () {
      final task = TaskModel()
        ..title = 'Read chapter 4 of clean architecture'
        ..description = 'Take summary notes';

      expect(task.resolvedPlaceTag, isNull);
    });

    test('SavedPlace encodes and decodes dwellSeconds and notify parameters', () {
      const place = SavedPlace(
        id: 'home_hq',
        name: 'Home HQ',
        point: LatLng(12.9716, 77.5946),
        radius: 120,
        notify: true,
        message: 'Welcome back!',
        dwellSeconds: 120,
      );

      final json = place.toJson();
      expect(json['id'], 'home_hq');
      expect(json['name'], 'Home HQ');
      expect(json['lat'], 12.9716);
      expect(json['lng'], 77.5946);
      expect(json['radius'], 120);
      expect(json['notify'], isTrue);
      expect(json['dwellSeconds'], 120);

      final decoded = SavedPlace.fromJson(json);
      expect(decoded.id, place.id);
      expect(decoded.name, place.name);
      expect(decoded.point.latitude, place.point.latitude);
      expect(decoded.point.longitude, place.point.longitude);
      expect(decoded.radius, place.radius);
      expect(decoded.notify, isTrue);
      expect(decoded.dwellSeconds, 120);
    });
  });
}
