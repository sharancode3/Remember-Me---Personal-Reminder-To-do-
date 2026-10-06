import 'package:isar/isar.dart';

part 'task_occurrence_model.g.dart';

enum OccurrenceStatus {
  pending,
  completed,
  skipped,
}

@collection
class TaskOccurrence {
  Id id = Isar.autoIncrement;

  @Index(unique: true, composite: [CompositeIndex('occurrenceDate')])
  late int taskId;

  late String occurrenceDate; // 'yyyy-MM-dd'

  @Index()
  late DateTime scheduledAt;

  @enumerated
  OccurrenceStatus status = OccurrenceStatus.pending;

  String? titleOverride;
  String? noteOverride;
  int? durationMinutesOverride;

  @Index()
  late int notificationId; // int32 collision-free ID

  DateTime? completedAt;
  DateTime? snoozedUntil;

  DateTime updatedAt = DateTime.now();
}
