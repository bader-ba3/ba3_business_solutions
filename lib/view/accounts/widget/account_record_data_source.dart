import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';

class AccountRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  AccountRecordDataSource({required List<AccountRecordModel> accountRecordModel,required AccountModel accountModel}) {

    dataGridRows.clear();
    var accountController = Get.find<AccountViewModel>();

    List<AccountRecordModel> allRecord =[];
    allRecord.addAll(accountRecordModel);
    for (var element in accountModel.accChild) {
      print(element);
      allRecord.addAll(accountController.allAccounts[element]!.toList());
    }
    dataGridRows = allRecord
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<RecordType>(columnName: Const.rowAccountType, value: e.type),
              DataGridCell<String>(columnName: Const.rowAccountTotal, value: e.total),
              DataGridCell<int>(columnName: Const.rowAccountBalance, value: e.balance),
              DataGridCell<String>(columnName: Const.rowAccountId, value: e.id),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: dataGridCell.columnName == Const.rowAccountType
              ? Text(
                  dataGridCell.value == RecordType.bond
                      ? 'سندات'
                      : dataGridCell.value == RecordType.invoice
                          ? "فواتير"
                          : "غير ذالك",
                  overflow: TextOverflow.ellipsis,
                )
              :dataGridCell.columnName == Const.rowAccountBalance||dataGridCell.columnName == Const.rowAccountTotal
          ?Text(dataGridCell.value == null ? '' : double.parse(dataGridCell.value.toString()).toStringAsFixed(2))
          :Text(
                  dataGridCell.value == null ? '' : dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }
}
