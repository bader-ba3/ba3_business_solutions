import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/changes_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/cheques/add_cheque.dart';
import 'package:ba3_business_solutions/view/user_management/role_management/role_management_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../Const/const.dart';
import '../core/bindings.dart';
import '../model/bond_record_model.dart';
import '../view/home/home_view.dart';
import '../view/main/main_screen.dart';
import '../view/user_management/account_management_view.dart';
import 'cards_view_model.dart';
import 'cost_center_view_model.dart';
import 'database_view_model.dart';
import 'import_view_model.dart';
import 'invoice_view_model.dart';

class GlobalViewModel extends GetxController {
  Map<String, GlobalModel> allGlobalModel = {};
  bool isDrawerOpen = true;
  ProductViewModel productController = Get.find<ProductViewModel>();
  StoreViewModel storeController = Get.find<StoreViewModel>();
  BondViewModel bondViewModel = Get.find<BondViewModel>();
  InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
  AccountViewModel accountViewModel = Get.find<AccountViewModel>();
  SellersViewModel sellerViewModel = Get.find<SellersViewModel>();
  ChequeViewModel chequeViewModel = Get.find<ChequeViewModel>();

  GlobalViewModel() {
    // deleteAllLocal();

    initFromLocal();
  }

  /// forEach on all item it's [SoSlow].
  Future<void> initFromLocal() async {
    allGlobalModel.clear();
    print("-" * 20);
    print("YOU RUN LONG TIME OPERATION");
    print("-" * 20);

    allGlobalModel =Map.fromEntries(HiveDataBase.globalModelBox.values.map((e) => MapEntry(e.bondId!, e)).toList());
    if(allGlobalModel.isEmpty) {
     await FirebaseFirestore.instance.collection(Const.globalCollection).get().then((value) async {
      for (var element in value.docs) {
      // for (var element in value.docChanges) {
        if (element.data()?['isDeleted'] != null && element.data()?['isDeleted']) {
          if (HiveDataBase.globalModelBox.keys.contains(element.id)) {
            deleteGlobal(HiveDataBase.globalModelBox.get(element.id)!);
          }
          // } else if (!getNoVAt(element.doc.id)) {
        }else{
          allGlobalModel[element.id] = GlobalModel.fromJson(element.data());
          allGlobalModel[element.id]?.invRecords = [];
          allGlobalModel[element.id]?.bondRecord = [];
          allGlobalModel[element.id]?.cheqRecords = [];
          await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.id).collection(Const.invoiceRecordCollection).get().then((value) {
            allGlobalModel[element.id]?.invRecords = value.docs.map((e) => InvoiceRecordModel.fromJson(e.data())).toList();
          });
          await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.id).collection(Const.chequeRecordCollection).get().then((value) {
            allGlobalModel[element.id]?.cheqRecords = value.docs.map((e) => ChequeRecModel.fromJson(e.data())).toList();
          });
          await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.id).collection(Const.bondRecordCollection).get().then((value) {
            allGlobalModel[element.id]?.bondRecord = value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
          });
          HiveDataBase.globalModelBox.put(allGlobalModel[element.id]?.bondId, allGlobalModel[element.id]!);
          updateDataInAll(allGlobalModel[element.id]!);
        }
      }
    });
     if (Get.currentRoute == "/LoginView") {
       Get.offAll(() => MainScreen());
     }
    }
    else{
      allGlobalModel.forEach((key, value) {
        updateDataInAll(value);
      });
      if (Get.currentRoute == "/LoginView") {
        Get.offAll(() => MainScreen());
      }
    }
  }

changeFreeType(type) async {
    HiveDataBase.setIsFree(type);
    Const.init(isFree: type);
   await Get.deleteAll(force: true);
   Get.put(UserManagementViewModel(),permanent: true);
   Get.put(AccountViewModel(),permanent: true);
   Get.put(StoreViewModel(),permanent: true);
   Get.put(ProductViewModel(),permanent: true);
   Get.put(BondViewModel(),permanent: true);
   Get.put(PatternViewModel(),permanent: true);
   Get.put(SellersViewModel(),permanent: true);
   Get.put(InvoiceViewModel(),permanent: true);
   Get.put(ChequeViewModel(),permanent: true);
   Get.put(CostCenterViewModel(),permanent: true);
   Get.put(IsolateViewModel(),permanent: true);
   Get.put(DataBaseViewModel(),permanent: true);
   Get.put(ImportViewModel(),permanent: true);
   Get.put(CardsViewModel(),permanent: true);
   Get.offAll(
         () => UserManagement(),
     binding: GetBinding(),
   );
}

  /////-Add
  Future<void> addGlobalBond(GlobalModel globalModel) async{
    globalModel.bondDate ??= DateTime.now().toString();
  globalModel.globalType = Const.globalTypeBond;
    globalModel.bondId = generateId(RecordType.bond);
    allGlobalModel[globalModel.bondId!] = globalModel;
    // addGlobalToLocal(globalModel);
    addBondToFirebase(globalModel);
    updateDataInAll(globalModel);
    bondViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.bondsCollection);
    update();
  }

  void addGlobalBondToMemory(GlobalModel globalModel) {
    addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    bondViewModel.update();
    update();
  }

  void addGlobalCheque(GlobalModel globalModel) {
    globalModel.globalType = Const.globalTypeCheque;
    globalModel.bondId = generateId(RecordType.bond);
    allGlobalModel[globalModel.bondId!] = globalModel;
    addChequeToFirebase(globalModel);
    updateDataInAll(globalModel);
    chequeViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.chequesCollection);
    update();
  }

  void addGlobalInvoice(GlobalModel globalModel) {
    GlobalModel _ = correctInvRecord(globalModel);
    UserManagementViewModel userManagementViewModel =Get.find<UserManagementViewModel>();
    if((userManagementViewModel.allRole[getMyUserRole()]?.roles[Const.roleViewInvoice]?.contains(Const.roleUserAdmin))??false){
      _.invIsPending = false;
    }else{
      _.invIsPending = true;
    }
    allGlobalModel[_.bondId!] = _;
    updateDataInAll(_);
    addInvoiceToFirebase(_);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(_.toFullJson(), Const.invoicesCollection);
    showEInvoiceDialog(mobileNumber: _.invMobileNumber ?? "", invId: _.bondId!);
    // invoiceViewModel.updateCodeList();
    invoiceViewModel.update();
    update();
  }

  void addGlobalInvoiceToMemory(GlobalModel globalModel) {
    addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    invoiceViewModel.update();
    update();
  }

  void addGlobalChequeToMemory(GlobalModel globalModel) {
    addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    chequeViewModel.update();
    update();
  }

  void addGlobalToLocal(GlobalModel globalModel) {
    HiveDataBase.globalModelBox.put(globalModel.bondId, globalModel);
  }

  ////-Update
  void updateGlobalInvoice(GlobalModel globalModel) {
    GlobalModel _ = correctInvRecord(globalModel);
    addInvoiceToFirebase(_);
    allGlobalModel[globalModel.bondId!] = globalModel;
    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.invoicesCollection);
    update();
  }

  Future<void> updateGlobalBond(GlobalModel globalModel) async {
    allGlobalModel[globalModel.bondId!] = globalModel;
  await  addBondToFirebase(globalModel);
    bondViewModel.initGlobalBond(globalModel);
    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.bondsCollection);
    update();
  }

  void updateGlobalCheque(GlobalModel globalModel) {
    allGlobalModel[globalModel.bondId!] = globalModel;
    updateDataInAll(globalModel);
    addChequeToFirebase(globalModel);
    chequeViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.chequesCollection);
    update();
  }

  ////--Delete
  void deleteGlobal(GlobalModel globalModel) {
    FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set({"isDeleted": true}, SetOptions(merge: true));
    deleteGlobalFromLocal(globalModel);
    deleteDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addRemoveChangeToChanges(globalModel.toFullJson(), Const.globalCollection);
    update();
  }

  void deleteGlobalMemory(GlobalModel globalModel) {
    deleteGlobalFromLocal(globalModel);
    deleteDataInAll(globalModel);
    update();
  }

  void deleteGlobalFromLocal(GlobalModel globalModel) {
    HiveDataBase.globalModelBox.delete(globalModel.bondId);
  }

  void deleteAllLocal() {
    HiveDataBase.globalModelBox.deleteFromDisk();
    HiveDataBase.accountModelBox.deleteFromDisk();
    HiveDataBase.storeModelBox.deleteFromDisk();
    HiveDataBase.productModelBox.deleteFromDisk();
    HiveDataBase.lastChangesIndexBox.deleteFromDisk();
    HiveDataBase.constBox.deleteFromDisk();
    HiveDataBase.isNewUser.deleteFromDisk();
  }

  ////-Utils
  GlobalModel correctInvRecord(GlobalModel globalModel) {
    globalModel.invRecords?.removeWhere((element) => element.invRecId == null);
    globalModel.bondRecord?.removeWhere((element) => element.bondRecId == null);
    globalModel.invDiscountRecord?.removeWhere((element) => element.discountId == null);
    for (var element in globalModel.invRecords ?? []) {
      if (!(element.invRecProduct?.contains("prod") ?? true)) globalModel.invRecords?[globalModel.invRecords!.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
    }
    for (BondRecordModel element in globalModel.bondRecord ?? []) {
      if (!(element.bondRecAccount?.contains("acc") ?? true)) globalModel.bondRecord?[globalModel.bondRecord!.indexOf(element)].bondRecAccount = getAccountIdFromText(element.bondRecAccount);
    }
    return globalModel;
  }

   addInvoiceToFirebase(GlobalModel globalModel) async {
    try {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.invoiceRecordCollection).get().then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    } catch (e) {}
    globalModel.invRecords?.forEach((element) async {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.invoiceRecordCollection).doc(element.invRecId).set(element.toJson());
    });

    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set(globalModel.toJson());
  }

  Future addBondToFirebase(GlobalModel globalModel) async {
    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.bondRecordCollection).get().then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });
    globalModel.bondRecord?.forEach((element) async {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.bondRecordCollection).doc(element.bondRecId).set(element.toJson());
    });
    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set(globalModel.toJson());
  }

  void addChequeToFirebase(GlobalModel globalModel) async {
    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.chequeRecordCollection).get().then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });
    globalModel.cheqRecords?.forEach((element) async {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.chequeRecordCollection).doc(element.cheqRecBondId).set(element.toJson());
    });
    await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set(globalModel.toJson());
  }

  updateDataInAll(GlobalModel globalModel) {
    if (globalModel.globalType == Const.globalTypeInvoice) {
      GlobalModel? filteredGlobalModel = checkFreeZoneProduct(globalModel);
      if(filteredGlobalModel == null ){
        return ;
      }
      if(!globalModel.invIsPending!){
        if (filteredGlobalModel.invType != Const.invoiceTypeAdd) {
          bondViewModel.initGlobalInvoiceBond(filteredGlobalModel);
          sellerViewModel.postRecord(userId: filteredGlobalModel.invSeller!, invId: filteredGlobalModel.invId, amount: filteredGlobalModel.invTotal!, date: filteredGlobalModel.invDate);
        }
        accountViewModel.initGlobalAccount(filteredGlobalModel);
        productController.initGlobalProduct(filteredGlobalModel);
        storeController.initGlobalStore(filteredGlobalModel);
      }
      invoiceViewModel.initGlobalInvoice(filteredGlobalModel);
    } else if (globalModel.globalType == Const.globalTypeCheque) {
      chequeViewModel.initGlobalCheque(globalModel);
    } else if (globalModel.globalType == Const.globalTypeBond) {
      bondViewModel.initGlobalBond(globalModel);
      accountViewModel.initGlobalAccount(globalModel);
    }
  }

  deleteDataInAll(GlobalModel globalModel) {
    if (globalModel.globalType == Const.globalTypeInvoice) {
      invoiceViewModel.deleteGlobalInvoice(globalModel);
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
      productController.deleteGlobalProduct(globalModel);
      storeController.deleteGlobalStore(globalModel);
      sellerViewModel.deleteGlobalSeller(globalModel);
    } else if (globalModel.globalType == Const.globalTypeCheque) {
      chequeViewModel.deleteGlobalCheque(globalModel);
    } else if (globalModel.globalType == Const.globalTypeBond) {
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
    }
  }

  GlobalModel generateNoVatModel(GlobalModel globalModel) {
    GlobalModel noVatGlobalModel = GlobalModel.fromJson(globalModel.toFullJson());
    noVatGlobalModel.bondId = Const.noVatKey + noVatGlobalModel.bondId!;
    noVatGlobalModel.invId = Const.noVatKey + noVatGlobalModel.invId!;
    noVatGlobalModel.invTotal = 0;
    for (var i = 0; i < (noVatGlobalModel.invRecords?.length ?? 0); i++) {
      noVatGlobalModel.invRecords?[i].invRecTotal = noVatGlobalModel.invRecords![i].invRecSubTotal! * noVatGlobalModel.invRecords![i].invRecQuantity!;
      noVatGlobalModel.invTotal = noVatGlobalModel.invRecords![i].invRecTotal! + noVatGlobalModel.invTotal!;
      noVatGlobalModel.invRecords?[i].invRecVat = 0;
    }
    return noVatGlobalModel;
  }

  GlobalModel? checkFreeZoneProduct(GlobalModel filteredGlobalModel) {
    if(HiveDataBase.isFree.get("isFree")!){
      GlobalModel _ = GlobalModel.fromJson(filteredGlobalModel.toFullJson());
      for(var i =0;i<_.invRecords!.length;i++){
        if(_.invRecords![i].invRecIsLocal!){
        }else{
          _.invTotal = _.invTotal! - _.invRecords![i].invRecTotal!;
          _.invRecords!.removeAt(i);
        }
      }
      if(_.invRecords!.isEmpty){
        return null;
      }else{
        return _;
      }

    }
    else{
    return filteredGlobalModel;
    }
  }

}
