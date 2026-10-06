import 'package:isar/isar.dart';

part 'focus_session_model.g.dart';

@collection
class FocusSessionModel {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startedAt;

  DateTime? endedAt;
  int? taskInstanceId;
  bool deepFocus = false;
  int uninterruptedMinutes = 0;
}
