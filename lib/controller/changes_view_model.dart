import 'dart:async';
import 'dart:math';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/Warranty/Controller/warranty_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Const/const.dart';
import '../model/Warranty_Model.dart';
import '../utils/generate_id.dart';

class ChangesViewModel extends GetxController {
  int padWidth = 8;
  List allReadFlags = [];

  ChangesViewModel() {

    FirebaseFirestore.instance.collection(Const.readFlagsCollection).doc("0").snapshots().listen((event) {
      allReadFlags.clear();
      print(event.data());
      allReadFlags = (event.data()?['allFlags'] ?? []).map((e) => e.toString()).toList();
    });
    Future.sync(() async {
      if (HiveDataBase.isNewUser.get("isNewUser") ?? true) {
        HiveDataBase.isNewUser.put("isNewUser", false);
        FirebaseFirestore.instance.collection(Const.readFlagsCollection).doc("0").set({
          "allFlags": FieldValue.arrayUnion([HiveDataBase.getMyReadFlag()]),
        }, SetOptions(merge: true));
        await FirebaseFirestore.instance.collection(Const.changesCollection).get().then((value) {
          HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", int.parse(value.docs.lastOrNull?.id ?? "1"));
        });
      }

    });
  }

  // getLastIndexChanges(){
  //   FirebaseFirestore.instance.collection(Const.changesCollection).get().then((value) {
  //     lastChangesIndex = int.parse(value.docs.last.id);
  //     print(lastChangesIndex);
  //     HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", lastChangesIndex);
  //   });
  // }

  listenChanges() {
    FirebaseFirestore.instance.collection(Const.settingCollection).get().then((event) {

    });
    FirebaseFirestore.instance.collection(Const.changesCollection)/*.where("changeId", isGreaterThan: HiveDataBase.lastChangesIndexBox.get("lastChangesIndex"))*/.snapshots().listen((value) async {
      // print("The Number Of Changes: " + value.docs.length.toString());
      print("I listen to Change!!!");
        for (var element in value.docs) {
          print(element['changeType']);
          if (element['changeType'] == Const.productsCollection) {
            ProductViewModel productViewModel = Get.find<ProductViewModel>();
            productViewModel.addProductToMemory(element.data());
          } else if (element['changeType'] == "remove_${Const.productsCollection}") {
            ProductViewModel productViewModel = Get.find<ProductViewModel>();
            //enter this function
            print("enter a delete function");
            productViewModel.removeProductFromMemory(element.data());
          } else if (element['changeType'] == Const.accountsCollection) {
            AccountViewModel accountViewModel = Get.find<AccountViewModel>();
            accountViewModel.addAccountToMemory(element.data());
          } else if (element['changeType'] == "remove_${Const.accountsCollection}") {
            AccountViewModel accountViewModel = Get.find<AccountViewModel>();
            accountViewModel.removeAccountFromMemory(element.data());
          } else if (element['changeType'] == Const.storeCollection) {
            StoreViewModel storeViewModel = Get.find<StoreViewModel>();
            storeViewModel.addStoreToMemory(element.data());
          } else if (element['changeType'] == "remove_" + Const.storeCollection) {
            StoreViewModel storeViewModel = Get.find<StoreViewModel>();
            storeViewModel.removeStoreFromMemory(element.data());
          } else if (element['changeType'] == Const.bondsCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.addGlobalBondToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == Const.invoicesCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.addGlobalInvoiceToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == Const.chequesCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.addGlobalChequeToMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == "remove_" + Const.globalCollection) {
            GlobalViewModel globalViewModel = Get.find<GlobalViewModel>();
            globalViewModel.deleteGlobalMemory(GlobalModel.fromJson(element.data()));
          } else if (element['changeType'] == "remove_${Const.warrantyCollection}") {
            WarrantyViewModel globalViewModel = Get.find<WarrantyViewModel>();
            globalViewModel.deleteInvoice(warrantyModel: WarrantyModel.fromJson(element.data()));
          } else if (element['changeType'] == Const.warrantyCollection) {
            WarrantyViewModel globalViewModel = Get.find<WarrantyViewModel>();
            globalViewModel.addToLocal(warrantyModel: WarrantyModel.fromJson(element.data()));
          } else {
            print("UNKNOWN CHANGE " * 20);
          }
          FirebaseFirestore.instance.collection(Const.changesCollection).doc(element.id).delete();
     /*     List readFlag = [];
          await element.reference.set({
            "allFlags": FieldValue.arrayUnion([HiveDataBase.getMyReadFlag()]),
          }, SetOptions(merge: true));
          element.reference.get().then((value) {
            if (value.data()!['allFlags'] != null && value.data()!['allFlags'] != []) {
              readFlag = value.data()!['allFlags'];
              //readFlag.add(HiveDataBase.getMyReadFlag());
              readFlag.sort(
                (a, b) => a.compareTo(b),
              );
            } else {
              // readFlag = [HiveDataBase.getMyReadFlag()];
            }
            allReadFlags.sort(
              (a, b) => a.compareTo(b),
            );
            print(allReadFlags.join(","));
            print(readFlag.join(","));
            print(allReadFlags.join(",").removeAllWhitespace == readFlag.join(",").removeAllWhitespace);
            if (allReadFlags.join(",").removeAllWhitespace == readFlag.join(",").removeAllWhitespace) {
              print("deleted");
              value.reference.delete();
            } else {}
          });*/

          // print(int.parse(element.data()['changeId'].toString()));
          // print("------"*30);
          // HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", int.parse(element.data()['changeId'].toString()));

        }

    });
  }

  String getLastChangesIndexWithPad() {
    return generateId(RecordType.changes) /*(HiveDataBase.lastChangesIndexBox.get("lastChangesIndex")! + 1).toString().padLeft(padWidth, "0")*/;
  }

  addChangeToChanges(Map json, changeType) async {
    String lastChangesIndex = getLastChangesIndexWithPad();
    print(lastChangesIndex);
    await FirebaseFirestore.instance.collection(Const.changesCollection).doc(lastChangesIndex).set({
      "changeType": changeType,
      "changeId": lastChangesIndex,
      ...json,
    });
    // await FirebaseFirestore.instance.collection(Const.settingCollection).doc("data").update({"lastChangesIndex": Random.secure().nextInt(999999999)});
  }

  addRemoveChangeToChanges(Map json, changeType) async {
    String _lastChangesIndex = getLastChangesIndexWithPad();
    print(_lastChangesIndex);
    await FirebaseFirestore.instance.collection(Const.changesCollection).doc(_lastChangesIndex).set({"changeType": "remove_" + changeType, "changeId": _lastChangesIndex, ...json});
    // FirebaseFirestore.instance.collection(Const.settingCollection).doc("data").update({"lastChangesIndex": Random.secure().nextInt(999999999)});
  }
}
