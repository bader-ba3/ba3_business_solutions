class StoreRecordModel {
  String? storeRecId;
  String? storeRecInvId;
  Map<String, StoreRecProductModel>? storeRecProduct={};

  StoreRecordModel({this.storeRecId, this.storeRecInvId, this.storeRecProduct});

  factory StoreRecordModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? storeRecProductJson = json['storeRecProduct'];
    Map<String, StoreRecProductModel> storeRecProductMap={};

    if (storeRecProductJson != null) {
      storeRecProductMap = storeRecProductJson.map((key, value) {
        return MapEntry(key, StoreRecProductModel.fromJson(value));
      });
    }

    return StoreRecordModel(
      storeRecId: json['storeRecId'],
      storeRecInvId: json['StoreRecInvId'],
      storeRecProduct: storeRecProductMap,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> storeRecProductJson = {};
    storeRecProduct?.forEach((key, value) {
      storeRecProductJson[key] = value.toJson();
    });

    return {
      'storeRecId': storeRecId,
      'StoreRecInvId': storeRecInvId,
      'storeRecProduct': storeRecProductJson,
    };
  }
}

class StoreRecProductModel {
  String? storeRecProductId;
  String? storeRecProductQuantity;
  String? storeRecProductPrice;
  String? storeRecProductTotal;

  StoreRecProductModel({
    this.storeRecProductId,
    this.storeRecProductQuantity,
    this.storeRecProductPrice,
    this.storeRecProductTotal,
  });

  factory StoreRecProductModel.fromJson(Map<String, dynamic> json) {
    return StoreRecProductModel(
      storeRecProductId: json['storeRecProductId'],
      storeRecProductQuantity: json['storeRecProductQuantity'],
      storeRecProductPrice: json['storeRecProductPrice'],
      storeRecProductTotal: json['storeRecProductTotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeRecProductId': storeRecProductId,
      'storeRecProductQuantity': storeRecProductQuantity,
      'storeRecProductPrice': storeRecProductPrice,
      'storeRecProductTotal': storeRecProductTotal,
    };
  }
}