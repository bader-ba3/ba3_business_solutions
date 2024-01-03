import 'package:ba3_business_solutions/utils/generate_id.dart';

class AccountRecordModel {
  String? id, total, account;
  int? balance;
  late RecordType type;
  AccountRecordModel.fromJson(json) {
    id = json['id'];
    total = json['total'].toString();
    account = json['account'];
    var _type = json['id'].toString().substring(0, 3);
    if (_type == "bon") {
      type = RecordType.bond;
    } else if (_type == "inv") {
      type = RecordType.invoice;
    } else {
      type = RecordType.undefined;
    }
  }
  AccountRecordModel(this.id, this.account, this.total, this.balance, this.type);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total": total,
      "account": account,
    };
  }
}
