import 'store_record_model.dart';

class StoreModel {
  String? stId, stName, stCode;
  Map<String, StoreRecordModel>stRecords ={};
  StoreModel({this.stId, this.stCode, this.stName});

  StoreModel.fromJson(Map<String, dynamic> map,this.stRecords) {

    stId = map['stId'];
    stCode = map['stCode'];
    stName = map['stName'];

  }

  toJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName};
    }
  toFullJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName,"stRecords":stRecords.map((key, value) => MapEntry(key, value.toJson()))};
  }
}
