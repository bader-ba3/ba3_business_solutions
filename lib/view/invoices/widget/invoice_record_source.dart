import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../controller/invoice_view_model.dart';
import '../../../controller/product_view_model.dart';
import '../../../model/invoice_record_model.dart';
import '../../../model/product_model.dart';
import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';

class InvoiceRecordSource extends DataGridSource {
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  double total = 0.0;

  final globalController = Get.find<InvoiceViewModel>();
  final productController = Get.find<ProductViewModel>();
  final patternController = Get.find<PatternViewModel>();

  List<InvoiceRecordModel> records;
  AccountModel? secAccountModel;

  InvoiceRecordSource({required this.records, this.secAccountModel, required this.accountVat}) {
    buildDataGridRows(records, accountVat);
  } //getVatFromName(accountVat)
// dataGridRow.invRecQuantity != null && dataGridRow.invRecSubTotal != null ? dataGridRow.invRecQuantity! * dataGridRow.invRecSubTotal! : null
  void buildDataGridRows(List<InvoiceRecordModel> records, accountVat) {
    this.accountVat = accountVat;
    bool isPatternHasVat = patternController.patternModel[globalController.initModel.patternId]!.patHasVat!;
    for (var i = 0; i < records.length; i++) {
      if (records[i].invRecSubTotal != null) {
        print(records[i].invRecProduct);
        var prod = searchText(records[i].invRecProduct.toString()).first;
        print(prod.prodName.toString() + "  " + prod.prodHasVat.toString());
        records[i].invRecVat = !isPatternHasVat
            ? 0.0
            : !(prod.prodHasVat!)
                ? 0.0
                : (records[i].invRecSubTotal != 0.0 ? records[i].invRecSubTotal : searchLastPrice(prod.prodId!, getVatFromName(accountVat)))! * getVatFromName(accountVat);
        // : double.parse(((records[i].invRecSubTotal != 0.0 ? records[i].invRecSubTotal : searchLastPrice(prod.prodId!, getVatFromName(accountVat)))! * (getVatFromName(accountVat))).toStringAsFixed(2));
        records[i].invRecTotal = (records[i].invRecSubTotal ?? 0) * (records[i].invRecQuantity ?? 0);
      }
    }
    dataGridRows = records
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: Const.rowInvId, value: dataGridRow.invRecId),
              DataGridCell<String>(columnName: Const.rowInvProduct, value: dataGridRow.invRecProduct),
              DataGridCell<int>(columnName: Const.rowInvQuantity, value: dataGridRow.invRecQuantity),
              DataGridCell<double>(columnName: Const.rowInvSubTotal, value: dataGridRow.invRecSubTotal),
              DataGridCell<double>(columnName: Const.rowInvVat, value: dataGridRow.invRecVat),
              DataGridCell<double>(columnName: Const.rowInvTotal, value: dataGridRow.invRecTotal),
              DataGridCell<double>(columnName: Const.rowInvTotalVat, value: dataGridRow.invRecQuantity != null && dataGridRow.invRecSubTotal != null ? dataGridRow.invRecQuantity! * (dataGridRow.invRecVat ?? 0) : null),
            ]))
        .toList();
  }

  late List<DataGridRow> dataGridRows;
  late String accountVat;

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // final int nextColumnIndex=rowColumnIndex.columnIndex+1;
    // final int nextRowIndex = rowColumnIndex.rowIndex ;
    //  int columnCount = 5;

    final dynamic oldValue = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value ?? '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    double vat = getVatFromName(accountVat);
    // if (column.columnName == Const.rowInvId) {
    //   dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //       DataGridCell<String>(columnName: Const.rowInvId, value: newCellValue);
    //   records[dataRowIndex].invRecId = newCellValue.toString();
    // }

    bool isPatternHasVat = patternController.patternModel[globalController.initModel.patternId]!.patHasVat!;
    if (column.columnName == Const.rowInvProduct) {
      List<ProductModel> result = searchText(newCellValue.toString());
      if (result.isEmpty) {
        Get.snackbar("error", "not found");
      } else if (result.length == 1) {
        var prod = result[0];
        choose_product(prod, vat, dataRowIndex, rowColumnIndex, isPatternHasVat);

        // print("----");
        // print(searchLastPrice(prod.prodId!, vat));
        // print((searchLastPrice(prod.prodId!, vat) * (vat)));
        // print("----");
        // dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: Const.rowInvProduct, value: prod.prodName);
        // records[dataRowIndex].invRecProduct = prod.prodName.toString();
        // records[dataRowIndex].invRecId = (dataRowIndex + 1).toString();
        // records[dataRowIndex].invRecSubTotal = (searchLastPrice(prod.prodId!, vat) - (searchLastPrice(prod.prodId!, vat) * (prod.prodHasVat! ? (vat) : 1)));
        // records[dataRowIndex].invRecVat = !isPatternHasVat
        //     ? 0.0
        //     : (prod.prodHasVat ?? false) //(total - (total * vat))
        //         // ? double.parse((searchLastPrice(prod.prodId!, vat) - (searchLastPrice(prod.prodId!, vat) / (vat + 1))).toStringAsFixed(1))
        //         ? (searchLastPrice(prod.prodId!, vat) * (vat))
        //         : 0.0;
        // records[dataRowIndex].invRecQuantity = 1;
        // records[dataRowIndex].invRecTotal = (records[dataRowIndex].invRecSubTotal ?? 0) * (records[dataRowIndex].invRecQuantity ?? 0);
        // if (int.parse(prod.prodAllQuantity ?? "0") < 0) {
        //   Get.snackbar("Warning", "the qunatity in store is negative (only: ${result.first.prodAllQuantity} )");
        // }
        // globalController.onCellTap(rowColumnIndex);
        // buildDataGridRows(records, accountVat);
        // updateDataGridSource();
      } else {
        Get.defaultDialog(
            title: "choose one",
            content: SizedBox(
              height: 500,
              width: 500,
              child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        choose_product(result[index], vat, dataRowIndex, rowColumnIndex, isPatternHasVat);
                        Get.back();
                      },
                      child: Text(result[index].prodName!),
                    );
                  }),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("back"))
            ]);
      }
    } else if (column.columnName == Const.rowInvQuantity) {
      // if (int.tryParse(newCellValue) != null) {
      //   var product_name = dataGridRows[dataRowIndex].getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
      //   if (product_name?.value == null) {
      //     Get.snackbar("error", "plz fill name first");
      //   } else {
      //     List<ProductModel> result = searchText(product_name!.value);
      //     if (int.parse(result.first.prodAllQuantity ?? "0") - int.parse(newCellValue) < 0) {
      //       Get.snackbar("Warning", "the qunatity is higher than all quantity in store (only: ${result.first.prodAllQuantity} )");
      //     }
      //     dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<int>(columnName: Const.rowInvQuantity, value: int.parse(newCellValue));
      //     records[dataRowIndex].invRecQuantity = int.parse(newCellValue);
      //     records[dataRowIndex].invRecTotal = (records[dataRowIndex].invRecSubTotal ?? 0) * (records[dataRowIndex].invRecQuantity ?? 0);
      //     buildDataGridRows(records);
      //     updateDataGridSource();
      //   }
      // } else {
      //   Get.snackbar("Error", "plz write a vailed number");
      // }
      var product_name = dataGridRows[dataRowIndex].getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
      if (product_name?.value == null) {
        Get.snackbar("error", "plz fill name first");
      } else {
        List<ProductModel> result = searchText(product_name!.value);
        if (int.tryParse(newCellValue) != null) {
          if (int.parse(result.first.prodAllQuantity ?? "0") - int.parse(newCellValue) < 0) {
            Get.snackbar("Warning", "the qunatity is higher than all quantity in store (only: ${result.first.prodAllQuantity} )");
          }
          dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<int>(columnName: Const.rowInvQuantity, value: int.parse(newCellValue));
          records[dataRowIndex].invRecQuantity = int.parse(newCellValue);
        } else {
          try {
            Expression exp = Parser().parse(newCellValue);
            var finalExp = exp.evaluate(EvaluationType.REAL, ContextModel()).toInt();
            dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<int>(columnName: Const.rowInvQuantity, value: finalExp);
            records[dataRowIndex].invRecQuantity = finalExp;
            if (int.parse(result.first.prodAllQuantity ?? "0") - finalExp < 0) {
              Get.snackbar("Warning", "the qunatity is higher than all quantity in store (only: ${result.first.prodAllQuantity} )");
            }
          } catch (error) {
            Get.snackbar("Error", "plz write a vailed number");
          }
        }
        globalController.onCellTap(rowColumnIndex);
        records[dataRowIndex].invRecTotal = (records[dataRowIndex].invRecSubTotal ?? 0) * (records[dataRowIndex].invRecQuantity ?? 0);
        buildDataGridRows(records, accountVat);
        updateDataGridSource();
      }
    } else if (column.columnName == Const.rowInvSubTotal) {
      var product_name = dataGridRows[dataRowIndex].getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
      if (product_name?.value == null) {
        Get.snackbar("error", "plz fill name first");
      } else {
        if (double.tryParse(newCellValue) != null) {
          records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : (double.parse(newCellValue) * vat);
          dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: Const.rowInvSubTotal, value: double.parse(newCellValue));
          records[dataRowIndex].invRecSubTotal = double.parse(newCellValue);
        } else {
          try {
            Expression exp = Parser().parse(newCellValue);
            var finalExp = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
            print(finalExp);
            records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : (double.parse(finalExp) * vat);
            dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: Const.rowInvSubTotal, value: double.parse(finalExp));
            records[dataRowIndex].invRecSubTotal = double.parse(finalExp);
          } catch (error) {
            print(error);
            Get.snackbar("Error", "plz write a vailed number");
          }
        }
        records[dataRowIndex].invRecTotal = (records[dataRowIndex].invRecSubTotal ?? 0) * (records[dataRowIndex].invRecQuantity ?? 0);
        globalController.onCellTap(rowColumnIndex);
        buildDataGridRows(records, accountVat);
        updateDataGridSource();
      }
    } else if (column.columnName == Const.rowInvTotal) {
      if (double.tryParse(newCellValue) != null) {
        dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: Const.rowInvTotal, value: double.parse(newCellValue));
        records[dataRowIndex].invRecTotal = double.parse(newCellValue);
        records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : (double.parse(newCellValue) * vat);
      } else {
        try {
          Expression exp = Parser().parse(newCellValue);
          var finalExp = exp.evaluate(EvaluationType.REAL, ContextModel());
          records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : (double.parse(finalExp) * vat);
          dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: Const.rowInvTotal, value: double.parse(finalExp));
          records[dataRowIndex].invRecTotal = double.parse(finalExp);
        } catch (error) {
          Get.snackbar("Error", "plz write a vailed number");
        }
      }
      records[dataRowIndex].invRecSubTotal = (records[dataRowIndex].invRecTotal ?? 0) / (records[dataRowIndex].invRecQuantity ?? 1);
      records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : ((records[dataRowIndex].invRecSubTotal ?? 0) * vat);
      globalController.onCellTap(rowColumnIndex);
      buildDataGridRows(records, accountVat);
      updateDataGridSource();
    }
// double.parse((searchLastPrice(result[index].prodId!, vat) - (searchLastPrice(result[index].prodId!, vat) / (vat + 1))).toStringAsFixed(1))

    // print(secAccountModel?.accId);
    // print(secAccountModel?.accHasVat);
    // if (!(secAccountModel!.accHasVat!)) {
    //   records[dataRowIndex].invRecVat = 0;
    //   buildDataGridRows(records);
    //   updateDataGridSource();
    // }
    globalController.update();
  }

  void choose_product(ProductModel result, double vat, int dataRowIndex, RowColumnIndex rowColumnIndex, bool isPatternHasVat) {
    print(searchLastPrice(result.prodId!, vat));
    dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: Const.rowInvProduct, value: result.toString());
    records[dataRowIndex].invRecProduct = result.prodName!.toString();
    records[dataRowIndex].invRecId = (dataRowIndex + 1).toString();
    records[dataRowIndex].invRecSubTotal = (searchLastPrice(result.prodId!, vat) / (result.prodHasVat! ? (vat + 1) : 1));
    records[dataRowIndex].invRecVat = !isPatternHasVat
        ? 0
        : (result.prodHasVat ?? false)
            ? (searchLastPrice(result.prodId!, vat) - (searchLastPrice(result.prodId!, vat) / (vat + 1)))
            : 0;
    records[dataRowIndex].invRecQuantity = 1;
    if (int.parse(result.prodAllQuantity ?? "0") < 0) {
      Get.snackbar("Warning", "the qunatity in store is negative (only: ${result.prodAllQuantity} )");
    }
    globalController.onCellTap(rowColumnIndex);
    buildDataGridRows(records, accountVat);
    updateDataGridSource();
    globalController.update();
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value?.toString() ?? '';

    newCellValue = null;

    final bool isNumericType = column.columnName == 'subTotal' || column.columnName == 'total';
    final bool isIntType = column.columnName == 'quantity';

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = double.parse(value);
            } else if (isIntType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn, RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 != 0) {
        return Colors.lightBlue.withOpacity(0.1);
      }

      return Colors.transparent;
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return GestureDetector(
        onSecondaryTapDown: (_) {
          var productName = row.getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
          if (productName?.value != null) {
            var prodId = productController.productDataMap.values.firstWhere((element) => element.prodName == productName?.value).prodId;
            showContextMenu(_.globalPosition, prodId);
          }
        },
        child: Container(
          color: getRowBackgroundColor(),
          alignment: Alignment.center,
          child: Text(dataGridCell.value == null
              ? ""
              : dataGridCell.value.runtimeType == double
                  ? dataGridCell.value.toStringAsFixed(2)
                  : dataGridCell.value.toString()),
        ),
      );
    }).toList());
  }

  void updateDataGridSource() {
    computeTotal();
    notifyListeners();
  }

  double computeTotal() {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals + record.invRecVat!);
      }
    }
    print("WE HOPE IT WILL WORK " + total.toString());
    return total;
  }

  late List<ProductModel> products = [];
  late List<ProductModel> selectedProducts = [];

  List<ProductModel> searchText(String query) {
    ProductViewModel productController = Get.find<ProductViewModel>();
    products = productController.productDataMap.values.toList().where((item) {
      var prodName = item.prodName.toString().toLowerCase().contains(query.toLowerCase());
      var prodCode = item.prodCode.toString().toLowerCase().contains(query.toLowerCase());
      return prodName || prodCode;
    }).toList();
    return products.toList();
  }

  double searchLastPrice(String prodId, vat) {
    double price = 0.0;
    ProductViewModel productController = Get.find<ProductViewModel>();
    if (productController.productRecordMap[prodId]!.lastOrNull != null) {
      ProductRecordModel product = productController.productRecordMap[prodId]!.last;
      price = double.parse(product.prodRecSubTotal!) + double.parse(product.prodRecSubVat!);
      print(price);
    }
    return price;
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    // Return false, to retain in edit mode.
    return true; // or super.canSubmitCell(dataGridRow, rowColumnIndex, column);
  }

  void showContextMenu(Offset tapPosition, productId) {
    //final RenderBox overlay = Overlay.of(Get.context!)!.context.findRenderObject() as RenderBox;
    showMenu(
      context: Get.context!,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy + 1.0,
      ),
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.golf_course),
            title: Text('عرض حركات المادة'),
          ),
          value: 'product',
        ),
      ],
    ).then((value) {
      if (value == 'product') {
        Get.to(ProductDetails(
          oldKey: productId,
        ));
      }
    });
  }
}
