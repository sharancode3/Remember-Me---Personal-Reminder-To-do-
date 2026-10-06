// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_record_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetJourneyRecordCollection on Isar {
  IsarCollection<JourneyRecord> get journeyRecords => this.collection();
}

const JourneyRecordSchema = CollectionSchema(
  name: r'JourneyRecord',
  id: 8792539655390489300,
  properties: {
    r'activityType': PropertySchema(
      id: 0,
      name: r'activityType',
      type: IsarType.string,
    ),
    r'averageSpeedKmh': PropertySchema(
      id: 1,
      name: r'averageSpeedKmh',
      type: IsarType.double,
    ),
    r'endTime': PropertySchema(
      id: 2,
      name: r'endTime',
      type: IsarType.dateTime,
    ),
    r'kmSplits': PropertySchema(
      id: 3,
      name: r'kmSplits',
      type: IsarType.objectList,
      target: r'KmSplitModel',
    ),
    r'movingDurationSeconds': PropertySchema(
      id: 4,
      name: r'movingDurationSeconds',
      type: IsarType.long,
    ),
    r'routePoints': PropertySchema(
      id: 5,
      name: r'routePoints',
      type: IsarType.objectList,
      target: r'RoutePointModel',
    ),
    r'startTime': PropertySchema(
      id: 6,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    ),
    r'totalDistanceMeters': PropertySchema(
      id: 8,
      name: r'totalDistanceMeters',
      type: IsarType.double,
    ),
    r'totalDurationSeconds': PropertySchema(
      id: 9,
      name: r'totalDurationSeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _journeyRecordEstimateSize,
  serialize: _journeyRecordSerialize,
  deserialize: _journeyRecordDeserialize,
  deserializeProp: _journeyRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'activityType': IndexSchema(
      id: 1012544980970652462,
      name: r'activityType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'activityType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'startTime': IndexSchema(
      id: -3870335341264752872,
      name: r'startTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'endTime': IndexSchema(
      id: 6854976694250177488,
      name: r'endTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'endTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'KmSplitModel': KmSplitModelSchema,
    r'RoutePointModel': RoutePointModelSchema
  },
  getId: _journeyRecordGetId,
  getLinks: _journeyRecordGetLinks,
  attach: _journeyRecordAttach,
  version: '3.1.0+1',
);

int _journeyRecordEstimateSize(
  JourneyRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activityType.length * 3;
  bytesCount += 3 + object.kmSplits.length * 3;
  {
    final offsets = allOffsets[KmSplitModel]!;
    for (var i = 0; i < object.kmSplits.length; i++) {
      final value = object.kmSplits[i];
      bytesCount += KmSplitModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.routePoints.length * 3;
  {
    final offsets = allOffsets[RoutePointModel]!;
    for (var i = 0; i < object.routePoints.length; i++) {
      final value = object.routePoints[i];
      bytesCount +=
          RoutePointModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _journeyRecordSerialize(
  JourneyRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activityType);
  writer.writeDouble(offsets[1], object.averageSpeedKmh);
  writer.writeDateTime(offsets[2], object.endTime);
  writer.writeObjectList<KmSplitModel>(
    offsets[3],
    allOffsets,
    KmSplitModelSchema.serialize,
    object.kmSplits,
  );
  writer.writeLong(offsets[4], object.movingDurationSeconds);
  writer.writeObjectList<RoutePointModel>(
    offsets[5],
    allOffsets,
    RoutePointModelSchema.serialize,
    object.routePoints,
  );
  writer.writeDateTime(offsets[6], object.startTime);
  writer.writeString(offsets[7], object.title);
  writer.writeDouble(offsets[8], object.totalDistanceMeters);
  writer.writeLong(offsets[9], object.totalDurationSeconds);
}

JourneyRecord _journeyRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = JourneyRecord();
  object.activityType = reader.readString(offsets[0]);
  object.averageSpeedKmh = reader.readDouble(offsets[1]);
  object.endTime = reader.readDateTime(offsets[2]);
  object.id = id;
  object.kmSplits = reader.readObjectList<KmSplitModel>(
        offsets[3],
        KmSplitModelSchema.deserialize,
        allOffsets,
        KmSplitModel(),
      ) ??
      [];
  object.movingDurationSeconds = reader.readLong(offsets[4]);
  object.routePoints = reader.readObjectList<RoutePointModel>(
        offsets[5],
        RoutePointModelSchema.deserialize,
        allOffsets,
        RoutePointModel(),
      ) ??
      [];
  object.startTime = reader.readDateTime(offsets[6]);
  object.title = reader.readStringOrNull(offsets[7]);
  object.totalDistanceMeters = reader.readDouble(offsets[8]);
  object.totalDurationSeconds = reader.readLong(offsets[9]);
  return object;
}

P _journeyRecordDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readObjectList<KmSplitModel>(
            offset,
            KmSplitModelSchema.deserialize,
            allOffsets,
            KmSplitModel(),
          ) ??
          []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readObjectList<RoutePointModel>(
            offset,
            RoutePointModelSchema.deserialize,
            allOffsets,
            RoutePointModel(),
          ) ??
          []) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _journeyRecordGetId(JourneyRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _journeyRecordGetLinks(JourneyRecord object) {
  return [];
}

void _journeyRecordAttach(
    IsarCollection<dynamic> col, Id id, JourneyRecord object) {
  object.id = id;
}

extension JourneyRecordQueryWhereSort
    on QueryBuilder<JourneyRecord, JourneyRecord, QWhere> {
  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhere> anyStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startTime'),
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhere> anyEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'endTime'),
      );
    });
  }
}

extension JourneyRecordQueryWhere
    on QueryBuilder<JourneyRecord, JourneyRecord, QWhereClause> {
  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> idBetween(
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      activityTypeEqualTo(String activityType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'activityType',
        value: [activityType],
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      activityTypeNotEqualTo(String activityType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [],
              upper: [activityType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [activityType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [activityType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'activityType',
              lower: [],
              upper: [activityType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      startTimeEqualTo(DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'startTime',
        value: [startTime],
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      startTimeNotEqualTo(DateTime startTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [],
              upper: [startTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [startTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [startTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'startTime',
              lower: [],
              upper: [startTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      startTimeGreaterThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [startTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      startTimeLessThan(
    DateTime startTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [],
        upper: [startTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      startTimeBetween(
    DateTime lowerStartTime,
    DateTime upperStartTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'startTime',
        lower: [lowerStartTime],
        includeLower: includeLower,
        upper: [upperStartTime],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> endTimeEqualTo(
      DateTime endTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'endTime',
        value: [endTime],
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      endTimeNotEqualTo(DateTime endTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTime',
              lower: [],
              upper: [endTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTime',
              lower: [endTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTime',
              lower: [endTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'endTime',
              lower: [],
              upper: [endTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause>
      endTimeGreaterThan(
    DateTime endTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endTime',
        lower: [endTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> endTimeLessThan(
    DateTime endTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endTime',
        lower: [],
        upper: [endTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterWhereClause> endTimeBetween(
    DateTime lowerEndTime,
    DateTime upperEndTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'endTime',
        lower: [lowerEndTime],
        includeLower: includeLower,
        upper: [upperEndTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension JourneyRecordQueryFilter
    on QueryBuilder<JourneyRecord, JourneyRecord, QFilterCondition> {
  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activityType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activityType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activityType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activityType',
        value: '',
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      activityTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activityType',
        value: '',
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      averageSpeedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      averageSpeedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      averageSpeedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      averageSpeedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      endTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endTime',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      endTimeGreaterThan(
    DateTime value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      endTimeLessThan(
    DateTime value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      endTimeBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmSplits',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmSplits',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmSplits',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmSplits',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmSplits',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'kmSplits',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      movingDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'movingDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      movingDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'movingDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      movingDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'movingDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      movingDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'movingDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routePoints',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routePoints',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routePoints',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routePoints',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routePoints',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'routePoints',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      startTimeGreaterThan(
    DateTime value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      startTimeLessThan(
    DateTime value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      startTimeBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleLessThan(
    String? value, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
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

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDistanceMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDistanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDistanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDistanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDurationSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDurationSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDurationSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDurationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      totalDurationSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDurationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension JourneyRecordQueryObject
    on QueryBuilder<JourneyRecord, JourneyRecord, QFilterCondition> {
  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      kmSplitsElement(FilterQuery<KmSplitModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'kmSplits');
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterFilterCondition>
      routePointsElement(FilterQuery<RoutePointModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'routePoints');
    });
  }
}

extension JourneyRecordQueryLinks
    on QueryBuilder<JourneyRecord, JourneyRecord, QFilterCondition> {}

extension JourneyRecordQuerySortBy
    on QueryBuilder<JourneyRecord, JourneyRecord, QSortBy> {
  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByActivityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByAverageSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByAverageSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> sortByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> sortByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByMovingDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByMovingDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      sortByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }
}

extension JourneyRecordQuerySortThenBy
    on QueryBuilder<JourneyRecord, JourneyRecord, QSortThenBy> {
  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByActivityType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByActivityTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activityType', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByAverageSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByAverageSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenByEndTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endTime', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByMovingDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByMovingDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'movingDurationSeconds', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.asc);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QAfterSortBy>
      thenByTotalDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationSeconds', Sort.desc);
    });
  }
}

extension JourneyRecordQueryWhereDistinct
    on QueryBuilder<JourneyRecord, JourneyRecord, QDistinct> {
  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct> distinctByActivityType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activityType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct>
      distinctByAverageSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageSpeedKmh');
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct> distinctByEndTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endTime');
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct>
      distinctByMovingDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'movingDurationSeconds');
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct>
      distinctByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistanceMeters');
    });
  }

  QueryBuilder<JourneyRecord, JourneyRecord, QDistinct>
      distinctByTotalDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDurationSeconds');
    });
  }
}

extension JourneyRecordQueryProperty
    on QueryBuilder<JourneyRecord, JourneyRecord, QQueryProperty> {
  QueryBuilder<JourneyRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<JourneyRecord, String, QQueryOperations> activityTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activityType');
    });
  }

  QueryBuilder<JourneyRecord, double, QQueryOperations>
      averageSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageSpeedKmh');
    });
  }

  QueryBuilder<JourneyRecord, DateTime, QQueryOperations> endTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endTime');
    });
  }

  QueryBuilder<JourneyRecord, List<KmSplitModel>, QQueryOperations>
      kmSplitsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kmSplits');
    });
  }

  QueryBuilder<JourneyRecord, int, QQueryOperations>
      movingDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'movingDurationSeconds');
    });
  }

  QueryBuilder<JourneyRecord, List<RoutePointModel>, QQueryOperations>
      routePointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routePoints');
    });
  }

  QueryBuilder<JourneyRecord, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<JourneyRecord, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<JourneyRecord, double, QQueryOperations>
      totalDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistanceMeters');
    });
  }

  QueryBuilder<JourneyRecord, int, QQueryOperations>
      totalDurationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDurationSeconds');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const KmSplitModelSchema = Schema(
  name: r'KmSplitModel',
  id: 2246172081842023899,
  properties: {
    r'elapsedSeconds': PropertySchema(
      id: 0,
      name: r'elapsedSeconds',
      type: IsarType.long,
    ),
    r'km': PropertySchema(
      id: 1,
      name: r'km',
      type: IsarType.long,
    )
  },
  estimateSize: _kmSplitModelEstimateSize,
  serialize: _kmSplitModelSerialize,
  deserialize: _kmSplitModelDeserialize,
  deserializeProp: _kmSplitModelDeserializeProp,
);

int _kmSplitModelEstimateSize(
  KmSplitModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _kmSplitModelSerialize(
  KmSplitModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.elapsedSeconds);
  writer.writeLong(offsets[1], object.km);
}

KmSplitModel _kmSplitModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = KmSplitModel(
    elapsedSeconds: reader.readLongOrNull(offsets[0]) ?? 0,
    km: reader.readLongOrNull(offsets[1]) ?? 0,
  );
  return object;
}

P _kmSplitModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension KmSplitModelQueryFilter
    on QueryBuilder<KmSplitModel, KmSplitModel, QFilterCondition> {
  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition>
      elapsedSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'elapsedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition>
      elapsedSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'elapsedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition>
      elapsedSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'elapsedSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition>
      elapsedSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'elapsedSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition> kmEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'km',
        value: value,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition> kmGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'km',
        value: value,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition> kmLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'km',
        value: value,
      ));
    });
  }

  QueryBuilder<KmSplitModel, KmSplitModel, QAfterFilterCondition> kmBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'km',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension KmSplitModelQueryObject
    on QueryBuilder<KmSplitModel, KmSplitModel, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const RoutePointModelSchema = Schema(
  name: r'RoutePointModel',
  id: -1756514952418907225,
  properties: {
    r'latitude': PropertySchema(
      id: 0,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'longitude': PropertySchema(
      id: 1,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'speedKmh': PropertySchema(
      id: 2,
      name: r'speedKmh',
      type: IsarType.double,
    ),
    r'timestampOffsetSeconds': PropertySchema(
      id: 3,
      name: r'timestampOffsetSeconds',
      type: IsarType.long,
    )
  },
  estimateSize: _routePointModelEstimateSize,
  serialize: _routePointModelSerialize,
  deserialize: _routePointModelDeserialize,
  deserializeProp: _routePointModelDeserializeProp,
);

int _routePointModelEstimateSize(
  RoutePointModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _routePointModelSerialize(
  RoutePointModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.latitude);
  writer.writeDouble(offsets[1], object.longitude);
  writer.writeDouble(offsets[2], object.speedKmh);
  writer.writeLong(offsets[3], object.timestampOffsetSeconds);
}

RoutePointModel _routePointModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RoutePointModel(
    latitude: reader.readDoubleOrNull(offsets[0]) ?? 0.0,
    longitude: reader.readDoubleOrNull(offsets[1]) ?? 0.0,
    speedKmh: reader.readDoubleOrNull(offsets[2]) ?? 0.0,
    timestampOffsetSeconds: reader.readLongOrNull(offsets[3]) ?? 0,
  );
  return object;
}

P _routePointModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 1:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 0.0) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension RoutePointModelQueryFilter
    on QueryBuilder<RoutePointModel, RoutePointModel, QFilterCondition> {
  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      speedKmhEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      speedKmhGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      speedKmhLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      speedKmhBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      timestampOffsetSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestampOffsetSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      timestampOffsetSecondsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestampOffsetSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      timestampOffsetSecondsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestampOffsetSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutePointModel, RoutePointModel, QAfterFilterCondition>
      timestampOffsetSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestampOffsetSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RoutePointModelQueryObject
    on QueryBuilder<RoutePointModel, RoutePointModel, QFilterCondition> {}
