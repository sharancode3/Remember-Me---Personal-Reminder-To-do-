import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/local/isar_service.dart';
import '../data/models/focus_session_model.dart';
import '../data/models/task_model.dart';
import '../data/models/task_occurrence_model.dart';

class BackupService {
  BackupService(this._isarService);

  final IsarService _isarService;

  Future<String?> exportNow() async {
    if (kIsWeb) return null;
    final baseDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${baseDir.path}/backups');
    if (!backupDir.existsSync()) {
      backupDir.createSync(recursive: true);
    }

    final tasks = await _isarService.isar.taskModels.where().findAll();
    final focusSessions = await _isarService.isar.focusSessionModels
        .where()
        .findAll();
    final occurrences = await _isarService.isar.taskOccurrences
        .where()
        .findAll();

    final payload = {
      'schemaVersion': 3,
      'exportedAt': DateTime.now().toIso8601String(),
      'tasks': tasks.map(_taskToJson).toList(),
      'focusSessions': focusSessions.map(_focusSessionToJson).toList(),
      'occurrences': occurrences.map(_occurrenceToJson).toList(),
    };

    final path =
        '${backupDir.path}/remember_me_backup_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(path);
    await file.writeAsString(jsonEncode(payload));
    return path;
  }

  Future<void> restoreFromFile(String path) async {
    if (kIsWeb) return;
    final file = File(path);
    if (!await file.exists()) return;
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    final tasks = (json['tasks'] as List<dynamic>? ?? [])
        .map((item) => _taskFromJson(item as Map<String, dynamic>))
        .toList();
    final focusSessions = (json['focusSessions'] as List<dynamic>? ?? [])
        .map((item) => _focusSessionFromJson(item as Map<String, dynamic>))
        .toList();
    final occurrences = (json['occurrences'] as List<dynamic>? ?? [])
        .map((item) => _occurrenceFromJson(item as Map<String, dynamic>))
        .toList();

    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.taskModels.clear();
      await _isarService.isar.focusSessionModels.clear();
      await _isarService.isar.taskOccurrences.clear();

      await _isarService.isar.taskModels.putAll(tasks);
      await _isarService.isar.focusSessionModels.putAll(focusSessions);
      await _isarService.isar.taskOccurrences.putAll(occurrences);
    });
  }

  Map<String, dynamic> _taskToJson(TaskModel task) => {
    'id': task.id,
    'templateId': task.templateId,
    'title': task.title,
    'description': task.description,
    'startAt': task.startAt.toIso8601String(),
    'endAt': task.endAt.toIso8601String(),
    'priority': task.priority,
    'recurrenceRule': task.recurrenceRule,
    'reminderOffsetMinutes': task.reminderOffsetMinutes,
    'status': task.status.name,
    'completionPercentage': task.completionPercentage,
    'isArchived': task.isArchived,
    'checklist': task.checklist
        .map((c) => {'text': c.text, 'isChecked': c.isChecked})
        .toList(),
    'tag': task.tag == null
        ? null
        : {
            'name': task.tag!.name,
            'colorValue': task.tag!.colorValue,
            'iconCodePoint': task.tag!.iconCodePoint,
          },
    'createdAt': task.createdAt.toIso8601String(),
    'updatedAt': task.updatedAt.toIso8601String(),
  };

  TaskModel _taskFromJson(Map<String, dynamic> json) {
    final task = TaskModel()
      ..id = json['id'] as int? ?? Isar.autoIncrement
      ..templateId = json['templateId'] as int?
      ..title = json['title'] as String? ?? ''
      ..description = json['description'] as String? ?? ''
      ..startAt =
          DateTime.tryParse(json['startAt'] as String? ?? '') ?? DateTime.now()
      ..endAt =
          DateTime.tryParse(json['endAt'] as String? ?? '') ??
          DateTime.now().add(const Duration(hours: 1))
      ..priority = json['priority'] as int? ?? 1
      ..recurrenceRule = json['recurrenceRule'] as String? ?? 'none'
      ..reminderOffsetMinutes = json['reminderOffsetMinutes'] as int? ?? 10
      ..status = TaskStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TaskStatus.pending,
      )
      ..completionPercentage = json['completionPercentage'] as int? ?? 0
      ..isArchived = json['isArchived'] as bool? ?? false
      ..createdAt =
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now()
      ..updatedAt =
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now();

    final checklistJson = json['checklist'] as List<dynamic>? ?? [];
    task.checklist = checklistJson.map((c) {
      final map = c as Map<String, dynamic>;
      return ChecklistItemModel(
        text: map['text'] as String? ?? '',
        isChecked: map['isChecked'] as bool? ?? false,
      );
    }).toList();

    if (json['tag'] != null) {
      final tagMap = json['tag'] as Map<String, dynamic>;
      task.tag = TaskTagModel(
        name: tagMap['name'] as String? ?? '',
        colorValue: tagMap['colorValue'] as int? ?? 0xFF68D8CF,
        iconCodePoint: tagMap['iconCodePoint'] as int? ?? 0xe3af,
      );
    }
    return task;
  }

  Map<String, dynamic> _focusSessionToJson(FocusSessionModel session) => {
    'id': session.id,
    'startedAt': session.startedAt.toIso8601String(),
    'endedAt': session.endedAt?.toIso8601String(),
    'deepFocus': session.deepFocus,
    'uninterruptedMinutes': session.uninterruptedMinutes,
  };

  FocusSessionModel _focusSessionFromJson(Map<String, dynamic> json) =>
      FocusSessionModel()
        ..id = json['id'] as int? ?? Isar.autoIncrement
        ..startedAt =
            DateTime.tryParse(json['startedAt'] as String? ?? '') ??
            DateTime.now()
        ..endedAt = json['endedAt'] != null
            ? DateTime.tryParse(json['endedAt'] as String)
            : null
        ..deepFocus = json['deepFocus'] as bool? ?? false
        ..uninterruptedMinutes = json['uninterruptedMinutes'] as int? ?? 0;

  Map<String, dynamic> _occurrenceToJson(TaskOccurrence occurrence) => {
    'id': occurrence.id,
    'taskId': occurrence.taskId,
    'occurrenceDate': occurrence.occurrenceDate,
    'scheduledAt': occurrence.scheduledAt.toIso8601String(),
    'status': occurrence.status.name,
    'noteOverride': occurrence.noteOverride,
    'durationMinutesOverride': occurrence.durationMinutesOverride,
    'notificationId': occurrence.notificationId,
    'updatedAt': occurrence.updatedAt.toIso8601String(),
  };

  TaskOccurrence _occurrenceFromJson(Map<String, dynamic> json) =>
      TaskOccurrence()
        ..id = json['id'] as int? ?? Isar.autoIncrement
        ..taskId = json['taskId'] as int? ?? 0
        ..occurrenceDate = json['occurrenceDate'] as String? ?? ''
        ..scheduledAt =
            DateTime.tryParse(json['scheduledAt'] as String? ?? '') ??
            DateTime.now()
        ..status = OccurrenceStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => OccurrenceStatus.pending,
        )
        ..noteOverride = json['noteOverride'] as String?
        ..durationMinutesOverride = json['durationMinutesOverride'] as int?
        ..notificationId = json['notificationId'] as int? ?? 0
        ..updatedAt =
            DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now();
}
