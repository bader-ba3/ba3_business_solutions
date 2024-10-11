import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/account/account_view_model.dart';
import '../../../model/account/account_model.dart';

class AccountViewDataGridSource extends DataGridSource {
  final Map<String, AccountModel> accountMap;

  // List<AccountRecordModel> accountRecordMap=[];

  AccountViewDataGridSource(this.accountMap);

  @override
  List<DataGridRow> get rows => accountMap.entries.map<DataGridRow>((entry) {
        String userId = entry.key;
        AccountModel account = entry.value;
        var accountController = Get.find<AccountViewModel>();

        // int? balance = accountRecordMap[userId]==null ||accountRecordMap[userId]!.isEmpty?0: accountRecordMap[userId]!.last.balance ;
        double balance = accountController.getBalance(userId);
        int count = accountController.getCount(userId);
        //int? count = accountRecordMap==null ||accountRecordMap!.isEmpty?0: accountRecordMap!.length ;

        return DataGridRow(cells: [
          DataGridCell<String>(
              columnName: AppConstants.rowViewAccountId, value: userId),
          DataGridCell<String>(
              columnName: AppConstants.rowViewAccountCode,
              value: account.accCode),
          DataGridCell<String>(
              columnName: AppConstants.rowViewAccountName,
              value: account.accName),
          DataGridCell<double>(
              columnName: AppConstants.rowViewAccountBalance, value: balance),
          DataGridCell<int>(
              columnName: AppConstants.rowViewAccountLength, value: count),
          // DataGridCell<String>(
          //     columnName: 'AccountId', value: account.accountId),
        ]);
      }).toList();

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return Colors.white;
      }

      return Colors.blue.withOpacity(0.5);
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: Alignment.center,
        color: getRowBackgroundColor(),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          dataGridCell.value.runtimeType == double
              ? dataGridCell.value.toStringAsFixed(2)
              : dataGridCell.value.toString(),
          style: const TextStyle(fontSize: 22),
        ),
      );
    }).toList());
  }
}
