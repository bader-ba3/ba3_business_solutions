import 'package:ba3_business_solutions/model/warranty/warranty_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../product/product_view_model.dart';

class WarrantyPlutoViewModel extends GetxController {
  WarrantyPlutoViewModel() {
    getColumns();
  }

  getColumns() {
    Map<PlutoColumn, dynamic> sampleData = WarrantyRecordModel().toEditedMap();
    columns = sampleData.keys.toList();
    update();
    return columns;
  }

  updateInvoiceValues(double? total, int? quantity) {}

  getPrice({type, prodName}) {}

  clearRowIndex(int rowIdx) {
    final rowToRemove = stateManager.rows[rowIdx];

    stateManager.removeRows([rowToRemove]);
    Get.back();
    update();
  }

  getRows(List<WarrantyRecordModel> modelList) {
    stateManager.removeAllRows();
    final newRows = stateManager.getNewRows(count: 30);

    if (modelList.isEmpty) {
      stateManager.appendRows(newRows);
      return rows;
    } else {
      rows = modelList.map((model) {
        Map<PlutoColumn, dynamic> rowData = model.toEditedMap();

        Map<String, PlutoCell> cells = {};

        rowData.forEach((key, value) {
          cells[key.field] = PlutoCell(value: value?.toString() ?? '');
        });

        return PlutoRow(cells: cells);
      }).toList();
    }

    stateManager.appendRows(rows);
    stateManager.appendRows(newRows);
    // print(rows.length);
    return rows;
  }

  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager = PlutoGridStateManager(
      columns: [],
      rows: [],
      gridFocusNode: FocusNode(),
      scroll: PlutoGridScrollController());
  List<PlutoColumn> columns = [];

  List<WarrantyRecordModel> invoiceRecord = [];

  List<WarrantyRecordModel> handleSaveAll() {
    stateManager.setShowLoading(true);
    List<WarrantyRecordModel> invRecord = [];

    invoiceRecord.clear();

    invRecord = stateManager.rows.where((element) {
      return getProductIdFromName(element.cells['invRecProduct']!.value) !=
          null;
    }).map(
      (e) {
        return WarrantyRecordModel.fromJsonPluto(e.toJson());
      },
    ).toList();

    for (var record in invRecord) {
      invoiceRecord.add(record);
    }
    stateManager.setShowLoading(false);

    return invRecord;
  }
}
