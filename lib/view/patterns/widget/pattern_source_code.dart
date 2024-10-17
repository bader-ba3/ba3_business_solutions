import 'package:ba3_business_solutions/data/model/patterens/pattern_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/functions/functions.dart';

class PatternRecordDataSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  PatternRecordDataSource(
      {required Map<String, PatternModel> patternRecordModel}) {
    dataGridRows.clear();
    dataGridRows = patternRecordModel.values
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: "patId", value: e.patId),
              DataGridCell<String>(
                  columnName: AppConstants.patCode, value: e.patCode),
              //  DataGridCell<String>(columnName: Const.patPrimary, value: getAccountNameFromId(e.patPrimary)),
              DataGridCell<String>(
                  columnName: AppConstants.patName, value: e.patName),
              DataGridCell<String>(
                  columnName: AppConstants.patType,
                  value: getInvTypeFromEnum(e.patType!)),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value == null ? '' : dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

  // description
  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }
}
