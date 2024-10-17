import 'dart:io';

import 'package:ba3_business_solutions/controller/global/changes_controller.dart';
import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/data/model/global/global_model.dart';
import 'package:ba3_business_solutions/data/model/store/store_model.dart';
import 'package:ba3_business_solutions/view/stores/widgets/store_data_grid_source_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/model/store/store_record_model.dart';

class StoreController extends GetxController {
  final CollectionReference _storeCollectionRef = FirebaseFirestore.instance.collection(AppConstants.storeCollection);

  RxMap<String, StoreModel> storeMap = <String, StoreModel>{}.obs;

  bool isAscending = true;

  DataGridController storeDataGridController = DataGridController();

  StoreModel? editStoreModel;

  var nameController = TextEditingController();
  var codeController = TextEditingController();

  StoreController() {
    getAllStore();
  }

  initStore([String? key]) {
    if (key == null) {
      nameController.clear();
      codeController.clear();
      editStoreModel = StoreModel();
    } else {
      editStoreModel = StoreModel.fromJson(storeMap[key]!.toFullJson());
      nameController.text = editStoreModel?.stName ?? "";
      codeController.text = editStoreModel?.stCode ?? "";
    }
  }

  String? openedStore;
  StoreDataGridSourceWidget? storeDataGridSource;

  void initGlobalStore(GlobalModel globalModel) {
    Map<String, StoreRecProductModel> allRecTotal = {};
    Map<String, StoreRecProductModel> allRecTotal2 = {};

    if (globalModel.invType != AppConstants.invoiceTypeChange) {
      bool isPay = globalModel.invType == AppConstants.invoiceTypeBuy || globalModel.invType == AppConstants.invoiceTypeAdd;
      int correctQuantity = isPay ? 1 : -1;
      Map<String, int> allRecTotalProduct = {};

      for (int i = 0; i < globalModel.invRecords!.length; i++) {
        if (globalModel.invRecords![i].invRecId != null) {
          if (allRecTotalProduct[globalModel.invRecords![i].invRecProduct] == null) {
            allRecTotalProduct[globalModel.invRecords![i].invRecProduct!] = ((globalModel.invRecords![i].invRecQuantity ?? 1));
          } else {
            allRecTotalProduct[globalModel.invRecords![i].invRecProduct!] =
                ((globalModel.invRecords![i].invRecQuantity ?? 1)) + allRecTotalProduct[globalModel.invRecords![i].invRecProduct!]!;
          }
        }
      }

      allRecTotalProduct.forEach((key, value) {
        var recCredit = value;
        if (getProductModelFromId(key) != null) {
          // bool isStoreProduct = getProductModelFromId(key)!.prodType == Const.productTypeStore;
          // InvoiceRecordModel element = globalModel.invRecords!.firstWhere((element) => element.invRecProduct == key);
          allRecTotal[key] = (StoreRecProductModel(
            storeRecProductId: key,
            storeRecProductPrice: "0",
            storeRecProductQuantity: (correctQuantity * recCredit).toString(),
            storeRecProductTotal: "0",
          ));
        }
      });

      StoreRecordModel model =
          StoreRecordModel(storeRecId: globalModel.invStorehouse, storeRecInvId: globalModel.invId, storeRecProduct: allRecTotal);
      if (storeMap[model.storeRecId]?.stRecords == null) {
        storeMap[model.storeRecId]?.stRecords = [model];
      } else {
        storeMap[model.storeRecId]?.stRecords.removeWhere((element) => element.storeRecInvId == globalModel.invId);
        storeMap[model.storeRecId]?.stRecords.add(model);
      }
    } else {
      for (int i = 0; i < globalModel.invRecords!.length; i++) {
        if (globalModel.invRecords![i].invRecId != null && getProductModelFromId(globalModel.invRecords![i].invRecProduct) != null) {
          bool isStoreProduct = getProductModelFromId(globalModel.invRecords![i].invRecProduct)!.prodType == AppConstants.productTypeStore;
          if (isStoreProduct) {
            allRecTotal[globalModel.invRecords![i].invRecProduct!] = StoreRecProductModel(
              storeRecProductId: globalModel.invRecords![i].invRecProduct,
              storeRecProductPrice: globalModel.invRecords![i].invRecSubTotal.toString(),
              storeRecProductQuantity: (-1 * globalModel.invRecords![i].invRecQuantity!).toString(),
              storeRecProductTotal: globalModel.invRecords![i].invRecTotal.toString(),
            );
            allRecTotal2[globalModel.invRecords![i].invRecProduct!] = StoreRecProductModel(
              storeRecProductId: globalModel.invRecords![i].invRecProduct,
              storeRecProductPrice: globalModel.invRecords![i].invRecSubTotal.toString(),
              storeRecProductQuantity: (1 * globalModel.invRecords![i].invRecQuantity!).toString(),
              storeRecProductTotal: globalModel.invRecords![i].invRecTotal.toString(),
            );
          }
        }
      }

      StoreRecordModel model =
          StoreRecordModel(storeRecId: globalModel.invStorehouse, storeRecInvId: globalModel.invId, storeRecProduct: allRecTotal);
      StoreRecordModel model2 =
          StoreRecordModel(storeRecId: globalModel.invSecStorehouse, storeRecInvId: globalModel.invId, storeRecProduct: allRecTotal2);

      if (storeMap[model.storeRecId]?.stRecords == null) {
        storeMap[model.storeRecId]?.stRecords = [model];
      } else {
        storeMap[model.storeRecId]?.stRecords.removeWhere((element) => element.storeRecInvId == globalModel.invId);
        storeMap[model.storeRecId]?.stRecords.add(model);
      }
      // if(globalModel.invSecStorehouse==null){
      // print(globalModel.toJson());
      //   HiveDataBase.globalModelBox.delete(globalModel.bondId);
      // }
      print("-----${model2.storeRecId}-------");
      print("-----${globalModel.invId}-------");
      print("-----${globalModel.entryBondId}-------");
      print("-----${globalModel.entryBondCode}-------");
      print("-----${globalModel.entryBondCode}-------");
      print("-----${globalModel.bondCode}-------");
      print("-----${globalModel.invFullCode}-------");
      print("-----${globalModel.invCode}-------");
      print("-----${globalModel.invSecStorehouse}-------");
      print("-----${globalModel.invStorehouse}-------");
      //todo:عدلتا لانو كان عم يطلع null
      model2.storeRecId ??= globalModel.invStorehouse;
      if (storeMap[model2.storeRecId.toString()]?.stRecords == null) {
        storeMap[model2.storeRecId]?.stRecords = [model2];
      } else {
        storeMap[model2.storeRecId]?.stRecords.removeWhere((element) => element.storeRecInvId == globalModel.invId);
        storeMap[model2.storeRecId]?.stRecords.add(model2);
      }
    }
    if (openedStore != null) {
      initStorePage(openedStore);
    }
  }

  void deleteGlobalStore(GlobalModel globalModel) {
    storeMap[globalModel.invStorehouse]?.stRecords.removeWhere((element) => element.storeRecInvId == globalModel.invId);
  }

  addStoreToMemory(Map json) {
    StoreModel storeModel = StoreModel.fromJson(json);
    storeMap[storeModel.stId!] = storeModel;
    HiveDataBase.storeModelBox.put(storeModel.stId, storeModel);
    storeDataGridSource = StoreDataGridSourceWidget(stores: storeMap);
    update();
  }

  void removeStoreFromMemory(Map json) {
    StoreModel storeModel = StoreModel.fromJson(json);
    storeMap.remove(storeModel.stId);
    HiveDataBase.accountModelBox.delete(storeModel.stId);
    storeDataGridSource = StoreDataGridSourceWidget(stores: storeMap);
    update();
  }

  getAllStore() {
    if (HiveDataBase.storeModelBox.isEmpty) {
      FirebaseFirestore.instance.collection(AppConstants.storeCollection).get().then((value) {
        storeMap.clear();
        HiveDataBase.storeModelBox.clear();
        for (var element in value.docs) {
          HiveDataBase.storeModelBox.put(element.id, StoreModel.fromJson(element.data()));
          storeMap[element.id] = StoreModel.fromJson(element.data());
        }
        storeDataGridSource = StoreDataGridSourceWidget(stores: storeMap);
        update();
      });
    } else {
      storeMap.clear();
      for (StoreModel element in HiveDataBase.storeModelBox.values.toList()) {
        storeMap[element.stId!] = element;
      }
      storeDataGridSource = StoreDataGridSourceWidget(stores: storeMap);
      update();
    }
  }

  Map<String, double> totalAmountPage = {};
  Map<String, StoreRecordView> allData = {};

  initStorePage(storeId) {
    totalAmountPage.clear();
    storeMap[storeId]?.stRecords.forEach((value) {
      value.storeRecProduct?.forEach((key, value) {
        totalAmountPage[value.storeRecProductId!] = (totalAmountPage[value.storeRecProductId!] ?? 0) + double.parse(value.storeRecProductQuantity!);
      });
    });
    totalAmountPage.forEach(
      (key, value) {
        allData[key] = StoreRecordView(
          productId: key.toString(),
          total: value.toString(),
        );
      },
    );
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => update());
  }

  addNewStore() {
    List<StoreModel> _ = storeMap.values.toList().where((element) => element.stCode == editStoreModel!.stCode).toList();
    if (_.isNotEmpty) {
      Get.snackbar("خطأ", "الرمز مستخدم");
      return;
    }
    editStoreModel?.stId = generateId(RecordType.store);
    _storeCollectionRef.doc(editStoreModel?.stId).set(editStoreModel?.toJson());
    ChangesController changesViewModel = Get.find<ChangesController>();

    changesViewModel.addChangeToChanges(editStoreModel!.toFullJson(), AppConstants.storeCollection);
    update();
  }

  editStore() {
    _storeCollectionRef.doc(editStoreModel?.stId).set(editStoreModel?.toJson());
    ChangesController changesViewModel = Get.find<ChangesController>();

    changesViewModel.addChangeToChanges(editStoreModel!.toFullJson(), AppConstants.storeCollection);
    update();
  }

  clearController() {
    editStoreModel = null;
    update();
  }

  // getNewCode() {
  //   int maxCode = 1;
  //   if (storeMap.isNotEmpty) {
  //     for (var element in storeMap.values) {
  //       int.parse(element.stCode!) > maxCode ? maxCode = int.parse(element.stCode!) : maxCode = maxCode;
  //     }
  //   }

  //   editStoreModel?.stCode = (maxCode + 1).toString();
  // }

  deleteStore(id) {
    StoreModel editStoreModel = storeMap[id]!;
    _storeCollectionRef.doc(editStoreModel.stId).delete();
    ChangesController changesViewModel = Get.find<ChangesController>();

    changesViewModel.addRemoveChangeToChanges(editStoreModel.toFullJson(), AppConstants.storeCollection);
    update();
  }

  // void saveInvInStore(List<InvoiceRecordModel> record, String? invId, String? invType, String? storeId) {
  //   Map<String, StoreRecProductModel> allRecTotal = {};
  //   bool isPay = invType == Const.invoiceTypeBuy;
  //   int correctQuantity = isPay ? 1 : -1;
  //   for (int i = 0; i < record.length; i++) {
  //     if (record[i].invRecId != null) {
  //       bool isStoreProduct= getProductModelFromId(record[i].invRecProduct)!.prodType==Const.productTypeStore;
  //       if(isStoreProduct) {
  //         allRecTotal[record[i].invRecProduct!] = StoreRecProductModel(
  //           storeRecProductId: record[i].invRecProduct,
  //           storeRecProductPrice: record[i].invRecSubTotal.toString(),
  //           storeRecProductQuantity: (correctQuantity * record[i].invRecQuantity!).toString(),
  //           storeRecProductTotal: record[i].invRecTotal.toString(),
  //         );
  //       }
  //     }
  //   }
  //   FirebaseFirestore.instance.collection(Const.storeCollection).doc(storeId).collection(Const.recordCollection).doc(invId).set(StoreRecordModel(
  //       storeRecId:storeId,
  //       storeRecInvId:invId,
  //       storeRecProduct:allRecTotal
  //   ).toJson());
  // }

  // void deleteRecord({required String storeId, String? invId}) {
  //     FirebaseFirestore.instance.collection(Const.storeCollection).doc(storeId).collection(Const.recordCollection).doc(invId).delete();
  // }

  Future<void> exportStore(String? oldKey) async {
    List<List> data = [
      ["اسم المادة", "العدد"]
    ];
    totalAmountPage.forEach((key, value) {
      data.add([getProductNameFromId(key), value.toString()]);
    });
    String csv = const ListToCsvConverter().convert(data);
    String? saveData = await FilePicker.platform.saveFile(fileName: "${getStoreNameFromId(oldKey)} ${DateTime.now().toString().split(" ")[0]}.csv");

    if (saveData != null) {
      File file = File(saveData);
      file.writeAsString(csv).then((File file) {
        print('CSV file created: ${file.absolute.path}');
      }).catchError((e) {
        print('Error: $e');
      });
    }
  }
}

String getStoreIdFromText(text) {
  var storeController = Get.find<StoreController>();
  if (text != null && text != " " && text != "") {
    return storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == text)?.stId ?? "";
  } else {
    return "";
  }
}

String getStoreNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<StoreController>().storeMap[id]!.stName!;
  } else {
    return "";
  }
}
