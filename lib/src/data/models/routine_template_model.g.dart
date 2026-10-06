// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_template_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRoutineTemplateModelCollection on Isar {
  IsarCollection<RoutineTemplateModel> get routineTemplateModels =>
      this.collection();
}

const RoutineTemplateModelSchema = CollectionSchema(
  name: r'RoutineTemplateModel',
  id: -4602115686298698328,
  properties: {
    r'checklistBlueprint': PropertySchema(
      id: 0,
      name: r'checklistBlueprint',
      type: IsarType.stringList,
    ),
    r'endMinuteOfDay': PropertySchema(
      id: 1,
      name: r'endMinuteOfDay',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'reminderOffsetMinutes': PropertySchema(
      id: 3,
      name: r'reminderOffsetMinutes',
      type: IsarType.long,
    ),
    r'startMinuteOfDay': PropertySchema(
      id: 4,
      name: r'startMinuteOfDay',
      type: IsarType.long,
    ),
    r'tag': PropertySchema(
      id: 5,
      name: r'tag',
      type: IsarType.object,
      target: r'TaskTagModel',
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'weekdays': PropertySchema(
      id: 7,
      name: r'weekdays',
      type: IsarType.longList,
    )
  },
  estimateSize: _routineTemplateModelEstimateSize,
  serialize: _routineTemplateModelSerialize,
  deserialize: _routineTemplateModelDeserialize,
  deserializeProp: _routineTemplateModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'TaskTagModel': TaskTagModelSchema},
  getId: _routineTemplateModelGetId,
  getLinks: _routineTemplateModelGetLinks,
  attach: _routineTemplateModelAttach,
  version: '3.1.0+1',
);

int _routineTemplateModelEstimateSize(
  RoutineTemplateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.checklistBlueprint.length * 3;
  {
    for (var i = 0; i < object.checklistBlueprint.length; i++) {
      final value = object.checklistBlueprint[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.tag;
    if (value != null) {
      bytesCount += 3 +
          TaskTagModelSchema.estimateSize(
              value, allOffsets[TaskTagModel]!, allOffsets);
    }
  }
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.weekdays.length * 8;
  return bytesCount;
}

void _routineTemplateModelSerialize(
  RoutineTemplateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.checklistBlueprint);
  writer.writeLong(offsets[1], object.endMinuteOfDay);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeLong(offsets[3], object.reminderOffsetMinutes);
  writer.writeLong(offsets[4], object.startMinuteOfDay);
  writer.writeObject<TaskTagModel>(
    offsets[5],
    allOffsets,
    TaskTagModelSchema.serialize,
    object.tag,
  );
  writer.writeString(offsets[6], object.title);
  writer.writeLongList(offsets[7], object.weekdays);
}

RoutineTemplateModel _routineTemplateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RoutineTemplateModel();
  object.checklistBlueprint = reader.readStringList(offsets[0]) ?? [];
  object.endMinuteOfDay = reader.readLong(offsets[1]);
  object.id = id;
  object.isActive = reader.readBool(offsets[2]);
  object.reminderOffsetMinutes = reader.readLong(offsets[3]);
  object.startMinuteOfDay = reader.readLong(offsets[4]);
  object.tag = reader.readObjectOrNull<TaskTagModel>(
    offsets[5],
    TaskTagModelSchema.deserialize,
    allOffsets,
  );
  object.title = reader.readString(offsets[6]);
  object.weekdays = reader.readLongList(offsets[7]) ?? [];
  return object;
}

P _routineTemplateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readObjectOrNull<TaskTagModel>(
        offset,
        TaskTagModelSchema.deserialize,
        allOffsets,
      )) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _routineTemplateModelGetId(RoutineTemplateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _routineTemplateModelGetLinks(
    RoutineTemplateModel object) {
  return [];
}

void _routineTemplateModelAttach(
    IsarCollection<dynamic> col, Id id, RoutineTemplateModel object) {
  object.id = id;
}

extension RoutineTemplateModelQueryWhereSort
    on QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QWhere> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RoutineTemplateModelQueryWhere
    on QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QWhereClause> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterWhereClause>
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterWhereClause>
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

extension RoutineTemplateModelQueryFilter on QueryBuilder<RoutineTemplateModel,
    RoutineTemplateModel, QFilterCondition> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checklistBlueprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checklistBlueprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checklistBlueprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checklistBlueprint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checklistBlueprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checklistBlueprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
          QAfterFilterCondition>
      checklistBlueprintElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checklistBlueprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
          QAfterFilterCondition>
      checklistBlueprintElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checklistBlueprint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checklistBlueprint',
        value: '',
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checklistBlueprint',
        value: '',
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklistBlueprint',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklistBlueprint',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklistBlueprint',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklistBlueprint',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklistBlueprint',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> checklistBlueprintLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'checklistBlueprint',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> endMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> reminderOffsetMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reminderOffsetMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> reminderOffsetMinutesGreaterThan(
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> reminderOffsetMinutesLessThan(
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> reminderOffsetMinutesBetween(
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> startMinuteOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startMinuteOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> tagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tag',
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> tagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tag',
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
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

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekdays',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekdays',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekdays',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekdays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> weekdaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'weekdays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension RoutineTemplateModelQueryObject on QueryBuilder<RoutineTemplateModel,
    RoutineTemplateModel, QFilterCondition> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel,
      QAfterFilterCondition> tag(FilterQuery<TaskTagModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tag');
    });
  }
}

extension RoutineTemplateModelQueryLinks on QueryBuilder<RoutineTemplateModel,
    RoutineTemplateModel, QFilterCondition> {}

extension RoutineTemplateModelQuerySortBy
    on QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QSortBy> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByEndMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByStartMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension RoutineTemplateModelQuerySortThenBy
    on QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QSortThenBy> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByEndMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByReminderOffsetMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderOffsetMinutes', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByStartMinuteOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startMinuteOfDay', Sort.desc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension RoutineTemplateModelQueryWhereDistinct
    on QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct> {
  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByChecklistBlueprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checklistBlueprint');
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByEndMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endMinuteOfDay');
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByReminderOffsetMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderOffsetMinutes');
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByStartMinuteOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startMinuteOfDay');
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoutineTemplateModel, RoutineTemplateModel, QDistinct>
      distinctByWeekdays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekdays');
    });
  }
}

extension RoutineTemplateModelQueryProperty on QueryBuilder<
    RoutineTemplateModel, RoutineTemplateModel, QQueryProperty> {
  QueryBuilder<RoutineTemplateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RoutineTemplateModel, List<String>, QQueryOperations>
      checklistBlueprintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checklistBlueprint');
    });
  }

  QueryBuilder<RoutineTemplateModel, int, QQueryOperations>
      endMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endMinuteOfDay');
    });
  }

  QueryBuilder<RoutineTemplateModel, bool, QQueryOperations>
      isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<RoutineTemplateModel, int, QQueryOperations>
      reminderOffsetMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderOffsetMinutes');
    });
  }

  QueryBuilder<RoutineTemplateModel, int, QQueryOperations>
      startMinuteOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startMinuteOfDay');
    });
  }

  QueryBuilder<RoutineTemplateModel, TaskTagModel?, QQueryOperations>
      tagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tag');
    });
  }

  QueryBuilder<RoutineTemplateModel, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<RoutineTemplateModel, List<int>, QQueryOperations>
      weekdaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekdays');
    });
  }
}
