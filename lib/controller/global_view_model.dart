import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
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
  var productController = Get.find<ProductViewModel>();
  var storeController = Get.find<StoreViewModel>();
  BondViewModel bondViewModel = Get.find<BondViewModel>();
  InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
  AccountViewModel accountViewModel = Get.find<AccountViewModel>();
  SellersViewModel sellerViewModel = Get.find<SellersViewModel>();

  GlobalViewModel() {
    initFromLocal();
  }

  /// forEach on all item it's [SoSlow].
  Future<void> initFromLocal() async {
    print("-" * 20);
    print("YOU RUN LONG TIME OPERATION");
    print("-" * 20);

    allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values.map((e) => MapEntry(e.bondId!, e)).toList());

    await FirebaseFirestore.instance.collection(Const.globalCollection).snapshots().listen((value) async {
      for (var element in value.docChanges) {
        print("the changed is : "+element.type.toString() );
        if (element.doc.data()?['isDeleted'] != null && element.doc.data()?['isDeleted']) {
          if (HiveDataBase.globalModelBox.keys.contains(element.doc.id)) {
            deleteGlobal(HiveDataBase.globalModelBox.get(element.doc.id)!);
          }
        } else if (!((element.doc.data()?['readFlags'] ?? []) as List).contains(HiveDataBase.getMyReadFlag())) {
          allGlobalModel[element.doc.id] = GlobalModel.fromJson(element.doc.data());
          allGlobalModel[element.doc.id]?.invRecords = [];
          allGlobalModel[element.doc.id]?.bondRecord = [];
          allGlobalModel[element.doc.id]?.cheqRecords = [];
          await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.doc.id).collection(Const.invoiceRecordCollection).get().then((value) {
            allGlobalModel[element.doc.id]?.invRecords = value.docs.map((e) => InvoiceRecordModel.fromJson(e.data())).toList();
          });
          await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.doc.id).collection(Const.chequeRecordCollection).get().then((value) {
            allGlobalModel[element.doc.id]?.cheqRecords = value.docs.map((e) => ChequeRecModel.fromJson(e.data())).toList();
          });
          await FirebaseFirestore.instance.collection(Const.globalCollection).doc(element.doc.id).collection(Const.bondRecordCollection).get().then((value) {
            allGlobalModel[element.doc.id]?.bondRecord = value.docs.map((e) => BondRecordModel.fromJson(e.data())).toList();
          });
          HiveDataBase.globalModelBox.put(allGlobalModel[element.doc.id]?.bondId, allGlobalModel[element.doc.id]!);
          element.doc.reference.update({
            'readFlags': FieldValue.arrayUnion([HiveDataBase.getMyReadFlag()]),
          });
          updateDataInAll(allGlobalModel[element.doc.id]!);
        } else {
          updateDataInAll(allGlobalModel[element.doc.id]!);
        }
      }
      if (Get.currentRoute == "/LoginView") {
        Get.offAll(() => HomeView());
      }
    });
  }


  /////-Add
  void addGlobalBond(GlobalModel globalModel) {
    globalModel.globalType = Const.globalTypeBond;
    globalModel.bondId = generateId(RecordType.bond);
    allGlobalModel[globalModel.bondId!]=globalModel;
    addGlobalToLocal(globalModel);
    addBondToFirebase(globalModel);
    updateDataInAll(globalModel);
    bondViewModel.update();
    update();
  }

  void addGlobalCheque(GlobalModel globalModel) {
    globalModel.globalType = Const.globalTypeCheque;
    globalModel.bondId = generateId(RecordType.bond);
    allGlobalModel[globalModel.bondId!]=globalModel;
    addGlobalToLocal(globalModel);
    addChequeToFirebase(globalModel);
    updateDataInAll(globalModel);
    chequeController.update();
    update();
  }

  void addGlobalInvoice(GlobalModel globalModel) {
    GlobalModel _ = correctInvRecord(globalModel);
    allGlobalModel[globalModel.bondId!]=globalModel;
    updateDataInAll(globalModel);
    addGlobalToLocal(_);
    addInvoiceToFirebase(_);
    showEInvoiceDialog(mobileNumber: globalModel.invMobileNumber??"", invId: globalModel.bondId!);
   // invoiceViewModel.updateCodeList();
    invoiceViewModel.update();
    update();
  }

  void addGlobalToLocal(GlobalModel globalModel) {
    HiveDataBase.globalModelBox.put(globalModel.bondId, globalModel);
  }

  ////-Update
  void updateGlobalInvoice(GlobalModel globalModel) {
    GlobalModel _ = correctInvRecord(globalModel);
    addGlobalToLocal(_);
    addInvoiceToFirebase(_);
    allGlobalModel[globalModel.bondId!] = globalModel;
    updateDataInAll(globalModel);
    update();
  }

  void updateGlobalBond(GlobalModel globalModel) {
    allGlobalModel[globalModel.bondId!] = globalModel;
    bondViewModel.initGlobalBond(globalModel);
    updateDataInAll(globalModel);
    addGlobalToLocal(globalModel);
    addBondToFirebase(globalModel);
    update();
  }

  void updateGlobalCheque(GlobalModel globalModel) {
    allGlobalModel[globalModel.bondId!] = globalModel;
    updateDataInAll(globalModel);
    addGlobalToLocal(globalModel);
    addChequeToFirebase(globalModel);
    chequeController.update();
    update();
  }

  ////--Delete
  void deleteGlobal(GlobalModel globalModel) {
    FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).set({"isDeleted": true}, SetOptions(merge: true));
    deleteGlobalFromLocal(globalModel);
    deleteDataInAll(globalModel);

    update();
  }

  void deleteGlobalFromLocal(GlobalModel globalModel) {
    HiveDataBase.globalModelBox.delete(globalModel.bondId);
  }

  void deleteAllLocal() {
    HiveDataBase.globalModelBox.deleteFromDisk();
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

    //FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(collectionPath)
  }

  void addBondToFirebase(GlobalModel globalModel) async {
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
      invoiceViewModel.initGlobalInvoice(globalModel);
      bondViewModel.initGlobalInvoiceBond(globalModel);
      accountViewModel.initGlobalAccount(globalModel);
      productController.initGlobalProduct(globalModel);
      storeController.initGlobalStore(globalModel);
      sellerViewModel.postRecord(userId: globalModel.invSeller!, invId: globalModel.invId, amount: globalModel.invTotal!, date: globalModel.invDate);
    } else if (globalModel.globalType == Const.globalTypeCheque) {
      chequeController.initGlobalCheque(globalModel);
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
      chequeController.deleteGlobalCheque(globalModel);
    } else if (globalModel.globalType == Const.globalTypeBond) {
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
    }
  }

}
