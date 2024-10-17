import '../bond/bond_record_model.dart';

class ProductRecordModel {
  String? invId, prodRecId, prodRecProduct, prodRecQuantity, prodRecSubTotal, prodRecTotal, prodType, prodRecSubVat, prodRecDate, prodRecStore, prodInvType;

  ProductRecordModel(
    this.invId,
    this.prodType,
    this.prodRecProduct,
    this.prodRecQuantity,
    this.prodRecId,
    this.prodRecTotal,
    this.prodRecSubTotal,
    this.prodRecDate,
    this.prodRecSubVat,
    this.prodRecStore,
    this.prodInvType,

  );

  ProductRecordModel.fromJson(Map<dynamic, dynamic> map) {
    invId = map['invId'];
    prodRecId = map['prodRecId'];
    prodRecProduct = map['prodRecProduct'];
    prodRecQuantity = map['prodRecQuantity'].toString();
    prodRecSubTotal = map['prodRecSubTotal'].toString();
    prodRecSubVat = map['prodRecSubVat'].toString();
    prodRecTotal = map['prodRecTotal'].toString();
    prodType = map['prodType'];
    prodRecDate = map['prodRecDate'];
    prodRecStore = map['prodRecStore'];
    prodInvType = map['prodInvType'];
  }

  @override
  int get hashCode => prodRecId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is BondRecordModel && runtimeType == other.runtimeType && invId == other.bondRecId;

  String? affectedId() {
    return prodRecId;
  }

  toJson() {
    return {
      'invId': invId,
      'prodRecId': prodRecId,
      'prodRecProduct': prodRecProduct,
      'prodRecQuantity': prodRecQuantity,
      'prodRecSubTotal': prodRecSubTotal,
      'prodRecTotal': prodRecTotal,
      'prodType': prodType,
      'prodRecSubVat': prodRecSubVat,
      'prodRecDate': prodRecDate,
      'prodRecStore': prodRecStore,
      'prodInvType': prodInvType,
    };
  }

  toFullJson() {
    return {
      'invId': invId,
      'prodRecId': prodRecId,
      'prodRecProduct': prodRecProduct,
      'prodRecQuantity': prodRecQuantity,
      'prodRecSubTotal': prodRecSubTotal,
      'prodRecTotal': prodRecTotal,
      'prodType': prodType,
      'prodRecSubVat': prodRecSubVat,
      'prodRecDate': prodRecDate,
      'prodRecStore': prodRecStore,
      'prodInvType': prodInvType,
    };
  }
}
