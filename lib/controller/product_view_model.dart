import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Const/const.dart';
import '../model/account_record_model.dart';
import '../model/invoice_record_model.dart';
import '../model/product_model.dart';
import '../utils/logger.dart';
import '../view/products/widget/product_record_data_source.dart';

class ProductViewModel extends GetxController {
  RxMap<String, List<ProductRecordModel>> productRecordMap = <String, List<ProductRecordModel>>{}.obs;
  RxMap<String, ProductModel> productDataMap = <String, ProductModel>{}.obs;
  late ProductRecordDataSource recordDataSource;

  ProductModel? productModel;
  ProductViewModel() {
    getAllProduct();
  }

  void getAllProduct() async {
    FirebaseFirestore.instance.collection(Const.productsCollection).snapshots().listen((value) async {
      productDataMap = <String, ProductModel>{}.obs;
      for (var element in value.docs) {
        productDataMap[element.id] = ProductModel.fromJson(element.data());
        element.reference.collection(Const.recordCollection).snapshots().listen((value0) {
          productRecordMap[element.id] = <ProductRecordModel>[];
          for (var element0 in value0.docs) {
            productRecordMap[element.id]?.add(ProductRecordModel.fromJson(element0.data(), element0.id));
          }
          String? allQuantity;
          var allItem = productRecordMap[element.id]?.map((e) => e.prodRecQuantity).toList();
          if (allItem!.isNotEmpty) {
            allQuantity = (productRecordMap[element.id]?.map((e) => e.prodRecQuantity).toList() ?? ["0"]).reduce((value, element) => (int.parse(value!) + int.parse(element!)).toString());
          }
          productDataMap[element.id]?.prodAllQuantity = allQuantity ?? "0";
          initProductPage(productRecordMap[element.id]!);
        });
      }
      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
      });
    });
  }

  void createProduct(ProductModel editProductModel, {withLogger = false}) {
    editProductModel.prodId = generateId(RecordType.product);
    FirebaseFirestore.instance.collection(Const.productsCollection).where('prodCode', isEqualTo: editProductModel.prodCode).get().then((value) async {
      if (value.docs.isNotEmpty) {
        Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
        return;
      }
      if (withLogger) logger(newData: editProductModel);
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).set(editProductModel.toJson());
      Get.snackbar("فحص المطاييح", '${editProductModel.toJson()} تم اضافة المطيح');
    });
  }

  void updateProduct(ProductModel editProductModel, {withLogger = false}) {
    if (withLogger) logger(oldData: productDataMap[editProductModel.prodId], newData: editProductModel);
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).update(editProductModel.toJson());
    update();
  }

  void deleteProduct({withLogger = false}) {
    if (withLogger) logger(oldData: productModel);
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel?.prodId).delete();
    productModel == null;
    update();
  }

  Future<void> saveInvInProduct(List<InvoiceRecordModel> record, invId, type) async {
    Map<String, List> allRecTotal = {};
    bool isPay = type == "pay";
    int correctQuantity = isPay ? 1 : -1;
    for (int i = 0; i < record.length; i++) {
      if (record[i].invRecId != null) {
        if (allRecTotal[record[i].invRecProduct] == null) {
          allRecTotal[record[i].invRecProduct!] = [(correctQuantity * record[i].invRecQuantity!)];
        } else {
          allRecTotal[record[i].invRecProduct]!.add((correctQuantity * record[i].invRecQuantity!));
        }
      }
    }
    allRecTotal.forEach((key, value) {
      var recCredit = value.reduce((value, element) => value + element);
      InvoiceRecordModel element = record.firstWhere((element) => element.invRecProduct == key);
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(key).collection(Const.recordCollection).doc(invId).set({
        'invId': invId,
        'prodRecId': element.invRecId,
        'prodRecProduct': key,
        'prodRecQuantity': recCredit,
        'prodRecSubTotal': element.invRecSubTotal,
        'prodRecSubVat': element.invRecVat,
        'prodRecTotal': element.invRecTotal,
        'prodType': type,
      });
    }); //prodRecSubVat
  }

  void deleteInvFromProduct(List<InvoiceRecordModel> record, invId) {
    for (var element in record) {
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.invRecProduct).collection(Const.recordCollection).doc(invId).delete();
    }
  }

  void initProductPage(List<ProductRecordModel> editedProductRecord) {
    recordDataSource = ProductRecordDataSource(productRecordModel: editedProductRecord);
  }

  String searchProductIdByName(name) {
    return productDataMap.values.toList().firstWhere((element) => element.prodName == name).prodId!;
  }

  void initGrid(value) async {
    productDataMap = <String, ProductModel>{}.obs;
    for (var element in value.docs) {
      productDataMap[element.id] = ProductModel.fromJson(element.data());
      element.reference.collection(Const.recordCollection).snapshots().listen((value0) {
        productRecordMap[element.id] = <ProductRecordModel>[];
        for (var element0 in value0.docs) {
          productRecordMap[element.id]?.add(ProductRecordModel.fromJson(element0.data(), element0.id));
        }
        String? allQuantity;
        var allItem = productRecordMap[element.id]?.map((e) => e.prodRecQuantity).toList();
        if (allItem!.isNotEmpty) {
          allQuantity = (productRecordMap[element.id]?.map((e) => e.prodRecQuantity).toList() ?? ["0"]).reduce((value, element) => (int.parse(value!) + int.parse(element!)).toString());
        }
        productDataMap[element.id]?.prodAllQuantity = allQuantity ?? "0";
        initProductPage(productRecordMap[element.id]!);
      });
    }
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      update();
    });
    // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => update());
  }
}
