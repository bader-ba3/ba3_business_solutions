class InvoiceRecordModel {
  String? invRecId, invRecProduct,prodChoosePriceMethod;
  int? invRecQuantity;
  double? invRecSubTotal, invRecTotal, invRecVat;
  bool? invRecIsLocal;

  InvoiceRecordModel({
    this.invRecId,
    this.invRecProduct,
    this.invRecQuantity,
    this.invRecSubTotal,
    this.invRecTotal,
    this.invRecVat,
    this.prodChoosePriceMethod,
    this.invRecIsLocal,
  });

  InvoiceRecordModel.fromJson(Map<dynamic, dynamic> map) {
    invRecId = map['invRecId'];
    invRecProduct = map['invRecProduct'];
    invRecQuantity = map['invRecQuantity'];
    invRecSubTotal = double.parse(map['invRecSubTotal'].toString());
    invRecTotal = double.parse(map['invRecTotal'].toString());
    invRecVat = double.parse((map['invRecVat'] ?? 0).toString());
    invRecIsLocal = map['invRecIsLocal'];
  }

  toJson() {
    return {
      'invRecId': invRecId,
      'invRecProduct': invRecProduct,
      'invRecQuantity': invRecQuantity,
      'invRecSubTotal': invRecSubTotal,
      'invRecTotal': invRecTotal,
      'invRecVat': invRecVat,
      'invRecIsLocal': invRecIsLocal,
    };
  }

  @override
  int get hashCode => invRecId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InvoiceRecordModel && runtimeType == other.runtimeType && invRecId == other.invRecId;

  Map<String, Map<String, dynamic>> getChanges(InvoiceRecordModel other) {
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (invRecProduct != other.invRecProduct) {
      newChanges['invRecProduct'] = other.invRecProduct;
      oldChanges['invRecProduct'] = invRecProduct;
    }

    if (invRecQuantity != other.invRecQuantity) {
      newChanges['invRecQuantity'] = other.invRecQuantity;
      oldChanges['invRecQuantity'] = invRecQuantity;
    }

    if (invRecSubTotal != other.invRecSubTotal) {
      newChanges['invRecSubTotal'] = other.invRecSubTotal;
      oldChanges['invRecSubTotal'] = invRecSubTotal;
    }

    if (invRecTotal != other.invRecTotal) {
      newChanges['invRecTotal'] = other.invRecTotal;
      oldChanges['invRecTotal'] = invRecTotal;
    }

    if (invRecVat != other.invRecVat) {
      newChanges['invRecVat'] = other.invRecVat;
      oldChanges['invRecVat'] = invRecVat;
    }

    if (invRecIsLocal != other.invRecIsLocal) {
      newChanges['invRecIsLocal'] = other.invRecIsLocal;
      oldChanges['invRecIsLocal'] = invRecIsLocal;
    }

    if (newChanges.isNotEmpty) newChanges['invRecId'] = other.invRecId;
    if (oldChanges.isNotEmpty) oldChanges['invRecId'] = invRecId;

    return {"newData": newChanges, "oldData": oldChanges};
  }
}
