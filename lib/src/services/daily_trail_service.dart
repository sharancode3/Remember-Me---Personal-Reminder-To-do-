import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../data/repositories/daily_repository.dart';

class TrailFix {
  const TrailFix(
    this.point,
    this.time,
    this.accuracy, {
    this.speed = 0,
    this.gap = false,
  });
  final LatLng point;
  final DateTime time;
  final double accuracy;
  final double speed;
  final bool gap;
  double get lat => point.latitude;
  double get lng => point.longitude;
  Map<String, dynamic> toJson() => {
    'lat': point.latitude,
    'lng': point.longitude,
    'time': time.millisecondsSinceEpoch,
    'accuracy': accuracy,
    'speed': speed,
    'gap': gap,
  };
  factory TrailFix.fromJson(Map<String, dynamic> json) => TrailFix(
    LatLng((json['lat'] as num).toDouble(), (json['lng'] as num).toDouble()),
    json['time'] is num
        ? DateTime.fromMillisecondsSinceEpoch((json['time'] as num).toInt())
        : DateTime.parse(json['time'] as String),
    (json['accuracy'] as num).toDouble(),
    speed: (json['speed'] as num?)?.toDouble() ?? 0,
    gap: json['gap'] == true,
  );
}

class TrailGap {
  const TrailGap({
    required this.start,
    required this.end,
    this.reason = 'tunnel_or_loss',
    this.fromPoint,
    this.toPoint,
  });

  final DateTime start;
  final DateTime end;
  final String reason;
  final LatLng? fromPoint;
  final LatLng? toPoint;

  Duration get duration => end.difference(start);

  Map<String, dynamic> toJson() => {
    'type': 'gap',
    'start': start.millisecondsSinceEpoch,
    'end': end.millisecondsSinceEpoch,
    'reason': reason,
  };

  factory TrailGap.fromJson(Map<String, dynamic> json) => TrailGap(
    start: json['start'] is num
        ? DateTime.fromMillisecondsSinceEpoch((json['start'] as num).toInt())
        : DateTime.parse(json['start'] as String),
    end: json['end'] is num
        ? DateTime.fromMillisecondsSinceEpoch((json['end'] as num).toInt())
        : DateTime.parse(json['end'] as String),
    reason: json['reason'] as String? ?? 'tunnel_or_loss',
  );
}

class SavedPlace {
  const SavedPlace({
    required this.id,
    required this.name,
    required this.point,
    this.radius = 100,
    this.notify = false,
    this.message = '',
    this.dwellSeconds = 90,
  });
  final String id, name, message;
  final LatLng point;
  final double radius;
  final bool notify;
  final int dwellSeconds;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lat': point.latitude,
    'lng': point.longitude,
    'radius': radius,
    'notify': notify,
    'message': message,
    'dwellSeconds': dwellSeconds,
  };
  factory SavedPlace.fromJson(Map<String, dynamic> data) => SavedPlace(
    id: data['id'] as String,
    name: data['name'] as String,
    point: LatLng(
      (data['lat'] as num).toDouble(),
      (data['lng'] as num).toDouble(),
    ),
    radius: (data['radius'] as num).toDouble(),
    notify: data['notify'] == true,
    message: data['message'] as String? ?? '',
    dwellSeconds: (data['dwellSeconds'] as num?)?.toInt() ?? 90,
  );
}

class ParsedTrailPayload {
  const ParsedTrailPayload({required this.fixes, required this.gaps});
  final List<TrailFix> fixes;
  final List<TrailGap> gaps;
}

/// Runs off the main UI thread via [compute] to parse and link large trail datasets without frame drops.
ParsedTrailPayload parseAndProcessTrail(String jsonString) {
  if (jsonString.isEmpty || jsonString == '[]') {
    return const ParsedTrailPayload(fixes: [], gaps: []);
  }

  final rawList = jsonDecode(jsonString) as List;
  final parsedFixes = <TrailFix>[];
  final parsedGaps = <TrailGap>[];

  for (final item in rawList) {
    if (item is! Map) continue;
    final map = Map<String, dynamic>.from(item);
    if (map['type'] == 'gap' ||
        (map.containsKey('start') && map.containsKey('end'))) {
      parsedGaps.add(TrailGap.fromJson(map));
    } else if (map.containsKey('lat') && map.containsKey('lng')) {
      parsedFixes.add(TrailFix.fromJson(map));
    }
  }

  // Link gaps to adjacent points
  final linkedGaps = <TrailGap>[];
  for (final gap in parsedGaps) {
    final from = parsedFixes
        .where((f) => f.time.isBefore(gap.start) || f.time == gap.start)
        .lastOrNull;
    final to = parsedFixes
        .where((f) => f.time.isAfter(gap.end) || f.time == gap.end)
        .firstOrNull;
    linkedGaps.add(
      TrailGap(
        start: gap.start,
        end: gap.end,
        reason: gap.reason,
        fromPoint: from?.point,
        toPoint: to?.point,
      ),
    );
  }

  return ParsedTrailPayload(fixes: parsedFixes, gaps: linkedGaps);
}

class TrailStats {
  TrailStats(List<TrailFix> fixes) {
    const geo = Distance();
    for (var i = 1; i < fixes.length; i++) {
      final seconds =
          fixes[i].time.difference(fixes[i - 1].time).inMilliseconds / 1000;
      if (fixes[i].gap || seconds <= 0 || seconds > 120) continue;
      final meters = geo(fixes[i - 1].point, fixes[i].point);
      if (meters / seconds > 65) continue;
      distance += meters;
      duration += seconds;
      final speed = fixes[i].speed > 0 ? fixes[i].speed : meters / seconds;
      if (speed <= 65 && speed > maximumSpeed) maximumSpeed = speed;
    }
  }
  double distance = 0, duration = 0, maximumSpeed = 0;
  double get averageSpeed => duration == 0 ? 0 : distance / duration;
  double get metersPerMinute => averageSpeed * 60;
}

class DailyTrailService extends ChangeNotifier {
  static const channel = MethodChannel('remember_me/daily');
  bool get android =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  bool enabled = false;
  String? error;
  bool googleConfigured = false;
  List<SavedPlace> places = [];
  final List<TrailFix> _sessionFixes = [];
  StreamSubscription<Position>? _subscription;
  Timer? _poll;
  bool _disposed = false;
  bool _viewing = false;

  void setViewing(bool value) {
    _viewing = value;
    _poll?.cancel();
    if (android && enabled && value && !_disposed) {
      _poll = Timer.periodic(const Duration(seconds: 5), (_) => refresh());
    }
  }

  List<TrailFix> fixes = [];
  List<TrailGap> gaps = [];
  DateTime selectedDay = dayOnly(DateTime.now());

  Future<void> initialize() async {
    if (android) {
      try {
        enabled = await channel.invokeMethod<bool>('trackingEnabled') ?? false;
        try {
          googleConfigured =
              await channel.invokeMethod<bool>('googleConfigured') ?? false;
          final data = await channel.invokeMethod<String>('getPlaces') ?? '[]';
          places = (jsonDecode(data) as List)
              .map(
                (e) => SavedPlace.fromJson(Map<String, dynamic>.from(e as Map)),
              )
              .toList();
        } catch (_) {}
        await refresh();
        if (enabled) await start();
      } catch (e) {
        error = e.toString().replaceFirst('Bad state: ', '');
        enabled = false;
        if (!_disposed) notifyListeners();
      }
      return;
    }
    await refresh();
  }

  Future<void> start() async {
    error = null;
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError('Turn on location services to record your trail.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError(
        'Allow location access in phone settings to record your trail.',
      );
    }
    if (android) {
      if (await Geolocator.getLocationAccuracy() ==
          LocationAccuracyStatus.reduced) {
        throw StateError(
          'Enable precise location in phone settings to record an accurate trail.',
        );
      }
      await channel.invokeMethod<void>('startTracking');
    } else {
      await _subscription?.cancel();
      _subscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 15,
            ),
          ).listen(
            (p) {
              if (p.accuracy > 80) return;
              _sessionFixes.add(
                TrailFix(
                  LatLng(p.latitude, p.longitude),
                  p.timestamp,
                  p.accuracy,
                ),
              );
              refresh();
            },
            onError: (Object e) {
              error =
                  'Location paused. Check your location permission and try again.';
              if (!_disposed) notifyListeners();
            },
          );
    }
    enabled = true;
    setViewing(_viewing);
    await refresh();
  }

  Future<void> stop() async {
    if (android) await channel.invokeMethod<void>('stopTracking');
    await _subscription?.cancel();
    _subscription = null;
    _poll?.cancel();
    enabled = false;
    if (!_disposed) notifyListeners();
  }

  Future<void> select(DateTime day) async {
    selectedDay = dayOnly(day);
    await refresh();
  }

  Future<void> refresh() async {
    final date = selectedDay;
    if (android) {
      try {
        final data = await channel.invokeMethod<String>('readTrail', {
          'day':
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        });
        final payload = await compute(parseAndProcessTrail, data ?? '[]');
        fixes = payload.fixes;
        gaps = payload.gaps;
        final status = await channel.invokeMapMethod<String, dynamic>(
          'trackingStatus',
        );
        error = status?['error'] as String?;
      } on PlatformException catch (e) {
        error = e.message;
      }
    } else {
      fixes = _sessionFixes.where((p) => dayOnly(p.time) == date).toList();
      gaps = [];
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> deleteDay() async {
    if (android) {
      await channel.invokeMethod<void>('deleteTrail', {
        'day':
            '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}',
      });
    } else {
      _sessionFixes.removeWhere((p) => dayOnly(p.time) == selectedDay);
    }
    await refresh();
  }

  Future<void> savePlace(SavedPlace place) async {
    final next = [...places.where((p) => p.id != place.id), place];
    if (android) {
      await channel.invokeMethod<void>('savePlaces', {
        'data': jsonEncode(next.map((p) => p.toJson()).toList()),
      });
    }
    places = next;
    if (!_disposed) notifyListeners();
  }

  Future<void> removePlace(String id) async {
    final next = places.where((p) => p.id != id).toList();
    if (android) {
      await channel.invokeMethod<void>('savePlaces', {
        'data': jsonEncode(next.map((p) => p.toJson()).toList()),
      });
    }
    places = next;
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _poll?.cancel();
    _subscription?.cancel();
    super.dispose();
  }
}
