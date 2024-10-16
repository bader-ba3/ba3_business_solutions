import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/data/model/seller/seller_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AllSellerInvoiceDataGridSource extends DataGridSource {
  List<DataGridRow> dataGridRows = [];

  AllSellerInvoiceDataGridSource({required List<SellerRecModel> sellerRecModel}) {
    dataGridRows.clear();
    dataGridRows = (sellerRecModel)
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: AppConstants.rowSellerAllInvoiceInvId, value: e.selleRecInvId),
              DataGridCell<String>(
                  columnName: AppConstants.rowSellerAllInvoiceAmount, value: double.parse(e.selleRecAmount ?? "0").toStringAsFixed(2)),
              DataGridCell<String>(columnName: AppConstants.rowSellerAllInvoiceDate, value: e.selleRecInvDate),
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
        color: getRowBackgroundColor(),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          dataGridCell.value.toString(),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      );
    }).toList());
  }
}
