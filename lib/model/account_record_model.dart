
import 'package:ba3_business_solutions/controller/account_view_model.dart';


import '../Const/const.dart';

class AccountRecordModel {
  String? id, total, account,isPaidStatus,accountRecordType,date,code;
  double? balance,paid,subBalance=0;

  AccountRecordModel.fromJson(json) {
    id = json['id'];
    total = json['total'].toString();
    account = json['account'];
    isPaidStatus = json['isPaidStatus'];
    accountRecordType = json['accountRecordType'];
    date = json['date'];
    code = json['code'];
  }
  AccountRecordModel(this.id, this.account, this.total, this.balance,this.accountRecordType,this.date,this.code,this.subBalance);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "total": total,
      "account": account,
      "accountRecordType": accountRecordType,
      "isPaidStatus": isPaidStatus,
      "date": date,
      "code": code,
      "subBalance": subBalance,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "القيمة": total,
      "رقم": code,

      "الحساب": getAccountNameFromId(account),
      'نوع السند':accountRecordType!.startsWith("pat")?getPatNameFromId(accountRecordType??''): getBondTypeFromEnum(accountRecordType ?? ""),
      // "accountRecordType": accountRecordType,
      // "isPaidStatus": isPaidStatus,
      "التاريخ": date,
      "الحساب بعد العملية": subBalance,
    };
  }
}
