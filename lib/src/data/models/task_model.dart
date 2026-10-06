import 'package:isar/isar.dart';

part 'task_model.g.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed,
  missed,
  archived,
}

@embedded
class ChecklistItemModel {
  ChecklistItemModel({this.text = '', this.isChecked = false});

  late String text;
  late bool isChecked;
}

@embedded
class TaskTagModel {
  TaskTagModel({this.name = '', this.colorValue = 0xFF68D8CF, this.iconCodePoint = 0xe3af});

  late String name;
  late int colorValue;
  late int iconCodePoint;
}

@collection
class TaskModel {
  Id id = Isar.autoIncrement;

  @Index()
  int? templateId;

  late String title;
  String description = '';

  @Index()
  int? categoryId;

  @Index()
  late DateTime startAt;

  @Index()
  late DateTime endAt;

  int priority = 1;
  String recurrenceRule = 'none';
  int reminderOffsetMinutes = 10;
  bool isAlarmStyle = false;
  int nagMinutes = 0;

  @Index()
  String? placeId;

  String? get resolvedPlaceTag {
    if (placeId != null && placeId!.trim().isNotEmpty) return placeId!.trim();
    final pattern = RegExp(r'[@#]([a-zA-Z0-9_\-]+)');
    final titleMatch = pattern.firstMatch(title);
    if (titleMatch != null) return titleMatch.group(1);
    final descMatch = pattern.firstMatch(description);
    if (descMatch != null) return descMatch.group(1);
    return null;
  }

  List<ChecklistItemModel> checklist = [];
  TaskTagModel? tag;

  @enumerated
  TaskStatus status = TaskStatus.pending;

  int completionPercentage = 0;
  bool manuallyRescheduled = false;
  bool isArchived = false;
  DateTime? lastOverdueNudgeAt;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  bool get isDone {
    if (checklist.isEmpty) return false;
    return checklist.every((item) => item.isChecked);
  }
}
