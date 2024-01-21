import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/view/bonds/bond_details_view.dart';
import 'package:ba3_business_solutions/view/bonds/custom_bond_details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/bond_record_model.dart';
import '../utils/generate_id.dart';
import '../utils/logger.dart';
import '../view/bonds/widget/bond_record_data_source.dart';
import '../view/bonds/widget/custom_bond_record_data_source.dart';

class BondViewModel extends GetxController {
  late BondRecordDataSource recordDataSource;
  late DataGridController dataGridController;
  late CustomBondRecordDataSource customBondRecordDataSource;

  late GlobalModel bondModel;
  RxMap<String, GlobalModel> allBondsItem = <String, GlobalModel>{}.obs;
  bool isEdit = false;
  late GlobalModel tempBondModel;

  BondViewModel() {
    getAllBonds();
  }

  getAllBonds() async {
    print("start get bond data");
    FirebaseFirestore.instance.collection(Const.bondsCollection).snapshots().listen((QuerySnapshot querySnapshot) {
      allBondsItem.clear();
      for (var element in querySnapshot.docs) {
        allBondsItem[element.id] = GlobalModel.fromJson(element.data());
        element.reference.collection(Const.recordCollection).snapshots().listen((value) {
          List<BondRecordModel> _ = value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
          allBondsItem[element.id]?.bondRecord = _;
        });
      }
    });
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {

      update();
    });
    //update();
  }

  // initAllBonds(querySnapshot) async {
  //   allBondsItem.clear();
  //   for (var element in querySnapshot.docs) {
  //     allBondsItem[element['bondId']] = GlobalModel.fromJson(element.data());
  //     element.reference
  //         .collection(Const.recordCollection)
  //         .snapshots()
  //         .listen((value) {
  //       List<BondRecordModel> _ =
  //           value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
  //       allBondsItem[element['bondId']]?.bondRecord = _;
  //     });
  //   }

  //   WidgetsFlutterBinding.ensureInitialized()
  //       .waitUntilFirstFrameRasterized
  //       .then((value) {
  //     update();
  //   });
  //   //update();
  // }

  postOneBond(bool isNew, {bool withLogger = false}) async {
    bondModel = GlobalModel.fromJson(tempBondModel.toFullJson());
    print(tempBondModel.toFullJson());
    final accountController = Get.find<AccountViewModel>();
    for (var i = 0; i < bondModel.bondRecord!.length; i++) {
      if (bondModel.bondRecord?[i].bondRecAccount?.substring(0, 3) != 'acc') {
        bondModel.bondRecord?[i].bondRecAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == bondModel.bondRecord?[i].bondRecAccount).accId;
      }
    }
    if (isNew) {
      bondModel.bondId = generateId(RecordType.bond);
      tempBondModel.bondId = bondModel.bondId;
    }

    if (double.parse(bondModel.bondTotal!) != 0 && bondModel.bondType == Const.bondTypeDaily) {
      Get.snackbar("خطأ", "خطأ بالمجموع");
      return;
    } else if (double.parse(bondModel.bondTotal!) == 0 && bondModel.bondType == Const.bondTypeDebit || bondModel.bondType == Const.bondTypeCredit) {
      Get.snackbar("خطأ", "فارغ");
      return;
    }

    FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).set(bondModel.toJson());
    print(bondModel.bondRecord?.length);
    bondModel.bondRecord?.forEach((element) async {
      print(element.toJson());
      FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).collection(Const.recordCollection).doc(element.bondRecId).set(element.toJson());
    });
    if (withLogger) logger(newData: bondModel);
    accountController.updateInAccount(bondModel);
    saveRecordInFirebase(bondModel);
    // _allBondsItem[bondModel.bondId!]=  bondModel;
    // _allBondsItem.entries.toList().sort((e1, e2) => e1.value.bondId!.compareTo(e2.value.bondId!));
    isEdit = false;
    update();
  }

  updateBond({String? modelKey, bool withLogger = false}) async {
    if (withLogger) logger(oldData: allBondsItem[tempBondModel.bondId!], newData: tempBondModel);
    allBondsItem[tempBondModel.bondId!] = GlobalModel.fromJson(tempBondModel.toFullJson());
    if (bondModel.bondType != Const.bondTypeDaily) {
      tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "0");
    }
    final accountController = Get.find<AccountViewModel>();
    for (var i = 0; i < bondModel.bondRecord!.length; i++) {
      if (bondModel.bondRecord?[i].bondRecAccount?.substring(0, 3) != 'acc') {
        bondModel.bondRecord?[i].bondRecAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == bondModel.bondRecord?[i].bondRecAccount).accId;
      }
    }
    if (double.parse(bondModel.bondTotal!) != 0 && bondModel.bondType == Const.bondTypeDaily) {
      Get.snackbar("خطأ", "خطأ بالمجموع");
    } else if (double.parse(bondModel.bondTotal!) == 0 && bondModel.bondType == Const.bondTypeDebit || bondModel.bondType == Const.bondTypeCredit) {
      Get.snackbar("خطأ", "فارغ");
    }
    bondModel = GlobalModel.fromJson(allBondsItem[tempBondModel.bondId!]!.toFullJson());
    await FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).collection(Const.recordCollection).get().then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
    FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).delete();
    for (BondRecordModel bondRecord in bondModel.bondRecord!) {
      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(bondRecord.bondRecAccount).collection(Const.recordCollection).doc(bondModel.bondId).delete();
    }
    FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).set(bondModel.toJson());
    bondModel.bondRecord?.forEach((element) async {
      print(element.bondRecAccount);
      print(element.bondRecId);
      FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondModel.bondId).collection(Const.recordCollection).doc(element.bondRecId).set(element.toJson());
    });
    saveRecordInFirebase(bondModel);
    accountController.updateInAccount(bondModel, modelKey: modelKey);
    isEdit = false;
    update();
  }

  deleteOneBonds({String? bondId, bool withLogger = false}) async {
    bondId ??= bondModel.bondId;
    if (bondId != null) {
      bondModel = allBondsItem[bondId]!;
    }
    print(bondId);
    if (withLogger) logger(oldData: bondModel);
    for (BondRecordModel bondRecord in bondModel.bondRecord!) {
      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(bondRecord.bondRecAccount).collection(Const.recordCollection).doc(bondId).delete();
    }
    await FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondId).collection(Const.recordCollection).get().then((value) {
      for (var e in value.docs) {
        e.reference.delete();
      }
    });
    await FirebaseFirestore.instance.collection(Const.bondsCollection).doc(bondId).delete();

    isEdit = false;
    update();
  }

  void saveRecordInFirebase(GlobalModel bondModel) async {
    Map<String, List> allRecTotal = {};
    for (int i = 0; i < bondModel.bondRecord!.length; i++) {
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(bondModel.bondRecord![i].bondRecAccount).get().then((value) {
        if (allRecTotal[value.id] == null) {
          allRecTotal[value.id] = [bondModel.bondRecord![i].bondRecDebitAmount! - bondModel.bondRecord![i].bondRecCreditAmount!];
        } else {
          allRecTotal[value.id]!.add(bondModel.bondRecord![i].bondRecDebitAmount! - bondModel.bondRecord![i].bondRecCreditAmount!);
        }
      });
    }
    allRecTotal.forEach((key, value) {
      var recCredit = value.reduce((value, element) => value + element);
      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(key).collection(Const.recordCollection).doc(bondModel.bondId).set({
        "total": recCredit.toString(),
        "id": bondModel.bondId,
        "account": key,
      });
    });
  }

  void restoreOldData() {
    tempBondModel = GlobalModel.fromJson(bondModel.toFullJson());
    update();

    // FirebaseFirestore.instance.collection(ConstRecord.bondsCollection).doc(bondModel.bondId).get().then((value) {
    //   value.reference.collection(ConstRecord.recordCollection).get().then((value1) {
    //     List<BondRecordModel> _ = value1.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
    //   var newBondModel = GlobalModel.fromJson(value.data()!);
    //   newBondModel.bondRecord=_;
    //   _allBondsItem[bondModel.bondId!]=newBondModel;
    //   update();
    //   });
    // });
  }

  void changeIndexCode({required String code}) {
    var model = allBondsItem.values.toList().firstWhereOrNull((element) => element.bondCode == code);
    if (model == null) {
      Get.snackbar("خطأ", "غير موجود");
    } else {
      tempBondModel = GlobalModel.fromJson(model.toFullJson());
      bondModel = GlobalModel.fromJson(model.toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
            ));
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        update();
      }
    }
    update();
  }

  void deleteOneRecord(int rowIndex) {
    tempBondModel.bondRecord?.removeAt(rowIndex);
    // updateBond();
    for (var i = 0; i < tempBondModel.bondRecord!.length; i++) {
      tempBondModel.bondRecord?[i].bondRecId = "0$i";
    }
    initTotal();
    initPage();
    isEdit = true;
    update();
  }

  void initPage() {
    initTotal();
    if (tempBondModel.bondType == Const.bondTypeDaily) {
      recordDataSource = BondRecordDataSource(recordData: tempBondModel);
    } else {
      customBondRecordDataSource = CustomBondRecordDataSource(recordData: tempBondModel, oldisDebit: tempBondModel.bondType == Const.bondTypeDebit);
    }
    dataGridController = DataGridController();

    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      // update();
    });
  }

  void initTotal() {
    double debit = 0;
    double credit = 0;
    tempBondModel.bondRecord?.forEach((element) {
      debit = debit + (element.bondRecDebitAmount ?? 0);
      credit = credit + (element.bondRecCreditAmount ?? 0);
    });
    tempBondModel.bondTotal = (debit - credit).toStringAsFixed(2);
  }

  void fastAddBond({String? bondId,String? oldBondCode, String? originId, required double total, required List<BondRecordModel> record,String? bondDate,String?bondType}) {
    tempBondModel = GlobalModel();
    bondModel = GlobalModel();
    tempBondModel.bondRecord = record;
    tempBondModel.originId = originId;
    if (bondId == null) {
      tempBondModel.bondId = generateId(RecordType.bond);
    } else {
      tempBondModel.bondId = bondId;
      bondModel.bondId = bondId;
    }
    tempBondModel.bondTotal = total.toString();
    tempBondModel.bondType = bondType;
    tempBondModel.bondType = Const.bondTypeDaily;
    var bondCode = "";
    if (!isEdit) {
      // String bondId = generateId(RecordType.bond);
      bondCode = (int.parse(allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
      while (allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(bondCode)) {
        bondCode = (int.parse(bondCode) + 1).toString();
      }
      //TODO add_bondid_to_cheqoe_model_to_save_it_while_edit
      // invoiceModel.bondCode = bondCode;
    }
    if(oldBondCode==null){
      tempBondModel.bondCode = bondCode;
    }else{
      tempBondModel.bondCode = oldBondCode;
    }
    tempBondModel.bondDate=bondDate;
    tempBondModel.bondDate??=DateTime.now().toString().split(" ")[0];
    postOneBond(false);
  }

  prevBond() {
    var index = allBondsItem.keys.toList().indexOf(tempBondModel.bondId!);
    if (allBondsItem.keys.toList().first == allBondsItem.keys.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allBondsItem.values.toList()[index - 1].toFullJson());
      bondModel = GlobalModel.fromJson(allBondsItem.values.toList()[index - 1].toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
            ));
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        update();
      }
    }
  }

  nextBond() {
    var index = allBondsItem.keys.toList().indexOf(tempBondModel.bondId!);
    if (allBondsItem.keys.toList().last == allBondsItem.keys.toList()[index]) {
    } else {
      tempBondModel = GlobalModel.fromJson(allBondsItem.values.toList()[index + 1].toFullJson());
      bondModel = GlobalModel.fromJson(allBondsItem.values.toList()[index + 1].toFullJson());
      if (bondModel.bondType == Const.bondTypeDaily) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
            ));
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == Const.bondTypeDebit,
            ));
        update();
      }
    }
  }

  String? checkValidate() {
    var _;
    tempBondModel.bondRecord?.forEach((element) {
      print(element.toJson());
      if(element.bondRecAccount==''||element.bondRecAccount==null||element.bondRecId==null||(element.bondRecCreditAmount==0&&element.bondRecDebitAmount==0)){
        // print("empty");
        _= "الحقول فارغة";
      }else{
        // print("ok");
      }

    });
    if(_!=null)return _;
    if(tempBondModel.bondType==Const.bondTypeDaily&&double.parse(tempBondModel.bondTotal!)!=0){
      return"خطأ بالمجموع";
    }
    if(tempBondModel.bondType!=Const.bondTypeDaily&&double.parse(tempBondModel.bondTotal!)==0){
      return "خطأ بالمجموع";
    }
    if(tempBondModel.bondCode==null||int.tryParse(tempBondModel.bondCode!)==null){
      return "الرمز فارغ";
    }
    return null;
  }
}
