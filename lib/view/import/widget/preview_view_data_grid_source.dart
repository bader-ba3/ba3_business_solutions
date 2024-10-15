import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PreViewViewDataGridSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  PreViewViewDataGridSource({required List<List<String>> productList, required List<String> rows}) {
    dataGridRows.clear();
    dataGridRows = (productList)
        .map<DataGridRow>((e) => DataGridRow(
                cells: List.generate(
              rows.length,
              (index) => DataGridCell<String>(columnName: rows[index], value: e[index]),
            )))
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
        padding: const EdgeInsets.all(8.0),
        child: dataGridCell.value.runtimeType != bool
            ? Text(dataGridCell.value.toString())
            : IgnorePointer(
                ignoring: true,
                child: Switch(
                    activeColor: Colors.amber,
                    value: dataGridCell.value,
                    onChanged: (_) {
                      dataGridCell = DataGridCell<bool>(columnName: AppConstants.rowImportHasVat, value: _);
                    }),
              ),
      );
    }).toList());
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    var displayText = dataGridRows[rowColumnIndex.rowIndex].getCells()[rowColumnIndex.columnIndex].value;
    displayText ??= '';
    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == AppConstants.rowBondId ||
        column.columnName == AppConstants.rowBondCreditAmount ||
        column.columnName == AppConstants.rowBondDebitAmount;

    // Holds regular expression pattern based on the column type.
    // final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: column.columnName == AppConstants.rowImportHasVat
          ? Switch(
              autofocus: true,
              value: displayText,
              onChanged: (_) {
                newCellValue = _;
                submitCell();
              })
          : TextField(
              autofocus: true,
              controller: editingController..text = displayText.toString(),
              textAlign: TextAlign.center,
              autocorrect: false,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              ),
              //  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(regExp)],
              keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
              onChanged: (String value) {
                if (value.isNotEmpty) {
                  newCellValue = value;
                } else {
                  newCellValue = null;
                }
              },
              onSubmitted: (String value) {
                // if (regExp.hasMatch(value)) {
                //   newCellValue = value;
                submitCell();
                // } else {
                //   Get.snackbar("error", "enter a valid number");
                //   newCellValue = null;
                // }

                /// Call [CellSubmit] callback to fire the canSubmitCell and
                /// onCellSubmit to commit the new value in single place.
              },
            ),
    );
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    // return isNumericKeyBoard ? RegExp(r"(\d+)?\.(\d+)?") : RegExp(r'.*');
    return isNumericKeyBoard ? RegExp(r'\b\d+\.\d+\b') : RegExp(r'.*');
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue =
        dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value ?? '';
    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);
    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell(columnName: column.columnName, value: newCellValue);
  }
}
