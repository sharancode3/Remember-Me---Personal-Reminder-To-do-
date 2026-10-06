import 'package:isar/isar.dart';

part 'journey_record_model.g.dart';

@embedded
class KmSplitModel {
  KmSplitModel({this.km = 0, this.elapsedSeconds = 0});

  late int km;
  late int elapsedSeconds;
}

@embedded
class RoutePointModel {
  RoutePointModel({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.timestampOffsetSeconds = 0,
    this.speedKmh = 0.0,
  });

  late double latitude;
  late double longitude;
  late int timestampOffsetSeconds;
  late double speedKmh;
}

@collection
class JourneyRecord {
  Id id = Isar.autoIncrement;

  String? title;

  @Index()
  late String activityType; // 'walk', 'run', 'cycle'

  @Index()
  late DateTime startTime;

  @Index()
  late DateTime endTime;

  double totalDistanceMeters = 0.0;
  int totalDurationSeconds = 0;
  int movingDurationSeconds = 0;
  double averageSpeedKmh = 0.0;

  List<KmSplitModel> kmSplits = [];
  List<RoutePointModel> routePoints = [];
}
