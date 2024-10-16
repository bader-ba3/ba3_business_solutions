import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/generate_id.dart';
import '../../model/global/global_model.dart';
import '../../model/warranty/warranty_model.dart';
import '../account/account_controller.dart';
import '../product/product_controller.dart';
import '../store/store_controller.dart';
import '../warranty/warranty_controller.dart';
import 'global_controller.dart';

class ChangesController extends GetxController {
  int padWidth = 8;
  List allReadFlags = [];

  ChangesController() {
    /*  FirebaseFirestore.instance.collection(AppStrings.readFlagsCollection).doc("0").snapshots().listen((event) {
      allReadFlags.clear();
      print(event.data());
      allReadFlags = (event.data()?['allFlags'] ?? []).map((e) => e.toString()).toList();
    });
    Future.sync(() async {
      if (HiveDataBase.isNewUser.get("isNewUser") ?? true) {
        HiveDataBase.isNewUser.put("isNewUser", false);
        FirebaseFirestore.instance.collection(AppStrings.readFlagsCollection).doc("0").set({
          "allFlags": FieldValue.arrayUnion([HiveDataBase.getMyReadFlag()]),
        }, SetOptions(merge: true));
        await FirebaseFirestore.instance.collection(AppStrings.changesCollection).get().then((value) {
          HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", int.parse(value.docs.lastOrNull?.id ?? "1"));
        });
      }

    });*/
  }

  getLastIndexChanges() {
/*    FirebaseFirestore.instance.collection(AppStrings.changesCollection).get().then((value) {
      AppStrings lastChangesIndex = int.parse(value.docs.last.id);
      print(lastChangesIndex);
      HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", lastChangesIndex);
    });*/
  }

  listenChanges() {
    FirebaseFirestore.instance.collection(AppConstants.changesCollection).where(AppConstants.userName, isEqualTo: null).snapshots().listen((value) async {
      // print("The Number Of Changes: " + value.docs.length.toString());
      print("I listen to Change!!!");
      for (var element in value.docs) {
        if (element.data()[AppConstants.userName] == null) {
          print(element['changeType']);
          if (element['changeType'] == AppConstants.productsCollection) {
            ProductController productViewModel = Get.find<ProductController>();
            productViewModel.addProductToMemory(element.data());
          } else if (element['changeType'] == "remove_${AppConstants.productsCollection}") {
            ProductController productViewModel = Get.find<ProductController>();
            // enter this function
            print("enter a delete function");
            productViewModel.removeProductFromMemory(element.data());
          } else if (element['changeType'] == AppConstants.accountsCollection) {
            AccountController accountViewModel = Get.find<AccountController>();
            accountViewModel.addAccountToMemory(element.data());
          } else if (element['changeType'] == "remove_${AppConstants.accountsCollection}") {
            AccountController accountViewModel = Get.find<AccountController>();
            accountViewModel.removeAccountFromMemory(element.data());
          } else if (element['changeType'] == AppConstants.storeCollection) {
            StoreController storeViewModel = Get.find<StoreController>();
            storeViewModel.addStoreToMemory(element.data());
          } else if (element['changeType'] == "remove_${AppConstants.storeCollection}") {
            StoreController storeViewModel = Get.find<StoreController>();
            storeViewModel.removeStoreFromMemory(element.data());
          } else if (element['changeType'] == AppConstants.bondsCollection) {
            GlobalController globalViewModel = Get.find<GlobalController>();
            globalViewModel.addGlobalBondToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == AppConstants.invoicesCollection) {
            GlobalController globalViewModel = Get.find<GlobalController>();
            globalViewModel.addGlobalInvoiceToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == AppConstants.chequesCollection) {
            GlobalController globalViewModel = Get.find<GlobalController>();
            globalViewModel.addGlobalChequeToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == "remove_${AppConstants.globalCollection}") {
            GlobalController globalViewModel = Get.find<GlobalController>();
            globalViewModel.deleteGlobalMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == "remove_${AppConstants.warrantyCollection}") {
            WarrantyController globalViewModel = Get.find<WarrantyController>();
            globalViewModel.deleteInvoice(warrantyModel: WarrantyModel.fromJson(element.data()));
          } else if (element['changeType'] == AppConstants.warrantyCollection) {
            WarrantyController globalViewModel = Get.find<WarrantyController>();
            globalViewModel.addToLocal(warrantyModel: WarrantyModel.fromJson(element.data()));
          } else {
            print("UNKNOWN CHANGE " * 20);
          }
          if (element.data()[AppConstants.userName] == null /*|| element.data()["abd"] == null*/) {
            FirebaseFirestore.instance.collection(AppConstants.changesCollection).doc(element.id).set({AppConstants.userName: true, ...element.data()});
          } /*else if (element.data()["abd"] != null) {
            // FirebaseFirestore.instance.collection(AppStrings.changesCollection).doc(element.id).delete();
          }*/
        }
      }
    });
  }

  String getLastChangesIndexWithPad() {
    return generateId(RecordType.changes) /*(HiveDataBase.lastChangesIndexBox.get("lastChangesIndex")! + 1).toString().padLeft(padWidth, "0")*/;
  }

  addChangeToChanges(Map json, changeType) async {
    String lastChangesIndex = getLastChangesIndexWithPad();
    print(lastChangesIndex);
    await FirebaseFirestore.instance.collection(AppConstants.changesCollection).doc(lastChangesIndex).set({
      AppConstants.userName: true,
      "changeType": changeType,
      "changeId": lastChangesIndex,
      ...json,
    });
    // await FirebaseFirestore.instance.collection(Const.settingCollection).doc("data").update({"lastChangesIndex": Random.secure().nextInt(999999999)});
  }

  addRemoveChangeToChanges(Map json, changeType) async {
    String lastChangesIndex = getLastChangesIndexWithPad();
    print(lastChangesIndex);
    await FirebaseFirestore.instance
        .collection(AppConstants.changesCollection)
        .doc(lastChangesIndex)
        .set({"changeType": "remove_" + changeType, "changeId": lastChangesIndex, ...json});
    // FirebaseFirestore.instance.collection(Const.settingCollection).doc("data").update({"lastChangesIndex": Random.secure().nextInt(999999999)});
  }
}
