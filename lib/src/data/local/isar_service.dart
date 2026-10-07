import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/focus_session_model.dart';
import '../models/task_model.dart';
import '../models/task_occurrence_model.dart';

class IsarService {
  IsarService._(this.isar);

  final Isar isar;

  static Future<IsarService> open() async {
    late final String directory;
    if (kIsWeb) {
      directory = '';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      directory = dir.path;
    }
    final isar = await Isar.open(
      [TaskModelSchema, FocusSessionModelSchema, TaskOccurrenceSchema],
      directory: directory,
      name: 'remember_me_db',
    );
    return IsarService._(isar);
  }
}
