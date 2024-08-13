import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';

class ProductModel {
  String? prodId, prodName, prodCode, prodFullCode, prodCustomerPrice, prodWholePrice, prodRetailPrice, prodCostPrice, prodMinPrice, prodAverageBuyPrice,prodAllQuantity, prodBarcode, prodGroupCode, prodType, prodParentId;
  bool? prodIsParent, prodIsGroup, prodIsLocal;
  List? prodChild = [];
  List<ProductRecordModel>? prodRecord = [];
  int? prodGroupPad;

  ProductModel({
    this.prodId,
    this.prodName,
    this.prodCode,
    this.prodFullCode,
    this.prodCustomerPrice,
    this.prodWholePrice,
    this.prodRetailPrice,
    this.prodCostPrice,
    this.prodMinPrice,
    this.prodBarcode,
    this.prodGroupCode,
    this.prodType,
    this.prodParentId,
    this.prodIsParent,
    this.prodIsGroup,
    this.prodIsLocal,
    this.prodGroupPad,
    this.prodAverageBuyPrice,
  });

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    prodId = map['prodId'];
    prodName = map['prodName'];
    prodCode = map['prodCode'];
    prodFullCode = map['prodFullCode'];
    prodCustomerPrice = map['prodCustomerPrice'];
    prodWholePrice = map['prodWholePrice'];
    prodRetailPrice = map['prodRetailPrice'];
    prodCostPrice = map['prodCostPrice'];
    prodMinPrice = map['prodMinPrice'];
    prodBarcode = map['prodBarcode'];
    prodGroupCode = map['prodGroupCode'];
    prodAverageBuyPrice = map['prodAverageBuyPrice'];
    prodType = map['prodType'];
    prodParentId = map['prodParentId'];
    prodIsParent = map['prodIsParent'];
    prodChild = map['prodChild'];
    if (map['prodRecord'] != [] && map['prodRecord'] != null) {
      map['prodRecord'].forEach((e) {
        if (e.runtimeType == Map<dynamic, dynamic>) {
          prodRecord?.add(ProductRecordModel.fromJson(e));
        } else {
          prodRecord?.add(e);
        }
      });
    } else {
      prodRecord = [];
    }
    prodIsGroup = map['prodIsGroup'];
    prodIsLocal = map['prodIsLocal'];
    prodGroupPad = map['prodGroupPad'];
  }

 
  Map difference(ProductModel oldData) {
    assert(oldData.prodId == prodId && oldData.prodId != null && prodId != null || oldData.prodId == prodId && oldData.prodId != null && prodId != null);
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (prodName != oldData.prodName) {
      newChanges['prodName'] = oldData.prodName;
      oldChanges['prodName'] = prodName;
    }
    if (prodCode != oldData.prodCode) {
      newChanges['prodCode'] = oldData.prodCode;
      oldChanges['prodCode'] = prodCode;
    }
    if (prodCustomerPrice != oldData.prodCustomerPrice) {
      newChanges['prodCustomerPrice'] = oldData.prodCustomerPrice;
      oldChanges['prodCustomerPrice'] = prodCustomerPrice;
    }
    if (prodWholePrice != oldData.prodWholePrice) {
      newChanges['prodWholePrice'] = oldData.prodWholePrice;
      oldChanges['prodWholePrice'] = prodWholePrice;
    }
    if (prodRetailPrice != oldData.prodRetailPrice) {
      newChanges['prodRetailPrice'] = oldData.prodRetailPrice;
      oldChanges['prodRetailPrice'] = prodRetailPrice;
    }
    if (prodCostPrice != oldData.prodCostPrice) {
      newChanges['prodCostPrice'] = oldData.prodCostPrice;
      oldChanges['prodCostPrice'] = prodCostPrice;
    }
    if (prodMinPrice != oldData.prodMinPrice) {
      newChanges['prodMinPrice'] = oldData.prodMinPrice;
      oldChanges['prodMinPrice'] = prodMinPrice;
    }
    if (prodBarcode != oldData.prodBarcode) {
      newChanges['prodBarcode'] = oldData.prodBarcode;
      oldChanges['prodBarcode'] = prodBarcode;
    }
    if (prodGroupCode != oldData.prodGroupCode) {
      newChanges['prodGroupCode'] = oldData.prodGroupCode;
      oldChanges['prodGroupCode'] = prodGroupCode;
    }
    if (prodType != oldData.prodType) {
      newChanges['prodType'] = oldData.prodType;
      oldChanges['prodType'] = prodType;
    }
    if (prodParentId != oldData.prodParentId) {
      newChanges['prodParentId'] = oldData.prodParentId;
      oldChanges['prodParentId'] = prodParentId;
    }
    if (prodIsParent != oldData.prodIsParent) {
      newChanges['prodIsParent'] = oldData.prodIsParent;
      oldChanges['prodIsParent'] = prodIsParent;
    }
    if (prodChild != oldData.prodChild) {
      newChanges['prodChild'] = oldData.prodChild;
      oldChanges['prodChild'] = prodChild;
    }
    if (prodIsGroup != oldData.prodIsGroup) {
      newChanges['prodIsGroup'] = oldData.prodIsGroup;
      oldChanges['prodIsGroup'] = prodIsGroup;
    }
    if (prodIsLocal != oldData.prodIsLocal) {
      newChanges['prodIsLocal'] = oldData.prodIsLocal;
      oldChanges['prodIsLocal'] = prodIsLocal;
    }
    if (prodGroupPad != oldData.prodGroupPad) {
      newChanges['prodGroupPad'] = oldData.prodGroupPad;
      oldChanges['prodGroupPad'] = prodGroupPad;
    }

    return {
      "newData": [newChanges],
      "oldData": [oldChanges]
    };
  }

  String? affectedId() {
    return prodId;
  }

  String? affectedKey({String? type}) {
    return "prodId";
  }

  toJson() {
    return {
      'prodId': prodId,
      'prodName': prodName,
      'prodCode': prodCode,
      'prodCustomerPrice': prodCustomerPrice,
      'prodWholePrice': prodWholePrice,
      'prodRetailPrice': prodRetailPrice,
      'prodCostPrice': prodCostPrice,
      'prodMinPrice': prodMinPrice,
      'prodBarcode': prodBarcode,
      'prodGroupCode': prodGroupCode,
      'prodAverageBuyPrice': prodAverageBuyPrice,
      'prodType': prodType,
      'prodParentId': prodParentId,
      'prodIsParent': prodIsParent,
      'prodChild': prodChild,
      'prodFullCode': prodFullCode,
      'prodIsGroup': prodIsGroup,
      'prodIsLocal': prodIsLocal,
      'prodGroupPad': prodGroupPad,
    };
  }

  Map<String, dynamic> toFullJson() {
    return {
      'prodId': prodId,
      'prodName': prodName,
      'prodCode': prodCode,
      'prodFullCode': prodFullCode,
      'prodCustomerPrice': prodCustomerPrice,
      'prodWholePrice': prodWholePrice,
      'prodRetailPrice': prodRetailPrice,
      'prodCostPrice': prodCostPrice,
      'prodMinPrice': prodMinPrice,
      'prodBarcode': prodBarcode,
      'prodGroupCode': prodGroupCode,
      'prodType': prodType,
      'prodParentId': prodParentId,
      'prodIsParent': prodIsParent,
      'prodChild': prodChild,
      'prodAverageBuyPrice': prodAverageBuyPrice,
      'prodRecord': prodRecord,
      'prodIsGroup': prodIsGroup,
      'prodIsLocal': prodIsLocal,
      'prodGroupPad': prodGroupPad,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      // 'الرمز التسليلي': prodId,
      'رمز المادة': prodFullCode,
      'اسم المادة': prodName,
      // 'prodCode': prodCode,
      'اسم الاب': getProductNameFromIdIsolate(prodParentId),
      'سعر المستهلك': prodCustomerPrice,
      'سعر الجملة': prodWholePrice,
      'سعر المبيع': prodRetailPrice,
      'سعر الكلفة': prodCostPrice,
      'اقل سعر مسموح': prodMinPrice,
      'الباركود': prodBarcode,
      // 'prodGroupCode': prodGroupCode,
      'النوع': getProductTypeFromEnum(prodType ?? ""),

      // 'prodIsParent': prodIsParent,
      // 'prodChild': prodChild,
      // 'prodRecord': prodRecord,
      // 'prodIsGroup': prodIsGroup,
      // 'prodIsLocal': prodIsLocal,
      // 'prodGroupPad': prodGroupPad,
    };
  }

  Map<String, dynamic> toTree() {
    if(prodParentId == null && prodName.toString()!="CASH ADVANCEE 1000AED"&& prodName.toString()!="FREE"&& prodName.toString()!="ALL"){
      print(prodName.toString()+ "   "+prodFullCode.toString()+ "    "+prodCode.toString());
      print(prodId);

    }

  return {
      'id': int.parse(prodId!.split("prod")[1]),
      'value': "$prodFullCode      $prodName"  ,
  'parentId':prodParentId!=null&&prodParentId!.startsWith("prod") ?int.parse((prodParentId!.split("prod")[1])):"1"
      // 'parentId': int.parse((prodParentId!.split("prod")[1])/* != null
      //     ? (prodParentId?.split("prod")[1])!
      //     : "1"*/ ),
    };


  }
}
