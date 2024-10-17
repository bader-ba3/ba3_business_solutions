import 'package:ba3_business_solutions/data/model/global/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/account/account_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/model/account/account_model.dart';

class EntryBondRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  dynamic newCellValuea;
  TextEditingController editingController = TextEditingController();

  EntryBondRecordDataSource({required GlobalModel recordData}) {
    buildRowInit(recordData);
    addItem();
  }

  final accountController = Get.find<AccountController>();

  buildRowInit(GlobalModel recordData) {
    dataGridRows = (recordData.entryBondRecord ?? [])
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: AppConstants.rowBondId, value: e.bondRecId),
              DataGridCell<String>(
                  columnName: AppConstants.rowBondAccount,
                  value: accountController.accountList.values.toList().firstWhereOrNull((_) => _.accId == e.bondRecAccount)?.accName),
              DataGridCell<double>(columnName: AppConstants.rowBondDebitAmount, value: e.bondRecDebitAmount),
              DataGridCell<double>(columnName: AppConstants.rowBondCreditAmount, value: e.bondRecCreditAmount),
              DataGridCell<String>(columnName: AppConstants.rowBondDescription, value: e.bondRecDescription),
            ]))
        .toList();
  }

  void addItem() {
    dataGridRows.add(const DataGridRow(cells: [
      DataGridCell<String>(columnName: AppConstants.rowBondId, value: ""),
      DataGridCell<String>(columnName: AppConstants.rowBondAccount, value: ''),
      DataGridCell<double>(columnName: AppConstants.rowBondCreditAmount, value: null),
      DataGridCell<double>(columnName: AppConstants.rowBondDebitAmount, value: null),
      DataGridCell<String>(columnName: AppConstants.rowBondDescription, value: ""),
    ]));
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value == null
                ? ''
                : dataGridCell.value.runtimeType == double
                    ? dataGridCell.value.toStringAsFixed(2)
                    : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    // return isNumericKeyBoard ? RegExp(r"(\d+)?\.(\d+)?") : RegExp(r'.*');
    return isNumericKeyBoard ? RegExp(r'\b\d+\.\d+\b') : RegExp(r'.*');
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountController accountController = Get.find<AccountController>();
    products = accountController.accountList.values.toList().where((item) {
      var name = item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code = item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      // var type = item.accType==Const.accountTypeDefault;
      return (name || code);
    }).toList();
    return products.map((e) => e.accName!).toList();
  }
}
