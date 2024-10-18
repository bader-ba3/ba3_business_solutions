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
      _handleInvoiceType(globalModel, allRecTotal);
    } else {
      _handleInvoiceTypeChange(globalModel, allRecTotal, allRecTotal2);
    }

    if (openedStore != null) {
      initStorePage(openedStore);
    }
  }

  void _handleInvoiceType(GlobalModel globalModel, Map<String, StoreRecProductModel> allRecTotal) {
    bool isPay = globalModel.invType == AppConstants.invoiceTypeBuy || globalModel.invType == AppConstants.invoiceTypeAdd;
    int correctQuantity = isPay ? 1 : -1;
    Map<String, int> allRecTotalProduct = {};

    for (var record in globalModel.invRecords!) {
      if (record.invRecId != null) {
        allRecTotalProduct.update(
          record.invRecProduct!,
          (existingQuantity) => existingQuantity + (record.invRecQuantity ?? 1),
          ifAbsent: () => (record.invRecQuantity ?? 1),
        );
      }
    }

    allRecTotalProduct.forEach((key, value) {
      var recCredit = value;
      var productModel = getProductModelFromId(key);
      if (productModel != null) {
        allRecTotal[key] = StoreRecProductModel(
          storeRecProductId: key,
          storeRecProductPrice: "0",
          storeRecProductQuantity: (correctQuantity * recCredit).toString(),
          storeRecProductTotal: "0",
        );
      }
    });

    _updateStoreMap(
      storeRecId: globalModel.invStorehouse,
      invId: globalModel.invId,
      allRecTotal: allRecTotal,
    );
  }

  void _handleInvoiceTypeChange(
      GlobalModel globalModel, Map<String, StoreRecProductModel> allRecTotal, Map<String, StoreRecProductModel> allRecTotal2) {
    for (var record in globalModel.invRecords!) {
      if (record.invRecId != null && getProductModelFromId(record.invRecProduct) != null) {
        bool isStoreProduct = getProductModelFromId(record.invRecProduct)!.prodType == AppConstants.productTypeStore;
        if (isStoreProduct) {
          allRecTotal[record.invRecProduct!] = StoreRecProductModel(
            storeRecProductId: record.invRecProduct,
            storeRecProductPrice: record.invRecSubTotal.toString(),
            storeRecProductQuantity: (-1 * record.invRecQuantity!).toString(),
            storeRecProductTotal: record.invRecTotal.toString(),
          );
          allRecTotal2[record.invRecProduct!] = StoreRecProductModel(
            storeRecProductId: record.invRecProduct,
            storeRecProductPrice: record.invRecSubTotal.toString(),
            storeRecProductQuantity: (1 * record.invRecQuantity!).toString(),
            storeRecProductTotal: record.invRecTotal.toString(),
          );
        }
      }
    }

    _updateStoreMap(
      storeRecId: globalModel.invStorehouse,
      invId: globalModel.invId,
      allRecTotal: allRecTotal,
    );

    var secondaryStorehouse = globalModel.invSecStorehouse ?? globalModel.invStorehouse;
    _updateStoreMap(
      storeRecId: secondaryStorehouse,
      invId: globalModel.invId,
      allRecTotal: allRecTotal2,
    );

    _logModelDetails(globalModel, secondaryStorehouse);
  }

  void _updateStoreMap({
    required String? storeRecId,
    required String? invId,
    required Map<String, StoreRecProductModel>? allRecTotal,
  }) {
    StoreRecordModel model = StoreRecordModel(
      storeRecId: storeRecId,
      storeRecInvId: invId,
      storeRecProduct: allRecTotal,
    );

    var storeRecords = storeMap[storeRecId]?.stRecords;
    if (storeRecords == null) {
      storeMap[storeRecId]?.stRecords = [model];
    } else {
      storeRecords.removeWhere((element) => element.storeRecInvId == invId);
      storeRecords.add(model);
    }
  }

  void _logModelDetails(GlobalModel globalModel, String? secondaryStorehouse) {
    print("-----$secondaryStorehouse-------");
    print("-----${globalModel.invId}-------");
    print("-----${globalModel.entryBondId}-------");
    print("-----${globalModel.entryBondCode}-------");
    print("-----${globalModel.bondCode}-------");
    print("-----${globalModel.invFullCode}-------");
    print("-----${globalModel.invCode}-------");
    print("-----${globalModel.invSecStorehouse}-------");
    print("-----${globalModel.invStorehouse}-------");
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

  deleteStore(id) {
    StoreModel editStoreModel = storeMap[id]!;
    _storeCollectionRef.doc(editStoreModel.stId).delete();
    ChangesController changesViewModel = Get.find<ChangesController>();

    changesViewModel.addRemoveChangeToChanges(editStoreModel.toFullJson(), AppConstants.storeCollection);
    update();
  }

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
