import 'dart:io';

import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/stores/widgets/store_dataSource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/store_record_model.dart';

class StoreViewModel extends GetxController {
  final CollectionReference _storeCollectionRef = FirebaseFirestore.instance.collection(Const.storeCollection);

  RxMap<String, StoreModel> storeMap = <String, StoreModel>{}.obs;

  bool isAscending = true;

  DataGridController storeDataGridController = DataGridController();

  StoreModel? editStoreModel;

  StoreViewModel() {
    getAllStore();
  }
  String? openedStore;
  StoreRecordDataSource? recordViewDataSource;

  void initGlobalStore(GlobalModel globalModel) {
    Map<String, StoreRecProductModel> allRecTotal = {};
    bool isPay = globalModel.invType == "pay";
    int correctQuantity = isPay ? 1 : -1;
    for (int i = 0; i <  globalModel.invRecords!.length; i++) {
      if ( globalModel.invRecords![i].invRecId != null) {
        bool isStoreProduct= getProductModelFromId( globalModel.invRecords![i].invRecProduct)!.prodType==Const.productTypeStore;
        if(isStoreProduct) {
          allRecTotal[ globalModel.invRecords![i].invRecProduct!] = StoreRecProductModel(
            storeRecProductId:  globalModel.invRecords![i].invRecProduct,
            storeRecProductPrice:  globalModel.invRecords![i].invRecSubTotal.toString(),
            storeRecProductQuantity: (correctQuantity *  globalModel.invRecords![i].invRecQuantity!).toString(),
            storeRecProductTotal:  globalModel.invRecords![i].invRecTotal.toString(),
          );
        }
      }
    }
    print(allRecTotal);
    // FirebaseFirestore.instance.collection(Const.storeCollection).doc(globalModel.invStorehouse).collection(Const.recordCollection).doc(globalModel.invId).set();
    StoreRecordModel model=   StoreRecordModel(
        storeRecId:globalModel.invStorehouse,
        storeRecInvId:globalModel.invId,
        storeRecProduct:allRecTotal
    );

    if(storeMap[model.storeRecId]?.stRecords==null){
      storeMap[model.storeRecId]?.stRecords=[model];
    }else{
      storeMap[model.storeRecId]?.stRecords.removeWhere((element) => element.storeRecInvId==globalModel.invId);
      storeMap[model.storeRecId]?.stRecords.add(model);
    }
    if(openedStore!=null){
      initStorePage(openedStore);
    }
  }

  void deleteGlobalStore(GlobalModel globalModel){
    storeMap[globalModel.invStorehouse]?.stRecords.removeWhere((element) => element.storeRecInvId==globalModel.invId);
  }


  getAllStore() {
     FirebaseFirestore.instance.collection(Const.storeCollection).snapshots().listen((value)  {
       RxMap<String, List<StoreRecordModel>> oldStoreMap = <String, List<StoreRecordModel>>{}.obs;
       storeMap.forEach((key, value) {
         oldStoreMap[key]=value.stRecords;
       });
       storeMap.clear();

      for (var element in value.docs) {
        storeMap[element.id] = StoreModel.fromJson(element.data());
        storeMap[element.id]?.stRecords =oldStoreMap[element.id]??[];
      }
      recordViewDataSource = StoreRecordDataSource(stores: storeMap);
      update();
    });
  }
  Map<String,double> totalAmountPage={};
  initStorePage(storeId){
    totalAmountPage.clear();
    storeMap[storeId]?.stRecords.forEach((value) {
      value.storeRecProduct?.forEach((key, value) {
        totalAmountPage[value.storeRecProductId!]=(totalAmountPage[value.storeRecProductId!]??0)+double.parse(value.storeRecProductQuantity!)!;
      });
    });
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) => update());
  }
  addNewStore() {
    editStoreModel?.stId = generateId(RecordType.store);
    _storeCollectionRef.doc(editStoreModel?.stId).set(editStoreModel?.toJson());
    update();
  }

  editStore() {
    _storeCollectionRef.doc(editStoreModel?.stId).set(editStoreModel?.toJson());
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

  deleteStore() {
    _storeCollectionRef.doc(editStoreModel?.stId).delete();
    update();
  }

  // void saveInvInStore(List<InvoiceRecordModel> record, String? invId, String? invType, String? storeId) {
  //   Map<String, StoreRecProductModel> allRecTotal = {};
  //   bool isPay = invType == "pay";
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
   List<List> data=[["اسم المادة","العدد"]];
   totalAmountPage.forEach((key, value) {
     data.add([getProductNameFromId(key),value.toString()]);
   });
    String csv = const ListToCsvConverter().convert(data);
  String? saveData= await FilePicker.platform.saveFile(
        fileName:getStoreNameFromId(oldKey)+" "+DateTime.now().toString().split(" ")[0]+".csv"
    );

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
String getStoreIdFromText(text) {
  var storeController = Get.find<StoreViewModel>();
  if (text != null && text != " " && text != "") {
    return storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == text)?.stId??"";
  } else {
    return "";
  }
}

String getStoreNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<StoreViewModel>().storeMap[id]!.stName!;
  } else {
    return "";
  }

}