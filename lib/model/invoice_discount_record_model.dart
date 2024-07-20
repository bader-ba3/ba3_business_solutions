class InvoiceDiscountRecordModel{
  String? invId,accountId;
  double? discountPercentage,discountTotal ,addedPercentage,addedTotal ;
  int? discountId;
  bool? isChooseDiscountTotal ,isChooseAddedTotal ;
  InvoiceDiscountRecordModel({this.invId,this.accountId,this.addedPercentage,this.addedTotal,this.discountId,this.isChooseDiscountTotal,this.discountPercentage,this.discountTotal,this.isChooseAddedTotal});
  InvoiceDiscountRecordModel.fromJson(json){
    invId=json['invId'];
    accountId=json['accountId'];
    isChooseDiscountTotal=json['isChooseDiscountTotal'];
    discountPercentage=json['discountPercentage'];
    discountTotal=json['discountTotal'];
    discountId=json['discountId'];
    isChooseAddedTotal=json['isChooseAddedTotal'];
    addedPercentage=json['addedPercentage'];
    addedTotal=json['addedTotal'];
  }

  toJson(){
    return {
      "invId":invId,
      "accountId":accountId,
      "discountPercentage":discountPercentage,
      "discountTotal":discountTotal,
      "isChooseDiscountTotal":isChooseDiscountTotal,
      "discountId":discountId,
      "addedPercentage":addedPercentage,
      "addedTotal":addedTotal,
      "isChooseAddedTotal":isChooseAddedTotal,
    };
  }
}