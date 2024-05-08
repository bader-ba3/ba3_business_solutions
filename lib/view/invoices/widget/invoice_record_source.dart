import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/old_model/account_model.dart';
import 'package:ba3_business_solutions/old_model/product_record_model.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../controller/invoice_view_model.dart';
import '../../../controller/product_view_model.dart';
import '../../../old_model/invoice_record_model.dart';
import '../../../old_model/product_model.dart';
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
  bool? isPatternHasVat;
  int? color;
  InvoiceRecordSource({required this.records, this.secAccountModel, required this.accountVat}) {
    buildDataGridRows(records, accountVat);
  } //getVatFromName(accountVat)
// dataGridRow.invRecQuantity != null && dataGridRow.invRecSubTotal != null ? dataGridRow.invRecQuantity! * dataGridRow.invRecSubTotal! : null
  void buildDataGridRows(List<InvoiceRecordModel> records, accountVat) {
    this.accountVat = accountVat;
    bool isPatternHasVat = patternController.patternModel[globalController.initModel.patternId]!.patHasVat!;
    color=patternController.patternModel[globalController.initModel.patternId]!.patColor;
    this.isPatternHasVat = isPatternHasVat;
    for (var i = 0; i < records.length; i++) {
      if (records[i].invRecSubTotal != null) {
         //searchText().first;
        print(records[i].invRecProduct.toString());
         var prod = getProductModelFromId(records[i].invRecProduct.toString());
        records[i].invRecVat = !isPatternHasVat
            ? 0.0
            : !(prod!.prodHasVat!)
                ? 0.0
                : (records[i].invRecSubTotal != 0.0 ? records[i].invRecSubTotal : searchLastPrice(prod.prodId!, getVatFromName(accountVat), i))! * getVatFromName(accountVat);
        // : double.parse(((records[i].invRecSubTotal != 0.0 ? records[i].invRecSubTotal : searchLastPrice(prod.prodId!, getVatFromName(accountVat)))! * (getVatFromName(accountVat))).toStringAsFixed(2));
        records[i].invRecTotal = (records[i].invRecSubTotal ?? 0) * (records[i].invRecQuantity ?? 0);
      }
    }
    dataGridRows = records
        .map<DataGridRow>((dataGridRow) => DataGridRow(cells: [
              DataGridCell<String>(columnName: Const.rowInvId, value: dataGridRow.invRecId),
              DataGridCell<String>(columnName: Const.rowInvProduct, value: getProductNameFromId(dataGridRow.invRecProduct)),
              DataGridCell<int>(columnName: Const.rowInvQuantity, value: dataGridRow.invRecQuantity),
              DataGridCell<double>(columnName: Const.rowInvSubTotal, value: dataGridRow.invRecSubTotal),
              DataGridCell<double>(columnName: Const.rowInvVat, value: dataGridRow.invRecVat),
              DataGridCell<double>(columnName: Const.rowInvTotal, value: dataGridRow.invRecQuantity != null && dataGridRow.invRecSubTotal != null ? (dataGridRow.invRecQuantity! * (dataGridRow.invRecVat ?? 0))+(dataGridRow.invRecTotal??0) : null),
              DataGridCell<double>(columnName: Const.rowInvTotalVat, value: dataGridRow.invRecQuantity != null && dataGridRow.invRecSubTotal != null ? dataGridRow.invRecQuantity! * (dataGridRow.invRecVat ?? 0)+(dataGridRow.invRecTotal??0) : null),
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

    // if (newCellValue == null || oldValue == newCellValue) {
    //   return;
    // }
    double vat = getVatFromName(accountVat);
    // if (column.columnName == Const.rowInvId) {
    //   dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
    //       DataGridCell<String>(columnName: Const.rowInvId, value: newCellValue);
    //   records[dataRowIndex].invRecId = newCellValue.toString();
    // }

    bool isPatternHasVat = patternController.patternModel[globalController.initModel.patternId]!.patHasVat!;
    if (column.columnName == Const.rowInvProduct) {
      List<ProductModel> result = searchText(newCellValue.toString());
      print(result.map((e) => (e.prodName,e.prodIsGroup)));
      if(newCellValue==null){
        result= productController.productDataMap.values.toList().where((element) => !(element.prodIsGroup??false)).toList();
      }
      if (result.isEmpty) {
        Get.snackbar("خطأ", "غير موجود");
      } else if (result.length == 1) {
        var prod = result[0];
        choose_product(prod, vat, dataRowIndex, rowColumnIndex, isPatternHasVat);
      } else {
        Get.defaultDialog(
            title: "اختر احد المواد",
            content: SizedBox(
              height: Get.height/2,
              width:Get.height/2,
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
    }
    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == Const.rowInvQuantity) {
      var product_name = dataGridRows[dataRowIndex].getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
      if (product_name?.value == null) {
        Get.snackbar("خطأ", "يجب إدخال المادة اولا");
      } else {
        List<ProductModel> result = searchText(product_name!.value);
        if (int.tryParse(newCellValue) != null) {
          if (int.parse(result.first.prodAllQuantity ?? "0") - int.parse(newCellValue) < 0 && result.first.prodType == Const.productTypeStore) {
            Get.snackbar("تحذير", "الكمية المضافة اكبر من الكمية الموجودة");
          }
          dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<int>(columnName: Const.rowInvQuantity, value: int.parse(newCellValue));
          records[dataRowIndex].invRecQuantity = int.parse(newCellValue);
        } else {
          try {
            Expression exp = Parser().parse(newCellValue);
            var finalExp = exp.evaluate(EvaluationType.REAL, ContextModel()).toInt();
            dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<int>(columnName: Const.rowInvQuantity, value: finalExp);
            records[dataRowIndex].invRecQuantity = finalExp;
            if (int.parse(result.first.prodAllQuantity ?? "0") - finalExp < 0 && result.first.prodType == Const.productTypeStore) {
              Get.snackbar("تحذير", "الكمية المضافة اكبر من الكمية الموجودة");
            }
          } catch (error) {
            Get.snackbar("خطأ", "يرجى كتابة رقم");
          }
        }
        globalController.onCellTap(rowColumnIndex);
        records[dataRowIndex].invRecTotal = (records[dataRowIndex].invRecSubTotal ?? 0) * (records[dataRowIndex].invRecQuantity ?? 0);
        buildDataGridRows(records, accountVat);
        updateDataGridSource();
      }
    }
    if (column.columnName == Const.rowInvSubTotal) {
      var product_name = dataGridRows[dataRowIndex].getCells().firstWhereOrNull((element) => element.columnName == Const.rowInvProduct);
      if (product_name?.value == null) {
        Get.snackbar("خطأ", "يجب إدخال المادة اولا");
      } else {
        List<ProductModel> result = searchText(product_name!.value);
        if (double.tryParse(newCellValue) != null) {
          if(double.tryParse(newCellValue)!>=double.parse(result.first.prodMinPrice??"0")/1.05) {
            records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : (double.parse(newCellValue) * vat);
            dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: Const.rowInvSubTotal, value: double.parse(newCellValue));
            records[dataRowIndex].invRecSubTotal = double.parse(newCellValue);
          }else{
            Get.snackbar("خطأ", "السعر المكتوب اقل من اقل سعر مسموح");
          }
        } else {
          try {
            Expression exp = Parser().parse(newCellValue);
            var finalExp = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
            if(double.tryParse(finalExp)!>=double.parse(result.first.prodMinPrice!)/1.05) {
            records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : (double.parse(finalExp) * vat);
            dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<double>(columnName: Const.rowInvSubTotal, value: double.parse(finalExp));
            records[dataRowIndex].invRecSubTotal = double.parse(finalExp);
          }else{
              Get.snackbar("خطأ", "السعر المكتوب اقل من اقل سعر مسموح");
            }
          } catch (error) {
            print(error);
            Get.snackbar("خطأ", "يرجى كتابة رقم");
          }
        }
        records[dataRowIndex].invRecTotal = (records[dataRowIndex].invRecSubTotal ?? 0) * (records[dataRowIndex].invRecQuantity ?? 0);
        records[dataRowIndex].prodChoosePriceMethod=Const.invoiceChoosePriceMethodeCustom;
        globalController.onCellTap(rowColumnIndex);
        buildDataGridRows(records, accountVat);
        updateDataGridSource();
      }
    }
    if (column.columnName == Const.rowInvTotal) {
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
          Get.snackbar("خطأ", "يرجى كتابة رقم");
        }
      }
      records[dataRowIndex].invRecSubTotal = (records[dataRowIndex].invRecTotal ?? 0) / (records[dataRowIndex].invRecQuantity ?? 1);
      records[dataRowIndex].invRecVat = !isPatternHasVat ? 0 : ((records[dataRowIndex].invRecSubTotal ?? 0) * vat);
      globalController.onCellTap(rowColumnIndex);
      buildDataGridRows(records, accountVat);
      updateDataGridSource();
    }
    globalController.update();
  }

  void choose_product(ProductModel result, double vat, int dataRowIndex, RowColumnIndex rowColumnIndex, bool isPatternHasVat) {
    // print(searchLastPrice(result.prodId!, vat, dataRowIndex));
    dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] = DataGridCell<String>(columnName: Const.rowInvProduct, value: result.toString());
    records[dataRowIndex].invRecProduct = result.prodId!.toString();
    records[dataRowIndex].invRecIsLocal = result.prodIsLocal;
    records[dataRowIndex].invRecId = (dataRowIndex + 1).toString();
    records[dataRowIndex].invRecSubTotal = (searchLastPrice(result.prodId!, vat, dataRowIndex) / (result.prodHasVat! ? (vat + 1) : 1));
    records[dataRowIndex].invRecVat = !isPatternHasVat
        ? 0
        : (result.prodHasVat ?? false)
            ? (searchLastPrice(result.prodId!, vat, dataRowIndex) - (searchLastPrice(result.prodId!, vat, dataRowIndex) / (vat + 1)))
            : 0;
    records[dataRowIndex].invRecQuantity = 1;
    if (int.parse(result.prodAllQuantity ?? "0") < 0 && result.prodType == Const.productTypeStore) {
      Get.snackbar("تحذير", "الكمية المضافة اكبر من الكمية الموجودة");
    }
    globalController.onCellTap(rowColumnIndex);
    buildDataGridRows(records, accountVat);
    updateDataGridSource();
    globalController.update();
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    String displayText = dataGridRow.getCells().firstWhereOrNull((DataGridCell dataGridCell) => dataGridCell.columnName == column.columnName)?.value?.toString() ?? '';

    newCellValue = null;

    final bool isNumericType = column.columnName == 'subTotal' || column.columnName == 'total';
    final bool isIntType = column.columnName == 'quantity';
    if(double.tryParse(displayText)!=null){
      displayText= double.parse(displayText).toStringAsFixed(2);
    }
    return Container(
      color:effectiveRows.indexOf(dataGridRow) % 2 == 0?Color(color!).withOpacity(0.2): Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration: const InputDecoration(
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
      if (index % 2 == 0) {
        return Color(color!).withOpacity(0.2);
      }

      return Colors.transparent;
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
    return total;
  }

  late List<ProductModel> products = [];
  late List<ProductModel> selectedProducts = [];

  List<ProductModel> searchText(String query) {
    products = productController.productDataMap.values.toList().where((item) {
      bool prodName = item.prodName.toString().toLowerCase().contains(query.toLowerCase());
      // bool prodCode = item.prodCode.toString().toLowerCase().contains(query.toLowerCase());
      bool prodCode = item.prodFullCode.toString().toLowerCase().contains(query.toLowerCase());
      //bool prodId = item.prodId.toString().toLowerCase().contains(query.toLowerCase());
      return (prodName || prodCode) && !item.prodIsGroup!;
    }).toList();
    return products.toList();
  }

  double searchLastPrice(String prodId, vat, index) {
    double price = 0.0;
    if (records[index].prodChoosePriceMethod == null) {
      records[index].prodChoosePriceMethod = Const.invoiceChoosePriceMethodeCustomerPrice;
    }
    price = getPrice(records[index].prodChoosePriceMethod, prodId);
    return price;
  }

  double getPrice(type, prodId) {
    double price = 0;
    ProductModel product = productController.productDataMap[prodId]!;
    if (type == Const.invoiceChoosePriceMethodeCustomerPrice) {
      price = double.parse(product.prodCustomerPrice??"0");
    }
    if (type == Const.invoiceChoosePriceMethodeWholePrice) {
      price = double.parse(product.prodWholePrice??"0");
    }
    if (type == Const.invoiceChoosePriceMethodeRetailPrice) {
      price = double.parse(product.prodRetailPrice??"0");
    }
    if (type == Const.invoiceChoosePriceMethodeMinPrice) {
      price = double.parse(product.prodMinPrice??"0");
    }
    if (type == Const.invoiceChoosePriceMethodeCostPrice) {
      price = double.parse(product.prodCostPrice??"0");
    } else if (type == Const.invoiceChoosePriceMethodeLastPrice) {
      List<ProductRecordModel>? last_price_product = productController.productDataMap[prodId]?.prodRecord;
      if(last_price_product!.isNotEmpty){
        price = double.parse(last_price_product.last.prodRecSubTotal!) + double.parse(last_price_product.last.prodRecSubVat!);
      }
    } else if (type == Const.invoiceChoosePriceMethodeHigher) {
      List<ProductRecordModel>? higherProducts = productController.productDataMap[prodId]?.prodRecord;
      if (higherProducts != null && higherProducts.isNotEmpty) {
        for (var element in higherProducts) {
          if ((double.parse(element.prodRecSubTotal!) + double.parse(element.prodRecSubVat!)) > price) {
            price = double.parse(element.prodRecSubTotal!) + double.parse(element.prodRecSubVat!);
          }
        }
      }
    } else if (type == Const.invoiceChoosePriceMethodeLower) {
      List<ProductRecordModel>? lowerProducts = productController.productDataMap[prodId]?.prodRecord;
      if (lowerProducts != null && lowerProducts.isNotEmpty) {
        price = double.parse(lowerProducts.first.prodRecSubTotal!) + double.parse(lowerProducts.first.prodRecSubVat!);
        for (var element in lowerProducts) {
          if ((double.parse(element.prodRecSubTotal!) + double.parse(element.prodRecSubVat!)) < price) {
            price = double.parse(element.prodRecSubTotal!) + double.parse(element.prodRecSubVat!);
          }
        }
      }
    } else if (type == Const.invoiceChoosePriceMethodeAveragePrice) {
      List<ProductRecordModel>? averageProducts = productController.productDataMap[prodId]?.prodRecord;
      if (averageProducts != null && averageProducts.isNotEmpty) {
        double allPrice = 0;
        for (var element in averageProducts) {
          price = double.parse(element.prodRecSubTotal!) + double.parse(element.prodRecSubVat!);
          allPrice += price;
        }
        // print(allPrice);
        // print(averageProducts.length);
        price = allPrice / averageProducts.length;
      }
    }
    return price;
  }

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
        globalController.deleteOneRecord(index);
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
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر المستهلك', Const.invoiceChoosePriceMethodeCustomerPrice),
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر الجملة', Const.invoiceChoosePriceMethodeWholePrice),
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر المفرق', Const.invoiceChoosePriceMethodeRetailPrice),
        showContextMenuItem(index, productModel, isPatternHasVat, 'اقل سعر مسموح', Const.invoiceChoosePriceMethodeMinPrice),
        if(checkPermission(Const.roleUserAdmin, Const.roleViewInvoice))
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر التكلفة', Const.invoiceChoosePriceMethodeCostPrice),
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر الوسطي', Const.invoiceChoosePriceMethodeAveragePrice),
        showContextMenuItem(index, productModel, isPatternHasVat, 'اخر سعر', Const.invoiceChoosePriceMethodeLastPrice),
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر الاعلى', Const.invoiceChoosePriceMethodeHigher),
        showContextMenuItem(index, productModel, isPatternHasVat, 'سعر الاقل', Const.invoiceChoosePriceMethodeLower),
        PopupMenuItem(
          height:2,
          enabled: false,
          child: Container(height: 2,color: Colors.grey.shade300,),),
        PopupMenuItem(
          enabled: false,
          child: ListTile(
            title: Text(
             "الربح"+": "+((records[index].invRecSubTotal!+records[index].invRecVat!)-double.parse(productModel.prodCostPrice??"0")!).toStringAsFixed(2),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
        PopupMenuItem(
          enabled: false,
          child: ListTile(
            title: Text(
              "نسبة الربح"+": "+((records[index].invRecSubTotal!+records[index].invRecVat!-double.parse(productModel.prodCostPrice??"0"))/double.parse(productModel.prodCostPrice??"0")*100!).toStringAsFixed(2)+"%",
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem showContextMenuItem(index, productModel, isPatternHasVat, text, method) {
    return PopupMenuItem(
      onTap: () {
        records[index].prodChoosePriceMethod = method;
        records[index].invRecSubTotal = (searchLastPrice(productModel.prodId!, 0, index) / (productModel.prodHasVat! ? (0.05 + 1) : 1));
        records[index].invRecVat = !isPatternHasVat
            ? 0
            : (productModel.prodHasVat ?? false)
                ? (searchLastPrice(productModel.prodId!, 0, index) - (searchLastPrice(productModel.prodId!, 0, index) / (0.05 + 1)))
                : 0;
        buildDataGridRows(records, accountVat);
        updateDataGridSource();
        globalController.update();
      },
      enabled: true,
      child: ListTile(
        leading: records[index].prodChoosePriceMethod == method ? Icon(Icons.check) : null,
        title: Text(
          text + ": " + getPrice(method, productModel.prodId).toStringAsFixed(2),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
