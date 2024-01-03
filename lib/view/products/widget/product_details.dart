import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_view.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../model/product_model.dart';
import '../../../model/product_record_model.dart';

class ProductDetails extends StatefulWidget {
  final String? oldKey;
  const ProductDetails({super.key, this.oldKey});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<ProductRecordModel> editedProductRecord = [];
  ProductViewModel productController = Get.find<ProductViewModel>();

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.oldKey ?? "a"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Get.to(AddProduct(
                    oldKey: widget.oldKey,
                  ));
                },
                child: Text("update")),
            SizedBox(
              width: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  productController.deleteProduct(withLogger: true);
                  Get.back();
                },
                child: Text("delete")),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(Const.productsCollection)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null ||
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return GetBuilder<ProductViewModel>(
                              builder: (controller) {
                            initPage();
                            controller.initGrid(snapshot.data);
                            return SfDataGrid(
                              onCellTap: (DataGridCellTapDetails _) {
                                if (_.rowColumnIndex.rowIndex != 0)
                                  Get.to(() => InvoiceView(
                                        billId: editedProductRecord[
                                                _.rowColumnIndex.rowIndex - 1]
                                            .invId!,
                                        patternId: '',
                                      ));
                              },
                              source: controller.recordDataSource,
                              allowEditing: false,
                              selectionMode: SelectionMode.none,
                              editingGestureType: EditingGestureType.tap,
                              navigationMode: GridNavigationMode.cell,
                              columnWidthMode: ColumnWidthMode.fill,
                              columns: <GridColumn>[
                                GridColumnItem(
                                    label: "النوع", name: Const.rowProductType),
                                GridColumnItem(
                                    label: 'الكمية',
                                    name: Const.rowProductQuantity),
                                GridColumnItem(
                                    label: 'الرمز التسلسي للفاتورة',
                                    name: Const.rowProductInvId),
                              ],
                            );
                          });
                        }
                      }),
                ),
              ),
              //Spacer(),
              // ElevatedButton(
              //     onPressed: () {
              //       if (editedProduct.prodId == null) {
              //         productController.createProduct(editedProduct,
              //             withLogger: true);
              //         isEdit = false;
              //       } else {
              //         productController.updateProduct(editedProduct,
              //             withLogger: true);
              //         isEdit = false;
              //       }
              //     },
              //     child:
              //         Text(editedProduct.prodId == null ? "create" : "update"))
            ],
          ),
        ),
      ),
    );
  }

  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: false,
        columnName: name,
        label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              label.toString(),
            )));
  }

  void initPage() {
    if (widget.oldKey != null) {
      productController.productModel = ProductModel.fromJson(
          productController.productDataMap[widget.oldKey!]!.toJson());
      editedProductRecord.clear();
      productController.productRecordMap[widget.oldKey!]?.forEach((element) {
        editedProductRecord
            .add(ProductRecordModel.fromJson(element.toJson(), element.invId));
      });
      ProductModel _ = productController.productDataMap[widget.oldKey!]!;
    } else {
      productController.productModel = ProductModel();
      editedProductRecord = <ProductRecordModel>[];
    }
    productController.initProductPage(editedProductRecord);
  }
}
