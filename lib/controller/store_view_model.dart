import 'dart:io';

import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/stores/widgets/store_dataSource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/store_record_model.dart';

class StoreViewModel extends GetxController {
  final CollectionReference _storeCollectionRef = FirebaseFirestore.instance.collection(Const.storeCollection);

  RxMap<String, StoreModel> _storesMap = <String, StoreModel>{}.obs;

  RxMap<String, StoreModel> get storeMap => _storesMap;
  bool isAscending = true;

  DataGridController storeDataGridController = DataGridController();

  StoreModel? editStoreModel;

  StoreViewModel() {
    getAllStore();

  }

  StoreRecordDataSource? recordViewDataSource;
  getAllStore() {
     FirebaseFirestore.instance.collection(Const.storeCollection).snapshots().listen((value)  {
      _storesMap.clear();
      for (var element in value.docs) {
        // _storesMap[element.id] = StoreModel.fromJson(element.data());
        element.reference.collection(Const.recordCollection).snapshots().listen((value) {
          Map<String, StoreRecordModel> _={};
          for (var e in value.docs) {
            _[e.id]=StoreRecordModel.fromJson(e.data());
          }
          _storesMap[element.id] = StoreModel.fromJson(element.data(),_);

          recordViewDataSource = StoreRecordDataSource(stores: _storesMap);
        });
      }
      recordViewDataSource = StoreRecordDataSource(stores: _storesMap);

      update();
    });
  }
  Map<String,double> totalAmountPage={};
  initStorePage(storeId){
    totalAmountPage.clear();
    storeMap[storeId]?.stRecords.forEach((key, value) {
      value.storeRecProduct?.forEach((key, value) {
        totalAmountPage[value.storeRecProductId!]=(totalAmountPage[value.storeRecProductId!]??0)+double.parse(value.storeRecProductQuantity!)!;
      });
    });
    print(totalAmountPage);
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

  void saveInvInStore(List<InvoiceRecordModel> record, String? invId, String? invType, String? storeId) {
    Map<String, StoreRecProductModel> allRecTotal = {};
    bool isPay = invType == "pay";
    int correctQuantity = isPay ? 1 : -1;
    for (int i = 0; i < record.length; i++) {
      if (record[i].invRecId != null) {
        bool isStoreProduct= getProductModelFromId(record[i].invRecProduct)!.prodType==Const.productTypeStore;
        if(isStoreProduct) {
          allRecTotal[record[i].invRecProduct!] = StoreRecProductModel(
            storeRecProductId: record[i].invRecProduct,
            storeRecProductPrice: record[i].invRecSubTotal.toString(),
            storeRecProductQuantity: (correctQuantity * record[i].invRecQuantity!).toString(),
            storeRecProductTotal: record[i].invRecTotal.toString(),
          );
        }
      }
    }
    FirebaseFirestore.instance.collection(Const.storeCollection).doc(storeId).collection(Const.recordCollection).doc(invId).set(StoreRecordModel(
        storeRecId:storeId,
        storeRecInvId:invId,
        storeRecProduct:allRecTotal
    ).toJson());
  }

  void deleteRecord({required String storeId, String? invId}) {
      FirebaseFirestore.instance.collection(Const.storeCollection).doc(storeId).collection(Const.recordCollection).doc(invId).delete();
  }

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
    return storeController.storeMap.values.toList().firstWhere((element) => element.stName == text).stId!;
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