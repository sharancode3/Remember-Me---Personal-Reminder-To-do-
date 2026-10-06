// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_occurrence_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskOccurrenceCollection on Isar {
  IsarCollection<TaskOccurrence> get taskOccurrences => this.collection();
}

const TaskOccurrenceSchema = CollectionSchema(
  name: r'TaskOccurrence',
  id: -1163587584219672540,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'durationMinutesOverride': PropertySchema(
      id: 1,
      name: r'durationMinutesOverride',
      type: IsarType.long,
    ),
    r'noteOverride': PropertySchema(
      id: 2,
      name: r'noteOverride',
      type: IsarType.string,
    ),
    r'notificationId': PropertySchema(
      id: 3,
      name: r'notificationId',
      type: IsarType.long,
    ),
    r'occurrenceDate': PropertySchema(
      id: 4,
      name: r'occurrenceDate',
      type: IsarType.string,
    ),
    r'scheduledAt': PropertySchema(
      id: 5,
      name: r'scheduledAt',
      type: IsarType.dateTime,
    ),
    r'snoozedUntil': PropertySchema(
      id: 6,
      name: r'snoozedUntil',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TaskOccurrencestatusEnumValueMap,
    ),
    r'taskId': PropertySchema(
      id: 8,
      name: r'taskId',
      type: IsarType.long,
    ),
    r'titleOverride': PropertySchema(
      id: 9,
      name: r'titleOverride',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _taskOccurrenceEstimateSize,
  serialize: _taskOccurrenceSerialize,
  deserialize: _taskOccurrenceDeserialize,
  deserializeProp: _taskOccurrenceDeserializeProp,
  idName: r'id',
  indexes: {
    r'taskId_occurrenceDate': IndexSchema(
      id: -5118637582248559012,
      name: r'taskId_occurrenceDate',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'occurrenceDate',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'scheduledAt': IndexSchema(
      id: -1483275037155116518,
      name: r'scheduledAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scheduledAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'notificationId': IndexSchema(
      id: 1533036797414670656,
      name: r'notificationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'notificationId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _taskOccurrenceGetId,
  getLinks: _taskOccurrenceGetLinks,
  attach: _taskOccurrenceAttach,
  version: '3.1.0+1',
);

int _taskOccurrenceEstimateSize(
  TaskOccurrence object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.noteOverride;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.occurrenceDate.length * 3;
  {
    final value = object.titleOverride;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _taskOccurrenceSerialize(
  TaskOccurrence object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.durationMinutesOverride);
  writer.writeString(offsets[2], object.noteOverride);
  writer.writeLong(offsets[3], object.notificationId);
  writer.writeString(offsets[4], object.occurrenceDate);
  writer.writeDateTime(offsets[5], object.scheduledAt);
  writer.writeDateTime(offsets[6], object.snoozedUntil);
  writer.writeByte(offsets[7], object.status.index);
  writer.writeLong(offsets[8], object.taskId);
  writer.writeString(offsets[9], object.titleOverride);
  writer.writeDateTime(offsets[10], object.updatedAt);
}

TaskOccurrence _taskOccurrenceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskOccurrence();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.durationMinutesOverride = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.noteOverride = reader.readStringOrNull(offsets[2]);
  object.notificationId = reader.readLong(offsets[3]);
  object.occurrenceDate = reader.readString(offsets[4]);
  object.scheduledAt = reader.readDateTime(offsets[5]);
  object.snoozedUntil = reader.readDateTimeOrNull(offsets[6]);
  object.status =
      _TaskOccurrencestatusValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          OccurrenceStatus.pending;
  object.taskId = reader.readLong(offsets[8]);
  object.titleOverride = reader.readStringOrNull(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  return object;
}

P _taskOccurrenceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (_TaskOccurrencestatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          OccurrenceStatus.pending) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TaskOccurrencestatusEnumValueMap = {
  'pending': 0,
  'completed': 1,
  'skipped': 2,
};
const _TaskOccurrencestatusValueEnumMap = {
  0: OccurrenceStatus.pending,
  1: OccurrenceStatus.completed,
  2: OccurrenceStatus.skipped,
};

Id _taskOccurrenceGetId(TaskOccurrence object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskOccurrenceGetLinks(TaskOccurrence object) {
  return [];
}

void _taskOccurrenceAttach(
    IsarCollection<dynamic> col, Id id, TaskOccurrence object) {
  object.id = id;
}

extension TaskOccurrenceByIndex on IsarCollection<TaskOccurrence> {
  Future<TaskOccurrence?> getByTaskIdOccurrenceDate(
      int taskId, String occurrenceDate) {
    return getByIndex(r'taskId_occurrenceDate', [taskId, occurrenceDate]);
  }

  TaskOccurrence? getByTaskIdOccurrenceDateSync(
      int taskId, String occurrenceDate) {
    return getByIndexSync(r'taskId_occurrenceDate', [taskId, occurrenceDate]);
  }

  Future<bool> deleteByTaskIdOccurrenceDate(int taskId, String occurrenceDate) {
    return deleteByIndex(r'taskId_occurrenceDate', [taskId, occurrenceDate]);
  }

  bool deleteByTaskIdOccurrenceDateSync(int taskId, String occurrenceDate) {
    return deleteByIndexSync(
        r'taskId_occurrenceDate', [taskId, occurrenceDate]);
  }

  Future<List<TaskOccurrence?>> getAllByTaskIdOccurrenceDate(
      List<int> taskIdValues, List<String> occurrenceDateValues) {
    final len = taskIdValues.length;
    assert(occurrenceDateValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([taskIdValues[i], occurrenceDateValues[i]]);
    }

    return getAllByIndex(r'taskId_occurrenceDate', values);
  }

  List<TaskOccurrence?> getAllByTaskIdOccurrenceDateSync(
      List<int> taskIdValues, List<String> occurrenceDateValues) {
    final len = taskIdValues.length;
    assert(occurrenceDateValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([taskIdValues[i], occurrenceDateValues[i]]);
    }

    return getAllByIndexSync(r'taskId_occurrenceDate', values);
  }

  Future<int> deleteAllByTaskIdOccurrenceDate(
      List<int> taskIdValues, List<String> occurrenceDateValues) {
    final len = taskIdValues.length;
    assert(occurrenceDateValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([taskIdValues[i], occurrenceDateValues[i]]);
    }

    return deleteAllByIndex(r'taskId_occurrenceDate', values);
  }

  int deleteAllByTaskIdOccurrenceDateSync(
      List<int> taskIdValues, List<String> occurrenceDateValues) {
    final len = taskIdValues.length;
    assert(occurrenceDateValues.length == len,
        'All index values must have the same length');
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([taskIdValues[i], occurrenceDateValues[i]]);
    }

    return deleteAllByIndexSync(r'taskId_occurrenceDate', values);
  }

  Future<Id> putByTaskIdOccurrenceDate(TaskOccurrence object) {
    return putByIndex(r'taskId_occurrenceDate', object);
  }

  Id putByTaskIdOccurrenceDateSync(TaskOccurrence object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'taskId_occurrenceDate', object,
        saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTaskIdOccurrenceDate(List<TaskOccurrence> objects) {
    return putAllByIndex(r'taskId_occurrenceDate', objects);
  }

  List<Id> putAllByTaskIdOccurrenceDateSync(List<TaskOccurrence> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'taskId_occurrenceDate', objects,
        saveLinks: saveLinks);
  }
}

extension TaskOccurrenceQueryWhereSort
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QWhere> {
  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhere> anyScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'scheduledAt'),
      );
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhere>
      anyNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'notificationId'),
      );
    });
  }
}

extension TaskOccurrenceQueryWhere
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QWhereClause> {
  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdEqualToAnyOccurrenceDate(int taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId_occurrenceDate',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdNotEqualToAnyOccurrenceDate(int taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdGreaterThanAnyOccurrenceDate(
    int taskId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId_occurrenceDate',
        lower: [taskId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdLessThanAnyOccurrenceDate(
    int taskId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId_occurrenceDate',
        lower: [],
        upper: [taskId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdBetweenAnyOccurrenceDate(
    int lowerTaskId,
    int upperTaskId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskId_occurrenceDate',
        lower: [lowerTaskId],
        includeLower: includeLower,
        upper: [upperTaskId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdOccurrenceDateEqualTo(int taskId, String occurrenceDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId_occurrenceDate',
        value: [taskId, occurrenceDate],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      taskIdEqualToOccurrenceDateNotEqualTo(int taskId, String occurrenceDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [taskId],
              upper: [taskId, occurrenceDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [taskId, occurrenceDate],
              includeLower: false,
              upper: [taskId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [taskId, occurrenceDate],
              includeLower: false,
              upper: [taskId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId_occurrenceDate',
              lower: [taskId],
              upper: [taskId, occurrenceDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      scheduledAtEqualTo(DateTime scheduledAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scheduledAt',
        value: [scheduledAt],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      scheduledAtNotEqualTo(DateTime scheduledAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledAt',
              lower: [],
              upper: [scheduledAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledAt',
              lower: [scheduledAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledAt',
              lower: [scheduledAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scheduledAt',
              lower: [],
              upper: [scheduledAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      scheduledAtGreaterThan(
    DateTime scheduledAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledAt',
        lower: [scheduledAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      scheduledAtLessThan(
    DateTime scheduledAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledAt',
        lower: [],
        upper: [scheduledAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      scheduledAtBetween(
    DateTime lowerScheduledAt,
    DateTime upperScheduledAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scheduledAt',
        lower: [lowerScheduledAt],
        includeLower: includeLower,
        upper: [upperScheduledAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      notificationIdEqualTo(int notificationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'notificationId',
        value: [notificationId],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      notificationIdNotEqualTo(int notificationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [],
              upper: [notificationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [notificationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [notificationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'notificationId',
              lower: [],
              upper: [notificationId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      notificationIdGreaterThan(
    int notificationId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'notificationId',
        lower: [notificationId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      notificationIdLessThan(
    int notificationId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'notificationId',
        lower: [],
        upper: [notificationId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterWhereClause>
      notificationIdBetween(
    int lowerNotificationId,
    int upperNotificationId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'notificationId',
        lower: [lowerNotificationId],
        includeLower: includeLower,
        upper: [upperNotificationId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskOccurrenceQueryFilter
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QFilterCondition> {
  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      durationMinutesOverrideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationMinutesOverride',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      durationMinutesOverrideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationMinutesOverride',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      durationMinutesOverrideEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMinutesOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      durationMinutesOverrideGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMinutesOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      durationMinutesOverrideLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMinutesOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      durationMinutesOverrideBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMinutesOverride',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'noteOverride',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'noteOverride',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteOverride',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteOverride',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteOverride',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      noteOverrideIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteOverride',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      notificationIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      notificationIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      notificationIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notificationId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      notificationIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notificationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurrenceDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occurrenceDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occurrenceDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occurrenceDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'occurrenceDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'occurrenceDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'occurrenceDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'occurrenceDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurrenceDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      occurrenceDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'occurrenceDate',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      scheduledAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      scheduledAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      scheduledAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      scheduledAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      snoozedUntilIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snoozedUntil',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      snoozedUntilIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snoozedUntil',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      snoozedUntilEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      snoozedUntilGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      snoozedUntilLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snoozedUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      snoozedUntilBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snoozedUntil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      statusEqualTo(OccurrenceStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      statusGreaterThan(
    OccurrenceStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      statusLessThan(
    OccurrenceStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      statusBetween(
    OccurrenceStatus lower,
    OccurrenceStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      taskIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      taskIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      taskIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      taskIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'titleOverride',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'titleOverride',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'titleOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'titleOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'titleOverride',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'titleOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'titleOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'titleOverride',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'titleOverride',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'titleOverride',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      titleOverrideIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'titleOverride',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskOccurrenceQueryObject
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QFilterCondition> {}

extension TaskOccurrenceQueryLinks
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QFilterCondition> {}

extension TaskOccurrenceQuerySortBy
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QSortBy> {
  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByDurationMinutesOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutesOverride', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByDurationMinutesOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutesOverride', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByNoteOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteOverride', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByNoteOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteOverride', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByOccurrenceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceDate', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByOccurrenceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceDate', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortBySnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortBySnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByTitleOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleOverride', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByTitleOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleOverride', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TaskOccurrenceQuerySortThenBy
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QSortThenBy> {
  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByDurationMinutesOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutesOverride', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByDurationMinutesOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMinutesOverride', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByNoteOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteOverride', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByNoteOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noteOverride', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByNotificationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationId', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByOccurrenceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceDate', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByOccurrenceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceDate', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenBySnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenBySnoozedUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntil', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByTitleOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleOverride', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByTitleOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleOverride', Sort.desc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TaskOccurrenceQueryWhereDistinct
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct> {
  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByDurationMinutesOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMinutesOverride');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByNoteOverride({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteOverride', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByNotificationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationId');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByOccurrenceDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurrenceDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAt');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctBySnoozedUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozedUntil');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct> distinctByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId');
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByTitleOverride({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleOverride',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskOccurrence, TaskOccurrence, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TaskOccurrenceQueryProperty
    on QueryBuilder<TaskOccurrence, TaskOccurrence, QQueryProperty> {
  QueryBuilder<TaskOccurrence, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskOccurrence, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<TaskOccurrence, int?, QQueryOperations>
      durationMinutesOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMinutesOverride');
    });
  }

  QueryBuilder<TaskOccurrence, String?, QQueryOperations>
      noteOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteOverride');
    });
  }

  QueryBuilder<TaskOccurrence, int, QQueryOperations> notificationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationId');
    });
  }

  QueryBuilder<TaskOccurrence, String, QQueryOperations>
      occurrenceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurrenceDate');
    });
  }

  QueryBuilder<TaskOccurrence, DateTime, QQueryOperations>
      scheduledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAt');
    });
  }

  QueryBuilder<TaskOccurrence, DateTime?, QQueryOperations>
      snoozedUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozedUntil');
    });
  }

  QueryBuilder<TaskOccurrence, OccurrenceStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TaskOccurrence, int, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<TaskOccurrence, String?, QQueryOperations>
      titleOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleOverride');
    });
  }

  QueryBuilder<TaskOccurrence, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
