// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsc.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast

extension GetSubscriptionItemCollection on Isar {
  IsarCollection<SubscriptionItem> get subscriptionItems {
    return getCollection('SubscriptionItem');
  }
}

final SubscriptionItemSchema = CollectionSchema(
  name: 'SubscriptionItem',
  schema:
      '{"name":"SubscriptionItem","idName":"id","properties":[{"name":"name","type":"String"},{"name":"nextPaymentAt","type":"Long"},{"name":"price","type":"Long"}],"indexes":[],"links":[]}',
  nativeAdapter: const _SubscriptionItemNativeAdapter(),
  webAdapter: const _SubscriptionItemWebAdapter(),
  idName: 'id',
  propertyIds: {'name': 0, 'nextPaymentAt': 1, 'price': 2},
  listProperties: {},
  indexIds: {},
  indexTypes: {},
  linkIds: {},
  backlinkIds: {},
  linkedCollections: [],
  getId: (obj) {
    if (obj.id == Isar.autoIncrement) {
      return null;
    } else {
      return obj.id;
    }
  },
  setId: (obj, id) => obj.id = id,
  getLinks: (obj) => [],
  version: 2,
);

class _SubscriptionItemWebAdapter extends IsarWebTypeAdapter<SubscriptionItem> {
  const _SubscriptionItemWebAdapter();

  @override
  Object serialize(
      IsarCollection<SubscriptionItem> collection, SubscriptionItem object) {
    final jsObj = IsarNative.newJsObject();
    IsarNative.jsObjectSet(jsObj, 'id', object.id);
    IsarNative.jsObjectSet(jsObj, 'name', object.name);
    IsarNative.jsObjectSet(jsObj, 'nextPaymentAt',
        object.nextPaymentAt?.toUtc().millisecondsSinceEpoch);
    IsarNative.jsObjectSet(jsObj, 'price', object.price);
    return jsObj;
  }

  @override
  SubscriptionItem deserialize(
      IsarCollection<SubscriptionItem> collection, dynamic jsObj) {
    final object = SubscriptionItem(
      IsarNative.jsObjectGet(jsObj, 'name'),
      IsarNative.jsObjectGet(jsObj, 'price'),
      IsarNative.jsObjectGet(jsObj, 'nextPaymentAt') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'nextPaymentAt'),
                  isUtc: true)
              .toLocal()
          : null,
    );
    object.id = IsarNative.jsObjectGet(jsObj, 'id');
    return object;
  }

  @override
  P deserializeProperty<P>(Object jsObj, String propertyName) {
    switch (propertyName) {
      case 'id':
        return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
      case 'name':
        return (IsarNative.jsObjectGet(jsObj, 'name')) as P;
      case 'nextPaymentAt':
        return (IsarNative.jsObjectGet(jsObj, 'nextPaymentAt') != null
            ? DateTime.fromMillisecondsSinceEpoch(
                    IsarNative.jsObjectGet(jsObj, 'nextPaymentAt'),
                    isUtc: true)
                .toLocal()
            : null) as P;
      case 'price':
        return (IsarNative.jsObjectGet(jsObj, 'price')) as P;
      default:
        throw 'Illegal propertyName';
    }
  }

  @override
  void attachLinks(Isar isar, int id, SubscriptionItem object) {}
}

class _SubscriptionItemNativeAdapter
    extends IsarNativeTypeAdapter<SubscriptionItem> {
  const _SubscriptionItemNativeAdapter();

  @override
  void serialize(
      IsarCollection<SubscriptionItem> collection,
      IsarRawObject rawObj,
      SubscriptionItem object,
      int staticSize,
      List<int> offsets,
      AdapterAlloc alloc) {
    var dynamicSize = 0;
    final value0 = object.name;
    IsarUint8List? _name;
    if (value0 != null) {
      _name = IsarBinaryWriter.utf8Encoder.convert(value0);
    }
    dynamicSize += (_name?.length ?? 0) as int;
    final value1 = object.nextPaymentAt;
    final _nextPaymentAt = value1;
    final value2 = object.price;
    final _price = value2;
    final size = staticSize + dynamicSize;

    rawObj.buffer = alloc(size);
    rawObj.buffer_length = size;
    final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
    final writer = IsarBinaryWriter(buffer, staticSize);
    writer.writeBytes(offsets[0], _name);
    writer.writeDateTime(offsets[1], _nextPaymentAt);
    writer.writeLong(offsets[2], _price);
  }

  @override
  SubscriptionItem deserialize(IsarCollection<SubscriptionItem> collection,
      int id, IsarBinaryReader reader, List<int> offsets) {
    final object = SubscriptionItem(
      reader.readStringOrNull(offsets[0]),
      reader.readLongOrNull(offsets[2]),
      reader.readDateTimeOrNull(offsets[1]),
    );
    object.id = id;
    return object;
  }

  @override
  P deserializeProperty<P>(
      int id, IsarBinaryReader reader, int propertyIndex, int offset) {
    switch (propertyIndex) {
      case -1:
        return id as P;
      case 0:
        return (reader.readStringOrNull(offset)) as P;
      case 1:
        return (reader.readDateTimeOrNull(offset)) as P;
      case 2:
        return (reader.readLongOrNull(offset)) as P;
      default:
        throw 'Illegal propertyIndex';
    }
  }

  @override
  void attachLinks(Isar isar, int id, SubscriptionItem object) {}
}

extension SubscriptionItemQueryWhereSort
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QWhere> {
  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterWhere> anyId() {
    return addWhereClauseInternal(const WhereClause(indexName: null));
  }
}

extension SubscriptionItemQueryWhere
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QWhereClause> {
  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterWhereClause> idEqualTo(
      int? id) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: true,
      upper: [id],
      includeUpper: true,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterWhereClause>
      idNotEqualTo(int? id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      ));
    } else {
      return addWhereClauseInternal(WhereClause(
        indexName: null,
        lower: [id],
        includeLower: false,
      )).addWhereClauseInternal(WhereClause(
        indexName: null,
        upper: [id],
        includeUpper: false,
      ));
    }
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterWhereClause>
      idGreaterThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [id],
      includeLower: include,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterWhereClause>
      idLessThan(
    int? id, {
    bool include = false,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      upper: [id],
      includeUpper: include,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterWhereClause> idBetween(
    int? lowerId,
    int? upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(WhereClause(
      indexName: null,
      lower: [lowerId],
      includeLower: includeLower,
      upper: [upperId],
      includeUpper: includeUpper,
    ));
  }
}

extension SubscriptionItemQueryFilter
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QFilterCondition> {
  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      idEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      idGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      idLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      idBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'name',
      value: null,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nextPaymentAtIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'nextPaymentAt',
      value: null,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nextPaymentAtEqualTo(DateTime? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'nextPaymentAt',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nextPaymentAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'nextPaymentAt',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nextPaymentAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'nextPaymentAt',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      nextPaymentAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'nextPaymentAt',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      priceIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'price',
      value: null,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      priceEqualTo(int? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      priceGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      priceLessThan(
    int? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'price',
      value: value,
    ));
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterFilterCondition>
      priceBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'price',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension SubscriptionItemQueryLinks
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QFilterCondition> {}

extension SubscriptionItemQueryWhereSortBy
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QSortBy> {
  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      sortByNextPaymentAt() {
    return addSortByInternal('nextPaymentAt', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      sortByNextPaymentAtDesc() {
    return addSortByInternal('nextPaymentAt', Sort.desc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy> sortByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      sortByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }
}

extension SubscriptionItemQueryWhereSortThenBy
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QSortThenBy> {
  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      thenByNextPaymentAt() {
    return addSortByInternal('nextPaymentAt', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      thenByNextPaymentAtDesc() {
    return addSortByInternal('nextPaymentAt', Sort.desc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy> thenByPrice() {
    return addSortByInternal('price', Sort.asc);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QAfterSortBy>
      thenByPriceDesc() {
    return addSortByInternal('price', Sort.desc);
  }
}

extension SubscriptionItemQueryWhereDistinct
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QDistinct> {
  QueryBuilder<SubscriptionItem, SubscriptionItem, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QDistinct>
      distinctByNextPaymentAt() {
    return addDistinctByInternal('nextPaymentAt');
  }

  QueryBuilder<SubscriptionItem, SubscriptionItem, QDistinct>
      distinctByPrice() {
    return addDistinctByInternal('price');
  }
}

extension SubscriptionItemQueryProperty
    on QueryBuilder<SubscriptionItem, SubscriptionItem, QQueryProperty> {
  QueryBuilder<SubscriptionItem, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<SubscriptionItem, String?, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<SubscriptionItem, DateTime?, QQueryOperations>
      nextPaymentAtProperty() {
    return addPropertyNameInternal('nextPaymentAt');
  }

  QueryBuilder<SubscriptionItem, int?, QQueryOperations> priceProperty() {
    return addPropertyNameInternal('price');
  }
}
