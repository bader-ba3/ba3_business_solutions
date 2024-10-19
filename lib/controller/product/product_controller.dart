import 'dart:io';

import 'package:ba3_business_solutions/controller/global/changes_controller.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_controller.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/data/model/global/global_model.dart';
import 'package:ba3_business_solutions/data/model/product/product_record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/logger.dart';
import '../../data/model/invoice/invoice_record_model.dart';
import '../../data/model/product/product_model.dart';
import '../../data/model/product/product_tree.dart';
import '../../view/products/widget/product_record_data_source.dart';

class ProductController extends GetxController {
  RxMap<String, ProductModel> productDataMap = <String, ProductModel>{}.obs;
  RxMap<String, List<ProductRecordModel>> productRecordMap = <String, List<ProductRecordModel>>{}.obs;

  Map<String, List<ProductRecordModel>> prodListForSearch = {};
  late ProductRecordDataSource recordDataSource;

  ProductModel? productModel;

  getListForSearch() {}

  ProductController() {
    getAllProduct();
  }

  bool isLoadingInitAllProduct = true;

  initAllProduct() async {
    isLoadingInitAllProduct = false;
    update();
    HiveDataBase.globalModelBox.values
        .where(
      (element) => element.globalType == AppConstants.globalTypeInvoice,
    )
        .forEach(
      (global) {
        initGlobalProduct(global);
      },
    );
    isLoadingInitAllProduct = true;
    update();
  }

  List<ProductRecordModel> getAllCustomInvProduct({required String prodId, required String invType}) {
    return productRecordMap[prodId]
            ?.where(
              (element) => element.prodInvType == invType,
            )
            .toList() ??
        [];
  }

  int getQuantityProd(String prodId) {
    int quantity = 0;

    int allSales = getAllCustomInvProduct(prodId: prodId, invType: AppConstants.invoiceTypeSales)
        .map(
          (e) => int.tryParse(e.prodRecQuantity.toString()) ?? 0,
        )
        .fold(
          0,
          (previousValue, element) => element + previousValue,
        );
    int allBuy = getAllCustomInvProduct(prodId: prodId, invType: AppConstants.invoiceTypeBuy)
        .map(
          (e) => int.tryParse(e.prodRecQuantity.toString()) ?? 0,
        )
        .fold(
          0,
          (previousValue, element) => element + previousValue,
        );

    quantity = allBuy - allSales;
    return quantity;
  }

  initGlobalProduct(GlobalModel globalModel) async {
    for (int i = 0; i < globalModel.invRecords!.length; i++) {
      if (globalModel.invRecords![i].invRecId != null) {
        if (productRecordMap[globalModel.invRecords![i].invRecProduct] == null) {
          productRecordMap[globalModel.invRecords![i].invRecProduct!] = [
            ProductRecordModel(
              globalModel.invId,
              globalModel.invType,
              globalModel.invRecords![i].invRecProduct!,
              (globalModel.invRecords![i].invRecQuantity ?? 0).toString(),
              globalModel.invRecords![i].invRecId,
              globalModel.invRecords![i].invRecTotal.toString(),
              globalModel.invRecords![i].invRecSubTotal.toString(),
              globalModel.invDate,
              globalModel.invRecords![i].invRecVat.toString(),
              globalModel.invStorehouse,
              globalModel.invType,
            )
          ];
        } else {
          productRecordMap[globalModel.invRecords![i].invRecProduct!]!.add(ProductRecordModel(
            globalModel.invId,
            globalModel.invType,
            globalModel.invRecords![i].invRecProduct!,
            (globalModel.invRecords![i].invRecQuantity ?? 0).toString(),
            globalModel.invRecords![i].invRecId,
            globalModel.invRecords![i].invRecTotal.toString(),
            globalModel.invRecords![i].invRecSubTotal.toString(),
            globalModel.invDate,
            globalModel.invRecords![i].invRecVat.toString(),
            globalModel.invStorehouse,
            globalModel.invType,
          ));
        }
      }
    }
  }

  double getAvreageBuy(ProductModel productModel) {
    InvoiceController invoiceViewModel = Get.find<InvoiceController>();
    double avg = 0;
    int count = 0;
    for (ProductRecordModel element in productModel.prodRecord ?? []) {
      GlobalModel globalModel = invoiceViewModel.invoiceModel[element.invId!]!;
      count = (int.parse(element.prodRecQuantity ?? "0")) + count;
      if (globalModel.invType == AppConstants.invoiceTypeBuy) {
        avg = ((double.parse(element.prodRecSubTotal ?? "0") * int.parse(element.prodRecQuantity ?? "0")) +
                ((count - int.parse(element.prodRecQuantity ?? "0")) * avg)) /
            count;
      }
    }
    return avg;
  }

  void deleteGlobalProduct(GlobalModel globalModel) {
    globalModel.invRecords?.forEach((element) {
      productDataMap[element.invRecProduct]?.prodRecord?.removeWhere((element) => element.invId == globalModel.invId);
    });
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  List<ProductModel> searchOfProductByText(query, bool withGroup) {
    List<ProductModel> productsForSearch = [];
    query = replaceArabicNumbersWithEnglish(query);
    String query2 = '';
    String query3 = '';

    if (query.contains(" ")) {
      query3 = query.split(" ")[0];
      query2 = query.split(" ")[1];
    } else {
      query3 = query;
      query2 = query;
    }
    productsForSearch = productDataMap.values
        .where(
          (element) {
            if (HiveDataBase.getWithFree()) {
              return !(element.prodName?.startsWith("F") ?? true);
            } else {
              return true;
            }
          },
        )
        .toList()
        .where((item) {
          bool prodName = item.prodName.toString().toLowerCase().contains(query3.toLowerCase()) &&
              item.prodName.toString().toLowerCase().contains(query2.toLowerCase());
          bool prodCode = item.prodFullCode.toString().toLowerCase().contains(query.toLowerCase());
          bool prodBarcode = item.prodBarcode.toString().toLowerCase().contains(query.toLowerCase());
          return (prodName || prodCode || prodBarcode) && item.prodIsGroup == withGroup;
        })
        .toList();

    return productsForSearch.toList();
  }

  void getAllProduct() async {
    if (HiveDataBase.productModelBox.values.isEmpty) {
      print("THE PRODUCT IS READ FROM FIREBASE");
      FirebaseFirestore.instance.collection(AppConstants.productsCollection).get().then((value) async {
        productDataMap.clear();
        for (var element in value.docs) {
          HiveDataBase.productModelBox.put(element.id, ProductModel.fromJson(element.data()));
          productDataMap[element.id] = ProductModel.fromJson(element.data());
        }

        update();
        initModel();
        initPage();
        go(lastIndex);
      });
    } else {
      for (var element in HiveDataBase.productModelBox.values.toList()) {
        productDataMap[element.prodId!] = element;
      }
      if (HiveDataBase.isFree.get("isFree")!) {
        productDataMap = Map.fromEntries(productDataMap.entries
                .where(
                  (element) => element.value.prodIsLocal ?? false,
                )
                .toList())
            .obs;
      }
      update();
      initModel();
      initPage();
      go(lastIndex);
    }
  }

  String getNextProductCode({String? perantId}) {
    int code = 0;
    if (productDataMap.isEmpty) {
      return "00";
    }
    if (perantId != null) {
      List<String?>? childIds = productDataMap[perantId]?.prodChild?.map((e) => productDataMap[e]?.prodCode).toList();
      if (childIds != null && childIds.isNotEmpty) {
        return (int.parse(childIds.last!) + 1).toString().padLeft(productDataMap[perantId]!.prodGroupPad ?? 2, "0");
      } else {
        return "0".padLeft(productDataMap[perantId]!.prodGroupPad ?? 2, "0");
      }
    } else {
      List<String?>? parentIds = productDataMap.values.toList().where((element) => element.prodIsParent!).map((e) => e.prodCode).toList();
      if (parentIds.isNotEmpty) {
        return ((int.tryParse(parentIds.last!) ?? 0) + 1).toString().padLeft(2, "0");
      }
    }
    return code.toString();
  }

  int padNumber = 1;

  String getFullCodeOfProduct(String accID) {
    if (productDataMap[accID]!.prodIsParent!) {
      String code = productDataMap[accID]!.prodCode!.padLeft(padNumber, "0");
      return code;
    } else {
      int? pad = productDataMap[productDataMap[accID]!.prodParentId!]!.prodGroupPad;
      String code = productDataMap[accID]!.prodCode!.padLeft(pad ?? padNumber, "0");
      var perCode = getFullCodeOfProduct(productDataMap[accID]!.prodParentId!);
      return perCode + code;
    }
  }

  void createProduct(ProductModel editProductModel, {withLogger = false}) async {
    var fullCode = '';
    if (editProductModel.prodParentId == null) {
      fullCode = editProductModel.prodCode!;
    } else {
      fullCode = productDataMap[editProductModel.prodParentId]!.prodFullCode! +
          editProductModel.prodCode!.padLeft(productDataMap[editProductModel.prodParentId]!.prodGroupPad ?? padNumber, "0");
    }
    ProductModel? productModel = productDataMap.values.toList().firstWhereOrNull((element) => element.prodFullCode == fullCode);
    if (productModel != null) {
      Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
      return;
    }
    editProductModel.prodFullCode = fullCode;
    editProductModel.prodId = generateId(RecordType.product);
    editProductModel.prodIsGroup ??= false;
    ChangesController changesViewModel = Get.find<ChangesController>();

    if (editProductModel.prodParentId == null) {
      editProductModel.prodIsParent = true;
    } else {
      FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });
      if (productDataMap[editProductModel.prodParentId]?.prodChild == null) {
        productDataMap[editProductModel.prodParentId]?.prodChild = [editProductModel.prodId];
        HiveDataBase.productModelBox
            .put(editProductModel.prodParentId, getProductModelFromId(editProductModel.prodParentId)!..prodChild = [editProductModel.prodId]);
      } else {
        HiveDataBase.productModelBox
            .put(editProductModel.prodParentId, getProductModelFromId(editProductModel.prodParentId)!..prodChild!.add(editProductModel.prodId));
        productDataMap[editProductModel.prodParentId]?.prodChild?.add(editProductModel.prodId);
      }
      changesViewModel.addChangeToChanges(productDataMap[editProductModel.prodParentId]!.toFullJson(), AppConstants.productsCollection);
      editProductModel.prodIsParent = false;
    }
    if (withLogger) logger(newData: editProductModel);
    await FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(editProductModel.prodId).set(editProductModel.toJson());
    HiveDataBase.productModelBox.put(editProductModel.prodId, editProductModel);
    changesViewModel.addChangeToChanges(editProductModel.toFullJson(), AppConstants.productsCollection);
    Get.snackbar("فحص المطاييح", ' تم اضافة المطيح');
  }

  addProductToMemory(Map json) {
    print("addProductToMemory");
    ProductModel productModel = ProductModel.fromJson(json);
    List<ProductRecordModel> oldDate = [];
    if (productDataMap[productModel.prodId!] != null) {
      oldDate = productDataMap[productModel.prodId!]!.prodRecord!;
    }
    productModel.prodRecord = oldDate;
    productDataMap[productModel.prodId!] = productModel;
    HiveDataBase.productModelBox.put(productModel.prodId, productModel);
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  updateProduct(ProductModel editProductModel, {withLogger = false}) async {
    ChangesController changesViewModel = Get.find<ChangesController>();
    editProductModel.prodRecord = [];
    var fullCode = '';
    if (editProductModel.prodParentId == null) {
      fullCode = editProductModel.prodCode!;
    } else {
      fullCode = productDataMap[editProductModel.prodParentId]!.prodFullCode! +
          editProductModel.prodCode!.padLeft(productDataMap[editProductModel.prodParentId]!.prodGroupPad ?? padNumber, "0");
    }
    ProductModel? productModel = productDataMap.values.toList().firstWhereOrNull((element) => element.prodFullCode == fullCode);
    if (productModel != null && editProductModel.prodId != productModel.prodId) {
      Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
      return;
    }
    editProductModel.prodFullCode = fullCode;
    if (withLogger) {
      logger(oldData: productDataMap[editProductModel.prodId], newData: editProductModel);
    }
    editProductModel.prodIsGroup ??= false;
    if (editProductModel.prodParentId == null) {
      editProductModel.prodIsParent = true;
    } else {
      await FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });

      if (productDataMap[editProductModel.prodParentId]?.prodChild == null) {
        productDataMap[editProductModel.prodParentId]?.prodChild = [editProductModel.prodId];
        await HiveDataBase.productModelBox
            .put(editProductModel.prodParentId, getProductModelFromId(editProductModel.prodParentId)!..prodChild = [editProductModel.prodId]);
      } else {
        productDataMap[editProductModel.prodParentId]?.prodChild?.add(editProductModel.prodId);
        await HiveDataBase.productModelBox
            .put(editProductModel.prodParentId, getProductModelFromId(editProductModel.prodParentId)!..prodChild!.add(editProductModel.prodId));
      }
      changesViewModel.addChangeToChanges(productDataMap[editProductModel.prodParentId]!.toFullJson(), AppConstants.productsCollection);
      editProductModel.prodIsParent = false;
    }
    await FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(editProductModel.prodId).update(editProductModel.toJson());
    await HiveDataBase.productModelBox.put(editProductModel.prodId, editProductModel);

    changesViewModel.addChangeToChanges(editProductModel.toFullJson(), AppConstants.productsCollection);
    update();
  }

  int getCountOfProduct(ProductModel productModel) {
    List<ProductRecordModel> allRec = [];

    allRec.addAll(productModel.prodRecord ?? []);
    productModel.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord ?? []);
    });
    if (allRec.isEmpty) return 0;
    int _ = allRec.map((e) => int.parse(e.prodRecQuantity!)).toList().reduce((value, element) => value + element);
    return _;
  }

  Future<void> deleteProduct({withLogger = false}) async {
    if (withLogger) logger(oldData: productModel);
    if (productModel?.prodParentId != null) {
      await FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(productModel!.prodParentId).update({
        'prodChild': FieldValue.arrayRemove([productModel!.prodId]),
      });
    }
    FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(productModel?.prodId).delete();
    ChangesController changesViewModel = Get.find<ChangesController>();
    changesViewModel.addRemoveChangeToChanges(productModel!.toFullJson(), AppConstants.productsCollection);
    productModel == null;

    update();
  }

  void removeProductFromMemory(Map json) {
    ProductModel productModel = ProductModel.fromJson(json);
    if (productModel.prodParentId != null) {
      productDataMap[productModel.prodParentId]?.prodChild?.remove(productModel.prodId);
      HiveDataBase.productModelBox.put(productModel.prodParentId, productDataMap[productModel.prodParentId]!);
    }
    productDataMap.remove(productModel.prodId);
    HiveDataBase.productModelBox.delete(productModel.prodId);
    update();
    initModel();
    initPage();
    go(lastIndex);
  }

  void initProductPage(ProductModel editedProduct) {
    recordDataSource = ProductRecordDataSource(productModel: editedProduct);
  }

  String searchProductIdByName(name) {
    return productDataMap.values.toList().firstWhere((element) => element.prodName == name).prodId!;
  }

  String? editItem;
  TextEditingController? editCon;

  String? lastIndex;

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
    element.prodChild?.removeWhere((e) => productDataMap[e] == null);
    var list = element.prodChild?.map((e) => addToModel(productDataMap[e]!)).toList();

    productDataMap[element.prodId]?.prodFullCode = getFullCodeOfProduct(element.prodId!);
    ProductTree model = ProductTree.fromJson({"name": element.prodName}, element.prodId, list ?? []);
    return model;
  }

  initPage() {
    treeController = TreeController<ProductTree>(
      roots: allProductTree,
      childrenProvider: (ProductTree node) => node.list,
    );
    update();
  }

  void setupParentList(String parent) {
    allPer.add(productDataMap[parent]!.prodId);
    if (productDataMap[parent]!.prodParentId != null) {
      setupParentList(productDataMap[parent]!.prodParentId!);
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
    FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(editItem).update({
      "prodName": editCon?.text,
    });
    editItem = null;
    update();
  }

  Future<void> exportProduct(String? oldKey) async {
    List<List> data = [
      ["اسم المادة", "الفاتورة", "العدد", "التاريخ"]
    ];
    List<ProductRecordModel> allRec = [];
    ProductModel _ = productDataMap[oldKey]!;
    allRec.addAll(_.prodRecord ?? []);
    _.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord ?? []);
    });
    for (var value in allRec) {
      data.add([getProductNameFromId(value.prodRecProduct), value.prodType, value.prodRecQuantity, value.prodRecDate]);
    }
    String csv = const ListToCsvConverter().convert(data);
    String? saveData;
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      saveData = await FilePicker.platform.saveFile(fileName: "${getProductNameFromId(oldKey)} ${DateTime.now().toString().split(" ")[0]}.csv");
    } else {
      Directory documents = await getApplicationDocumentsDirectory();
      saveData = ("${documents.path}/${getProductNameFromId(oldKey)} ${DateTime.now().toString().split(" ")[0]}.csv");
    }

    if (saveData != null) {
      File file = File(saveData);
      file.writeAsString(csv).then((File file) {
        print('CSV file created: ${file.absolute.path}');
      }).catchError((e) {
        print('Error: $e');
      });
    }
  }

  void createFolderDialog() {
    var nameCon = TextEditingController();
    String? prodParentId;
    String? rootName;
    List<String> rootFolder =
        productDataMap.values.toList().where((element) => element.prodIsParent! && element.prodIsGroup!).map((e) => e.prodId!).toList();
    Map<String, List<String>> allParent = {};
    Map<String, String> dropDownList = {};
    Get.defaultDialog(
        title: "اختر الطريق",
        content: SizedBox(
          height: Get.height / 2,
          width: Get.height / 2,
          child: StatefulBuilder(builder: (context, setstate) {
            return ListView(
              children: [
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: TextFormField(
                    controller: nameCon,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton(
                    value: rootName,
                    items: rootFolder.map((e) => DropdownMenuItem(value: e, child: Text(getProductNameFromId(e)))).toList(),
                    onChanged: (_) {
                      prodParentId = _;
                      rootName = _;
                      Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId == _ && element.prodIsGroup!);
                      if (a.isNotEmpty) {
                        allParent[_!] = a.toList().map((e) => e.prodId!).toList();
                      }
                      setstate(() {});
                    }),
                for (List<String> element in allParent.values)
                  DropdownButton(
                      value: dropDownList[element.toString()],
                      items: element.map((e) => DropdownMenuItem(value: e, child: Text(getProductNameFromId(e)))).toList(),
                      onChanged: (_) {
                        prodParentId = _;
                        dropDownList[element.toString()] = _!;
                        Iterable<ProductModel> a =
                            productDataMap.values.toList().where((element) => element.prodParentId == _ && element.prodIsGroup!);
                        if (a.isNotEmpty) {
                          allParent[_] = a.toList().map((e) => e.prodId!).toList();
                        }
                        setstate(() {});
                      }),
              ],
            );
          }),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                addFolder(nameCon.text, prodParentId: prodParentId);
                Get.back();
              },
              child: const Text("إضافة")),
          ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("إلغاء")),
        ]);
  }

  void addFolder(name, {String? prodParentId}) {
    int code = 0;
    if (prodParentId == null) {
      code = productDataMap.values.toList().where((element) => element.prodIsParent!).map((e) => (int.tryParse(e.prodCode!) ?? 0)).toList().last + 1;
    } else {
      Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId == prodParentId);
      if (a.isNotEmpty) {
        code = a.map((e) => int.parse(e.prodCode!)).toList().last + 1;
      }
    }
    var prodModel = ProductModel(
        prodIsGroup: true,
        prodIsParent: prodParentId == null,
        prodParentId: prodParentId,
        prodName: name,
        prodCode: code.toString(),
        prodId: generateId(RecordType.product));
    if (prodParentId != null) {
      FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc(prodParentId).update({
        'prodChild': FieldValue.arrayUnion([prodModel.prodId]),
      });
    }
    productDataMap[prodParentId]!.prodChild!.add(prodModel.prodId);
    FirebaseFirestore.instance.collection(AppConstants.productsCollection).doc().set(prodModel.toJson());
    HiveDataBase.productModelBox.put(prodModel.prodId, prodModel);
    HiveDataBase.productModelBox.put(prodParentId, productDataMap[prodParentId]!);
  }
}

String getProductIdFromFullName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductController>()
            .productDataMap
            .values
            .toList()
            .cast<ProductModel?>()
            .firstWhereOrNull((element) => element?.prodFullCode == name)
            ?.prodId ??
        "";
  } else {
    return "";
  }
}

String? getProductIdFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductController>()
        .productDataMap
        .values
        .toList()
        .cast<ProductModel?>()
        .firstWhereOrNull((element) => element?.prodName == name || element?.prodCode == name)
        ?.prodId;
  } else {
    return null;
  }
}

List<ProductModel>? getProductsModelFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductController>()
        .productDataMap
        .values
        .toList()
        .where((element) =>
            !element.prodIsGroup! &&
            (element.prodName!.toLowerCase().contains(name.toLowerCase()) ||
                element.prodFullCode!.toLowerCase().contains(name.toLowerCase()) ||
                element.prodBarcode!.toLowerCase().contains(name.toLowerCase())))
        .toList();
  }
  return null;
}

ProductModel? getProductModelFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductController>()
        .productDataMap
        .values
        .toList()
        .where((element) =>
            !element.prodIsGroup! &&
            (element.prodName!.toLowerCase().contains(name.toLowerCase()) ||
                element.prodFullCode!.toLowerCase().contains(name.toLowerCase()) ||
                element.prodBarcode!.toLowerCase().contains(name.toLowerCase())))
        .firstOrNull;
  }
  return null;
}

String getProductNameFromId(id) {
  if (id != null && id != " " && id != "") {
    if (Get.find<ProductController>().productDataMap[id] == null) {
      return "";
    }
    return Get.find<ProductController>().productDataMap[id]!.prodName!;
  } else {
    return "";
  }
}

String getProductBarcodeFromId(id) {
  if (id != null && id != " " && id != "") {
    if (Get.find<ProductController>().productDataMap[id] == null) {
      return "0";
    }
    return Get.find<ProductController>().productDataMap[id]!.prodBarcode!;
  } else {
    return "0";
  }
}

ProductModel? getProductModelFromId(id) {
  if (id.runtimeType == InvoiceRecordModel) {
    return Get.find<ProductController>().productDataMap[(id as InvoiceRecordModel).invRecProduct!];
  } else if (id != null && id != " " && id != "") {
    if (Get.find<ProductController>().productDataMap[id] == null) {
      return null;
    }
    return Get.find<ProductController>().productDataMap[id]!;
  } else {
    return null;
  }
}

String replaceArabicNumbersWithEnglish(String input) {
  return input.replaceAllMapped(RegExp(r'[٠-٩]'), (Match match) {
    return String.fromCharCode(match.group(0)!.codeUnitAt(0) - 0x0660 + 0x0030);
  });
}
