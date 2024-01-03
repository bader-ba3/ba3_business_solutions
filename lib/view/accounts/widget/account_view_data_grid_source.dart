import 'package:ba3_business_solutions/Const/const.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../model/account_model.dart';
import '../../../model/account_record_model.dart';

class AccountViewDataGridSource extends DataGridSource {
  final Map<String, AccountModel> accountMap;
  Map<String, List<AccountRecordModel>> accountRecordMap;

  AccountViewDataGridSource(this.accountMap, this.accountRecordMap);

  @override
  List<DataGridRow> get rows => accountMap.entries.map<DataGridRow>((entry) {
        String userId = entry.key;
        AccountModel account = entry.value;

        int? balance = accountRecordMap[userId]==null ||accountRecordMap[userId]!.isEmpty?0: accountRecordMap[userId]!.last.balance ;

        int? count = accountRecordMap[userId]==null ||accountRecordMap[userId]!.isEmpty?0: accountRecordMap[userId]!.length ;

        return DataGridRow(cells: [
          DataGridCell<String>(columnName: Const.rowViewAccountId, value: userId),
          DataGridCell<String>(columnName: Const.rowViewAccountCode, value: account.accCode),
          DataGridCell<String>(columnName: Const.rowViewAccountName, value: account.accName),
          DataGridCell<int>(columnName: Const.rowViewAccountBalance, value: balance),
          DataGridCell<int>(columnName: Const.rowViewAccountLength, value: count),
          // DataGridCell<String>(
          //     columnName: 'AccountId', value: account.accountId),
        ]);
      }).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
