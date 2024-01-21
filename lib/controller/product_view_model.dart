import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ba3_business_solutions/model/product_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import '../Const/const.dart';
import '../model/invoice_record_model.dart';
import '../model/product_model.dart';
import '../model/product_tree.dart';
import '../utils/logger.dart';
import '../view/products/widget/product_record_data_source.dart';

class ProductViewModel extends GetxController {
  // RxMap<String, List<ProductRecordModel>> productRecordMap = <String, List<ProductRecordModel>>{}.obs;
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
          // productRecordMap[element.id] = <ProductRecordModel>[];
          List<ProductRecordModel> _=[];
          for (var element0 in value0.docs) {
            _.add(ProductRecordModel.fromJson(element0.data(), element0.id));
          }
          productDataMap[element.id]?.prodRecord=_;
          String? allQuantity;
          var allItem = productDataMap[element.id]?.prodRecord?.map((e) => e.prodRecQuantity).toList();
          if (allItem!.isNotEmpty) {
            allQuantity = (productDataMap[element.id]?.prodRecord?.map((e) => e.prodRecQuantity).toList() ?? ["0"]).reduce((value, element) => (int.parse(value!) + int.parse(element!)).toString());
          }
          productDataMap[element.id]?.prodAllQuantity = allQuantity ?? "0";
          initProductPage(productDataMap[element.id]!);
        });
      }
      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
        initModel();
        initPage();
        go(lastIndex);
      });
    });
  }

  void createProduct(ProductModel editProductModel, {withLogger = false}) {
    editProductModel.prodId = generateId(RecordType.product);
    if(editProductModel.prodParentId==null){
      editProductModel.prodIsParent=true;
    }else{
      print(editProductModel.prodParentId);
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });
      editProductModel.prodIsParent=false;
    }
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
    if(editProductModel.prodParentId==null){
      editProductModel.prodIsParent=true;
    }else{
      print(editProductModel.prodParentId);
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });
      editProductModel.prodIsParent=false;
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).update(editProductModel.toJson());
    update();
  }

  Future<void> deleteProduct({withLogger = false}) async {
    if (withLogger) logger(oldData: productModel);
    if (productModel?.prodParentId != null) {
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel!.prodParentId).update({
        'prodChild': FieldValue.arrayRemove([productModel!.prodId]),
      });
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel?.prodId).delete();
    productModel == null;
    update();
  }

  Future<void> saveInvInProduct(List<InvoiceRecordModel> record, invId, type,date) async {
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
      bool isStoreProduct= getProductModelFromId(key)!.prodType==Const.productTypeStore;
      InvoiceRecordModel element = record.firstWhere((element) => element.invRecProduct == key);
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(key).collection(Const.recordCollection).doc(invId).set({
        'invId': invId,
        'prodRecId': element.invRecId,
        'prodRecProduct': key,
        'prodRecQuantity': isStoreProduct?recCredit:0,
        'prodRecSubTotal': element.invRecSubTotal,
        'prodRecSubVat': element.invRecVat,
        'prodRecTotal': element.invRecTotal,
        'prodType': type,
        'prodRecDate': date,
      });
    }); //prodRecSubVat
  }

  void deleteInvFromProduct(List<InvoiceRecordModel> record, invId) {
    for (var element in record) {
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.invRecProduct).collection(Const.recordCollection).doc(invId).delete();
    }
  }

  void initProductPage(ProductModel editedProduct) {
    recordDataSource = ProductRecordDataSource(productModel: editedProduct);
  }

  String searchProductIdByName(name) {
    return productDataMap.values.toList().firstWhere((element) => element.prodName == name).prodId!;
  }

  // void initGrid(value) async {
  //   productDataMap = <String, ProductModel>{}.obs;
  //   for (var element in value.docs) {
  //     productDataMap[element.id] = ProductModel.fromJson(element.data());
  //     element.reference.collection(Const.recordCollection).snapshots().listen((value0) {
  //       productRecordMap[element.id] = <ProductRecordModel>[];
  //       for (var element0 in value0.docs) {
  //         productRecordMap[element.id]?.add(ProductRecordModel.fromJson(element0.data(), element0.id));
  //       }
  //       String? allQuantity;
  //       var allItem = productRecordMap[element.id]?.map((e) => e.prodRecQuantity).toList();
  //       if (allItem!.isNotEmpty) {
  //         allQuantity = (productRecordMap[element.id]?.map((e) => e.prodRecQuantity).toList() ?? ["0"]).reduce((value, element) => (int.parse(value!) + int.parse(element!)).toString());
  //       }
  //       productDataMap[element.id]?.prodAllQuantity = allQuantity ?? "0";
  //       initProductPage(productRecordMap[element.id]!);
  //     });
  //   }
  //   WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
  //     update();
  //   });
  //   // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => update());
  // }


  //--=-=-==-==--=-=-=-==-==-=-=-=-=-=-=-=-=-=-=-=-=--=-=-==-=-=--=-

  String? editItem;
  TextEditingController? editCon;

  var lastIndex;

  List<ProductTree> allProductTree = [];

  TreeController<ProductTree>? treeController;

  void initModel() {
    allProductTree.clear();
    List<ProductModel> rootList = productDataMap.values.toList().where((element) => element.prodIsParent ?? false).toList();
    for (var element in rootList) {
      allProductTree.add(addToModel(element));
    }
  }

  ProductTree addToModel(ProductModel element) {
    var list = element.prodChild?.map((e) => addToModel(productDataMap[e]!)).toList();
    ProductTree model = ProductTree.fromJson({"name": element.prodName}, element.prodId, list??[]);
    return model;
  }

  initPage() {
    treeController = TreeController<ProductTree>(
      roots: allProductTree,
      childrenProvider: (ProductTree node) => node.list,
    );
    update();
  }

  void setupParentList(parent) {
    allPer.add(productDataMap[parent]!.prodId);
    if (productDataMap[parent]!.prodParentId != null) {
      setupParentList(productDataMap[parent]!.prodIsParent);
    }
  }


  var allPer = [];
  void go(String? parent) {
    if (parent != null) {
      allPer.clear();
      setupParentList(parent);
      var allper = allPer.reversed.toList();
      List<ProductTree> _ = treeController!.roots.toList();
      for (var i = 0; i < allper.length; i++) {
        if (_.isNotEmpty) {
          treeController?.expand(_.firstWhere((element) => element.id == allper[i]));
          _ = _.firstWhereOrNull((element) => element.id == allper[i])?.list ?? [];
        }
      }
    }
  }
  void startRenameChild(String? id) {
    editItem = id;
    editCon = TextEditingController(text: productDataMap[id]!.prodName!);
    update();
  }

  void endRenameChild() {
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editItem).update({
      "prodName": editCon?.text,
    });
    editItem = null;
    update();
  }
  Future<void> exportProduct(String? oldKey) async {
    List<List> data=[["اسم المادة","الفاتورة","العدد","التاريخ"]];
    List<ProductRecordModel> allRec=[];
    ProductModel _= productDataMap[oldKey]!;
    allRec.addAll(_.prodRecord??[]);
    _.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord??[]);
    });
    allRec.forEach((ProductRecordModel value) {
      data.add([getProductNameFromId(value.prodRecProduct),value.prodType,value.prodRecQuantity,value.prodRecDate]);
    });
    String csv = const ListToCsvConverter().convert(data);
    String? saveData;
    if(defaultTargetPlatform!=TargetPlatform.iOS){
      saveData= await FilePicker.platform.saveFile(
          fileName:getProductNameFromId(oldKey)+" "+DateTime.now().toString().split(" ")[0]+".csv"
      );
    }else{
      Directory documents = await getApplicationDocumentsDirectory();
      saveData = (documents.path+"/"+getProductNameFromId(oldKey)+" "+DateTime.now().toString().split(" ")[0]+".csv");
    }

    if(saveData!=null){
      File file = File(saveData);
      file.writeAsString(csv).then((File file) {
        print('CSV file created: ${file.absolute.path}');
      }).catchError((e) {
        print('Error: $e');
      });
    }

  }
}

String getProductNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<ProductViewModel>().productDataMap[id]!.prodName!;
  } else {
    return "";
  }}
ProductModel? getProductModelFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<ProductViewModel>().productDataMap[id]!;
  } else {
    return null;
  }}
