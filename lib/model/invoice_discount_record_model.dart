class InvoiceDiscountRecordModel{
  String? invId,accountId;
  double? percentage,total;
  int? discountId;
  bool? isChooseTotal;
  InvoiceDiscountRecordModel({this.invId,this.accountId,this.percentage,this.total,this.discountId,this.isChooseTotal});
  InvoiceDiscountRecordModel.fromJson(json){
    invId=json['invId'];
    accountId=json['accountId'];
    isChooseTotal=json['isChooseTotal'];
    percentage=json['percentage'];
    total=json['total'];
    discountId=json['discountId'];
  }

  toJson(){
    return {
      "invId":invId,
      "accountId":accountId,
      "percentage":percentage,
      "total":total,
      "isChooseTotal":isChooseTotal,
      "discountId":discountId,
    };
  }
}