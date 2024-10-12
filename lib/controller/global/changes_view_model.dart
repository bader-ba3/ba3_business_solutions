import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/generate_id.dart';
import '../../model/global/global_model.dart';
import '../../model/warranty/warranty_model.dart';
import '../account/account_view_model.dart';
import '../product/product_view_model.dart';
import '../store/store_view_model.dart';
import '../warranty/warranty_controller.dart';
import 'global_view_model.dart';

class ChangesViewModel extends GetxController {
  int padWidth = 8;
  List allReadFlags = [];

  ChangesViewModel() {
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
    FirebaseFirestore.instance.collection(AppConstants.changesCollection)/*.where("ali", isEqualTo: null)*/.snapshots().listen((value) async {
      // print("The Number Of Changes: " + value.docs.length.toString());
      print("I listen to Change!!!");
      for (var element in value.docs) {
        if (element.data()["ali"] != "asd") {
          print(element['changeType']);
          if (element['changeType'] == AppConstants.productsCollection) {
            ProductViewModel productViewModel = Get.find<ProductViewModel>();
            productViewModel.addProductToMemory(element.data());
          } else if (element['changeType'] == "remove_${AppConstants.productsCollection}") {
            ProductViewModel productViewModel = Get.find<ProductViewModel>();
            // enter this function
            print("enter a delete function");
            productViewModel.removeProductFromMemory(element.data());
          } else if (element['changeType'] == AppConstants.accountsCollection) {
            AccountViewModel accountViewModel = Get.find<AccountViewModel>();
            accountViewModel.addAccountToMemory(element.data());
          } else if (element['changeType'] == "remove_${AppConstants.accountsCollection}") {
            AccountViewModel accountViewModel = Get.find<AccountViewModel>();
            accountViewModel.removeAccountFromMemory(element.data());
          } else if (element['changeType'] == AppConstants.storeCollection) {
            StoreController storeViewModel = Get.find<StoreController>();
            storeViewModel.addStoreToMemory(element.data());
          } else if (element['changeType'] == "remove_${AppConstants.storeCollection}") {
            StoreController storeViewModel = Get.find<StoreController>();
            storeViewModel.removeStoreFromMemory(element.data());
          } else if (element['changeType'] == AppConstants.bondsCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.addGlobalBondToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == AppConstants.invoicesCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.addGlobalInvoiceToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == AppConstants.chequesCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.addGlobalChequeToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == "remove_${AppConstants.globalCollection}") {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
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
          if (element.data()["ali"] == null || element.data()["abd"] == null) {
            FirebaseFirestore.instance.collection(AppConstants.changesCollection).doc(element.id).set({"ali": true, ...element.data()});
          } else if (element.data()["abd"] != null) {
            // FirebaseFirestore.instance.collection(AppStrings.changesCollection).doc(element.id).delete();
          }
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
      "ali": true,
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
