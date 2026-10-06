import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/local/isar_service.dart';
import '../data/models/advanced_models.dart';

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

    final templates = await _isarService.isar.taskTemplateModels.where().findAll();
    final instances = await _isarService.isar.taskInstanceModels.where().findAll();
    final checklist = await _isarService.isar.checklistItems.where().findAll();
    final categories = await _isarService.isar.categoryModels.where().findAll();
    final weekly = await _isarService.isar.weeklySummaryCaches.where().findAll();
    final settings = await _isarService.isar.appSettingsModels.where().findAll();
    final blueprint = await _isarService.isar.blueprintProfileModels.where().findAll();
    final fixedBlocks = await _isarService.isar.fixedActivityBlockModels.where().findAll();

    final payload = {
      'schemaVersion': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'templates': templates.map((e) => _templateToJson(e)).toList(),
      'instances': instances.map((e) => _instanceToJson(e)).toList(),
      'checklist': checklist.map((e) => _checklistToJson(e)).toList(),
      'categories': categories.map((e) => _categoryToJson(e)).toList(),
      'weeklyAnalytics': weekly.map((e) => _weeklyToJson(e)).toList(),
      'settings': settings.map((e) => _settingsToJson(e)).toList(),
      'blueprint': blueprint.map((e) => _blueprintToJson(e)).toList(),
      'fixedBlocks': fixedBlocks.map((e) => _fixedBlockToJson(e)).toList(),
    };

    final path = '${backupDir.path}/remember_me_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(path);
    await file.writeAsString(jsonEncode(payload));
    return path;
  }

  Future<void> restoreFromFile(String path) async {
    if (kIsWeb) return;
    final file = File(path);
    if (!await file.exists()) return;
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    final templates = (json['templates'] as List<dynamic>? ?? [])
        .map((item) => _templateFromJson(item as Map<String, dynamic>))
        .toList();
    final instances = (json['instances'] as List<dynamic>? ?? [])
        .map((item) => _instanceFromJson(item as Map<String, dynamic>))
        .toList();
    final checklist = (json['checklist'] as List<dynamic>? ?? [])
        .map((item) => _checklistFromJson(item as Map<String, dynamic>))
        .toList();
    final categories = (json['categories'] as List<dynamic>? ?? [])
        .map((item) => _categoryFromJson(item as Map<String, dynamic>))
        .toList();
    final weekly = (json['weeklyAnalytics'] as List<dynamic>? ?? [])
        .map((item) => _weeklyFromJson(item as Map<String, dynamic>))
        .toList();
    final settings = (json['settings'] as List<dynamic>? ?? [])
      .map((item) => _settingsFromJson(item as Map<String, dynamic>))
      .toList();
    final blueprint = (json['blueprint'] as List<dynamic>? ?? [])
      .map((item) => _blueprintFromJson(item as Map<String, dynamic>))
      .toList();
    final fixedBlocks = (json['fixedBlocks'] as List<dynamic>? ?? [])
      .map((item) => _fixedBlockFromJson(item as Map<String, dynamic>))
      .toList();

    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.taskTemplateModels.clear();
      await _isarService.isar.taskInstanceModels.clear();
      await _isarService.isar.checklistItems.clear();
      await _isarService.isar.categoryModels.clear();
      await _isarService.isar.weeklySummaryCaches.clear();
      await _isarService.isar.appSettingsModels.clear();
      await _isarService.isar.blueprintProfileModels.clear();
      await _isarService.isar.fixedActivityBlockModels.clear();

      await _isarService.isar.taskTemplateModels.putAll(templates);
      await _isarService.isar.taskInstanceModels.putAll(instances);
      await _isarService.isar.checklistItems.putAll(checklist);
      await _isarService.isar.categoryModels.putAll(categories);
      await _isarService.isar.weeklySummaryCaches.putAll(weekly);
      await _isarService.isar.appSettingsModels.putAll(settings);
      await _isarService.isar.blueprintProfileModels.putAll(blueprint);
      await _isarService.isar.fixedActivityBlockModels.putAll(fixedBlocks);
    });
  }

  Future<void> autoBackupIfDue() async {
    if (kIsWeb) return;
    final docs = await getApplicationDocumentsDirectory();
    final marker = File('${docs.path}/backups/last_auto_backup.txt');
    DateTime? last;
    if (await marker.exists()) {
      final content = await marker.readAsString();
      last = DateTime.tryParse(content);
    }
    if (last != null && DateTime.now().difference(last).inDays < 7) {
      return;
    }
    final path = await exportNow();
    if (path != null) {
      await marker.parent.create(recursive: true);
      await marker.writeAsString(DateTime.now().toIso8601String());
    }
  }

  Map<String, dynamic> _templateToJson(TaskTemplateModel model) => {
        'id': model.id,
        'title': model.title,
        'description': model.description,
        'categoryId': model.categoryId,
        'startTime': model.startTime,
        'endTime': model.endTime,
        'recurrencePattern': model.recurrencePattern.index,
        'weekdayMask': model.weekdayMask,
        'isStaticRoutine': model.isStaticRoutine,
        'defaultReminderOffsetMinutes': model.defaultReminderOffsetMinutes,
        'createdAt': model.createdAt.toIso8601String(),
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  TaskTemplateModel _templateFromJson(Map<String, dynamic> json) {
    final model = TaskTemplateModel()
      ..id = (json['id'] as num).toInt()
      ..title = json['title'] as String
      ..description = (json['description'] as String?) ?? ''
      ..categoryId = (json['categoryId'] as num?)?.toInt()
      ..startTime = (json['startTime'] as num).toInt()
      ..endTime = (json['endTime'] as num).toInt()
      ..recurrencePattern = RecurrencePattern.values[(json['recurrencePattern'] as num).toInt()]
      ..weekdayMask = (json['weekdayMask'] as num).toInt()
      ..isStaticRoutine = (json['isStaticRoutine'] as bool?) ?? false
      ..defaultReminderOffsetMinutes = (json['defaultReminderOffsetMinutes'] as num?)?.toInt() ?? 10
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..updatedAt = DateTime.parse(json['updatedAt'] as String);
    return model;
  }

  Map<String, dynamic> _instanceToJson(TaskInstanceModel model) => {
        'id': model.id,
        'templateId': model.templateId,
        'date': model.date.toIso8601String(),
        'startTime': model.startTime,
        'endTime': model.endTime,
        'title': model.title,
        'description': model.description,
        'categoryId': model.categoryId,
        'status': model.status.index,
        'completionPercentage': model.completionPercentage,
        'manuallyRescheduled': model.manuallyRescheduled,
        'isArchived': model.isArchived,
        'createdAt': model.createdAt.toIso8601String(),
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  TaskInstanceModel _instanceFromJson(Map<String, dynamic> json) {
    final model = TaskInstanceModel()
      ..id = (json['id'] as num).toInt()
      ..templateId = (json['templateId'] as num?)?.toInt()
      ..date = DateTime.parse(json['date'] as String)
      ..startTime = (json['startTime'] as num).toInt()
      ..endTime = (json['endTime'] as num).toInt()
      ..title = json['title'] as String
      ..description = (json['description'] as String?) ?? ''
      ..categoryId = (json['categoryId'] as num?)?.toInt()
      ..status = TaskLifecycleStatus.values[(json['status'] as num?)?.toInt() ?? 0]
      ..completionPercentage = (json['completionPercentage'] as num?)?.toInt() ?? 0
      ..manuallyRescheduled = (json['manuallyRescheduled'] as bool?) ?? false
      ..isArchived = (json['isArchived'] as bool?) ?? false
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..updatedAt = DateTime.parse(json['updatedAt'] as String);
    return model;
  }

  Map<String, dynamic> _checklistToJson(ChecklistItem item) => {
        'id': item.id,
        'taskInstanceId': item.taskInstanceId,
        'title': item.title,
        'isCompleted': item.isCompleted,
      };

  ChecklistItem _checklistFromJson(Map<String, dynamic> json) {
    final item = ChecklistItem()
      ..id = (json['id'] as num).toInt()
      ..taskInstanceId = (json['taskInstanceId'] as num).toInt()
      ..title = json['title'] as String
      ..isCompleted = (json['isCompleted'] as bool?) ?? false;
    return item;
  }

  Map<String, dynamic> _categoryToJson(CategoryModel model) => {
        'id': model.id,
        'name': model.name,
        'colorHex': model.colorHex,
        'iconCodePoint': model.iconCodePoint,
      };

  CategoryModel _categoryFromJson(Map<String, dynamic> json) {
    final model = CategoryModel()
      ..id = (json['id'] as num).toInt()
      ..name = json['name'] as String
      ..colorHex = json['colorHex'] as String
      ..iconCodePoint = (json['iconCodePoint'] as num).toInt();
    return model;
  }

  Map<String, dynamic> _weeklyToJson(WeeklySummaryCache model) => {
        'id': model.id,
        'weekStartDate': model.weekStartDate.toIso8601String(),
        'completionRate': model.completionRate,
        'totalFocusedMinutes': model.totalFocusedMinutes,
        'missedCount': model.missedCount,
        'mostProductiveDay': model.mostProductiveDay,
        'totalScheduledMinutes': model.totalScheduledMinutes,
        'totalCompletedMinutes': model.totalCompletedMinutes,
        'categoryWiseProductivityJson': model.categoryWiseProductivityJson,
        'mostProductive2HourWindow': model.mostProductive2HourWindow,
        'mostMissedTimeSlot': model.mostMissedTimeSlot,
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  WeeklySummaryCache _weeklyFromJson(Map<String, dynamic> json) {
    final model = WeeklySummaryCache()
      ..id = (json['id'] as num).toInt()
      ..weekStartDate = DateTime.parse(json['weekStartDate'] as String)
      ..completionRate = (json['completionRate'] as num).toDouble()
      ..totalFocusedMinutes = (json['totalFocusedMinutes'] as num).toInt()
      ..missedCount = (json['missedCount'] as num).toInt()
      ..mostProductiveDay = (json['mostProductiveDay'] as num).toInt()
      ..totalScheduledMinutes = (json['totalScheduledMinutes'] as num?)?.toInt() ?? 0
      ..totalCompletedMinutes = (json['totalCompletedMinutes'] as num?)?.toInt() ?? 0
      ..categoryWiseProductivityJson = (json['categoryWiseProductivityJson'] as String?) ?? '{}'
      ..mostProductive2HourWindow = (json['mostProductive2HourWindow'] as String?) ?? 'N/A'
      ..mostMissedTimeSlot = (json['mostMissedTimeSlot'] as String?) ?? 'N/A'
      ..updatedAt = DateTime.parse(json['updatedAt'] as String);
    return model;
  }

  Map<String, dynamic> _settingsToJson(AppSettingsModel model) => {
        'id': model.id,
        'remindersEnabled': model.remindersEnabled,
        'defaultReminderOffsetMinutes': model.defaultReminderOffsetMinutes,
        'dailySummaryEnabled': model.dailySummaryEnabled,
        'dailySummaryHour': model.dailySummaryHour,
        'dailySummaryMinute': model.dailySummaryMinute,
        'overdueAlertsEnabled': model.overdueAlertsEnabled,
        'autoCarryForwardEnabled': model.autoCarryForwardEnabled,
        'showRealismLegend': model.showRealismLegend,
        'lastDailySummarySentAt': model.lastDailySummarySentAt?.toIso8601String(),
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  AppSettingsModel _settingsFromJson(Map<String, dynamic> json) {
    return AppSettingsModel()
      ..id = (json['id'] as num?)?.toInt() ?? 1
      ..remindersEnabled = (json['remindersEnabled'] as bool?) ?? true
      ..defaultReminderOffsetMinutes = (json['defaultReminderOffsetMinutes'] as num?)?.toInt() ?? 10
      ..dailySummaryEnabled = (json['dailySummaryEnabled'] as bool?) ?? true
      ..dailySummaryHour = (json['dailySummaryHour'] as num?)?.toInt() ?? 21
      ..dailySummaryMinute = (json['dailySummaryMinute'] as num?)?.toInt() ?? 0
      ..overdueAlertsEnabled = (json['overdueAlertsEnabled'] as bool?) ?? true
      ..autoCarryForwardEnabled = (json['autoCarryForwardEnabled'] as bool?) ?? true
        ..showRealismLegend = (json['showRealismLegend'] as bool?) ?? true
      ..lastDailySummarySentAt = json['lastDailySummarySentAt'] == null
          ? null
          : DateTime.parse(json['lastDailySummarySentAt'] as String)
      ..updatedAt = DateTime.parse((json['updatedAt'] as String?) ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> _blueprintToJson(BlueprintProfileModel model) => {
        'id': model.id,
        'wakeMinuteOfDay': model.wakeMinuteOfDay,
        'sleepMinuteOfDay': model.sleepMinuteOfDay,
        'mode': model.mode.index,
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  BlueprintProfileModel _blueprintFromJson(Map<String, dynamic> json) {
    return BlueprintProfileModel()
      ..id = (json['id'] as num?)?.toInt() ?? 1
      ..wakeMinuteOfDay = (json['wakeMinuteOfDay'] as num?)?.toInt() ?? 7 * 60
      ..sleepMinuteOfDay = (json['sleepMinuteOfDay'] as num?)?.toInt() ?? 23 * 60
      ..mode = BlueprintMode.values[(json['mode'] as num?)?.toInt() ?? 0]
      ..updatedAt = DateTime.parse((json['updatedAt'] as String?) ?? DateTime.now().toIso8601String());
  }

  Map<String, dynamic> _fixedBlockToJson(FixedActivityBlockModel model) => {
        'id': model.id,
        'title': model.title,
        'startMinuteOfDay': model.startMinuteOfDay,
        'endMinuteOfDay': model.endMinuteOfDay,
        'weekdayMask': model.weekdayMask,
        'type': model.type.index,
        'colorValue': model.colorValue,
        'createdAt': model.createdAt.toIso8601String(),
        'updatedAt': model.updatedAt.toIso8601String(),
      };

  FixedActivityBlockModel _fixedBlockFromJson(Map<String, dynamic> json) {
    return FixedActivityBlockModel()
      ..id = (json['id'] as num?)?.toInt() ?? 0
      ..title = (json['title'] as String?) ?? ''
      ..startMinuteOfDay = (json['startMinuteOfDay'] as num?)?.toInt() ?? 9 * 60
      ..endMinuteOfDay = (json['endMinuteOfDay'] as num?)?.toInt() ?? 10 * 60
      ..weekdayMask = (json['weekdayMask'] as num?)?.toInt() ?? 0
      ..type = FixedActivityType.values[(json['type'] as num?)?.toInt() ?? 4]
      ..colorValue = (json['colorValue'] as num?)?.toInt() ?? 0xFF4F8CFF
      ..createdAt = DateTime.parse((json['createdAt'] as String?) ?? DateTime.now().toIso8601String())
      ..updatedAt = DateTime.parse((json['updatedAt'] as String?) ?? DateTime.now().toIso8601String());
  }
}
