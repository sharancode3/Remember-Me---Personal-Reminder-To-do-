import 'package:isar/isar.dart';

import 'task_model.dart';

part 'routine_template_model.g.dart';

@collection
class RoutineTemplateModel {
  Id id = Isar.autoIncrement;

  late String title;
  late int startMinuteOfDay;
  late int endMinuteOfDay;
  int reminderOffsetMinutes = 10;
  late List<int> weekdays;
  late List<String> checklistBlueprint;
  TaskTagModel? tag;
  bool isActive = true;
}
