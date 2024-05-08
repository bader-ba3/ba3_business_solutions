// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Products extends _Products
    with RealmEntity, RealmObjectBase, RealmObject {
  Products(
    ObjectId? id, {
    String? prodBarcode,
    Iterable<String> prodChild = const [],
    String? prodCode,
    String? prodCostPrice,
    String? prodCustomerPrice,
    String? prodFullCode,
    String? prodGroupCode,
    int? prodGroupPad,
    bool? prodHasVat,
    String? prodId,
    String? prodImage,
    bool? prodIsGroup,
    bool? prodIsLocal,
    bool? prodIsParent,
    String? prodMinPrice,
    String? prodName,
    String? prodParentId,
    Iterable<ProdRecord> prodRecord = const [],
    String? prodRetailPrice,
    String? prodType,
    String? prodWholePrice,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'prodBarcode', prodBarcode);
    RealmObjectBase.set<RealmList<String>>(
        this, 'prodChild', RealmList<String>(prodChild));
    RealmObjectBase.set(this, 'prodCode', prodCode);
    RealmObjectBase.set(this, 'prodCostPrice', prodCostPrice);
    RealmObjectBase.set(this, 'prodCustomerPrice', prodCustomerPrice);
    RealmObjectBase.set(this, 'prodFullCode', prodFullCode);
    RealmObjectBase.set(this, 'prodGroupCode', prodGroupCode);
    RealmObjectBase.set(this, 'prodGroupPad', prodGroupPad);
    RealmObjectBase.set(this, 'prodHasVat', prodHasVat);
    RealmObjectBase.set(this, 'prodId', prodId);
    RealmObjectBase.set(this, 'prodImage', prodImage);
    RealmObjectBase.set(this, 'prodIsGroup', prodIsGroup);
    RealmObjectBase.set(this, 'prodIsLocal', prodIsLocal);
    RealmObjectBase.set(this, 'prodIsParent', prodIsParent);
    RealmObjectBase.set(this, 'prodMinPrice', prodMinPrice);
    RealmObjectBase.set(this, 'prodName', prodName);
    RealmObjectBase.set(this, 'prodParentId', prodParentId);
    RealmObjectBase.set<RealmList<ProdRecord>>(
        this, 'prodRecord', RealmList<ProdRecord>(prodRecord));
    RealmObjectBase.set(this, 'prodRetailPrice', prodRetailPrice);
    RealmObjectBase.set(this, 'prodType', prodType);
    RealmObjectBase.set(this, 'prodWholePrice', prodWholePrice);
  }

  Products._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get prodBarcode =>
      RealmObjectBase.get<String>(this, 'prodBarcode') as String?;
  @override
  set prodBarcode(String? value) =>
      RealmObjectBase.set(this, 'prodBarcode', value);

  @override
  RealmList<String> get prodChild =>
      RealmObjectBase.get<String>(this, 'prodChild') as RealmList<String>;
  @override
  set prodChild(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get prodCode =>
      RealmObjectBase.get<String>(this, 'prodCode') as String?;
  @override
  set prodCode(String? value) => RealmObjectBase.set(this, 'prodCode', value);

  @override
  String? get prodCostPrice =>
      RealmObjectBase.get<String>(this, 'prodCostPrice') as String?;
  @override
  set prodCostPrice(String? value) =>
      RealmObjectBase.set(this, 'prodCostPrice', value);

  @override
  String? get prodCustomerPrice =>
      RealmObjectBase.get<String>(this, 'prodCustomerPrice') as String?;
  @override
  set prodCustomerPrice(String? value) =>
      RealmObjectBase.set(this, 'prodCustomerPrice', value);

  @override
  String? get prodFullCode =>
      RealmObjectBase.get<String>(this, 'prodFullCode') as String?;
  @override
  set prodFullCode(String? value) =>
      RealmObjectBase.set(this, 'prodFullCode', value);

  @override
  String? get prodGroupCode =>
      RealmObjectBase.get<String>(this, 'prodGroupCode') as String?;
  @override
  set prodGroupCode(String? value) =>
      RealmObjectBase.set(this, 'prodGroupCode', value);

  @override
  int? get prodGroupPad =>
      RealmObjectBase.get<int>(this, 'prodGroupPad') as int?;
  @override
  set prodGroupPad(int? value) =>
      RealmObjectBase.set(this, 'prodGroupPad', value);

  @override
  bool? get prodHasVat =>
      RealmObjectBase.get<bool>(this, 'prodHasVat') as bool?;
  @override
  set prodHasVat(bool? value) => RealmObjectBase.set(this, 'prodHasVat', value);

  @override
  String? get prodId => RealmObjectBase.get<String>(this, 'prodId') as String?;
  @override
  set prodId(String? value) => RealmObjectBase.set(this, 'prodId', value);

  @override
  String? get prodImage =>
      RealmObjectBase.get<String>(this, 'prodImage') as String?;
  @override
  set prodImage(String? value) => RealmObjectBase.set(this, 'prodImage', value);

  @override
  bool? get prodIsGroup =>
      RealmObjectBase.get<bool>(this, 'prodIsGroup') as bool?;
  @override
  set prodIsGroup(bool? value) =>
      RealmObjectBase.set(this, 'prodIsGroup', value);

  @override
  bool? get prodIsLocal =>
      RealmObjectBase.get<bool>(this, 'prodIsLocal') as bool?;
  @override
  set prodIsLocal(bool? value) =>
      RealmObjectBase.set(this, 'prodIsLocal', value);

  @override
  bool? get prodIsParent =>
      RealmObjectBase.get<bool>(this, 'prodIsParent') as bool?;
  @override
  set prodIsParent(bool? value) =>
      RealmObjectBase.set(this, 'prodIsParent', value);

  @override
  String? get prodMinPrice =>
      RealmObjectBase.get<String>(this, 'prodMinPrice') as String?;
  @override
  set prodMinPrice(String? value) =>
      RealmObjectBase.set(this, 'prodMinPrice', value);

  @override
  String? get prodName =>
      RealmObjectBase.get<String>(this, 'prodName') as String?;
  @override
  set prodName(String? value) => RealmObjectBase.set(this, 'prodName', value);

  @override
  String? get prodParentId =>
      RealmObjectBase.get<String>(this, 'prodParentId') as String?;
  @override
  set prodParentId(String? value) =>
      RealmObjectBase.set(this, 'prodParentId', value);

  @override
  RealmList<ProdRecord> get prodRecord =>
      RealmObjectBase.get<ProdRecord>(this, 'prodRecord')
          as RealmList<ProdRecord>;
  @override
  set prodRecord(covariant RealmList<ProdRecord> value) =>
      throw RealmUnsupportedSetError();

  @override
  String? get prodRetailPrice =>
      RealmObjectBase.get<String>(this, 'prodRetailPrice') as String?;
  @override
  set prodRetailPrice(String? value) =>
      RealmObjectBase.set(this, 'prodRetailPrice', value);

  @override
  String? get prodType =>
      RealmObjectBase.get<String>(this, 'prodType') as String?;
  @override
  set prodType(String? value) => RealmObjectBase.set(this, 'prodType', value);

  @override
  String? get prodWholePrice =>
      RealmObjectBase.get<String>(this, 'prodWholePrice') as String?;
  @override
  set prodWholePrice(String? value) =>
      RealmObjectBase.set(this, 'prodWholePrice', value);

  @override
  Stream<RealmObjectChanges<Products>> get changes =>
      RealmObjectBase.getChanges<Products>(this);

  @override
  Stream<RealmObjectChanges<Products>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Products>(this, keyPaths);

  @override
  Products freeze() => RealmObjectBase.freezeObject<Products>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'prodBarcode': prodBarcode.toEJson(),
      'prodChild': prodChild.toEJson(),
      'prodCode': prodCode.toEJson(),
      'prodCostPrice': prodCostPrice.toEJson(),
      'prodCustomerPrice': prodCustomerPrice.toEJson(),
      'prodFullCode': prodFullCode.toEJson(),
      'prodGroupCode': prodGroupCode.toEJson(),
      'prodGroupPad': prodGroupPad.toEJson(),
      'prodHasVat': prodHasVat.toEJson(),
      'prodId': prodId.toEJson(),
      'prodImage': prodImage.toEJson(),
      'prodIsGroup': prodIsGroup.toEJson(),
      'prodIsLocal': prodIsLocal.toEJson(),
      'prodIsParent': prodIsParent.toEJson(),
      'prodMinPrice': prodMinPrice.toEJson(),
      'prodName': prodName.toEJson(),
      'prodParentId': prodParentId.toEJson(),
      'prodRecord': prodRecord.toEJson(),
      'prodRetailPrice': prodRetailPrice.toEJson(),
      'prodType': prodType.toEJson(),
      'prodWholePrice': prodWholePrice.toEJson(),
    };
  }

  static EJsonValue _toEJson(Products value) => value.toEJson();
  static Products _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'prodBarcode': EJsonValue prodBarcode,
        'prodChild': EJsonValue prodChild,
        'prodCode': EJsonValue prodCode,
        'prodCostPrice': EJsonValue prodCostPrice,
        'prodCustomerPrice': EJsonValue prodCustomerPrice,
        'prodFullCode': EJsonValue prodFullCode,
        'prodGroupCode': EJsonValue prodGroupCode,
        'prodGroupPad': EJsonValue prodGroupPad,
        'prodHasVat': EJsonValue prodHasVat,
        'prodId': EJsonValue prodId,
        'prodImage': EJsonValue prodImage,
        'prodIsGroup': EJsonValue prodIsGroup,
        'prodIsLocal': EJsonValue prodIsLocal,
        'prodIsParent': EJsonValue prodIsParent,
        'prodMinPrice': EJsonValue prodMinPrice,
        'prodName': EJsonValue prodName,
        'prodParentId': EJsonValue prodParentId,
        'prodRecord': EJsonValue prodRecord,
        'prodRetailPrice': EJsonValue prodRetailPrice,
        'prodType': EJsonValue prodType,
        'prodWholePrice': EJsonValue prodWholePrice,
      } =>
        Products(
          fromEJson(id),
          prodBarcode: fromEJson(prodBarcode),
          prodChild: fromEJson(prodChild),
          prodCode: fromEJson(prodCode),
          prodCostPrice: fromEJson(prodCostPrice),
          prodCustomerPrice: fromEJson(prodCustomerPrice),
          prodFullCode: fromEJson(prodFullCode),
          prodGroupCode: fromEJson(prodGroupCode),
          prodGroupPad: fromEJson(prodGroupPad),
          prodHasVat: fromEJson(prodHasVat),
          prodId: fromEJson(prodId),
          prodImage: fromEJson(prodImage),
          prodIsGroup: fromEJson(prodIsGroup),
          prodIsLocal: fromEJson(prodIsLocal),
          prodIsParent: fromEJson(prodIsParent),
          prodMinPrice: fromEJson(prodMinPrice),
          prodName: fromEJson(prodName),
          prodParentId: fromEJson(prodParentId),
          prodRecord: fromEJson(prodRecord),
          prodRetailPrice: fromEJson(prodRetailPrice),
          prodType: fromEJson(prodType),
          prodWholePrice: fromEJson(prodWholePrice),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Products._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Products, 'Products', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true, primaryKey: true),
      SchemaProperty('prodBarcode', RealmPropertyType.string, optional: true),
      SchemaProperty('prodChild', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('prodCode', RealmPropertyType.string, optional: true),
      SchemaProperty('prodCostPrice', RealmPropertyType.string, optional: true),
      SchemaProperty('prodCustomerPrice', RealmPropertyType.string,
          optional: true),
      SchemaProperty('prodFullCode', RealmPropertyType.string, optional: true),
      SchemaProperty('prodGroupCode', RealmPropertyType.string, optional: true),
      SchemaProperty('prodGroupPad', RealmPropertyType.int, optional: true),
      SchemaProperty('prodHasVat', RealmPropertyType.bool, optional: true),
      SchemaProperty('prodId', RealmPropertyType.string, optional: true),
      SchemaProperty('prodImage', RealmPropertyType.string, optional: true),
      SchemaProperty('prodIsGroup', RealmPropertyType.bool, optional: true),
      SchemaProperty('prodIsLocal', RealmPropertyType.bool, optional: true),
      SchemaProperty('prodIsParent', RealmPropertyType.bool, optional: true),
      SchemaProperty('prodMinPrice', RealmPropertyType.string, optional: true),
      SchemaProperty('prodName', RealmPropertyType.string, optional: true),
      SchemaProperty('prodParentId', RealmPropertyType.string, optional: true),
      SchemaProperty('prodRecord', RealmPropertyType.object,
          linkTarget: 'prodRecord', collectionType: RealmCollectionType.list),
      SchemaProperty('prodRetailPrice', RealmPropertyType.string,
          optional: true),
      SchemaProperty('prodType', RealmPropertyType.string, optional: true),
      SchemaProperty('prodWholePrice', RealmPropertyType.string,
          optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class ProdRecord extends _ProdRecord
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  ProdRecord({
    ObjectId? id,
    String? invId,
    String? prodRecDate,
    String? prodRecId,
    String? prodRecProduct,
    String? prodRecQuantity,
    String? prodRecSubTotal,
    String? prodRecSubVat,
    String? prodRecTotal,
    String? prodType,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'invId', invId);
    RealmObjectBase.set(this, 'prodRecDate', prodRecDate);
    RealmObjectBase.set(this, 'prodRecId', prodRecId);
    RealmObjectBase.set(this, 'prodRecProduct', prodRecProduct);
    RealmObjectBase.set(this, 'prodRecQuantity', prodRecQuantity);
    RealmObjectBase.set(this, 'prodRecSubTotal', prodRecSubTotal);
    RealmObjectBase.set(this, 'prodRecSubVat', prodRecSubVat);
    RealmObjectBase.set(this, 'prodRecTotal', prodRecTotal);
    RealmObjectBase.set(this, 'prodType', prodType);
  }

  ProdRecord._();

  @override
  ObjectId? get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId?;
  @override
  set id(ObjectId? value) => RealmObjectBase.set(this, '_id', value);

  @override
  String? get invId => RealmObjectBase.get<String>(this, 'invId') as String?;
  @override
  set invId(String? value) => RealmObjectBase.set(this, 'invId', value);

  @override
  String? get prodRecDate =>
      RealmObjectBase.get<String>(this, 'prodRecDate') as String?;
  @override
  set prodRecDate(String? value) =>
      RealmObjectBase.set(this, 'prodRecDate', value);

  @override
  String? get prodRecId =>
      RealmObjectBase.get<String>(this, 'prodRecId') as String?;
  @override
  set prodRecId(String? value) => RealmObjectBase.set(this, 'prodRecId', value);

  @override
  String? get prodRecProduct =>
      RealmObjectBase.get<String>(this, 'prodRecProduct') as String?;
  @override
  set prodRecProduct(String? value) =>
      RealmObjectBase.set(this, 'prodRecProduct', value);

  @override
  String? get prodRecQuantity =>
      RealmObjectBase.get<String>(this, 'prodRecQuantity') as String?;
  @override
  set prodRecQuantity(String? value) =>
      RealmObjectBase.set(this, 'prodRecQuantity', value);

  @override
  String? get prodRecSubTotal =>
      RealmObjectBase.get<String>(this, 'prodRecSubTotal') as String?;
  @override
  set prodRecSubTotal(String? value) =>
      RealmObjectBase.set(this, 'prodRecSubTotal', value);

  @override
  String? get prodRecSubVat =>
      RealmObjectBase.get<String>(this, 'prodRecSubVat') as String?;
  @override
  set prodRecSubVat(String? value) =>
      RealmObjectBase.set(this, 'prodRecSubVat', value);

  @override
  String? get prodRecTotal =>
      RealmObjectBase.get<String>(this, 'prodRecTotal') as String?;
  @override
  set prodRecTotal(String? value) =>
      RealmObjectBase.set(this, 'prodRecTotal', value);

  @override
  String? get prodType =>
      RealmObjectBase.get<String>(this, 'prodType') as String?;
  @override
  set prodType(String? value) => RealmObjectBase.set(this, 'prodType', value);

  @override
  Stream<RealmObjectChanges<ProdRecord>> get changes =>
      RealmObjectBase.getChanges<ProdRecord>(this);

  @override
  Stream<RealmObjectChanges<ProdRecord>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<ProdRecord>(this, keyPaths);

  @override
  ProdRecord freeze() => RealmObjectBase.freezeObject<ProdRecord>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'invId': invId.toEJson(),
      'prodRecDate': prodRecDate.toEJson(),
      'prodRecId': prodRecId.toEJson(),
      'prodRecProduct': prodRecProduct.toEJson(),
      'prodRecQuantity': prodRecQuantity.toEJson(),
      'prodRecSubTotal': prodRecSubTotal.toEJson(),
      'prodRecSubVat': prodRecSubVat.toEJson(),
      'prodRecTotal': prodRecTotal.toEJson(),
      'prodType': prodType.toEJson(),
    };
  }

  static EJsonValue _toEJson(ProdRecord value) => value.toEJson();
  static ProdRecord _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'invId': EJsonValue invId,
        'prodRecDate': EJsonValue prodRecDate,
        'prodRecId': EJsonValue prodRecId,
        'prodRecProduct': EJsonValue prodRecProduct,
        'prodRecQuantity': EJsonValue prodRecQuantity,
        'prodRecSubTotal': EJsonValue prodRecSubTotal,
        'prodRecSubVat': EJsonValue prodRecSubVat,
        'prodRecTotal': EJsonValue prodRecTotal,
        'prodType': EJsonValue prodType,
      } =>
        ProdRecord(
          id: fromEJson(id),
          invId: fromEJson(invId),
          prodRecDate: fromEJson(prodRecDate),
          prodRecId: fromEJson(prodRecId),
          prodRecProduct: fromEJson(prodRecProduct),
          prodRecQuantity: fromEJson(prodRecQuantity),
          prodRecSubTotal: fromEJson(prodRecSubTotal),
          prodRecSubVat: fromEJson(prodRecSubVat),
          prodRecTotal: fromEJson(prodRecTotal),
          prodType: fromEJson(prodType),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(ProdRecord._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.embeddedObject, ProdRecord, 'prodRecord', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', optional: true),
      SchemaProperty('invId', RealmPropertyType.string, optional: true),
      SchemaProperty('prodRecDate', RealmPropertyType.string, optional: true),
      SchemaProperty('prodRecId', RealmPropertyType.string, optional: true),
      SchemaProperty('prodRecProduct', RealmPropertyType.string,
          optional: true),
      SchemaProperty('prodRecQuantity', RealmPropertyType.string,
          optional: true),
      SchemaProperty('prodRecSubTotal', RealmPropertyType.string,
          optional: true),
      SchemaProperty('prodRecSubVat', RealmPropertyType.string, optional: true),
      SchemaProperty('prodRecTotal', RealmPropertyType.string, optional: true),
      SchemaProperty('prodType', RealmPropertyType.string, optional: true),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
