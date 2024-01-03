import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Const/const.dart';



class ProductRecordDataSource extends DataGridSource {

  List<DataGridRow> dataGridRows = [];
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();

  ProductRecordDataSource({required List<ProductRecordModel> productRecordModel}) {
    dataGridRows.clear();
    dataGridRows = productRecordModel
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: Const.rowProductType, value: e.prodType),
      DataGridCell<String>(columnName: Const.rowProductQuantity, value: e.prodRecQuantity),
      DataGridCell<String>(columnName: Const.rowProductInvId, value: e.invId),
    ])).toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
            return Container(
                alignment: Alignment.center,
                padding:const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  dataGridCell.value==null?'':
                  dataGridCell.value.toString(),
                  overflow: TextOverflow.ellipsis,
                ));
          }).toList());
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async{
    // Return false, to retain in edit mode.
    return false; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }


}