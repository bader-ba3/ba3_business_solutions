import 'package:ba3_business_solutions/utils/generate_id.dart';

class AccountRecordModel {
  String? id, total, account;
  double? balance;
  AccountRecordModel.fromJson(json) {
    id = json['id'];
    total = json['total'].toString();
    account = json['account'];
  }
  AccountRecordModel(this.id, this.account, this.total, this.balance);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total": total,
      "account": account,
    };
  }
}
