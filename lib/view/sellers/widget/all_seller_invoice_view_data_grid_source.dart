import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AllSellerInvoiceViewDataGridSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  AllSellerInvoiceViewDataGridSource({required List<SellerRecModel> sellerRecModel}) {
    dataGridRows.clear();
    dataGridRows = (sellerRecModel)
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: Const.rowSellerAllInvoiceInvId, value: e.selleRecInvId),
              DataGridCell<String>(columnName: Const.rowSellerAllInvoiceAmount, value: double.parse(e.selleRecAmount??"0").toStringAsFixed(2)),
              DataGridCell<String>(columnName: Const.rowSellerAllInvoiceDate, value: e.selleRecInvDate),
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
        padding: EdgeInsets.all(8.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
