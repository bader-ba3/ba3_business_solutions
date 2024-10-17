class ProductImei {
  String? imei;
  String? invId;

  ProductImei({this.imei, this.invId});

  factory ProductImei.fromJson(Map<String, dynamic> json) {
    return ProductImei(
      imei: json['imei'],
      invId: json['invId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imei': imei,
      'invId': invId,
    };
  }
}