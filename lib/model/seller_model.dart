class SellerModel {
  String? sellerName, sellerCode, sellerId;
  List<SellerRecModel>? sellerRecord = [];
  SellerModel({
    this.sellerName,
    this.sellerCode,
    this.sellerId,
    this.sellerRecord,
  });

  Map<String, dynamic> toJson() {
    return {
      'sellerName': sellerName,
      'sellerCode': sellerCode,
      'sellerId': sellerId,
    };
  }

  SellerModel.fromJson(Map<String, dynamic> json, this.sellerId) {
    sellerName = json['sellerName'];
    sellerCode = json['sellerCode'];
  }
}

class SellerRecModel {
  String? selleRecInvId, selleRecAmount, selleRecUserId, selleRecInvDate;
  List? sellerRecord = [];
  SellerRecModel({
    this.selleRecInvId,
    this.selleRecAmount,
    this.selleRecUserId,
    this.selleRecInvDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'selleRecInvId': selleRecInvId,
      'selleRecAmount': selleRecAmount,
      'selleRecUserId': selleRecUserId,
      'selleRecInvDate': selleRecInvDate,
    };
  }

  SellerRecModel.fromJson(
    Map<String, dynamic> json,
  ) {
    selleRecInvId = json['selleRecInvId'];
    selleRecAmount = json['selleRecAmount'];
    selleRecUserId = json['selleRecUserId'];
    selleRecInvDate = json['selleRecInvDate'];
  }
}
    //   "selleRecInvId": invId,
    //   "selleRecAmount": amount,
    //   "selleRecUserId": userId,
