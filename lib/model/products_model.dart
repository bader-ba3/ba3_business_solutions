import 'package:realm/realm.dart';

part 'products_model.realm.dart';



@RealmModel()
class _Products {
  @PrimaryKey()
  @MapTo('_id')
  ObjectId? id;
  String? prodBarcode;
  late List<String> prodChild;
  String? prodCode;
  String? prodCostPrice;
  String? prodCustomerPrice;
  String? prodFullCode;
  String? prodGroupCode;
  int? prodGroupPad;
  bool? prodHasVat;
  String? prodId;
  String? prodImage;
  bool? prodIsGroup;
  bool? prodIsLocal;
  bool? prodIsParent;
  String? prodMinPrice;
  String? prodName;
  String? prodParentId;
  late List<_ProdRecord> prodRecord;
  String? prodRetailPrice;
  String? prodType;
  String? prodWholePrice;
}

@RealmModel(ObjectType.embeddedObject)
@MapTo('prodRecord')
class _ProdRecord {
  @MapTo('_id')
  ObjectId? id;
  String? invId;
  String? prodRecDate;
  String? prodRecId;
  String? prodRecProduct;
  String? prodRecQuantity;
  String? prodRecSubTotal;
  String? prodRecSubVat;
  String? prodRecTotal;
  String? prodType;
}
