import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/view/patterns/widget/pattern_source_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/generate_id.dart';
import 'account_view_model.dart';

class PatternViewModel extends GetxController {
  PatternRecordDataSource? recordViewDataSource;

  PatternViewModel() {
    getAllPattern();
    // recordViewDataSource=PatternRecordDataSource(patternRecordModel: patternModel);
  }

  RxMap<String, PatternModel> patternModel = <String, PatternModel>{}.obs;


  final CollectionReference _patternCollectionRef = FirebaseFirestore.instance.collection(Const.patternCollection);

  List<String> accountPickList = [];


  var accountController = Get.find<AccountViewModel>();
  var storeController = Get.find<StoreViewModel>();

  PatternModel? editPatternModel;

  getAllPattern() {
    _patternCollectionRef.snapshots().listen((value) {

      patternModel.clear();
      for (var element in value.docs) {
        patternModel[element.id] = PatternModel();
        patternModel[element.id] = PatternModel.fromJson(element.data() as Map<String, dynamic>);
      }
      recordViewDataSource = PatternRecordDataSource(patternRecordModel: {});
      recordViewDataSource = PatternRecordDataSource(patternRecordModel: patternModel);

      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
      });
    });
  }

  addPattern() {
    List a = patternModel.values.where((element) => editPatternModel!.patCode == element.patCode).toList();
    if(a.isNotEmpty){
      Get.snackbar("خطأ", "الرمز مستخدم");
      return;
    }
    editPatternModel?.patId ??= generateId(RecordType.pattern);
    PatternModel _ = PatternModel.fromJson(editPatternModel?.toJson());
    _.patPrimary = getAccountIdFromText(_.patPrimary);
    _.patSecondary = getAccountIdFromText(_.patSecondary);
    _.patVatAccount = getAccountIdFromText(_.patVatAccount);
    _.patStore = getStoreIdFromText(_.patStore);
    _.patNewStore = getStoreIdFromText(_.patNewStore);
    _patternCollectionRef.doc(_.patId).set(_.toJson());
    update();
  }

  editPattern() {
    // print(editPatternModel?.toJson());
    PatternModel _ = PatternModel.fromJson(editPatternModel?.toJson());
    if (!(_.patPrimary?.contains("acc") ?? false)) _.patPrimary = getAccountIdFromText(_.patPrimary);
    if (!(_.patVatAccount?.contains("acc") ?? false)) _.patVatAccount = getAccountIdFromText(_.patVatAccount);
    if (!(_.patSecondary?.contains("acc") ?? false)) _.patSecondary = getAccountIdFromText(_.patSecondary);
    if (!(_.patStore?.contains("store") ?? false)) _.patStore = getStoreIdFromText(_.patStore);
    if (!(_.patNewStore?.contains("store") ?? false)) _.patNewStore = getStoreIdFromText(_.patNewStore);
    // print(editPatternModel?.toJson());
    _patternCollectionRef.doc(_.patId).set(_.toJson());
    update();
  }

  deletePattern() {
    _patternCollectionRef.doc(editPatternModel?.patId).delete();
    update();
  }

  // PatternModel initPatternModel() {
  //   return PatternModel(patName: patNameController.text, patCode: patCodeController.text, patId: generateId(RecordType.pattern), patPrimary: patPrimaryController.text, patType: patTypeController.text);
  // }





  List _storePickList = [];
  Future<String> getStoreComplete(text) async {
    var _ = '';
    _storePickList = [];
    storeController.storeMap.forEach((key, value) {
      _storePickList.addIf(value.stCode!.toLowerCase().contains(text.toLowerCase()) || value.stName!.toLowerCase().contains(text.toLowerCase()), value.stName!);
    });
    // print(_storePickList.length);
    if (_storePickList.length > 1) {
      await Get.defaultDialog(
        title: "Chose form dialog",
        content: SizedBox(
          width: 500,
          height: 500,
          child: ListView.builder(
            itemCount: _storePickList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _ = _storePickList[index];
                  update();
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(
                      _storePickList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (_storePickList.length == 1) {
      _ = _storePickList[0];
    } else {
      Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
    }
    return _;
  }

  clearController() {
    editPatternModel = null;
    update();
  }

  // getNewCode() {
  //   int maxCode = 1;
  //   if (patternModel.isNotEmpty) {
  //     for (var element in patternModel.values) {
  //       int.parse(element.patCode!) > maxCode
  //           ? maxCode = int.parse(element.patCode!)
  //           : maxCode = maxCode;
  //     }
  //   }

  //   patCodeController.text = (maxCode + 1).toString();
  // }
}
String? getVatAccountFromPatternId(id){
  if (id != null && id != " " && id != "") {
    return Get.find<PatternViewModel>().patternModel[id]?.patVatAccount!;
  } else {
    return null;
  }}
PatternModel getPatModelFromPatternId(id){
  if (id != null && id != " " && id != "") {
    return Get.find<PatternViewModel>().patternModel[id]!;
  } else {
    return PatternModel(patName: "not found");
  }}