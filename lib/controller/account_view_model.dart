import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_tree.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Const/const.dart';
import '../model/account_record_model.dart';
import '../utils/generate_id.dart';
import '../view/accounts/widget/account_record_data_source.dart';
import '../view/accounts/widget/account_view_data_grid_source.dart';

class AccountViewModel extends GetxController {
  RxMap<String, RxList<AccountRecordModel>> allAccounts = <String, RxList<AccountRecordModel>>{}.obs;
  late AccountRecordDataSource accountRecordDataSource;
  late AccountRecordDataSource recordDataSource;
  RxMap<String, AccountModel> _accountList = <String, AccountModel>{}.obs;
  Map<String, AccountModel> get accountList => _accountList;
  late DataGridController dataGridController;
  final CollectionReference _accountCollectionRef = FirebaseFirestore.instance.collection(Const.accountsCollection);
  late DataGridController dataViewGridController;
  late AccountViewDataGridSource recordViewDataSource;

  double _total = 0.0;
  double get total => _total;

  AccountViewModel() {
    getAllAccounts();
    getAllAccount();
    initAccountViewPage();
  }

  initAccountViewPage() {
    dataViewGridController = DataGridController();
    recordViewDataSource = AccountViewDataGridSource(accountList, allAccounts);
    //update();
  }

  getAllAccount() async {
    FirebaseFirestore.instance.collection(Const.accountsCollection).snapshots().listen((value) {
      for (var element in value.docs) {
        _accountList[element.id] = AccountModel();
        _accountList[element.id] = AccountModel.fromJson(element.data(), element.id);
      }
      initModel();
      initPage();
      go(lastIndex);
      // update();
    });
  }


  String? lastAccountOpened;
  void getAllAccounts({oldKey}) async {
    FirebaseFirestore.instance.collection(Const.accountsCollection).snapshots().listen((value) async {
      for (var element in value.docs) {
        element.reference.collection(Const.recordCollection).snapshots().listen((value0) {
          allAccounts[element.id] = <AccountRecordModel>[].obs;
          for (var element0 in value0.docs) {
            allAccounts[element.id]?.add(AccountRecordModel.fromJson(element0.data()));
          }
          calculateBalance(element.id);
          if(lastAccountOpened!=null)initAccountPage(lastAccountOpened);
          update();
        });
      }

      update();
    });
  }

  initAccountPage(modeKey) {
    lastAccountOpened=modeKey;
    dataGridController = DataGridController();
    recordDataSource = AccountRecordDataSource(accountRecordModel: allAccounts[modeKey]!,accountModel:accountList[modeKey]!);
    //update();
  }

  ///----------------------------

  addNewAccount(AccountModel accountModel, {bool withLogger = false}) {
   String id = generateId(RecordType.account);
    print(accountModel.accId);
    accountModel.accId ??= id;
    if(accountModel.accParentId==null){
      accountModel.accIsParent=true;
    }else{
      FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountModel.accParentId).update({
        'accChild': FieldValue.arrayUnion([accountModel.accId]),
      });
      accountModel.accIsParent=false;
    }
    _accountCollectionRef.where('accCode', isEqualTo: accountModel.accCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
        return;
      }
      for (var i = 0 ; i< accountModel.accAggregateList.length;i++) {
        if (accountModel.accAggregateList[i].substring(0, 3) != 'acc') {
          accountModel.accAggregateList[i] = accountList.values.toList().firstWhere((e) => e.accName == accountModel.accAggregateList[i]).accId;
        }
      }
      if (withLogger) logger(newData: accountModel);
      _accountCollectionRef.doc(accountModel.accId).set(accountModel.toJson());
      accountList[accountModel.accId!] = AccountModel();
      accountList[accountModel.accId!] = accountModel;
      Get.snackbar("فحص المطاييح", "${accountModel.toJson()} تم اضافة المطيح");
      print(accountModel.toJson());
      // recordViewDataSource.updateDataGridSource();
      // accountRecordDataSource.updateDataGridSource();
      update();
    });
  }

  Future<void> updateInAccount(GlobalModel model, {String? modelKey}) async {
    Map<String, int> oldIndex = {};
    allAccounts.forEach((key, value) {
      for (var element in value.toList()) {
        if (element.id == model.bondId) {
          oldIndex[key] = allAccounts[key]!.indexWhere((element) => element.id == model.bondId);
          FirebaseFirestore.instance.collection(Const.accountsCollection).doc(key).collection(Const.recordCollection).doc(model.bondId).delete();
        }
      }
    });

    var con = Get.find<BondViewModel>();
    con.saveRecordInFirebase(model);
    if (modelKey != null) {
      calculateBalance(modelKey);
      initAccountPage(modelKey);
    }
    update();
  }
  double getBalance(userId){
    double _=0;
    List<AccountRecordModel> allRecord =[];
    AccountModel accountModel=accountList[userId]!;
    allRecord.addAll(allAccounts[userId]!);
    for (var element in accountModel.accChild) {
      print(element);
      allRecord.addAll(allAccounts[element]!.toList());
    }
    if(accountModel.accType==Const.accountTypeAggregateAccount){
      for (var element in accountModel.accAggregateList) {
        allRecord.addAll(allAccounts[element]!.toList());
      }
    }
    if(allRecord.isNotEmpty) {
      _= allRecord.map((e) => double.parse(e.total!)).toList().reduce((value, element) => value!+element);
    }
    return _;
  }
  void calculateBalance(String modelKey) {
    double all = 0;
    for (AccountRecordModel element in allAccounts[modelKey] ?? []) {
      try {
        // all += double.parse(element.total!.toString());
        int? itemIndex = allAccounts[modelKey]?.indexOf(element);
        allAccounts[modelKey]![itemIndex!].balance = all + double.parse(element.total!.toString());
        all = (allAccounts[modelKey]![itemIndex].balance)!;
      } finally {}
    }
  }

  computeTotal(List<AccountRecordModel> billsTotal) {
    _total = 0.0;
    for (int i = 0; i < billsTotal.length; i++) {
      _total = _total + double.parse(billsTotal[i].total!);
    }
  }

  buildSorce(String modelKey) {
    accountRecordDataSource = AccountRecordDataSource(accountRecordModel: allAccounts[modelKey]!,accountModel:accountList[modelKey]!);
    dataGridController = DataGridController();
    computeTotal(allAccounts[modelKey]!);
  }

  bildAry(String modelKey) {
    print("---------from Airy-------------------$modelKey");
    accountRecordDataSource = AccountRecordDataSource(accountRecordModel: allAccounts[modelKey]!,accountModel:accountList[modelKey]!);
    dataGridController = DataGridController();
    computeTotal(allAccounts[modelKey]!);
    update();
  }

  clear(List<TextEditingController> controllers) {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].clear();
      update();
    }
  }

  Future<void> updateAccount(AccountModel editProductModel, {withLogger = false}) async {
    if (withLogger) logger(oldData: accountList[editProductModel.accId]!, newData: editProductModel);
   await deleteAccount(editProductModel.accId!);
    addNewAccount(editProductModel);
    // FirebaseFirestore.instance.collection(Const.accountsCollection).doc(editProductModel.accId).update(editProductModel.toJson());
    update();
  }

  Future<void> deleteAccount(String id, {withLogger = false}) async {
    if (withLogger) logger(oldData: accountList[id]!);
    if (accountList[id]?.accParentId != null) {
     await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(accountList[id]?.accParentId).update({
        'accChild': FieldValue.arrayRemove([id]),
      });
    }
   await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(id).delete();

   // Get.back();
    update();
  }

  //----=--=-=--=-=-==-==-=-=-==-=-=-==-=-=-=-=-=-=-=-=-=-=/-
  String? editItem;
  TextEditingController? editCon;

  var lastIndex;
  List<AccountTree> allCost = [];

  TreeController<AccountTree>? treeController;
  // void getAllCostCenter({String? goto}) {
  //   FirebaseFirestore.instance.collection(Const.accountsCollection).snapshots().listen((value) async {
  //     costCenterModelList.clear();
  //
  //     for (var element in value.docs) {
  //       print(element.data());
  //       costCenterModelList[element.id] = AccountModel.fromJson(element.data(), element.id);
  //     }
  //     // initModel();
  //     // initPage();
  //     // go(lastIndex);
  //     // update();
  //   });
  // }

  void initModel() {
    allCost.clear();
    List<AccountModel> rootList = accountList.values.toList().where((element) => element.accIsParent ?? false).toList();
    for (var element in rootList) {
      allCost.add(addToModel(element));
    }
  }

  AccountTree addToModel(AccountModel element) {
    var list = element.accChild.map((e) => addToModel(accountList[e]!)).toList();
    AccountTree model = AccountTree.fromJson({"name": element.accName}, element.accId, list);
    return model;
  }

  initPage() {
    treeController = TreeController<AccountTree>(
      roots: allCost,
      childrenProvider: (AccountTree node) => node.list,
    );
    update();
  }

  void setupParentList(parent) {
    allPer.add(accountList[parent]!.accId);
    if (accountList[parent]!.accParentId != null) {
      setupParentList(accountList[parent]!.accIsParent);
    }
  }


  var allPer = [];
  void go(String? parent) {
    if (parent != null) {
      allPer.clear();
      setupParentList(parent);
      var allper = allPer.reversed.toList();
      List<AccountTree> _ = treeController!.roots.toList();
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
    editCon = TextEditingController(text: accountList[id]!.accName!);
    update();
  }

  void endRenameChild() {
    FirebaseFirestore.instance.collection(Const.accountsCollection).doc(editItem).update({
      "accName": editCon?.text,
    });
    editItem = null;
    update();
  }
}

String getAccountIdFromText(text) {
  var accountController = Get.find<AccountViewModel>();
  if (text != null && text != " " && text != "") {
    AccountModel? _= accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == text);
        if(_==null){
          return"";
        }else{
          return _.accId!;
        }
  } else {
    print("empty");
    return "";
  }
}

String getAccountNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<AccountViewModel>().accountList[id]!.accName!;
  } else {
    return "";
  }
}

AccountModel? getAccountModelFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<AccountViewModel>().accountList[id]!;
  } else {
    return null;
  }


  // /--------------------------------------------------------------

}
