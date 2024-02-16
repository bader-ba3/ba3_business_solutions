import 'store_record_model.dart';

class StoreModel {
  String? stId, stName, stCode;
  // Map<String, StoreRecordModel>stRecords ={};
  List<StoreRecordModel> stRecords=[];
  StoreModel({this.stId, this.stCode, this.stName});

  StoreModel.fromJson(Map<String, dynamic> map) {
    List<StoreRecordModel>? stRecord = map['stRecords']?.map<StoreRecordModel>((dynamic e) => StoreRecordModel.fromJson(e)).toList();
    stId = map['stId'];
    stCode = map['stCode'];
    stName = map['stName'];
    stRecords = stRecord??[];

  }

  toJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName};
    }
  toFullJson() {
    return {'stId': stId, 'stCode': stCode, 'stName': stName,"":stRecords.map((value) => value.toJson())};
  }
}
