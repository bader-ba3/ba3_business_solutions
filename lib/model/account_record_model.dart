import 'package:ba3_business_solutions/utils/generate_id.dart';

class AccountRecordModel {
  String? id, total, account,isPaidStatus,accountRecordType,date;
  double? balance,paid;

  AccountRecordModel.fromJson(json) {
    id = json['id'];
    total = json['total'].toString();
    account = json['account'];
    isPaidStatus = json['isPaidStatus'];
    accountRecordType = json['accountRecordType'];
    date = json['date'];
  }
  AccountRecordModel(this.id, this.account, this.total, this.balance,this.accountRecordType,this.date);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total": total,
      "account": account,
      "accountRecordType": accountRecordType,
      "isPaidStatus": isPaidStatus,
      "date": date,
    };
  }
}
