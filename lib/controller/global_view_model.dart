import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/changes_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/cheques/add_cheque.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Const/const.dart';
import '../model/bond_record_model.dart';
import '../view/home/home_view.dart';
import 'invoice_view_model.dart';

class GlobalViewModel extends GetxController {
  Map<String, GlobalModel> allGlobalModel = {};
  ProductViewModel productController = Get.find<ProductViewModel>();
  StoreViewModel storeController = Get.find<StoreViewModel>();
  BondViewModel bondViewModel = Get.find<BondViewModel>();
  InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
  AccountViewModel accountViewModel = Get.find<AccountViewModel>();
  SellersViewModel sellerViewModel = Get.find<SellersViewModel>();
  ChequeViewModel chequeViewModel = Get.find<ChequeViewModel>();

  GlobalViewModel() {
    initFromLocal();
  }

  /// forEach on all item it's [SoSlow].
  Future<void> initFromLocal() async {
    print("-" * 20);
    print("YOU RUN LONG TIME OPERATION");
    print("-" * 20);
    bool needToReadNoVat = false;

    bool getNoVAt(bondId) {
      if (needToReadNoVat) {
        productController.productDataMap = Map.fromEntries(productController.productDataMap.entries.map((e) => MapEntry(e.key, e.value.generateNoVat()))).obs;
        return bondId.contains(Const.noVatKey);
      } else {
        return !bondId.contains(Const.noVatKey);
      }
    }

    allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values.where((element) => getNoVAt(element.bondId!)).map((e) => MapEntry(e.bondId!, e)).toList());
    if(allGlobalModel.isEmpty) {
     await FirebaseFirestore.instance.collection(Const.globalCollection).get().then((value) async {
      for (var element in value.docs) {

      // for (var element in value.docChanges) {
        if (element.data()?['isDeleted'] != null && element.data()?['isDeleted']) {
          if (HiveDataBase.globalModelBox.keys.contains(element.id)) {
            deleteGlobal(HiveDataBase.globalModelBox.get(element.id)!);

          }
          // } else if (!getNoVAt(element.doc.id)) {
          // } else if (!((element.doc.data()?['readFlags'] ?? []) as List).contains(HiveDataBase.getMyReadFlag())) {
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
          element.reference.update({
            'readFlags': FieldValue.arrayUnion([HiveDataBase.getMyReadFlag()]),
          });
          updateDataInAll(allGlobalModel[element.id]!);
        }
      }
    });
     if (Get.currentRoute == "/LoginView") {
       Get.offAll(() => HomeView());
     }
    }else{
      allGlobalModel.forEach((key, value) {
        updateDataInAll(value);
      });
      if (Get.currentRoute == "/LoginView") {
        Get.offAll(() => HomeView());
      }
    }
  }


  /////-Add
  Future<void> addGlobalBond(GlobalModel globalModel) async {
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
    allGlobalModel[globalModel.bondId!] = globalModel;
    updateDataInAll(globalModel);
    addInvoiceToFirebase(_);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), Const.invoicesCollection);
    showEInvoiceDialog(mobileNumber: globalModel.invMobileNumber ?? "", invId: globalModel.bondId!);
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
  }

  ////-Utils
  GlobalModel correctInvRecord(GlobalModel globalModel) {
    globalModel.invRecords?.removeWhere((element) => element.invRecId == null);
    globalModel.bondRecord?.removeWhere((element) => element.bondRecId == null);
    for (var element in globalModel.invRecords ?? []) {
      if (!(element.invRecProduct?.contains("prod") ?? true)) globalModel.invRecords?[globalModel.invRecords!.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
    }
    for (BondRecordModel element in globalModel.bondRecord ?? []) {
      if (!(element.bondRecAccount?.contains("acc") ?? true)) globalModel.bondRecord?[globalModel.bondRecord!.indexOf(element)].bondRecAccount = getAccountIdFromText(element.bondRecAccount);
    }
    return globalModel;
  }

  void addInvoiceToFirebase(GlobalModel globalModel) async {
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
      GlobalModel filteredGlobalModel = checkFreeZoneProduct(globalModel);
        if(filteredGlobalModel.invType != Const.invoiceTypeAdd){
          bondViewModel.initGlobalInvoiceBond(filteredGlobalModel);
          accountViewModel.initGlobalAccount(filteredGlobalModel);
          sellerViewModel.postRecord(userId: filteredGlobalModel.invSeller!, invId: filteredGlobalModel.invId, amount: filteredGlobalModel.invTotal!, date: filteredGlobalModel.invDate);
        }
      invoiceViewModel.initGlobalInvoice(filteredGlobalModel);
      productController.initGlobalProduct(filteredGlobalModel);
      storeController.initGlobalStore(filteredGlobalModel);
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

  GlobalModel checkFreeZoneProduct(GlobalModel filteredGlobalModel) {
    if(Const.isFilterFree){
      GlobalModel _ = GlobalModel.fromJson(filteredGlobalModel.toFullJson());
      for(var i =0;i<_.invRecords!.length;i++){
        if(_.invRecords![i].invRecIsLocal!){
        }else{
          _.invTotal = _.invTotal! - _.invRecords![i].invRecTotal!;
          _.invRecords!.removeAt(i);
        }
      }
      return _;
    }
    else{
    return filteredGlobalModel;
    }
  }

}
