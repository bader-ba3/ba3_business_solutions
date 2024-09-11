import 'dart:ffi';

import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';

class AccountRecordModel {
  String? id, total, account, isPaidStatus, accountRecordType, date, code;
  double? balance, paid, subBalance, debit, credit;

  AccountRecordModel.fromJson(json) {
    id = json['id'];
    total = json['total'].toString();
    account = json['account'];
    debit = json['debit'];
    credit = json['credit'];
    isPaidStatus = json['isPaidStatus'];
    accountRecordType = json['accountRecordType'];
    date = json['date'];
    code = json['code'];
  }

  AccountRecordModel(this.id, this.account, this.total, this.balance, this.accountRecordType, this.date, this.code, this.subBalance, this.debit, this.credit);

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
      "debit": debit,
      "credit": credit,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "رقم": code,
      "مدين": debit?.toStringAsFixed(2),
      "دائن": credit?.toStringAsFixed(2),
      // "الحساب": getAccountNameFromId(account).toString(),
      "نوع السند":accountRecordType?.startsWith("pat")==true?getPatNameFromId(accountRecordType??'') :getBondTypeFromEnum(accountRecordType??''),
      "التاريخ": date.toString().split(" ")[0],
      "الحساب بعد العملية": subBalance?.toStringAsFixed(2),
      "القيمة": double.parse(total!).toStringAsFixed(2),
    };
  }
}
