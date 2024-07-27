class SellerModel {
  String? sellerName, sellerCode, sellerId;
  List<SellerRecModel>? sellerRecord = [];
  Map<String , SellerTargetArchive> sellerTargetArchive= {};
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

class SellerTargetArchive{
 late String mobileTarget , otherTarget  ;
 late bool isHitTarget ;
  Map<String , bool> tasks={};
  SellerTargetArchive({required this.mobileTarget ,required this.otherTarget ,required this.isHitTarget ,required this.tasks , });

  SellerTargetArchive.fromJson(json){
    mobileTarget = json['mobileTarget'];
    otherTarget = json['otherTarget'];
    isHitTarget = json['isHitTarget'];
    tasks= json['tasks'];
  }

  Map<String, dynamic> toJson() {
    return {
      'mobileTarget': mobileTarget,
      'otherTarget': otherTarget,
      'isHitTarget': isHitTarget,
    };
  }
}