// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_session_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

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
    ),
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
        ),
      ],
    ),
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
  FocusSessionModel object,
) {
  return [];
}

void _focusSessionModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  FocusSessionModel object,
) {
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
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
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
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
  startedAtEqualTo(DateTime startedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'startedAt', value: [startedAt]),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
  startedAtNotEqualTo(DateTime startedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startedAt',
                lower: [],
                upper: [startedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startedAt',
                lower: [startedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startedAt',
                lower: [startedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startedAt',
                lower: [],
                upper: [startedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
  startedAtGreaterThan(DateTime startedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startedAt',
          lower: [startedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterWhereClause>
  startedAtLessThan(DateTime startedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startedAt',
          lower: [],
          upper: [startedAt],
          includeUpper: include,
        ),
      );
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
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startedAt',
          lower: [lowerStartedAt],
          includeLower: includeLower,
          upper: [upperStartedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension FocusSessionModelQueryFilter
    on QueryBuilder<FocusSessionModel, FocusSessionModel, QFilterCondition> {
  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  deepFocusEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deepFocus', value: value),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  endedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endedAt'),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  endedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endedAt'),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  endedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endedAt', value: value),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  endedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  endedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endedAt',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedAt', value: value),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  startedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  startedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  taskInstanceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'taskInstanceId'),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  taskInstanceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'taskInstanceId'),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  taskInstanceIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'taskInstanceId', value: value),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  taskInstanceIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'taskInstanceId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  taskInstanceIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'taskInstanceId',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'taskInstanceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  uninterruptedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'uninterruptedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  uninterruptedMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uninterruptedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FocusSessionModel, FocusSessionModel, QAfterFilterCondition>
  uninterruptedMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uninterruptedMinutes',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uninterruptedMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
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
