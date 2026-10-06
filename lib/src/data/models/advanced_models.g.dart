// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskTemplateModelCollection on Isar {
  IsarCollection<TaskTemplateModel> get taskTemplateModels => this.collection();
}

const TaskTemplateModelSchema = CollectionSchema(
  name: r'TaskTemplateModel',
  id: -9197701679169174787,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'defaultReminderOffsetMinutes': PropertySchema(
      id: 2,
      name: r'defaultReminderOffsetMinutes',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 3,
      name: r'description',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(
      id: 4,
      name: r'endTime',
      type: IsarType.long,
    ),
    r'isStaticRoutine': PropertySchema(
      id: 5,
      name: r'isStaticRoutine',
      type: IsarType.bool,
    ),
    r'recurrencePattern': PropertySchema(
      id: 6,
      name: r'recurrencePattern',
      type: IsarType.byte,
      enumMap: _TaskTemplateModelrecurrencePatternEnumValueMap,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 8,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekdayMask': PropertySchema(
      id: 10,
      name: r'weekdayMask',
      type: IsarType.long,
    )
  },
  estimateSize: _taskTemplateModelEstimateSize,
  serialize: _taskTemplateModelSerialize,
  deserialize: _taskTemplateModelDeserialize,
  deserializeProp: _taskTemplateModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'categoryId': IndexSchema(
      id: -8798048739239305339,
      name: r'categoryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _taskTemplateModelGetId,
  getLinks: _taskTemplateModelGetLinks,
  attach: _taskTemplateModelAttach,
  version: '3.1.0+1',
);

int _taskTemplateModelEstimateSize(
  TaskTemplateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _taskTemplateModelSerialize(
  TaskTemplateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.defaultReminderOffsetMinutes);
  writer.writeString(offsets[3], object.description);
  writer.writeLong(offsets[4], object.endTime);
  writer.writeBool(offsets[5], object.isStaticRoutine);
  writer.writeByte(offsets[6], object.recurrencePattern.index);
  writer.writeLong(offsets[7], object.startTime);
  writer.writeString(offsets[8], object.title);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeLong(offsets[10], object.weekdayMask);
}

TaskTemplateModel _taskTemplateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskTemplateModel();
  object.categoryId = reader.readLongOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.defaultReminderOffsetMinutes = reader.readLong(offsets[2]);
  object.description = reader.readString(offsets[3]);
  object.endTime = reader.readLong(offsets[4]);
  object.id = id;
  object.isStaticRoutine = reader.readBool(offsets[5]);
  object.recurrencePattern = _TaskTemplateModelrecurrencePatternValueEnumMap[
          reader.readByteOrNull(offsets[6])] ??
      RecurrencePattern.daily;
  object.startTime = reader.readLong(offsets[7]);
  object.title = reader.readString(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.weekdayMask = reader.readLong(offsets[10]);
  return object;
}

P _taskTemplateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (_TaskTemplateModelrecurrencePatternValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RecurrencePattern.daily) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TaskTemplateModelrecurrencePatternEnumValueMap = {
  'daily': 0,
  'weekly': 1,
  'customWeekdays': 2,
};
const _TaskTemplateModelrecurrencePatternValueEnumMap = {
  0: RecurrencePattern.daily,
  1: RecurrencePattern.weekly,
  2: RecurrencePattern.customWeekdays,
};

Id _taskTemplateModelGetId(TaskTemplateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskTemplateModelGetLinks(
    TaskTemplateModel object) {
  return [];
}

void _taskTemplateModelAttach(
    IsarCollection<dynamic> col, Id id, TaskTemplateModel object) {
  object.id = id;
}

extension TaskTemplateModelQueryWhereSort
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QWhere> {
  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhere>
      anyCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'categoryId'),
      );
    });
  }
}

extension TaskTemplateModelQueryWhere
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QWhereClause> {
  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [null],
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdEqualTo(int? categoryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [categoryId],
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdNotEqualTo(int? categoryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdGreaterThan(
    int? categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [categoryId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdLessThan(
    int? categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [],
        upper: [categoryId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterWhereClause>
      categoryIdBetween(
    int? lowerCategoryId,
    int? upperCategoryId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [lowerCategoryId],
        includeLower: includeLower,
        upper: [upperCategoryId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskTemplateModelQueryFilter
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QFilterCondition> {
  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      categoryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      categoryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      categoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultReminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultReminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultReminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultReminderOffsetMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      endTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      endTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      endTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      endTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      isStaticRoutineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isStaticRoutine',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      recurrencePatternEqualTo(RecurrencePattern value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recurrencePattern',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      recurrencePatternGreaterThan(
    RecurrencePattern value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recurrencePattern',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      recurrencePatternLessThan(
    RecurrencePattern value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recurrencePattern',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      recurrencePatternBetween(
    RecurrencePattern lower,
    RecurrencePattern upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recurrencePattern',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      startTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      startTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      startTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      startTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
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

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      weekdayMaskEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdayMask',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      weekdayMaskGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekdayMask',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      weekdayMaskLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekdayMask',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterFilterCondition>
      weekdayMaskBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekdayMask',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskTemplateModelQueryObject
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QFilterCondition> {}

extension TaskTemplateModelQueryLinks
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QFilterCondition> {}

extension TaskTemplateModelQuerySortBy
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QSortBy> {
  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByDefaultReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByDefaultReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByIsStaticRoutine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStaticRoutine', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByIsStaticRoutineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStaticRoutine', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByRecurrencePattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrencePattern', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByRecurrencePatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrencePattern', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByWeekdayMask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      sortByWeekdayMaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.desc);
    });
  }
}

extension TaskTemplateModelQuerySortThenBy
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QSortThenBy> {
  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByDefaultReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByDefaultReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByIsStaticRoutine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStaticRoutine', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByIsStaticRoutineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isStaticRoutine', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByRecurrencePattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrencePattern', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByRecurrencePatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurrencePattern', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByWeekdayMask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.asc);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QAfterSortBy>
      thenByWeekdayMaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.desc);
    });
  }
}

extension TaskTemplateModelQueryWhereDistinct
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct> {
  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByDefaultReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultReminderOffsetMinutes');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByIsStaticRoutine() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isStaticRoutine');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByRecurrencePattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurrencePattern');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<TaskTemplateModel, TaskTemplateModel, QDistinct>
      distinctByWeekdayMask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdayMask');
    });
  }
}

extension TaskTemplateModelQueryProperty
    on QueryBuilder<TaskTemplateModel, TaskTemplateModel, QQueryProperty> {
  QueryBuilder<TaskTemplateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskTemplateModel, int?, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<TaskTemplateModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TaskTemplateModel, int, QQueryOperations>
      defaultReminderOffsetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultReminderOffsetMinutes');
    });
  }

  QueryBuilder<TaskTemplateModel, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TaskTemplateModel, int, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<TaskTemplateModel, bool, QQueryOperations>
      isStaticRoutineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isStaticRoutine');
    });
  }

  QueryBuilder<TaskTemplateModel, RecurrencePattern, QQueryOperations>
      recurrencePatternProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurrencePattern');
    });
  }

  QueryBuilder<TaskTemplateModel, int, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<TaskTemplateModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TaskTemplateModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<TaskTemplateModel, int, QQueryOperations> weekdayMaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdayMask');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskInstanceModelCollection on Isar {
  IsarCollection<TaskInstanceModel> get taskInstanceModels => this.collection();
}

const TaskInstanceModelSchema = CollectionSchema(
  name: r'TaskInstanceModel',
  id: 7755913469046451607,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'completionPercentage': PropertySchema(
      id: 1,
      name: r'completionPercentage',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 4,
      name: r'description',
      type: IsarType.string,
    ),
    r'endTime': PropertySchema(
      id: 5,
      name: r'endTime',
      type: IsarType.long,
    ),
    r'isArchived': PropertySchema(
      id: 6,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'manuallyRescheduled': PropertySchema(
      id: 7,
      name: r'manuallyRescheduled',
      type: IsarType.bool,
    ),
    r'startTime': PropertySchema(
      id: 8,
      name: r'startTime',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 9,
      name: r'status',
      type: IsarType.byte,
      enumMap: _TaskInstanceModelstatusEnumValueMap,
    ),
    r'templateId': PropertySchema(
      id: 10,
      name: r'templateId',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 11,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _taskInstanceModelEstimateSize,
  serialize: _taskInstanceModelSerialize,
  deserialize: _taskInstanceModelDeserialize,
  deserializeProp: _taskInstanceModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'templateId': IndexSchema(
      id: -5352721467389445085,
      name: r'templateId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'templateId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'categoryId': IndexSchema(
      id: -8798048739239305339,
      name: r'categoryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _taskInstanceModelGetId,
  getLinks: _taskInstanceModelGetLinks,
  attach: _taskInstanceModelAttach,
  version: '3.1.0+1',
);

int _taskInstanceModelEstimateSize(
  TaskInstanceModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _taskInstanceModelSerialize(
  TaskInstanceModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryId);
  writer.writeLong(offsets[1], object.completionPercentage);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeString(offsets[4], object.description);
  writer.writeLong(offsets[5], object.endTime);
  writer.writeBool(offsets[6], object.isArchived);
  writer.writeBool(offsets[7], object.manuallyRescheduled);
  writer.writeLong(offsets[8], object.startTime);
  writer.writeByte(offsets[9], object.status.index);
  writer.writeLong(offsets[10], object.templateId);
  writer.writeString(offsets[11], object.title);
  writer.writeDateTime(offsets[12], object.updatedAt);
}

TaskInstanceModel _taskInstanceModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskInstanceModel();
  object.categoryId = reader.readLongOrNull(offsets[0]);
  object.completionPercentage = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.description = reader.readString(offsets[4]);
  object.endTime = reader.readLong(offsets[5]);
  object.id = id;
  object.isArchived = reader.readBool(offsets[6]);
  object.manuallyRescheduled = reader.readBool(offsets[7]);
  object.startTime = reader.readLong(offsets[8]);
  object.status =
      _TaskInstanceModelstatusValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          TaskLifecycleStatus.pending;
  object.templateId = reader.readLongOrNull(offsets[10]);
  object.title = reader.readString(offsets[11]);
  object.updatedAt = reader.readDateTime(offsets[12]);
  return object;
}

P _taskInstanceModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (_TaskInstanceModelstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          TaskLifecycleStatus.pending) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TaskInstanceModelstatusEnumValueMap = {
  'pending': 0,
  'inProgress': 1,
  'completed': 2,
  'missed': 3,
  'archived': 4,
};
const _TaskInstanceModelstatusValueEnumMap = {
  0: TaskLifecycleStatus.pending,
  1: TaskLifecycleStatus.inProgress,
  2: TaskLifecycleStatus.completed,
  3: TaskLifecycleStatus.missed,
  4: TaskLifecycleStatus.archived,
};

Id _taskInstanceModelGetId(TaskInstanceModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskInstanceModelGetLinks(
    TaskInstanceModel object) {
  return [];
}

void _taskInstanceModelAttach(
    IsarCollection<dynamic> col, Id id, TaskInstanceModel object) {
  object.id = id;
}

extension TaskInstanceModelQueryWhereSort
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QWhere> {
  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhere>
      anyTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'templateId'),
      );
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhere>
      anyCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'categoryId'),
      );
    });
  }
}

extension TaskInstanceModelQueryWhere
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QWhereClause> {
  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'templateId',
        value: [null],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'templateId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdEqualTo(int? templateId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'templateId',
        value: [templateId],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdNotEqualTo(int? templateId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateId',
              lower: [],
              upper: [templateId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateId',
              lower: [templateId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateId',
              lower: [templateId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'templateId',
              lower: [],
              upper: [templateId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdGreaterThan(
    int? templateId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'templateId',
        lower: [templateId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdLessThan(
    int? templateId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'templateId',
        lower: [],
        upper: [templateId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      templateIdBetween(
    int? lowerTemplateId,
    int? upperTemplateId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'templateId',
        lower: [lowerTemplateId],
        includeLower: includeLower,
        upper: [upperTemplateId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [null],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdEqualTo(int? categoryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [categoryId],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdNotEqualTo(int? categoryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdGreaterThan(
    int? categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [categoryId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdLessThan(
    int? categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [],
        upper: [categoryId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterWhereClause>
      categoryIdBetween(
    int? lowerCategoryId,
    int? upperCategoryId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [lowerCategoryId],
        includeLower: includeLower,
        upper: [upperCategoryId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskInstanceModelQueryFilter
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QFilterCondition> {
  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      categoryIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      categoryIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'categoryId',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      categoryIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      categoryIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      categoryIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      categoryIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      completionPercentageEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      completionPercentageGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      completionPercentageLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      completionPercentageBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionPercentage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      endTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      endTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      endTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      endTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isArchived',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      manuallyRescheduledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manuallyRescheduled',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      startTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      startTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      startTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      startTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      statusEqualTo(TaskLifecycleStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      statusGreaterThan(
    TaskLifecycleStatus value, {
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      statusLessThan(
    TaskLifecycleStatus value, {
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      statusBetween(
    TaskLifecycleStatus lower,
    TaskLifecycleStatus upper, {
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      templateIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'templateId',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      templateIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'templateId',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      templateIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      templateIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'templateId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      templateIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'templateId',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      templateIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'templateId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
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

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterFilterCondition>
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

extension TaskInstanceModelQueryObject
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QFilterCondition> {}

extension TaskInstanceModelQueryLinks
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QFilterCondition> {}

extension TaskInstanceModelQuerySortBy
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QSortBy> {
  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByCompletionPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByManuallyRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manuallyRescheduled', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByManuallyRescheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manuallyRescheduled', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateId', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateId', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TaskInstanceModelQuerySortThenBy
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QSortThenBy> {
  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByCompletionPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionPercentage', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByManuallyRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manuallyRescheduled', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByManuallyRescheduledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manuallyRescheduled', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateId', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByTemplateIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateId', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TaskInstanceModelQueryWhereDistinct
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct> {
  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByCompletionPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionPercentage');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByManuallyRescheduled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manuallyRescheduled');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByTemplateId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'templateId');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskInstanceModel, TaskInstanceModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TaskInstanceModelQueryProperty
    on QueryBuilder<TaskInstanceModel, TaskInstanceModel, QQueryProperty> {
  QueryBuilder<TaskInstanceModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskInstanceModel, int?, QQueryOperations> categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<TaskInstanceModel, int, QQueryOperations>
      completionPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionPercentage');
    });
  }

  QueryBuilder<TaskInstanceModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TaskInstanceModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<TaskInstanceModel, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<TaskInstanceModel, int, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<TaskInstanceModel, bool, QQueryOperations> isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<TaskInstanceModel, bool, QQueryOperations>
      manuallyRescheduledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manuallyRescheduled');
    });
  }

  QueryBuilder<TaskInstanceModel, int, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<TaskInstanceModel, TaskLifecycleStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<TaskInstanceModel, int?, QQueryOperations> templateIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'templateId');
    });
  }

  QueryBuilder<TaskInstanceModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TaskInstanceModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChecklistItemCollection on Isar {
  IsarCollection<ChecklistItem> get checklistItems => this.collection();
}

const ChecklistItemSchema = CollectionSchema(
  name: r'ChecklistItem',
  id: 6734995178179243527,
  properties: {
    r'isCompleted': PropertySchema(
      id: 0,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'taskInstanceId': PropertySchema(
      id: 1,
      name: r'taskInstanceId',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _checklistItemEstimateSize,
  serialize: _checklistItemSerialize,
  deserialize: _checklistItemDeserialize,
  deserializeProp: _checklistItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'taskInstanceId': IndexSchema(
      id: -1579276660709411025,
      name: r'taskInstanceId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskInstanceId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _checklistItemGetId,
  getLinks: _checklistItemGetLinks,
  attach: _checklistItemAttach,
  version: '3.1.0+1',
);

int _checklistItemEstimateSize(
  ChecklistItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _checklistItemSerialize(
  ChecklistItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isCompleted);
  writer.writeLong(offsets[1], object.taskInstanceId);
  writer.writeString(offsets[2], object.title);
}

ChecklistItem _checklistItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChecklistItem();
  object.id = id;
  object.isCompleted = reader.readBool(offsets[0]);
  object.taskInstanceId = reader.readLong(offsets[1]);
  object.title = reader.readString(offsets[2]);
  return object;
}

P _checklistItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _checklistItemGetId(ChecklistItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _checklistItemGetLinks(ChecklistItem object) {
  return [];
}

void _checklistItemAttach(
    IsarCollection<dynamic> col, Id id, ChecklistItem object) {
  object.id = id;
}

extension ChecklistItemQueryWhereSort
    on QueryBuilder<ChecklistItem, ChecklistItem, QWhere> {
  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhere> anyTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'taskInstanceId'),
      );
    });
  }
}

extension ChecklistItemQueryWhere
    on QueryBuilder<ChecklistItem, ChecklistItem, QWhereClause> {
  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause>
      taskInstanceIdEqualTo(int taskInstanceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskInstanceId',
        value: [taskInstanceId],
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause>
      taskInstanceIdNotEqualTo(int taskInstanceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskInstanceId',
              lower: [],
              upper: [taskInstanceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskInstanceId',
              lower: [taskInstanceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskInstanceId',
              lower: [taskInstanceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskInstanceId',
              lower: [],
              upper: [taskInstanceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause>
      taskInstanceIdGreaterThan(
    int taskInstanceId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskInstanceId',
        lower: [taskInstanceId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause>
      taskInstanceIdLessThan(
    int taskInstanceId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskInstanceId',
        lower: [],
        upper: [taskInstanceId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterWhereClause>
      taskInstanceIdBetween(
    int lowerTaskInstanceId,
    int upperTaskInstanceId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'taskInstanceId',
        lower: [lowerTaskInstanceId],
        includeLower: includeLower,
        upper: [upperTaskInstanceId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChecklistItemQueryFilter
    on QueryBuilder<ChecklistItem, ChecklistItem, QFilterCondition> {
  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
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

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      taskInstanceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskInstanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      taskInstanceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskInstanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      taskInstanceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskInstanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      taskInstanceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskInstanceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension ChecklistItemQueryObject
    on QueryBuilder<ChecklistItem, ChecklistItem, QFilterCondition> {}

extension ChecklistItemQueryLinks
    on QueryBuilder<ChecklistItem, ChecklistItem, QFilterCondition> {}

extension ChecklistItemQuerySortBy
    on QueryBuilder<ChecklistItem, ChecklistItem, QSortBy> {
  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy>
      sortByTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy>
      sortByTaskInstanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.desc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ChecklistItemQuerySortThenBy
    on QueryBuilder<ChecklistItem, ChecklistItem, QSortThenBy> {
  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy>
      thenByTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy>
      thenByTaskInstanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.desc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension ChecklistItemQueryWhereDistinct
    on QueryBuilder<ChecklistItem, ChecklistItem, QDistinct> {
  QueryBuilder<ChecklistItem, ChecklistItem, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QDistinct>
      distinctByTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskInstanceId');
    });
  }

  QueryBuilder<ChecklistItem, ChecklistItem, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension ChecklistItemQueryProperty
    on QueryBuilder<ChecklistItem, ChecklistItem, QQueryProperty> {
  QueryBuilder<ChecklistItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ChecklistItem, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<ChecklistItem, int, QQueryOperations> taskInstanceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskInstanceId');
    });
  }

  QueryBuilder<ChecklistItem, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCategoryModelCollection on Isar {
  IsarCollection<CategoryModel> get categoryModels => this.collection();
}

const CategoryModelSchema = CollectionSchema(
  name: r'CategoryModel',
  id: 2062173352312629051,
  properties: {
    r'colorHex': PropertySchema(
      id: 0,
      name: r'colorHex',
      type: IsarType.string,
    ),
    r'iconCodePoint': PropertySchema(
      id: 1,
      name: r'iconCodePoint',
      type: IsarType.long,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _categoryModelEstimateSize,
  serialize: _categoryModelSerialize,
  deserialize: _categoryModelDeserialize,
  deserializeProp: _categoryModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'name': IndexSchema(
      id: 879695947855722453,
      name: r'name',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'name',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _categoryModelGetId,
  getLinks: _categoryModelGetLinks,
  attach: _categoryModelAttach,
  version: '3.1.0+1',
);

int _categoryModelEstimateSize(
  CategoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.colorHex.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _categoryModelSerialize(
  CategoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.colorHex);
  writer.writeLong(offsets[1], object.iconCodePoint);
  writer.writeString(offsets[2], object.name);
}

CategoryModel _categoryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CategoryModel();
  object.colorHex = reader.readString(offsets[0]);
  object.iconCodePoint = reader.readLong(offsets[1]);
  object.id = id;
  object.name = reader.readString(offsets[2]);
  return object;
}

P _categoryModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _categoryModelGetId(CategoryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _categoryModelGetLinks(CategoryModel object) {
  return [];
}

void _categoryModelAttach(
    IsarCollection<dynamic> col, Id id, CategoryModel object) {
  object.id = id;
}

extension CategoryModelByIndex on IsarCollection<CategoryModel> {
  Future<CategoryModel?> getByName(String name) {
    return getByIndex(r'name', [name]);
  }

  CategoryModel? getByNameSync(String name) {
    return getByIndexSync(r'name', [name]);
  }

  Future<bool> deleteByName(String name) {
    return deleteByIndex(r'name', [name]);
  }

  bool deleteByNameSync(String name) {
    return deleteByIndexSync(r'name', [name]);
  }

  Future<List<CategoryModel?>> getAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndex(r'name', values);
  }

  List<CategoryModel?> getAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'name', values);
  }

  Future<int> deleteAllByName(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'name', values);
  }

  int deleteAllByNameSync(List<String> nameValues) {
    final values = nameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'name', values);
  }

  Future<Id> putByName(CategoryModel object) {
    return putByIndex(r'name', object);
  }

  Id putByNameSync(CategoryModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'name', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByName(List<CategoryModel> objects) {
    return putAllByIndex(r'name', objects);
  }

  List<Id> putAllByNameSync(List<CategoryModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'name', objects, saveLinks: saveLinks);
  }
}

extension CategoryModelQueryWhereSort
    on QueryBuilder<CategoryModel, CategoryModel, QWhere> {
  QueryBuilder<CategoryModel, CategoryModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CategoryModelQueryWhere
    on QueryBuilder<CategoryModel, CategoryModel, QWhereClause> {
  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> nameEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'name',
        value: [name],
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterWhereClause> nameNotEqualTo(
      String name) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [name],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'name',
              lower: [],
              upper: [name],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CategoryModelQueryFilter
    on QueryBuilder<CategoryModel, CategoryModel, QFilterCondition> {
  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorHex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorHex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorHex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      colorHexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorHex',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      iconCodePointEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      iconCodePointGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      iconCodePointLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconCodePoint',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      iconCodePointBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconCodePoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
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

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension CategoryModelQueryObject
    on QueryBuilder<CategoryModel, CategoryModel, QFilterCondition> {}

extension CategoryModelQueryLinks
    on QueryBuilder<CategoryModel, CategoryModel, QFilterCondition> {}

extension CategoryModelQuerySortBy
    on QueryBuilder<CategoryModel, CategoryModel, QSortBy> {
  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> sortByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy>
      sortByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy>
      sortByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy>
      sortByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CategoryModelQuerySortThenBy
    on QueryBuilder<CategoryModel, CategoryModel, QSortThenBy> {
  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> thenByColorHex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy>
      thenByColorHexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorHex', Sort.desc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy>
      thenByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy>
      thenByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension CategoryModelQueryWhereDistinct
    on QueryBuilder<CategoryModel, CategoryModel, QDistinct> {
  QueryBuilder<CategoryModel, CategoryModel, QDistinct> distinctByColorHex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorHex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QDistinct>
      distinctByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconCodePoint');
    });
  }

  QueryBuilder<CategoryModel, CategoryModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension CategoryModelQueryProperty
    on QueryBuilder<CategoryModel, CategoryModel, QQueryProperty> {
  QueryBuilder<CategoryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CategoryModel, String, QQueryOperations> colorHexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorHex');
    });
  }

  QueryBuilder<CategoryModel, int, QQueryOperations> iconCodePointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconCodePoint');
    });
  }

  QueryBuilder<CategoryModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklySummaryCacheCollection on Isar {
  IsarCollection<WeeklySummaryCache> get weeklySummaryCaches =>
      this.collection();
}

const WeeklySummaryCacheSchema = CollectionSchema(
  name: r'WeeklySummaryCache',
  id: 191328043052656762,
  properties: {
    r'categoryWiseProductivityJson': PropertySchema(
      id: 0,
      name: r'categoryWiseProductivityJson',
      type: IsarType.string,
    ),
    r'completionRate': PropertySchema(
      id: 1,
      name: r'completionRate',
      type: IsarType.double,
    ),
    r'missedCount': PropertySchema(
      id: 2,
      name: r'missedCount',
      type: IsarType.long,
    ),
    r'mostMissedTimeSlot': PropertySchema(
      id: 3,
      name: r'mostMissedTimeSlot',
      type: IsarType.string,
    ),
    r'mostProductive2HourWindow': PropertySchema(
      id: 4,
      name: r'mostProductive2HourWindow',
      type: IsarType.string,
    ),
    r'mostProductiveDay': PropertySchema(
      id: 5,
      name: r'mostProductiveDay',
      type: IsarType.long,
    ),
    r'totalCompletedMinutes': PropertySchema(
      id: 6,
      name: r'totalCompletedMinutes',
      type: IsarType.long,
    ),
    r'totalFocusedMinutes': PropertySchema(
      id: 7,
      name: r'totalFocusedMinutes',
      type: IsarType.long,
    ),
    r'totalScheduledMinutes': PropertySchema(
      id: 8,
      name: r'totalScheduledMinutes',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekStartDate': PropertySchema(
      id: 10,
      name: r'weekStartDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _weeklySummaryCacheEstimateSize,
  serialize: _weeklySummaryCacheSerialize,
  deserialize: _weeklySummaryCacheDeserialize,
  deserializeProp: _weeklySummaryCacheDeserializeProp,
  idName: r'id',
  indexes: {
    r'weekStartDate': IndexSchema(
      id: 7906057668223877157,
      name: r'weekStartDate',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'weekStartDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklySummaryCacheGetId,
  getLinks: _weeklySummaryCacheGetLinks,
  attach: _weeklySummaryCacheAttach,
  version: '3.1.0+1',
);

int _weeklySummaryCacheEstimateSize(
  WeeklySummaryCache object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryWiseProductivityJson.length * 3;
  bytesCount += 3 + object.mostMissedTimeSlot.length * 3;
  bytesCount += 3 + object.mostProductive2HourWindow.length * 3;
  return bytesCount;
}

void _weeklySummaryCacheSerialize(
  WeeklySummaryCache object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryWiseProductivityJson);
  writer.writeDouble(offsets[1], object.completionRate);
  writer.writeLong(offsets[2], object.missedCount);
  writer.writeString(offsets[3], object.mostMissedTimeSlot);
  writer.writeString(offsets[4], object.mostProductive2HourWindow);
  writer.writeLong(offsets[5], object.mostProductiveDay);
  writer.writeLong(offsets[6], object.totalCompletedMinutes);
  writer.writeLong(offsets[7], object.totalFocusedMinutes);
  writer.writeLong(offsets[8], object.totalScheduledMinutes);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeDateTime(offsets[10], object.weekStartDate);
}

WeeklySummaryCache _weeklySummaryCacheDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklySummaryCache();
  object.categoryWiseProductivityJson = reader.readString(offsets[0]);
  object.completionRate = reader.readDouble(offsets[1]);
  object.id = id;
  object.missedCount = reader.readLong(offsets[2]);
  object.mostMissedTimeSlot = reader.readString(offsets[3]);
  object.mostProductive2HourWindow = reader.readString(offsets[4]);
  object.mostProductiveDay = reader.readLong(offsets[5]);
  object.totalCompletedMinutes = reader.readLong(offsets[6]);
  object.totalFocusedMinutes = reader.readLong(offsets[7]);
  object.totalScheduledMinutes = reader.readLong(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.weekStartDate = reader.readDateTime(offsets[10]);
  return object;
}

P _weeklySummaryCacheDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklySummaryCacheGetId(WeeklySummaryCache object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklySummaryCacheGetLinks(
    WeeklySummaryCache object) {
  return [];
}

void _weeklySummaryCacheAttach(
    IsarCollection<dynamic> col, Id id, WeeklySummaryCache object) {
  object.id = id;
}

extension WeeklySummaryCacheByIndex on IsarCollection<WeeklySummaryCache> {
  Future<WeeklySummaryCache?> getByWeekStartDate(DateTime weekStartDate) {
    return getByIndex(r'weekStartDate', [weekStartDate]);
  }

  WeeklySummaryCache? getByWeekStartDateSync(DateTime weekStartDate) {
    return getByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<bool> deleteByWeekStartDate(DateTime weekStartDate) {
    return deleteByIndex(r'weekStartDate', [weekStartDate]);
  }

  bool deleteByWeekStartDateSync(DateTime weekStartDate) {
    return deleteByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<List<WeeklySummaryCache?>> getAllByWeekStartDate(
      List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'weekStartDate', values);
  }

  List<WeeklySummaryCache?> getAllByWeekStartDateSync(
      List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'weekStartDate', values);
  }

  Future<int> deleteAllByWeekStartDate(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'weekStartDate', values);
  }

  int deleteAllByWeekStartDateSync(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'weekStartDate', values);
  }

  Future<Id> putByWeekStartDate(WeeklySummaryCache object) {
    return putByIndex(r'weekStartDate', object);
  }

  Id putByWeekStartDateSync(WeeklySummaryCache object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'weekStartDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWeekStartDate(List<WeeklySummaryCache> objects) {
    return putAllByIndex(r'weekStartDate', objects);
  }

  List<Id> putAllByWeekStartDateSync(List<WeeklySummaryCache> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'weekStartDate', objects, saveLinks: saveLinks);
  }
}

extension WeeklySummaryCacheQueryWhereSort
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QWhere> {
  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhere>
      anyWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekStartDate'),
      );
    });
  }
}

extension WeeklySummaryCacheQueryWhere
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QWhereClause> {
  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      weekStartDateEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weekStartDate',
        value: [weekStartDate],
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      weekStartDateNotEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [],
              upper: [weekStartDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [weekStartDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [weekStartDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [],
              upper: [weekStartDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      weekStartDateGreaterThan(
    DateTime weekStartDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [weekStartDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      weekStartDateLessThan(
    DateTime weekStartDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [],
        upper: [weekStartDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterWhereClause>
      weekStartDateBetween(
    DateTime lowerWeekStartDate,
    DateTime upperWeekStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [lowerWeekStartDate],
        includeLower: includeLower,
        upper: [upperWeekStartDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklySummaryCacheQueryFilter
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QFilterCondition> {
  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryWiseProductivityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryWiseProductivityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryWiseProductivityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryWiseProductivityJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryWiseProductivityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryWiseProductivityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryWiseProductivityJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryWiseProductivityJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryWiseProductivityJson',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      categoryWiseProductivityJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryWiseProductivityJson',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      completionRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      completionRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      completionRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      completionRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completionRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      missedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      missedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      missedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      missedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostMissedTimeSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostMissedTimeSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostMissedTimeSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostMissedTimeSlot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostMissedTimeSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostMissedTimeSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostMissedTimeSlot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostMissedTimeSlot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostMissedTimeSlot',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostMissedTimeSlotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostMissedTimeSlot',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostProductive2HourWindow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostProductive2HourWindow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostProductive2HourWindow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostProductive2HourWindow',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mostProductive2HourWindow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mostProductive2HourWindow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mostProductive2HourWindow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mostProductive2HourWindow',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostProductive2HourWindow',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductive2HourWindowIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mostProductive2HourWindow',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductiveDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mostProductiveDay',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductiveDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mostProductiveDay',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductiveDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mostProductiveDay',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      mostProductiveDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mostProductiveDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalCompletedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCompletedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalCompletedMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCompletedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalCompletedMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCompletedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalCompletedMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCompletedMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalFocusedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalFocusedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalFocusedMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalFocusedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalFocusedMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalFocusedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalFocusedMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalFocusedMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalScheduledMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalScheduledMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalScheduledMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalScheduledMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalScheduledMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalScheduledMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      totalScheduledMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalScheduledMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
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

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      weekStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      weekStartDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      weekStartDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterFilterCondition>
      weekStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklySummaryCacheQueryObject
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QFilterCondition> {}

extension WeeklySummaryCacheQueryLinks
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QFilterCondition> {}

extension WeeklySummaryCacheQuerySortBy
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QSortBy> {
  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByCategoryWiseProductivityJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryWiseProductivityJson', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByCategoryWiseProductivityJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryWiseProductivityJson', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMissedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMissedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMostMissedTimeSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostMissedTimeSlot', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMostMissedTimeSlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostMissedTimeSlot', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMostProductive2HourWindow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductive2HourWindow', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMostProductive2HourWindowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductive2HourWindow', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMostProductiveDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductiveDay', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByMostProductiveDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductiveDay', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByTotalCompletedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletedMinutes', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByTotalCompletedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletedMinutes', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByTotalFocusedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFocusedMinutes', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByTotalFocusedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFocusedMinutes', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByTotalScheduledMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduledMinutes', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByTotalScheduledMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduledMinutes', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      sortByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklySummaryCacheQuerySortThenBy
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QSortThenBy> {
  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByCategoryWiseProductivityJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryWiseProductivityJson', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByCategoryWiseProductivityJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryWiseProductivityJson', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completionRate', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMissedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMissedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMostMissedTimeSlot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostMissedTimeSlot', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMostMissedTimeSlotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostMissedTimeSlot', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMostProductive2HourWindow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductive2HourWindow', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMostProductive2HourWindowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductive2HourWindow', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMostProductiveDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductiveDay', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByMostProductiveDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mostProductiveDay', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByTotalCompletedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletedMinutes', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByTotalCompletedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCompletedMinutes', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByTotalFocusedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFocusedMinutes', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByTotalFocusedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFocusedMinutes', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByTotalScheduledMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduledMinutes', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByTotalScheduledMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalScheduledMinutes', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QAfterSortBy>
      thenByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklySummaryCacheQueryWhereDistinct
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct> {
  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByCategoryWiseProductivityJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryWiseProductivityJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completionRate');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByMissedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missedCount');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByMostMissedTimeSlot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostMissedTimeSlot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByMostProductive2HourWindow({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostProductive2HourWindow',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByMostProductiveDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mostProductiveDay');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByTotalCompletedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCompletedMinutes');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByTotalFocusedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalFocusedMinutes');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByTotalScheduledMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalScheduledMinutes');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QDistinct>
      distinctByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekStartDate');
    });
  }
}

extension WeeklySummaryCacheQueryProperty
    on QueryBuilder<WeeklySummaryCache, WeeklySummaryCache, QQueryProperty> {
  QueryBuilder<WeeklySummaryCache, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklySummaryCache, String, QQueryOperations>
      categoryWiseProductivityJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryWiseProductivityJson');
    });
  }

  QueryBuilder<WeeklySummaryCache, double, QQueryOperations>
      completionRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completionRate');
    });
  }

  QueryBuilder<WeeklySummaryCache, int, QQueryOperations>
      missedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missedCount');
    });
  }

  QueryBuilder<WeeklySummaryCache, String, QQueryOperations>
      mostMissedTimeSlotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostMissedTimeSlot');
    });
  }

  QueryBuilder<WeeklySummaryCache, String, QQueryOperations>
      mostProductive2HourWindowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostProductive2HourWindow');
    });
  }

  QueryBuilder<WeeklySummaryCache, int, QQueryOperations>
      mostProductiveDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mostProductiveDay');
    });
  }

  QueryBuilder<WeeklySummaryCache, int, QQueryOperations>
      totalCompletedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCompletedMinutes');
    });
  }

  QueryBuilder<WeeklySummaryCache, int, QQueryOperations>
      totalFocusedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalFocusedMinutes');
    });
  }

  QueryBuilder<WeeklySummaryCache, int, QQueryOperations>
      totalScheduledMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalScheduledMinutes');
    });
  }

  QueryBuilder<WeeklySummaryCache, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<WeeklySummaryCache, DateTime, QQueryOperations>
      weekStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekStartDate');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFocusSessionModelCollection on Isar {
  IsarCollection<FocusSessionModel> get focusSessionModels => this.collection();
}

const FocusSessionModelSchema = CollectionSchema(
  name: r'FocusSessionModel',
  id: 7372981340496076257,
  properties: {
    r'deepFocus': PropertySchema(
      id: 0,
      name: r'deepFocus',
      type: IsarType.bool,
    ),
    r'endedAt': PropertySchema(
      id: 1,
      name: r'endedAt',
      type: IsarType.dateTime,
    ),
    r'startedAt': PropertySchema(
      id: 2,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'taskInstanceId': PropertySchema(
      id: 3,
      name: r'taskInstanceId',
      type: IsarType.long,
    ),
    r'uninterruptedMinutes': PropertySchema(
      id: 4,
      name: r'uninterruptedMinutes',
      type: IsarType.long,
    )
  },
  estimateSize: _focusSessionModelEstimateSize,
  serialize: _focusSessionModelSerialize,
  deserialize: _focusSessionModelDeserialize,
  deserializeProp: _focusSessionModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'startedAt': IndexSchema(
      id: 8114395319341636597,
      name: r'startedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _focusSessionModelGetId,
  getLinks: _focusSessionModelGetLinks,
  attach: _focusSessionModelAttach,
  version: '3.1.0+1',
);

int _focusSessionModelEstimateSize(
  FocusSessionModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _focusSessionModelSerialize(
  FocusSessionModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.deepFocus);
  writer.writeDateTime(offsets[1], object.endedAt);
  writer.writeDateTime(offsets[2], object.startedAt);
  writer.writeLong(offsets[3], object.taskInstanceId);
  writer.writeLong(offsets[4], object.uninterruptedMinutes);
}

FocusSessionModel _focusSessionModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FocusSessionModel();
  object.deepFocus = reader.readBool(offsets[0]);
  object.endedAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.startedAt = reader.readDateTime(offsets[2]);
  object.taskInstanceId = reader.readLongOrNull(offsets[3]);
  object.uninterruptedMinutes = reader.readLong(offsets[4]);
  return object;
}

P _focusSessionModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _focusSessionModelGetId(FocusSessionModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _focusSessionModelGetLinks(
    FocusSessionModel object) {
  return [];
}

void _focusSessionModelAttach(
    IsarCollection<dynamic> col, Id id, FocusSessionModel object) {
  object.id = id;
}

extension FocusSessionModelQueryWhereSort
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QWhere> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhere>
      anyStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startedAt'),
      );
    });
  }
}

extension FocusSessionModelQueryWhere
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QWhereClause> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      startedAtEqualTo(DateTime startedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startedAt',
        value: [startedAt],
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      startedAtNotEqualTo(DateTime startedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startedAt',
              lower: [],
              upper: [startedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startedAt',
              lower: [startedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startedAt',
              lower: [startedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startedAt',
              lower: [],
              upper: [startedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      startedAtGreaterThan(
    DateTime startedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startedAt',
        lower: [startedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      startedAtLessThan(
    DateTime startedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startedAt',
        lower: [],
        upper: [startedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
      startedAtBetween(
    DateTime lowerStartedAt,
    DateTime upperStartedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startedAt',
        lower: [lowerStartedAt],
        includeLower: includeLower,
        upper: [upperStartedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FocusSessionModelQueryFilter
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QFilterCondition> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      deepFocusEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deepFocus',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      endedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endedAt',
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      endedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endedAt',
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      endedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      endedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      endedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      endedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
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

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
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

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      startedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      startedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      taskInstanceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taskInstanceId',
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      taskInstanceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taskInstanceId',
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      taskInstanceIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskInstanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      taskInstanceIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskInstanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      taskInstanceIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskInstanceId',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      taskInstanceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskInstanceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      uninterruptedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uninterruptedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      uninterruptedMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uninterruptedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      uninterruptedMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uninterruptedMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
      uninterruptedMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uninterruptedMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FocusSessionModelQueryObject
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QFilterCondition> {}

extension FocusSessionModelQueryLinks
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QFilterCondition> {}

extension FocusSessionModelQuerySortBy
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QSortBy> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByDeepFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepFocus', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByDeepFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepFocus', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByTaskInstanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByUninterruptedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uninterruptedMinutes', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      sortByUninterruptedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uninterruptedMinutes', Sort.desc);
    });
  }
}

extension FocusSessionModelQuerySortThenBy
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QSortThenBy> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByDeepFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepFocus', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByDeepFocusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deepFocus', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByTaskInstanceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskInstanceId', Sort.desc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByUninterruptedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uninterruptedMinutes', Sort.asc);
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterSortBy>
      thenByUninterruptedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uninterruptedMinutes', Sort.desc);
    });
  }
}

extension FocusSessionModelQueryWhereDistinct
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QDistinct> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QDistinct>
      distinctByDeepFocus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deepFocus');
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QDistinct>
      distinctByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endedAt');
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QDistinct>
      distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QDistinct>
      distinctByTaskInstanceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskInstanceId');
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QDistinct>
      distinctByUninterruptedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uninterruptedMinutes');
    });
  }
}

extension FocusSessionModelQueryProperty
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QQueryProperty> {
  QueryBuilder<FocusSessionModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FocusSessionModel, bool, QQueryOperations> deepFocusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deepFocus');
    });
  }

  QueryBuilder<FocusSessionModel, DateTime?, QQueryOperations>
      endedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endedAt');
    });
  }

  QueryBuilder<FocusSessionModel, DateTime, QQueryOperations>
      startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<FocusSessionModel, int?, QQueryOperations>
      taskInstanceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskInstanceId');
    });
  }

  QueryBuilder<FocusSessionModel, int, QQueryOperations>
      uninterruptedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uninterruptedMinutes');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsModelCollection on Isar {
  IsarCollection<AppSettingsModel> get appSettingsModels => this.collection();
}

const AppSettingsModelSchema = CollectionSchema(
  name: r'AppSettingsModel',
  id: -638838212012723081,
  properties: {
    r'allowSleepOverride': PropertySchema(
      id: 0,
      name: r'allowSleepOverride',
      type: IsarType.bool,
    ),
    r'autoCarryForwardEnabled': PropertySchema(
      id: 1,
      name: r'autoCarryForwardEnabled',
      type: IsarType.bool,
    ),
    r'bufferMinutes': PropertySchema(
      id: 2,
      name: r'bufferMinutes',
      type: IsarType.long,
    ),
    r'dailySummaryEnabled': PropertySchema(
      id: 3,
      name: r'dailySummaryEnabled',
      type: IsarType.bool,
    ),
    r'dailySummaryHour': PropertySchema(
      id: 4,
      name: r'dailySummaryHour',
      type: IsarType.long,
    ),
    r'dailySummaryMinute': PropertySchema(
      id: 5,
      name: r'dailySummaryMinute',
      type: IsarType.long,
    ),
    r'defaultReminderOffsetMinutes': PropertySchema(
      id: 6,
      name: r'defaultReminderOffsetMinutes',
      type: IsarType.long,
    ),
    r'lastDailySummarySentAt': PropertySchema(
      id: 7,
      name: r'lastDailySummarySentAt',
      type: IsarType.dateTime,
    ),
    r'overdueAlertsEnabled': PropertySchema(
      id: 8,
      name: r'overdueAlertsEnabled',
      type: IsarType.bool,
    ),
    r'remindersEnabled': PropertySchema(
      id: 9,
      name: r'remindersEnabled',
      type: IsarType.bool,
    ),
    r'showRealismLegend': PropertySchema(
      id: 10,
      name: r'showRealismLegend',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _appSettingsModelEstimateSize,
  serialize: _appSettingsModelSerialize,
  deserialize: _appSettingsModelDeserialize,
  deserializeProp: _appSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsModelGetId,
  getLinks: _appSettingsModelGetLinks,
  attach: _appSettingsModelAttach,
  version: '3.1.0+1',
);

int _appSettingsModelEstimateSize(
  AppSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _appSettingsModelSerialize(
  AppSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowSleepOverride);
  writer.writeBool(offsets[1], object.autoCarryForwardEnabled);
  writer.writeLong(offsets[2], object.bufferMinutes);
  writer.writeBool(offsets[3], object.dailySummaryEnabled);
  writer.writeLong(offsets[4], object.dailySummaryHour);
  writer.writeLong(offsets[5], object.dailySummaryMinute);
  writer.writeLong(offsets[6], object.defaultReminderOffsetMinutes);
  writer.writeDateTime(offsets[7], object.lastDailySummarySentAt);
  writer.writeBool(offsets[8], object.overdueAlertsEnabled);
  writer.writeBool(offsets[9], object.remindersEnabled);
  writer.writeBool(offsets[10], object.showRealismLegend);
  writer.writeDateTime(offsets[11], object.updatedAt);
}

AppSettingsModel _appSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingsModel();
  object.allowSleepOverride = reader.readBool(offsets[0]);
  object.autoCarryForwardEnabled = reader.readBool(offsets[1]);
  object.bufferMinutes = reader.readLong(offsets[2]);
  object.dailySummaryEnabled = reader.readBool(offsets[3]);
  object.dailySummaryHour = reader.readLong(offsets[4]);
  object.dailySummaryMinute = reader.readLong(offsets[5]);
  object.defaultReminderOffsetMinutes = reader.readLong(offsets[6]);
  object.id = id;
  object.lastDailySummarySentAt = reader.readDateTimeOrNull(offsets[7]);
  object.overdueAlertsEnabled = reader.readBool(offsets[8]);
  object.remindersEnabled = reader.readBool(offsets[9]);
  object.showRealismLegend = reader.readBool(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  return object;
}

P _appSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingsModelGetId(AppSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsModelGetLinks(AppSettingsModel object) {
  return [];
}

void _appSettingsModelAttach(
    IsarCollection<dynamic> col, Id id, AppSettingsModel object) {
  object.id = id;
}

extension AppSettingsModelQueryWhereSort
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QWhere> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsModelQueryWhere
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QWhereClause> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterWhereClause> idBetween(
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
}

extension AppSettingsModelQueryFilter
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      allowSleepOverrideEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'allowSleepOverride',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      autoCarryForwardEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoCarryForwardEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      bufferMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bufferMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      bufferMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bufferMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      bufferMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bufferMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      bufferMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bufferMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailySummaryEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailySummaryHour',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailySummaryHour',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailySummaryHour',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailySummaryHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dailySummaryMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dailySummaryMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dailySummaryMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      dailySummaryMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dailySummaryMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultReminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultReminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultReminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      defaultReminderOffsetMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultReminderOffsetMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastDailySummarySentAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDailySummarySentAt',
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastDailySummarySentAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDailySummarySentAt',
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastDailySummarySentAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDailySummarySentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastDailySummarySentAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDailySummarySentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastDailySummarySentAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDailySummarySentAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      lastDailySummarySentAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDailySummarySentAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      overdueAlertsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overdueAlertsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      remindersEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remindersEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      showRealismLegendEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'showRealismLegend',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
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

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterFilterCondition>
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

extension AppSettingsModelQueryObject
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {}

extension AppSettingsModelQueryLinks
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QFilterCondition> {}

extension AppSettingsModelQuerySortBy
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QSortBy> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByAllowSleepOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowSleepOverride', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByAllowSleepOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowSleepOverride', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByAutoCarryForwardEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCarryForwardEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByAutoCarryForwardEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCarryForwardEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByBufferMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bufferMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByBufferMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bufferMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDailySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDailySummaryHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryHour', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDailySummaryHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryHour', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDailySummaryMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryMinute', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDailySummaryMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryMinute', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDefaultReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByDefaultReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByLastDailySummarySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailySummarySentAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByLastDailySummarySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailySummarySentAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByOverdueAlertsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueAlertsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByOverdueAlertsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueAlertsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByRemindersEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByRemindersEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByShowRealismLegend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRealismLegend', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByShowRealismLegendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRealismLegend', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AppSettingsModelQuerySortThenBy
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QSortThenBy> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByAllowSleepOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowSleepOverride', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByAllowSleepOverrideDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowSleepOverride', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByAutoCarryForwardEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCarryForwardEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByAutoCarryForwardEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCarryForwardEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByBufferMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bufferMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByBufferMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bufferMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDailySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDailySummaryHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryHour', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDailySummaryHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryHour', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDailySummaryMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryMinute', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDailySummaryMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryMinute', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDefaultReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByDefaultReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultReminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByLastDailySummarySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailySummarySentAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByLastDailySummarySentAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDailySummarySentAt', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByOverdueAlertsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueAlertsEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByOverdueAlertsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overdueAlertsEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByRemindersEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByRemindersEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remindersEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByShowRealismLegend() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRealismLegend', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByShowRealismLegendDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'showRealismLegend', Sort.desc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AppSettingsModelQueryWhereDistinct
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct> {
  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByAllowSleepOverride() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowSleepOverride');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByAutoCarryForwardEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoCarryForwardEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByBufferMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bufferMinutes');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailySummaryEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByDailySummaryHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailySummaryHour');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByDailySummaryMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailySummaryMinute');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByDefaultReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultReminderOffsetMinutes');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByLastDailySummarySentAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDailySummarySentAt');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByOverdueAlertsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overdueAlertsEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByRemindersEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remindersEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByShowRealismLegend() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'showRealismLegend');
    });
  }

  QueryBuilder<AppSettingsModel, AppSettingsModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AppSettingsModelQueryProperty
    on QueryBuilder<AppSettingsModel, AppSettingsModel, QQueryProperty> {
  QueryBuilder<AppSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
      allowSleepOverrideProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowSleepOverride');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
      autoCarryForwardEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoCarryForwardEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, int, QQueryOperations>
      bufferMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bufferMinutes');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
      dailySummaryEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySummaryEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, int, QQueryOperations>
      dailySummaryHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySummaryHour');
    });
  }

  QueryBuilder<AppSettingsModel, int, QQueryOperations>
      dailySummaryMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySummaryMinute');
    });
  }

  QueryBuilder<AppSettingsModel, int, QQueryOperations>
      defaultReminderOffsetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultReminderOffsetMinutes');
    });
  }

  QueryBuilder<AppSettingsModel, DateTime?, QQueryOperations>
      lastDailySummarySentAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDailySummarySentAt');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
      overdueAlertsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overdueAlertsEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
      remindersEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remindersEnabled');
    });
  }

  QueryBuilder<AppSettingsModel, bool, QQueryOperations>
      showRealismLegendProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'showRealismLegend');
    });
  }

  QueryBuilder<AppSettingsModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskDraftModelCollection on Isar {
  IsarCollection<TaskDraftModel> get taskDraftModels => this.collection();
}

const TaskDraftModelSchema = CollectionSchema(
  name: r'TaskDraftModel',
  id: 3058389570781957571,
  properties: {
    r'checklistCsv': PropertySchema(
      id: 0,
      name: r'checklistCsv',
      type: IsarType.string,
    ),
    r'endMinuteOfDay': PropertySchema(
      id: 1,
      name: r'endMinuteOfDay',
      type: IsarType.long,
    ),
    r'reminderOffsetMinutes': PropertySchema(
      id: 2,
      name: r'reminderOffsetMinutes',
      type: IsarType.long,
    ),
    r'selectedEnergy': PropertySchema(
      id: 3,
      name: r'selectedEnergy',
      type: IsarType.long,
    ),
    r'selectedPriority': PropertySchema(
      id: 4,
      name: r'selectedPriority',
      type: IsarType.long,
    ),
    r'selectedTag': PropertySchema(
      id: 5,
      name: r'selectedTag',
      type: IsarType.long,
    ),
    r'startMinuteOfDay': PropertySchema(
      id: 6,
      name: r'startMinuteOfDay',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _taskDraftModelEstimateSize,
  serialize: _taskDraftModelSerialize,
  deserialize: _taskDraftModelDeserialize,
  deserializeProp: _taskDraftModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _taskDraftModelGetId,
  getLinks: _taskDraftModelGetLinks,
  attach: _taskDraftModelAttach,
  version: '3.1.0+1',
);

int _taskDraftModelEstimateSize(
  TaskDraftModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.checklistCsv.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _taskDraftModelSerialize(
  TaskDraftModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.checklistCsv);
  writer.writeLong(offsets[1], object.endMinuteOfDay);
  writer.writeLong(offsets[2], object.reminderOffsetMinutes);
  writer.writeLong(offsets[3], object.selectedEnergy);
  writer.writeLong(offsets[4], object.selectedPriority);
  writer.writeLong(offsets[5], object.selectedTag);
  writer.writeLong(offsets[6], object.startMinuteOfDay);
  writer.writeString(offsets[7], object.title);
  writer.writeDateTime(offsets[8], object.updatedAt);
}

TaskDraftModel _taskDraftModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskDraftModel();
  object.checklistCsv = reader.readString(offsets[0]);
  object.endMinuteOfDay = reader.readLong(offsets[1]);
  object.id = id;
  object.reminderOffsetMinutes = reader.readLong(offsets[2]);
  object.selectedEnergy = reader.readLong(offsets[3]);
  object.selectedPriority = reader.readLong(offsets[4]);
  object.selectedTag = reader.readLong(offsets[5]);
  object.startMinuteOfDay = reader.readLong(offsets[6]);
  object.title = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  return object;
}

P _taskDraftModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taskDraftModelGetId(TaskDraftModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskDraftModelGetLinks(TaskDraftModel object) {
  return [];
}

void _taskDraftModelAttach(
    IsarCollection<dynamic> col, Id id, TaskDraftModel object) {
  object.id = id;
}

extension TaskDraftModelQueryWhereSort
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QWhere> {
  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaskDraftModelQueryWhere
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QWhereClause> {
  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterWhereClause> idBetween(
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
}

extension TaskDraftModelQueryFilter
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QFilterCondition> {
  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checklistCsv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checklistCsv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checklistCsv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checklistCsv',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checklistCsv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checklistCsv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checklistCsv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checklistCsv',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checklistCsv',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      checklistCsvIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checklistCsv',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      endMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      endMinuteOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      endMinuteOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      endMinuteOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endMinuteOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
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

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
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

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      reminderOffsetMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      reminderOffsetMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      reminderOffsetMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      reminderOffsetMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reminderOffsetMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedEnergyEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedEnergy',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedEnergyGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedEnergy',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedEnergyLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedEnergy',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedEnergyBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedEnergy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedPriorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedPriority',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedPriorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedPriority',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedPriorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedPriority',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedPriorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedPriority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedTagEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedTag',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedTagGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedTag',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedTagLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedTag',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      selectedTagBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      startMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      startMinuteOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      startMinuteOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      startMinuteOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startMinuteOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
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

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
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

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterFilterCondition>
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

extension TaskDraftModelQueryObject
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QFilterCondition> {}

extension TaskDraftModelQueryLinks
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QFilterCondition> {}

extension TaskDraftModelQuerySortBy
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QSortBy> {
  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByChecklistCsv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistCsv', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByChecklistCsvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistCsv', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByEndMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortBySelectedEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedEnergy', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortBySelectedEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedEnergy', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortBySelectedPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPriority', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortBySelectedPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPriority', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortBySelectedTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTag', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortBySelectedTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTag', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByStartMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TaskDraftModelQuerySortThenBy
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QSortThenBy> {
  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByChecklistCsv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistCsv', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByChecklistCsvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checklistCsv', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByEndMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenBySelectedEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedEnergy', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenBySelectedEnergyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedEnergy', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenBySelectedPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPriority', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenBySelectedPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedPriority', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenBySelectedTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTag', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenBySelectedTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTag', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByStartMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension TaskDraftModelQueryWhereDistinct
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct> {
  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctByChecklistCsv({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checklistCsv', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endMinuteOfDay');
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctByReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderOffsetMinutes');
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctBySelectedEnergy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedEnergy');
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctBySelectedPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedPriority');
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctBySelectedTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedTag');
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startMinuteOfDay');
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TaskDraftModel, TaskDraftModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension TaskDraftModelQueryProperty
    on QueryBuilder<TaskDraftModel, TaskDraftModel, QQueryProperty> {
  QueryBuilder<TaskDraftModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TaskDraftModel, String, QQueryOperations>
      checklistCsvProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checklistCsv');
    });
  }

  QueryBuilder<TaskDraftModel, int, QQueryOperations> endMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endMinuteOfDay');
    });
  }

  QueryBuilder<TaskDraftModel, int, QQueryOperations>
      reminderOffsetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderOffsetMinutes');
    });
  }

  QueryBuilder<TaskDraftModel, int, QQueryOperations> selectedEnergyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedEnergy');
    });
  }

  QueryBuilder<TaskDraftModel, int, QQueryOperations>
      selectedPriorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedPriority');
    });
  }

  QueryBuilder<TaskDraftModel, int, QQueryOperations> selectedTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedTag');
    });
  }

  QueryBuilder<TaskDraftModel, int, QQueryOperations>
      startMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startMinuteOfDay');
    });
  }

  QueryBuilder<TaskDraftModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<TaskDraftModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBlueprintProfileModelCollection on Isar {
  IsarCollection<BlueprintProfileModel> get blueprintProfileModels =>
      this.collection();
}

const BlueprintProfileModelSchema = CollectionSchema(
  name: r'BlueprintProfileModel',
  id: 473079033550805558,
  properties: {
    r'mode': PropertySchema(
      id: 0,
      name: r'mode',
      type: IsarType.byte,
      enumMap: _BlueprintProfileModelmodeEnumValueMap,
    ),
    r'sleepMinuteOfDay': PropertySchema(
      id: 1,
      name: r'sleepMinuteOfDay',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'wakeMinuteOfDay': PropertySchema(
      id: 3,
      name: r'wakeMinuteOfDay',
      type: IsarType.long,
    )
  },
  estimateSize: _blueprintProfileModelEstimateSize,
  serialize: _blueprintProfileModelSerialize,
  deserialize: _blueprintProfileModelDeserialize,
  deserializeProp: _blueprintProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _blueprintProfileModelGetId,
  getLinks: _blueprintProfileModelGetLinks,
  attach: _blueprintProfileModelAttach,
  version: '3.1.0+1',
);

int _blueprintProfileModelEstimateSize(
  BlueprintProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _blueprintProfileModelSerialize(
  BlueprintProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.mode.index);
  writer.writeLong(offsets[1], object.sleepMinuteOfDay);
  writer.writeDateTime(offsets[2], object.updatedAt);
  writer.writeLong(offsets[3], object.wakeMinuteOfDay);
}

BlueprintProfileModel _blueprintProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BlueprintProfileModel();
  object.id = id;
  object.mode = _BlueprintProfileModelmodeValueEnumMap[
          reader.readByteOrNull(offsets[0])] ??
      BlueprintMode.normal;
  object.sleepMinuteOfDay = reader.readLong(offsets[1]);
  object.updatedAt = reader.readDateTime(offsets[2]);
  object.wakeMinuteOfDay = reader.readLong(offsets[3]);
  return object;
}

P _blueprintProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_BlueprintProfileModelmodeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BlueprintMode.normal) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BlueprintProfileModelmodeEnumValueMap = {
  'normal': 0,
  'exam': 1,
  'light': 2,
};
const _BlueprintProfileModelmodeValueEnumMap = {
  0: BlueprintMode.normal,
  1: BlueprintMode.exam,
  2: BlueprintMode.light,
};

Id _blueprintProfileModelGetId(BlueprintProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _blueprintProfileModelGetLinks(
    BlueprintProfileModel object) {
  return [];
}

void _blueprintProfileModelAttach(
    IsarCollection<dynamic> col, Id id, BlueprintProfileModel object) {
  object.id = id;
}

extension BlueprintProfileModelQueryWhereSort
    on QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QWhere> {
  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BlueprintProfileModelQueryWhere on QueryBuilder<BlueprintProfileModel,
    BlueprintProfileModel, QWhereClause> {
  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterWhereClause>
      idBetween(
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
}

extension BlueprintProfileModelQueryFilter on QueryBuilder<
    BlueprintProfileModel, BlueprintProfileModel, QFilterCondition> {
  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> modeEqualTo(BlueprintMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mode',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> modeGreaterThan(
    BlueprintMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mode',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> modeLessThan(
    BlueprintMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mode',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> modeBetween(
    BlueprintMode lower,
    BlueprintMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> sleepMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> sleepMinuteOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> sleepMinuteOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> sleepMinuteOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepMinuteOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> wakeMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> wakeMinuteOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> wakeMinuteOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel,
      QAfterFilterCondition> wakeMinuteOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeMinuteOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BlueprintProfileModelQueryObject on QueryBuilder<
    BlueprintProfileModel, BlueprintProfileModel, QFilterCondition> {}

extension BlueprintProfileModelQueryLinks on QueryBuilder<BlueprintProfileModel,
    BlueprintProfileModel, QFilterCondition> {}

extension BlueprintProfileModelQuerySortBy
    on QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QSortBy> {
  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortBySleepMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortBySleepMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortByWakeMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      sortByWakeMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinuteOfDay', Sort.desc);
    });
  }
}

extension BlueprintProfileModelQuerySortThenBy
    on QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QSortThenBy> {
  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mode', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenBySleepMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenBySleepMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByWakeMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QAfterSortBy>
      thenByWakeMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeMinuteOfDay', Sort.desc);
    });
  }
}

extension BlueprintProfileModelQueryWhereDistinct
    on QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QDistinct> {
  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QDistinct>
      distinctByMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mode');
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QDistinct>
      distinctBySleepMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepMinuteOfDay');
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintProfileModel, QDistinct>
      distinctByWakeMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeMinuteOfDay');
    });
  }
}

extension BlueprintProfileModelQueryProperty on QueryBuilder<
    BlueprintProfileModel, BlueprintProfileModel, QQueryProperty> {
  QueryBuilder<BlueprintProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BlueprintProfileModel, BlueprintMode, QQueryOperations>
      modeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mode');
    });
  }

  QueryBuilder<BlueprintProfileModel, int, QQueryOperations>
      sleepMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepMinuteOfDay');
    });
  }

  QueryBuilder<BlueprintProfileModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BlueprintProfileModel, int, QQueryOperations>
      wakeMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeMinuteOfDay');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFixedActivityBlockModelCollection on Isar {
  IsarCollection<FixedActivityBlockModel> get fixedActivityBlockModels =>
      this.collection();
}

const FixedActivityBlockModelSchema = CollectionSchema(
  name: r'FixedActivityBlockModel',
  id: 4171193793480493061,
  properties: {
    r'colorValue': PropertySchema(
      id: 0,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'endMinuteOfDay': PropertySchema(
      id: 2,
      name: r'endMinuteOfDay',
      type: IsarType.long,
    ),
    r'startMinuteOfDay': PropertySchema(
      id: 3,
      name: r'startMinuteOfDay',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _FixedActivityBlockModeltypeEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weekdayMask': PropertySchema(
      id: 7,
      name: r'weekdayMask',
      type: IsarType.long,
    )
  },
  estimateSize: _fixedActivityBlockModelEstimateSize,
  serialize: _fixedActivityBlockModelSerialize,
  deserialize: _fixedActivityBlockModelDeserialize,
  deserializeProp: _fixedActivityBlockModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _fixedActivityBlockModelGetId,
  getLinks: _fixedActivityBlockModelGetLinks,
  attach: _fixedActivityBlockModelAttach,
  version: '3.1.0+1',
);

int _fixedActivityBlockModelEstimateSize(
  FixedActivityBlockModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _fixedActivityBlockModelSerialize(
  FixedActivityBlockModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colorValue);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.endMinuteOfDay);
  writer.writeLong(offsets[3], object.startMinuteOfDay);
  writer.writeString(offsets[4], object.title);
  writer.writeByte(offsets[5], object.type.index);
  writer.writeDateTime(offsets[6], object.updatedAt);
  writer.writeLong(offsets[7], object.weekdayMask);
}

FixedActivityBlockModel _fixedActivityBlockModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FixedActivityBlockModel();
  object.colorValue = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.endMinuteOfDay = reader.readLong(offsets[2]);
  object.id = id;
  object.startMinuteOfDay = reader.readLong(offsets[3]);
  object.title = reader.readString(offsets[4]);
  object.type = _FixedActivityBlockModeltypeValueEnumMap[
          reader.readByteOrNull(offsets[5])] ??
      FixedActivityType.college;
  object.updatedAt = reader.readDateTime(offsets[6]);
  object.weekdayMask = reader.readLong(offsets[7]);
  return object;
}

P _fixedActivityBlockModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (_FixedActivityBlockModeltypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          FixedActivityType.college) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FixedActivityBlockModeltypeEnumValueMap = {
  'college': 0,
  'work': 1,
  'gym': 2,
  'commute': 3,
  'custom': 4,
};
const _FixedActivityBlockModeltypeValueEnumMap = {
  0: FixedActivityType.college,
  1: FixedActivityType.work,
  2: FixedActivityType.gym,
  3: FixedActivityType.commute,
  4: FixedActivityType.custom,
};

Id _fixedActivityBlockModelGetId(FixedActivityBlockModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _fixedActivityBlockModelGetLinks(
    FixedActivityBlockModel object) {
  return [];
}

void _fixedActivityBlockModelAttach(
    IsarCollection<dynamic> col, Id id, FixedActivityBlockModel object) {
  object.id = id;
}

extension FixedActivityBlockModelQueryWhereSort
    on QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QWhere> {
  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FixedActivityBlockModelQueryWhere on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QWhereClause> {
  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterWhereClause> idBetween(
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
}

extension FixedActivityBlockModelQueryFilter on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QFilterCondition> {
  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> endMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> endMinuteOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> endMinuteOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> endMinuteOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endMinuteOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> startMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> startMinuteOfDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> startMinuteOfDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> startMinuteOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startMinuteOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> typeEqualTo(FixedActivityType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> typeGreaterThan(
    FixedActivityType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> typeLessThan(
    FixedActivityType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> typeBetween(
    FixedActivityType lower,
    FixedActivityType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> updatedAtGreaterThan(
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> weekdayMaskEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdayMask',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> weekdayMaskGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekdayMask',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> weekdayMaskLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekdayMask',
        value: value,
      ));
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel,
      QAfterFilterCondition> weekdayMaskBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekdayMask',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension FixedActivityBlockModelQueryObject on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QFilterCondition> {}

extension FixedActivityBlockModelQueryLinks on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QFilterCondition> {}

extension FixedActivityBlockModelQuerySortBy
    on QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QSortBy> {
  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByEndMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByStartMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByWeekdayMask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      sortByWeekdayMaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.desc);
    });
  }
}

extension FixedActivityBlockModelQuerySortThenBy on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QSortThenBy> {
  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByColorValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorValue', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByEndMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByStartMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByWeekdayMask() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.asc);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QAfterSortBy>
      thenByWeekdayMaskDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekdayMask', Sort.desc);
    });
  }
}

extension FixedActivityBlockModelQueryWhereDistinct on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QDistinct> {
  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByColorValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorValue');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endMinuteOfDay');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startMinuteOfDay');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityBlockModel, QDistinct>
      distinctByWeekdayMask() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdayMask');
    });
  }
}

extension FixedActivityBlockModelQueryProperty on QueryBuilder<
    FixedActivityBlockModel, FixedActivityBlockModel, QQueryProperty> {
  QueryBuilder<FixedActivityBlockModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FixedActivityBlockModel, int, QQueryOperations>
      colorValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorValue');
    });
  }

  QueryBuilder<FixedActivityBlockModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<FixedActivityBlockModel, int, QQueryOperations>
      endMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endMinuteOfDay');
    });
  }

  QueryBuilder<FixedActivityBlockModel, int, QQueryOperations>
      startMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startMinuteOfDay');
    });
  }

  QueryBuilder<FixedActivityBlockModel, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<FixedActivityBlockModel, FixedActivityType, QQueryOperations>
      typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<FixedActivityBlockModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<FixedActivityBlockModel, int, QQueryOperations>
      weekdayMaskProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdayMask');
    });
  }
}
