import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';

import '../controller/account_view_model.dart';

class AccountModel {
  String? accId, accName, accComment, accType, accCode, accVat, accParentId;
  bool? accIsParent;
  List accChild = [];
  List accAggregateList = [];
  List<AccountRecordModel> accRecord = [];
  double? finalBalance ,fFinalBalance;

  AccountModel({this.accId, this.accName, this.accComment, this.accVat, this.accType, this.accCode, this.accParentId, this.accIsParent, this.finalBalance,this.fFinalBalance});

  AccountModel.fromJson(Map<dynamic, dynamic> map) {
    accId = map['accId'];
    accName = map['accName'];
    accComment = map['accComment'];
    accType = map['accType'];
    accCode = map['accCode'];
    accVat = map['accVat'];

    ///this is new
    finalBalance = map['finalBalance'];
    fFinalBalance = map['fFinalBalance'];
    accParentId = map['accParentId'];
    accIsParent = map['accIsParent'];
    if (map['accRecord'] != null && map['accRecord'] != []) {
      map['accRecord'].forEach((element) {
        if (element.runtimeType == AccountRecordModel) {
          accRecord.add(element);
        } else {
          accRecord.add(AccountRecordModel.fromJson(element));
        }
      }) ??
          [];
    } else {
      accRecord = [];
    }
    accChild = map['accChild'] ?? [];
    accAggregateList = map['accAggregateList'] ?? [];
  }

  Map difference(AccountModel oldData) {
    assert(oldData.accId == accId && oldData.accId != null && accId != null || oldData.accId == accId && oldData.accId != null && accId != null);
    Map<String, dynamic> newChanges = {};
    Map<String, dynamic> oldChanges = {};

    if (accName != oldData.accName) {
      newChanges['accName'] = oldData.accName;
      oldChanges['accName'] = accName;
    }
    if (accCode != oldData.accCode) {
      newChanges['accCode'] = oldData.accCode;
      oldChanges['accCode'] = accCode;
    }
    if (accComment != oldData.accComment) {
      newChanges['accComment'] = oldData.accComment;
      oldChanges['accComment'] = accComment;
    }
    if (accType != oldData.accType) {
      newChanges['accType'] = oldData.accType;
      oldChanges['accType'] = accType;
    }
    if (accVat != oldData.accVat) {
      newChanges['accVat'] = oldData.accVat;
      oldChanges['accVat'] = accVat;
    }
    if (accParentId != oldData.accParentId) {
      newChanges['accParentId'] = oldData.accParentId;
      oldChanges['accParentId'] = accParentId;
    }
    if (accIsParent != oldData.accIsParent) {
      newChanges['accIsParent'] = oldData.accIsParent;
      oldChanges['accIsParent'] = accIsParent;
    }
    if (accChild != oldData.accChild) {
      newChanges['accChild'] = oldData.accChild;
      oldChanges['accChild'] = accChild;
    }
    if (accAggregateList != oldData.accAggregateList) {
      newChanges['accAggregateList'] = oldData.accAggregateList;
      oldChanges['accAggregateList'] = accAggregateList;
    }

    return {
      "newData": [newChanges],
      "oldData": [oldChanges]
    };
  }

  String? affectedId() {
    return accId;
  }

  String? affectedKey({String? type}) {
    return "accId";
  }

  toJson() {
    return {
      'accId': accId,
      'accName': accName,
      'accComment': accComment,
      'accType': accType,
      'accCode': accCode,
      'accVat': accVat,
      'accParentId': accParentId,
      'accIsParent': accIsParent,
      'accChild': accChild,
      'accAggregateList': accAggregateList,
      'finalBalance': finalBalance,
      'fFinalBalance': fFinalBalance,
    };
  }

  toFullJson() {
    return {
      'accId': accId,
      'accName': accName,
      'accComment': accComment,
      'accType': accType,
      'accCode': accCode,
      'accVat': accVat,
      'fFinalBalance': fFinalBalance,

      'accParentId': accParentId,
      'accIsParent': accIsParent,
      'accChild': accChild,
      'finalBalance': finalBalance,
      'accAggregateList': accAggregateList,
      'accRecord': accRecord.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'accId': accId,
      'رمز الحساب': int.tryParse(accCode.toString()) ?? 0,
      'اسم الحساب': accName,
      'نوع الحساب': getAccountTypeFromEnum(accType ?? ""),
      'نوع الضريبة': accVat,
      'حساب الاب': getAccountNameFromId(accParentId),
      'الوصف': accComment,
      // 'الرصيد': getAccountBalanceFromId(accId),
      'الرصيد':HiveDataBase.getIsNunFree()? fFinalBalance:finalBalance,
    };
  }
}
