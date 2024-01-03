import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../controller/user_management.dart';
import '../../../model/product_model.dart';
import '../../../model/product_record_model.dart';

class AddProduct extends StatefulWidget {
  final String? oldKey;
  const AddProduct({super.key, this.oldKey});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  late ProductModel editedProduct;
  List<ProductRecordModel> editedProductRecord = [];
  ProductViewModel productController = Get.find<ProductViewModel>();
  bool isEdit = false;
  bool hasVat = true;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEdit) {
          Get.defaultDialog(actions: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text("discard")),
            ElevatedButton(
                onPressed: () {
                  checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewProduct).then((value) {
                    if(value){
                      productController.updateProduct(editedProduct, withLogger: true);
                      Get.back();
                      Get.back();
                    }
                  });


                },
                child: Text("changed")),
          ]);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(editedProduct.prodId ?? "new Product"),
          actions: [
            if (editedProduct.prodId != null)
              ElevatedButton(
                  onPressed: () {
                    checkPermissionForOperation(Const.roleUserDelete,Const.roleViewProduct).then((value) {
                      if(value){
                        productController.deleteProduct(withLogger: true);
                        Get.back();
                      }
                    });


                  },
                  child: Text("delete"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                //   width: 50,
                child: Row(
                  children: [
                    Text("name"),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        onChanged: (_) {
                          editedProduct.prodName = _;
                          isEdit = true;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Text("code"),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: codeController,
                        onChanged: (_) {
                          editedProduct.prodCode = _;
                          isEdit = true;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Text("price"),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        onChanged: (_) {
                          editedProduct.prodPrice = _;
                          isEdit = true;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Text("barcode"),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: barcodeController,
                        onChanged: (_) {
                          editedProduct.prodBarcode = _;
                          isEdit = true;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
                    Text("has vat"),
                    SizedBox(
                      width: 20,
                    ),
                    StatefulBuilder(builder: (context, setstate) {
                      return Switch(
                          mouseCursor: editedProduct.prodId == null ? null : SystemMouseCursors.forbidden,
                          value: hasVat,
                          onChanged: editedProduct.prodId == null
                              ? (_) {
                                  setstate(() {
                                    hasVat = _;
                                    editedProduct.prodHasVat = _;
                                    isEdit = true;
                                  });
                                }
                              : (_) {});
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (editedProduct.prodId == null) {
                      checkPermissionForOperation(Const.roleUserWrite,Const.roleViewProduct).then((value) {
                        if(value){
                          productController.createProduct(editedProduct, withLogger: true);
                          isEdit = false;
                        }
                      });


                    } else {

                      checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewProduct).then((value) {
                        if(value){
                          productController.updateProduct(editedProduct, withLogger: true);
                          isEdit = false;
                        }
                      });


                    }
                  },
                  child: Text(editedProduct.prodId == null ? "create" : "update"))
            ],
          ),
        ),
      ),
    );
  }

  void initPage() {
    if (widget.oldKey != null) {
      editedProduct = ProductModel.fromJson(productController.productDataMap[widget.oldKey!]!.toJson());
      productController.productModel = ProductModel.fromJson(productController.productDataMap[widget.oldKey!]!.toJson());
      editedProductRecord.clear();
      productController.productRecordMap[widget.oldKey!]?.forEach((element) {
        editedProductRecord.add(ProductRecordModel.fromJson(element.toJson(), element.invId));
      });
      ProductModel _ = productController.productDataMap[widget.oldKey!]!;
      nameController.text = _.prodName!;
      codeController.text = _.prodCode!;
      priceController.text = _.prodPrice!;
      barcodeController.text = _.prodBarcode!;
      hasVat = _.prodHasVat ?? false;
    } else {
      editedProduct = ProductModel();
      productController.productModel = ProductModel();
      editedProductRecord = <ProductRecordModel>[];
      hasVat = true;
      editedProduct.prodHasVat = true;
    }
    //  productController.initProductPage(editedProductRecord);
  }
}
