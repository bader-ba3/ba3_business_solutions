import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/bond_record_model.dart';
import 'package:ba3_business_solutions/model/cheque_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/cheques/add_cheque.dart';
import 'package:ba3_business_solutions/view/cheques/widget/all_cheques_view_data_grid_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Const/const.dart';
import '../model/account_record_model.dart';
import '../utils/generate_id.dart';
import '../view/accounts/widget/account_record_data_source.dart';
import '../view/accounts/widget/account_view_data_grid_source.dart';

class ChequeViewModel extends GetxController {
  RxMap<String, ChequeModel> allCheques = <String, ChequeModel>{}.obs;
  late AllChequesViewDataGridSource chequeRecordDataSource;
  late AllChequesViewDataGridSource recordDataSource;
  late DataGridController dataGridController;
  late DataGridController dataViewGridController;
  late AllChequesViewDataGridSource recordViewDataSource;
  var accountController = Get.find<AccountViewModel>();
  var bondController = Get.find<BondViewModel>();
  ChequeModel? initModel;
  ChequeModel? chequeModel;

  ChequeViewModel() {
    getAllCheques();
    initChequeViewPage();
  }

  initChequeViewPage() {
    dataViewGridController = DataGridController();
    recordViewDataSource = AllChequesViewDataGridSource(allCheques);
    //update();
  }

  void getAllCheques() async {
    FirebaseFirestore.instance.collection(Const.chequesCollection).snapshots().listen((value) async {
      allCheques.clear();
      for (var element in value.docs) {
        element.reference.collection(Const.recordCollection).snapshots().listen((value0) async {
          allCheques[element.id]?.cheqRecords = [];
          var _ = value0.docs.map((e) => ChequeRecModel.fromJson(e.data())).toList();
          allCheques[element.id] = ChequeModel.fromJson(element.data(), element.id, _);
          initChequePage();
          update();
        });
      }
      update();
    });
  }

  initChequePage() {
    dataGridController = DataGridController();
    recordDataSource = AllChequesViewDataGridSource(allCheques);
  }

  addCheque({String? oldId, String? oldBondId}) async {
    if (oldId != null) {
      initModel?.cheqId = oldId;
    } else {
      initModel?.cheqId = generateId(RecordType.cheque);
    }

    initModel?.cheqRemainingAmount = initModel?.cheqAllAmount;
    if (!initModel!.cheqPrimeryAccount!.contains("acc")) initModel!.cheqPrimeryAccount = getAccountIdFromText(initModel!.cheqPrimeryAccount);
    if (!initModel!.cheqSecoundryAccount!.contains("acc")) initModel!.cheqSecoundryAccount = getAccountIdFromText(initModel!.cheqSecoundryAccount);
    if (!initModel!.cheqBankAccount!.contains("acc")) initModel!.cheqBankAccount = getAccountIdFromText(initModel!.cheqBankAccount);
    initModel?.cheqStatus = Const.chequeStatusNotPaid;
    await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).set(initModel?.toJson());
    var bondId = oldBondId ?? generateId(RecordType.bond);
    bondController.fastAddBond(bondId: bondId, originId: initModel!.cheqId!, total: double.parse(initModel!.cheqAllAmount!), record: [
      BondRecordModel("00", double.parse(initModel!.cheqAllAmount!), 0, initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqPrimeryAccount! : initModel!.cheqSecoundryAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
      BondRecordModel("01", 0, double.parse(initModel!.cheqAllAmount!), initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqSecoundryAccount! : initModel!.cheqPrimeryAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
    ]);
    ChequeRecModel recMap = ChequeRecModel(
      cheqRecBondId: bondId,
      cheqRecAmount: initModel!.cheqAllAmount!,
      cheqRecType: Const.chequeRecTypeInit,
      cheqRecId: initModel?.cheqId,
      cheqRecChequeType: initModel?.cheqType,
      cheqRecPrimeryAccount: initModel!.cheqPrimeryAccount,
      cheqRecSecoundryAccount: initModel!.cheqSecoundryAccount,
    );
    // var recMap = {
    //   "cheqRecBondId": bondId,
    //   "cheqRecType": Const.chequeRecTypeInit,
    // };
    initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(bondId).set(recMap.toJson());
    update();
  }

  Future<void> updateCheque({withLogger = false}) async {
    await deleteCheque().then((value) async {
      if (!initModel!.cheqPrimeryAccount!.contains("acc")) initModel!.cheqPrimeryAccount = getAccountIdFromText(initModel!.cheqPrimeryAccount);
      if (!initModel!.cheqSecoundryAccount!.contains("acc")) initModel!.cheqSecoundryAccount = getAccountIdFromText(initModel!.cheqSecoundryAccount);
      if (withLogger) logger(oldData: allCheques[initModel?.cheqId]!, newData: initModel);
      await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).delete();
      var initBond = initModel!.cheqRecords?.where((element) => element.cheqRecType == Const.chequeRecTypeInit).first;
      initModel!.cheqRecords?.remove(initBond);
      await addCheque(oldId: initModel?.cheqId, oldBondId: initBond?.cheqRecBondId);
      initModel!.cheqRecords?.forEach((element) {
        if (element.cheqRecType == Const.chequeRecTypeAllPayment) {
          payAllAmount(oldBondId: element.cheqRecBondId, ispayEdit: true);
        }
        if (element.cheqRecType == Const.chequeRecTypePartPayment) {
          payAmount(element.cheqRecAmount, oldBondId: element.cheqRecBondId, ispayEdit: true);
        }
        // addRecord(element);
      });

      initChequePage();
      update();
    });
  }

  Future<void> deleteCheque({withLogger = false}) async {
    var id = initModel?.cheqId;
    if (withLogger) logger(oldData: allCheques[id]!);
    for (var element in initModel!.cheqRecords!) {
      await updateDeleteRecord(element.cheqRecBondId, isPayEdit: true);
    }
    // initModel!.cheqRecords = [];
    await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(id).delete();
    // initModel?.cheqRecords?.forEach((element) async {
    //   await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(id).collection(Const.recordCollection).doc(element.cheqRecBondId).delete();
    // });
    print("finish delete");
    print("---------------------------------------");
    //allCheques.remove(id);
    initChequePage();
    update();
    //Get.back();
  }

  Future<void> updateDeleteRecord(id, {type, required bool isPayEdit}) async {
    if (type != null) {
      initModel?.cheqStatus = type;
      await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).update({"cheqStatus": type});
    }
    if (!isPayEdit) {
      initModel?.cheqRecords?.removeWhere((element) => element.cheqRecBondId == id);
    }
    await FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(id).delete();
    bondController.deleteOneBonds(bondId: id);
    update();
  }

  List<String> _accountPickList = [];
  Future<String> getAccountComplete(text, type) async {
    _accountPickList = [];
    var _;
    accountController.accountList.forEach((key, value) {
      _accountPickList.addIf((value.accCode!.toLowerCase().contains(text.toLowerCase()) || value.accName!.toLowerCase().contains(text.toLowerCase())) && value.accType == type, value.accName!);
    });
    if (_accountPickList.length > 1) {
      await Get.defaultDialog(
        title: "Chosse form dialog",
        content: SizedBox(
          width: 500,
          height: 500,
          child: ListView.builder(
            itemCount: _accountPickList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  update();
                  Get.back();
                  _ = _accountPickList[index];
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(
                      _accountPickList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      return _;
    } else if (_accountPickList.length == 1) {
      return _accountPickList[0];
    } else {
      Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
      return "";
    }
  }


  bool checkAccountComplete(text, type)  {
    _accountPickList = [];
    var _;
    accountController.accountList.forEach((key, value) {
      _accountPickList.addIf((value.accCode!.toLowerCase().contains(text.toLowerCase()) || value.accName!.toLowerCase().contains(text.toLowerCase())) && value.accType == type, value.accName!);
    });
      if (_accountPickList.length == 1) {
        if(text==_accountPickList.first){
          print(text);
          print(_accountPickList.first);
          return true;
        }
    }
    return false;
  }

  void payAllAmount({String? oldBondId, required bool ispayEdit}) {
    initModel?.cheqStatus = Const.chequeStatusPaid;
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).update({"cheqStatus": Const.chequeStatusPaid});
    var bondId = oldBondId ?? generateId(RecordType.bond);
    bondController.fastAddBond(bondId: bondId, originId: initModel!.cheqId!, total: double.parse(initModel!.cheqAllAmount!), record: [
      BondRecordModel("00", double.parse(initModel!.cheqAllAmount!), 0, initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqBankAccount! : initModel!.cheqSecoundryAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
      BondRecordModel("01", 0, double.parse(initModel!.cheqAllAmount!), initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqSecoundryAccount! : initModel!.cheqBankAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
    ]);
    ChequeRecModel recMap = ChequeRecModel(
      cheqRecBondId: bondId,
      cheqRecAmount: initModel!.cheqAllAmount!,
      cheqRecType: Const.chequeRecTypeAllPayment,
      cheqRecId: initModel?.cheqId,
      cheqRecChequeType: initModel?.cheqType,
      cheqRecPrimeryAccount: initModel!.cheqSecoundryAccount,
      cheqRecSecoundryAccount: initModel!.cheqBankAccount,
    );
    // var recMap = {
    //   "cheqRecBondId": bondId,
    //   "cheqRecAmount": initModel!.cheqAllAmount!,
    //   "cheqRecType": Const.chequeRecTypeAllPayment,
    // };
    if (!ispayEdit) {
      initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    }
    //initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(bondId).set(recMap.toJson());
    initChequePage();
    update();
  }

  void payAmount(amount, {String? oldBondId, required bool ispayEdit}) {
    var status;
    print("_________________________");
    List<ChequeRecModel?>? payment_list = initModel?.cheqRecords?.cast<ChequeRecModel?>().where((element) => element?.cheqRecType == Const.chequeRecTypePartPayment).toList();
    if (payment_list != null && payment_list.isNotEmpty) {
      if (!ispayEdit && payment_list.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) + double.parse(amount) == double.parse(initModel!.cheqAllAmount!)) {
        initModel?.cheqStatus = Const.chequeStatusPaid;
        status = Const.chequeStatusPaid;
      } else if (ispayEdit && payment_list.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) == double.parse(initModel!.cheqAllAmount!)) {
        initModel?.cheqStatus = Const.chequeStatusPaid;
        status = Const.chequeStatusPaid;
      } else if (!ispayEdit && payment_list.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) + double.parse(amount) > double.parse(initModel!.cheqAllAmount!)) {
        return;
      } else if (double.parse(amount) == double.parse(initModel!.cheqAllAmount!)) {
        initModel?.cheqStatus = Const.chequeStatusPaid;
        status = Const.chequeStatusPaid;
      } else {
        initModel?.cheqStatus = Const.chequeStatusNotAllPaid;
        status = Const.chequeStatusNotAllPaid;
      }
    } else if (double.parse(amount) == double.parse(initModel!.cheqAllAmount!)) {
      initModel?.cheqStatus = Const.chequeStatusPaid;
      status = Const.chequeStatusPaid;
    } else if (double.parse(amount) > double.parse(initModel!.cheqAllAmount!)) {
      print("error " * 20);
      return;
    } else {
      initModel?.cheqStatus = Const.chequeStatusNotAllPaid;
      status = Const.chequeStatusNotAllPaid;
    }
    print(amount + "  " + initModel!.cheqAllAmount!);
    print("_________________________");
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).update({"cheqStatus": status});
    var bondId = oldBondId ?? generateId(RecordType.bond);
    bondController.fastAddBond(bondId: bondId, originId: initModel!.cheqId!, total: double.parse(initModel!.cheqAllAmount!), record: [
      BondRecordModel("00", double.parse(amount), 0, initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqBankAccount! : initModel!.cheqSecoundryAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
      BondRecordModel("01", 0, double.parse(amount), initModel?.cheqType == Const.chequeTypeCatch ? initModel!.cheqSecoundryAccount! : initModel!.cheqBankAccount!, "تم التوليد من الشيكات", invId: initModel?.cheqId),
    ]);
    // var recMap = {
    //   "cheqRecBondId": bondId,
    //   "cheqRecAmount": amount,
    //   "cheqRecType": Const.chequeRecTypePartPayment,
    // };
    ChequeRecModel recMap = ChequeRecModel(
      cheqRecBondId: bondId,
      cheqRecAmount: amount,
      cheqRecType: Const.chequeRecTypePartPayment,
      cheqRecId: initModel?.cheqId,
      cheqRecChequeType: initModel?.cheqType,
      cheqRecPrimeryAccount: initModel!.cheqSecoundryAccount,
      cheqRecSecoundryAccount: initModel!.cheqBankAccount,
    );
    if (!ispayEdit) {
      initModel?.cheqRecords?.add(ChequeRecModel.fromJson(recMap.toJson()));
    }
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(initModel?.cheqId).collection(Const.recordCollection).doc(bondId).set(recMap.toJson());
    initChequePage();
    update();
  }

  addRecord(ChequeRecModel model) {
    bondController.fastAddBond(bondId: model.cheqRecBondId, originId: model!.cheqRecId!, total: double.parse(model!.cheqRecAmount!), record: [
      BondRecordModel("00", double.parse(model!.cheqRecAmount!), 0, model?.cheqRecChequeType == Const.chequeTypeCatch ? model!.cheqRecPrimeryAccount! : model!.cheqRecSecoundryAccount!, "تم التوليد من الشيكات", invId: model?.cheqRecId),
      BondRecordModel("01", 0, double.parse(model!.cheqRecAmount!), model?.cheqRecChequeType == Const.chequeTypeCatch ? model!.cheqRecSecoundryAccount! : model!.cheqRecPrimeryAccount!, "تم التوليد من الشيكات", invId: model?.cheqRecId),
    ]);
    //initModel?.cheqRecords?.add(model);
    FirebaseFirestore.instance.collection(Const.chequesCollection).doc(model?.cheqRecId).collection(Const.recordCollection).doc(model.cheqRecBondId).set(model.toJson());
  }

  prevCheq() {
    var index = allCheques.keys.toList().indexOf(initModel!.cheqId!);
    if (allCheques.keys.toList().first == allCheques.keys.toList()[index]) {
    } else {
      initModel = ChequeModel.fromFullJson(allCheques.values.toList()[index - 1].toFullJson());
      update();
    }
  }

  nextCheq() {
    var index = allCheques.keys.toList().indexOf(initModel!.cheqId!);
    if (allCheques.keys.toList().last == allCheques.keys.toList()[index]) {
    } else {
      initModel = ChequeModel.fromFullJson(allCheques.values.toList()[index + 1].toFullJson());
      update();
    }
  }

  void changeIndexCode({required String code}) {
    var model = allCheques.values.toList().firstWhereOrNull((element) => element.cheqCode == code);
    if (model == null) {
      Get.snackbar("error", "not found");
    } else {
      initModel = ChequeModel.fromFullJson(model.toFullJson());
      update();
    }
  }
}
