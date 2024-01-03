class ProductModel {
  String? prodId, prodName, prodCode, prodPrice, prodAllQuantity, prodBarcode, prodGroupCode;
  bool? prodHasVat;

  ProductModel({
    this.prodId,
    this.prodName,
    this.prodCode,
    this.prodPrice,
    this.prodHasVat,
    this.prodBarcode,
    this.prodGroupCode,
  });

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    prodId = map['prodId'];
    prodName = map['prodName'];
    prodCode = map['prodCode'];
    prodPrice = map['prodPrice'];
    prodHasVat = map['prodHasVat'];
    prodBarcode = map['prodBarcode'];
    prodGroupCode = map['prodGroupCode'];
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
    if (prodPrice != oldData.prodPrice) {
      newChanges['prodPrice'] = oldData.prodPrice;
      oldChanges['prodPrice'] = prodPrice;
    }
    if (prodHasVat != oldData.prodHasVat) {
      newChanges['prodHasVat'] = oldData.prodHasVat;
      oldChanges['prodHasVat'] = prodHasVat;
    }
    if (prodBarcode != oldData.prodBarcode) {
      newChanges['prodBarcode'] = oldData.prodBarcode;
      oldChanges['prodBarcode'] = prodBarcode;
    }
    if (prodGroupCode != oldData.prodGroupCode) {
      newChanges['prodGroupCode'] = oldData.prodGroupCode;
      oldChanges['prodGroupCode'] = prodGroupCode;
    }

    return {
      "newData": [newChanges],
      "oldData": [oldChanges]
    };
  }

  String? affectedId() {
    return prodId;
  }

  toJson() {
    return {
      'prodId': prodId,
      'prodName': prodName,
      'prodCode': prodCode,
      'prodPrice': prodPrice,
      'prodHasVat': prodHasVat,
      'prodBarcode': prodBarcode,
      'prodGroupCode': prodGroupCode,
    };
  }

  toFullJson() {
    return {
      'prodId': prodId,
      'prodName': prodName,
      'prodCode': prodCode,
      'prodPrice': prodPrice,
      'prodHasVat': prodHasVat,
      'prodBarcode': prodBarcode,
      'prodGroupCode': prodGroupCode,
    };
  }
}
