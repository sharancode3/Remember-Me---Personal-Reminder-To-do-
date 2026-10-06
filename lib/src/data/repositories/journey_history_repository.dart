import 'package:isar/isar.dart';
import '../local/isar_service.dart';
import '../models/journey_record_model.dart';

abstract class JourneyHistoryRepository {
  Future<int> saveJourneyRecord(JourneyRecord record);
  Future<List<JourneyRecord>> getAllJourneys();
  Future<JourneyRecord?> getJourneyById(int id);
  Future<void> deleteJourney(int id);
  Stream<List<JourneyRecord>> watchAllJourneys();
}

class JourneyHistoryRepositoryImpl implements JourneyHistoryRepository {
  JourneyHistoryRepositoryImpl(this._isarService);

  final IsarService? _isarService;

  Isar? get _isar => _isarService?.isar;

  // In-memory fallback for testing / web
  final List<JourneyRecord> _inMemoryStore = [];

  @override
  Future<int> saveJourneyRecord(JourneyRecord record) async {
    final isar = _isar;
    if (isar != null) {
      return await isar.writeTxn(() async {
        return await isar.journeyRecords.put(record);
      });
    } else {
      if (record.id == 0 || record.id == Isar.autoIncrement) {
        record.id = _inMemoryStore.length + 1;
      }
      _inMemoryStore.removeWhere((r) => r.id == record.id);
      _inMemoryStore.add(record);
      return record.id;
    }
  }

  @override
  Future<List<JourneyRecord>> getAllJourneys() async {
    final isar = _isar;
    if (isar != null) {
      return await isar.journeyRecords.where().sortByStartTimeDesc().findAll();
    } else {
      final list = [..._inMemoryStore];
      list.sort((a, b) => b.startTime.compareTo(a.startTime));
      return list;
    }
  }

  @override
  Future<JourneyRecord?> getJourneyById(int id) async {
    final isar = _isar;
    if (isar != null) {
      return await isar.journeyRecords.get(id);
    } else {
      return _inMemoryStore.where((r) => r.id == id).firstOrNull;
    }
  }

  @override
  Future<void> deleteJourney(int id) async {
    final isar = _isar;
    if (isar != null) {
      await isar.writeTxn(() async {
        await isar.journeyRecords.delete(id);
      });
    } else {
      _inMemoryStore.removeWhere((r) => r.id == id);
    }
  }

  @override
  Stream<List<JourneyRecord>> watchAllJourneys() {
    final isar = _isar;
    if (isar != null) {
      return isar.journeyRecords.where().sortByStartTimeDesc().watch(fireImmediately: true);
    } else {
      final list = [..._inMemoryStore];
      list.sort((a, b) => b.startTime.compareTo(a.startTime));
      return Stream.value(list);
    }
  }
}
