import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/model/invoice/invoice_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../core/constants/app_strings.dart';
import '../../model/product/product_model.dart';
import '../../core/helper/functions/functions.dart';

class InvoicePlutoViewModel extends GetxController {
  InvoicePlutoViewModel() {
    getColumns();
  }

  getColumns() {
    Map<PlutoColumn, dynamic> sampleData = InvoiceRecordModel().toEditedMap();
    columns = sampleData.keys.toList();
    update();
    return columns;
  }

  clearRowIndex(int rowIdx) {
    final rowToRemove = stateManager.rows[rowIdx];

    stateManager.removeRows([rowToRemove]);
    Get.back();
    update();
  }

  String typeBile = '';
  String customerName = '';

  bool getIfHaveVAT() {
    if (typeBile != AppStrings.invoiceTypeBuy) {
      return true;
    } else {
      return getCustomerHaveVAT(customerName);
    }
  }

  getRows(List<InvoiceRecordModel> modelList) {
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

  double computeWithoutVatTotal() {
    int invRecQuantity = 0;
    double subtotals = 0.0;
    double total = 0.0;

    stateManager.setShowLoading(true);
    for (var record in stateManager.rows) {
      if (record.toJson()["invRecQuantity"] != '' &&
          record.toJson()["invRecSubTotal"] != '' &&
          (record.toJson()["invRecGift"] == '' ||
              (int.tryParse(record.toJson()["invRecGift"] ?? "0") ?? 0) >= 0)) {
        invRecQuantity = int.tryParse(replaceArabicNumbersWithEnglish(
                record.toJson()["invRecQuantity"].toString())) ??
            0;
        subtotals = double.tryParse(replaceArabicNumbersWithEnglish(
                record.toJson()["invRecSubTotal"].toString())) ??
            0;

        total += invRecQuantity * (subtotals);
      }
    }
    // for (var record in discountRecords) {
    //   if ((record.discountPercentage ?? 0) > 0) {
    //     total -= record.discountTotal ?? 0;
    //   }
    //   if ((record.addedPercentage ?? 0) > 0) {
    //     total += record.addedTotal ?? 0;
    //   }
    // }

    stateManager.setShowLoading(false);
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then(
      (value) {
        // update();
      },
    );
    return total;
  }

  int computeGiftsTotal() {
    int total = 0;

    stateManager.setShowLoading(true);
    for (var record in stateManager.rows) {
      if (record.toJson()["invRecGift"] != null &&
          record.toJson()["invRecGift"] != '') {
        total = int.tryParse(replaceArabicNumbersWithEnglish(
                record.toJson()["invRecQuantity"].toString())) ??
            0;
      }
    }
    stateManager.setShowLoading(false);

    return total;
  }

  double computeWithVatTotal() {
    double total = 0.0;
    for (var record in stateManager.rows) {
      if (record.toJson()["invRecQuantity"] != '' &&
          record.toJson()["invRecSubTotal"] != '') {
        total +=
            double.tryParse(record.toJson()["invRecTotal"].toString()) ?? 0;
      }
    }
    stateManager.setShowLoading(false);

    return total;
  }

  double getPrice({type, prodName}) {
    ProductViewModel productController = Get.find<ProductViewModel>();
    double price = 0;
    ProductModel product = getProductModelFromName(prodName.toString())!;

    switch (type) {
      case AppStrings.invoiceChoosePriceMethodeCustomerPrice:
        price = double.parse(product.prodCustomerPrice ?? "0");
        break;
      case AppStrings.invoiceChoosePriceMethodeWholePrice:
        price = double.parse(product.prodWholePrice ?? "0");
        break;
      case AppStrings.invoiceChoosePriceMethodeRetailPrice:
        price = double.parse(product.prodRetailPrice ?? "0");
        break;
      case AppStrings.invoiceChoosePriceMethodeMinPrice:
        price = double.parse(product.prodMinPrice ?? "0");
        break;
      case AppStrings.invoiceChoosePriceMethodeAverageBuyPrice:
        price = productController.getAvreageBuy(product);
        break;
      case AppStrings.invoiceChoosePriceMethodeCostPrice:
        price = double.parse(product.prodCostPrice ?? "0");
        break;
      case AppStrings.invoiceChoosePriceMethodeLastPrice:
        var lastPriceProduct =
            productController.productDataMap[prodName]?.prodRecord;
        if (lastPriceProduct != null && lastPriceProduct.isNotEmpty) {
          price = double.parse(lastPriceProduct.last.prodRecSubTotal!) +
              double.parse(lastPriceProduct.last.prodRecSubVat!);
        }
        break;
      case AppStrings.invoiceChoosePriceMethodeHigher:
        var higherProducts =
            productController.productDataMap[prodName]?.prodRecord;
        if (higherProducts != null && higherProducts.isNotEmpty) {
          for (var element in higherProducts) {
            var totalPrice = double.parse(element.prodRecSubTotal!) +
                double.parse(element.prodRecSubVat!);
            if (totalPrice > price) {
              price = totalPrice;
            }
          }
        }
        break;
      case AppStrings.invoiceChoosePriceMethodeLower:
        var lowerProducts =
            productController.productDataMap[prodName]?.prodRecord;
        if (lowerProducts != null && lowerProducts.isNotEmpty) {
          price = double.parse(lowerProducts.first.prodRecSubTotal!) +
              double.parse(lowerProducts.first.prodRecSubVat!);
          for (var element in lowerProducts) {
            var totalPrice = double.parse(element.prodRecSubTotal!) +
                double.parse(element.prodRecSubVat!);
            if (totalPrice < price) {
              price = totalPrice;
            }
          }
        }
        break;
      case AppStrings.invoiceChoosePriceMethodeAveragePrice:
        var averageProducts =
            productController.productDataMap[prodName]?.prodRecord;
        if (averageProducts != null && averageProducts.isNotEmpty) {
          double allPrice = 0;
          for (var element in averageProducts) {
            var totalPrice = double.parse(element.prodRecSubTotal!) +
                double.parse(element.prodRecSubVat!);
            allPrice += totalPrice;
          }
          price = allPrice / averageProducts.length;
        }
        break;
      default:
        throw ArgumentError("Unknown price method: $type");
    }

    return price;
  }

  void showContextMenuSubTotal({
    required Offset tapPosition,
    required ProductModel productModel,
    required int index,
  }) {
    final menuItems = [
      {
        'label': 'سعر المستهلك',
        'method': AppStrings.invoiceChoosePriceMethodeCustomerPrice
      },
      {
        'label': 'سعر الجملة',
        'method': AppStrings.invoiceChoosePriceMethodeWholePrice
      },
      {
        'label': 'سعر المفرق',
        'method': AppStrings.invoiceChoosePriceMethodeRetailPrice
      },
      {
        'label': 'اقل سعر مسموح',
        'method': AppStrings.invoiceChoosePriceMethodeMinPrice
      },
      {
        'label': 'سعر التكلفة',
        'method': AppStrings.invoiceChoosePriceMethodeCostPrice
      },
      {
        'label': 'سعر الوسطي',
        'method': AppStrings.invoiceChoosePriceMethodeAveragePrice
      },
      {
        'label': 'اخر سعر',
        'method': AppStrings.invoiceChoosePriceMethodeLastPrice
      },
      {
        'label': 'سعر الاعلى',
        'method': AppStrings.invoiceChoosePriceMethodeHigher
      },
      {
        'label': 'سعر الاقل',
        'method': AppStrings.invoiceChoosePriceMethodeLower
      },
      {
        'label': 'متوسط شراء',
        'method': AppStrings.invoiceChoosePriceMethodeAverageBuyPrice
      },
    ];

    showMenu(
      context: Get.context!,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy + 1.0,
      ),
      items: menuItems.map((menuItem) {
        return showContextMenuItem(
          index,
          productModel,
          menuItem['label']!,
          menuItem['method']!,
        );
      }).toList(),
    );
  }

  void updateCellValue(String field, dynamic value) {
    stateManager.changeCellValue(
      stateManager.currentRow!.cells[field]!,
      value,
      callOnChangedEvent: false,
      notify: true,
      force: true,
    );
  }

  double parseExpression(String expression) {
    return Parser()
        .parse(expression)
        .evaluate(EvaluationType.REAL, ContextModel());
  }

/*  void handleProductColumn(String fieldName, String productValue) {
    var productModel = getProductModelFromName(productValue);
    String prodName = productModel?.prodName ?? '';

    updateCellValue(fieldName, prodName);
  }*/

  void updateInvoiceValues(double subTotal, int quantity) {
    double vat = getIfHaveVAT() ? (subTotal * 0.05) : 0;
    double total = (subTotal) * quantity;
    updateCellValue("invRecVat", vat.toStringAsFixed(2));
    updateCellValue("invRecSubTotal", (subTotal-vat).toStringAsFixed(2));
    updateCellValue("invRecTotal", total.toStringAsFixed(2));
    updateCellValue("invRecQuantity",quantity);
  }

  void updateInvoiceValuesByTotal(double total, int quantity) {
    double subTotal = getIfHaveVAT()
        ? (total / quantity) - ((total * 0.05) / quantity)
        : total / quantity;
    double vat = getIfHaveVAT() ? ((total / quantity) - subTotal) : 0;

    updateCellValue("invRecVat", vat.toStringAsFixed(2));
    updateCellValue("invRecSubTotal", subTotal.toStringAsFixed(2));
    updateCellValue("invRecTotal", total.toStringAsFixed(2));
  }

  void updateInvoiceValuesByQuantity(int quantity, subtotal, double vat) {
    double total = (subtotal + vat) * quantity;

    updateCellValue("invRecTotal", total.toStringAsFixed(2));
  }

  PopupMenuItem showContextMenuItem(
      int index, ProductModel productModel, text, method) {
    return PopupMenuItem(
      onTap: () {
        updateInvoiceValues(
          getPrice(prodName: productModel.prodName, type: method),
          int.tryParse(stateManager.rows[index].cells["invRecQuantity"]?.value
                      .toString() ??
                  "1") ??
              1,
        );
        update();
      },
      enabled: true,
      child: ListTile(
        title: Text(
          text +
              ": " +
              getPrice(type: method, prodName: productModel.prodName)
                  .toStringAsFixed(2),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  List<InvoiceRecordModel> invoiceRecord = [];

  List<InvoiceRecordModel> handleSaveAll({required bool withOutProud}) {
    stateManager.setShowLoading(true);
    List<InvoiceRecordModel> invRecord = [];

    invoiceRecord.clear();
    if (withOutProud) {
      invRecord = stateManager.rows.where((element) {
        return element.cells['invRecProduct']!.value != '';
      }).map(
        (e) {
          // e.cells['invRecProduct']!.value=getProductIdFromName(e.cells['invRecProduct']!.value)??e.cells['invRecProduct']!.value;
          return InvoiceRecordModel.fromJsonPluto(e.toJson());
        },
      ).toList();
    } else {
      invRecord = stateManager.rows.where((element) {
        return getProductIdFromName(element.cells['invRecProduct']!.value) !=
            null;
      }).map(
        (e) {
          // e.cells['invRecProduct']!.value=getProductIdFromName(e.cells['invRecProduct']!.value)??e.cells['invRecProduct']!.value;
          return InvoiceRecordModel.fromJsonPluto(e.toJson());
        },
      ).toList();
    }

    for (var record in invRecord) {
      record.invRecGiftTotal = (record.invRecGift ?? 0) *
          (double.tryParse(
                  getProductModelFromId(record.invRecProduct)?.prodCostPrice ??
                      "0") ??
              0);
      invoiceRecord.add(record);
    }
    stateManager.setShowLoading(false);

    return invRecord;
  }

  changeVat() {
    handleSaveAll(withOutProud: false);
    if (!getIfHaveVAT()) {
      for (var element in invoiceRecord) {
        element.invRecSubTotal =
            (element.invRecSubTotal ?? 0) + (element.invRecVat ?? 0);
        element.invRecVat = 0;
      }
    } else {
      for (var element in invoiceRecord) {
        element.invRecVat = (element.invRecSubTotal ?? 0) * 0.05;
        element.invRecSubTotal =
            ((element.invRecTotal ?? 0) / (element.invRecQuantity ?? 0)) -
                (element.invRecVat!);
        element.invRecTotal = (element.invRecSubTotal! + element.invRecVat!) *
            (element.invRecQuantity ?? 0);
      }
    }
    getRows(invoiceRecord);
    update();
  }
}
