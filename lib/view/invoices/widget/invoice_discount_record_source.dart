import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../controller/invoice_view_model.dart';
import '../../../controller/product_view_model.dart';
import '../../../model/invoice_discount_record_model.dart';
import '../../../model/invoice_record_model.dart';
import '../../../model/product_model.dart';
import 'package:math_expressions/math_expressions.dart';

class InvoiceDiscountRecordSource extends DataGridSource {
  dynamic newCellValue;
  TextEditingController editingController = TextEditingController();
  double total = 0.0;

  final invoiceViewModel = Get.find<InvoiceViewModel>();
  final productController = Get.find<ProductViewModel>();
  final patternController = Get.find<PatternViewModel>();

  List<InvoiceDiscountRecordModel> records;
  AccountModel? secAccountModel;
  bool? isPatternHasVat;

  InvoiceDiscountRecordSource({required this.records}) {
    buildDataGridRows(records);
  }

  void buildDataGridRows(List<InvoiceDiscountRecordModel> records) {
    dataGridRows = records
        .map<DataGridRow>((dataGridRow) {
          // if(dataGridRow.discountId!=null){
          //   if(dataGridRow.isChooseTotal==true){
          //     dataGridRow.percentage = dataGridRow.total! / totalWithoutVat!;
          //   }else if(dataGridRow.isChooseTotal==false){
          //     dataGridRow.total = totalWithoutVat! * dataGridRow.percentage! / 100;
          //   }
          // }
          return DataGridRow(cells: [
            DataGridCell<int>(columnName: Const.rowInvDiscountId, value: dataGridRow.discountId),
            DataGridCell<String>(columnName: Const.rowInvDiscountAccount, value: getAccountNameFromId(dataGridRow.accountId)),
            DataGridCell<double>(columnName: Const.rowInvDiscountTotal, value: dataGridRow.total),
            DataGridCell<double>(columnName: Const.rowInvDiscountPercentage, value: dataGridRow.percentage),
          ]);
    })
        .toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value ?? '';
    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);
    if(records[dataRowIndex].discountId == null){
      records[dataRowIndex].discountId = (dataRowIndex + 1);
      records[dataRowIndex].percentage=0;
      records[dataRowIndex].total=0;
    }
    if (column.columnName == Const.rowInvDiscountAccount) {
      AccountModel? _ = await getAccountCompleteID(newCellValue);
      if(_!=null){
        records[dataRowIndex].accountId =_.accId;
        invoiceViewModel.onDiscountCellTap(rowColumnIndex);
        buildDataGridRows(records);
        updateDataGridSource();
      }
    }else if(records[dataRowIndex].accountId!=null&&newCellValue!=null){
      if(column.columnName == Const.rowInvDiscountTotal){

        records[dataRowIndex].percentage =invoiceViewModel.getPercentage(double.parse(newCellValue));
        if(records[dataRowIndex].percentage!>100){

        }else{
          records[dataRowIndex].total =double.parse(newCellValue);
          records[dataRowIndex].isChooseTotal =true;
          invoiceViewModel.onDiscountCellTap(rowColumnIndex);
          buildDataGridRows(records);
          updateDataGridSource();
        }

      }else if(column.columnName == Const.rowInvDiscountPercentage){
        if(double.parse(newCellValue)!>100){

        }else{
        records[dataRowIndex].percentage =double.parse(newCellValue);
        records[dataRowIndex].isChooseTotal =false;
        records[dataRowIndex].total =invoiceViewModel.getTotal(double.parse(newCellValue));
        invoiceViewModel.onDiscountCellTap(rowColumnIndex);
        buildDataGridRows(records);
        updateDataGridSource();
        }
      }
    }
    invoiceViewModel.update();
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    String displayText = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value?.toString() ?? '';

    newCellValue = null;

    final bool isNumericType = column.columnName == 'subTotal' || column.columnName == 'total';
    final bool isIntType = column.columnName == 'quantity';
    if (double.tryParse(displayText) != null) {
      displayText = double.parse(displayText).toStringAsFixed(2);
    }
    return Container(
      color: effectiveRows.indexOf(dataGridRow) % 2 == 0 ? Colors.grey.withOpacity(0.2) : Colors.grey,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration:  InputDecoration(
          fillColor: Colors.black,
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
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      if (index % 2 == 0) {
        return  Colors.grey.shade300;
      }

      return Colors.grey;
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return GestureDetector(
        onSecondaryTapDown: (_) {
          var productName = row.getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
          if (productName?.value != null) {
            var prodItem = productController.productDataMap.values.firstWhere((element) => element.prodName == productName?.value);
            if (dataGridCell.columnName == Const.rowInvProduct) {
              showContextMenuProductName(_.globalPosition, prodItem.prodId, effectiveRows.indexOf(row));
            } else if (dataGridCell.columnName == Const.rowInvSubTotal) {
              showContextMenuSubTotal(_.globalPosition, prodItem, effectiveRows.indexOf(row), isPatternHasVat!);
            }
          }
        },
        onLongPressStart: (_) {
          var productName = row.getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
          if (productName?.value != null) {
            var prodItem = productController.productDataMap.values.firstWhere((element) => element.prodName == productName?.value);
            if (dataGridCell.columnName == Const.rowInvProduct) {
              showContextMenuProductName(_.globalPosition, prodItem.prodId, effectiveRows.indexOf(row));
            } else if (dataGridCell.columnName == Const.rowInvSubTotal) {
              showContextMenuSubTotal(_.globalPosition, prodItem, effectiveRows.indexOf(row), isPatternHasVat!);
            }
          }
        },
        child: Container(
          color: getRowBackgroundColor(),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(dataGridCell.value == null
                    ? ""
                    : dataGridCell.value.runtimeType == double
                        ? dataGridCell.value.toStringAsFixed(2)
                        : dataGridCell.value.toString(),textAlign: TextAlign.center,),
              ),
              if(dataGridCell.columnName == Const.rowInvDiscountPercentage)
                Text("%",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(width: 10,),
            ],
          ),
        ),
      );
    }).toList());
  }

  void updateDataGridSource() {
    // computeTotal();
    notifyListeners();
  }

  // double computeTotal() {
  //   int quantity = 0;
  //   double subtotals = 0.0;
  //   total = 0.0;
  //   for (var record in records) {
  //     if (record.invRecQuantity != null && record.invRecSubTotal != null) {
  //       quantity = record.invRecQuantity!;
  //       subtotals = record.invRecSubTotal!;
  //       total += quantity * (subtotals + record.invRecVat!);
  //     }
  //   }
  //   return total;
  // }


  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column) async {
    return true;
  }

  void showContextMenuProductName(Offset tapPosition, productId, int index) {
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
        PopupMenuItem(
          child: ListTile(
            leading: Icon(
              Icons.close,
              color: Colors.red,
            ),
            title: Text('حذف المادة'),
          ),
          value: 'delete',
        ),
      ],
    ).then((value) {
      if (value == 'product') {
        Get.to(ProductDetails(
          oldKey: productId,
        ));
      }
      if (value == 'delete') {
        invoiceViewModel.deleteOneRecord(index);
      }
    });
  }

  void showContextMenuSubTotal(Offset tapPosition, ProductModel productModel, int index, bool isPatternHasVat) {
    showMenu(
      // 457
      context: Get.context!,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy + 1.0,
      ),
      items: [
        showContextMenuItem(index, 'حذف'),
      ],
    );
  }

  PopupMenuItem showContextMenuItem(index, text) {
    return PopupMenuItem(
      onTap: () {},
      enabled: true,
      child: ListTile(
        leading: Icon(Icons.delete,color: Colors.red,),
        title: Text(
          text,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
