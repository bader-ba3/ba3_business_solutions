class InventoryModel {
  String? inventoryName,inventoryDate,inventoryId ,inventoryUserId;
  Map inventoryRecord = {};
  List inventoryTargetedProductList = [];
  InventoryModel({required this.inventoryId,required this.inventoryName,required this.inventoryDate ,required this.inventoryRecord,required this.inventoryTargetedProductList,required this.inventoryUserId});

  InventoryModel.fromJson(json){
    inventoryName = json['inventoryName'];
    inventoryDate = json['inventoryDate'];
    inventoryUserId = json['inventoryUserId'];
    inventoryRecord =   json['inventoryRecord'];
    inventoryTargetedProductList =   json['inventoryTargetedProductList']??[];
    // inventoryRecord =   Map.fromEntries( json['inventoryRecord'].entries.map((e) => MapEntry(e.key.toString(), e.value.toString())).toList());

  }
  toJson() {
    return {
      'inventoryName': inventoryName,
    'inventoryUserId': inventoryUserId,
    'inventoryDate': inventoryDate,
      'inventoryRecord': inventoryRecord,
      'inventoryTargetedProductList': inventoryTargetedProductList,
  };
  }
}