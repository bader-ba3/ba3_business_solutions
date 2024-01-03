import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/stores/widgets/store_dataSource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid/src/datagrid_widget/helper/callbackargs.dart';

class StoreViewModel extends GetxController {
  final CollectionReference _storeCollectionRef = FirebaseFirestore.instance.collection(Const.storeCollectionRef);

  RxMap<String, StoreModel> _storesMap = <String, StoreModel>{}.obs;

  RxMap<String, StoreModel> get storeMap => _storesMap;
  bool isAscending = true;

  DataGridController storeDataGridController = DataGridController();

  StoreModel? editStoreModel;

  StoreViewModel() {
    getAllStore();
  }

  StoreRecordDataSource? recordViewDataSource;

  addNewStore() {
    editStoreModel?.stId = generateId(RecordType.store);
    _storeCollectionRef.doc(editStoreModel?.stId).set(editStoreModel?.toJson());
    update();
  }

  getAllStore() {
    FirebaseFirestore.instance.collection(Const.storeCollectionRef).snapshots().listen((value) {
      _storesMap.clear();
      for (var element in value.docs) {
        _storesMap[element.id] = StoreModel();
        _storesMap[element.id] = StoreModel.fromJson(element.data());
      }
      recordViewDataSource = StoreRecordDataSource(stores: {});
      recordViewDataSource = StoreRecordDataSource(stores: _storesMap);
      update();
    });
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
}
