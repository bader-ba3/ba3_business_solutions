class StoreModel {
  String? stId, stName, stCode;

  StoreModel({this.stId, this.stCode, this.stName});

  StoreModel.fromJson(Map<String, dynamic> map) {

    stId = map['stId'];
    stCode = map['stCode'];
    stName = map['stName'];
  }

  toJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName};
    }
}
