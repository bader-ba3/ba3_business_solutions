import 'dart:async';
import 'dart:math';

import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Const/const.dart';

class ChangesViewModel extends GetxController{
  int padWidth = 8;

  ChangesViewModel(){

    Future.sync(() async {
      if(HiveDataBase.isNewUser.get("isNewUser")??true){
        HiveDataBase.isNewUser.put("isNewUser",false);
       await FirebaseFirestore.instance.collection(Const.changesCollection).get().then((value) {
          HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", int.parse(value.docs.last.id));
        });
      }
      listenChanges();
    });

  }

  // getLastIndexChanges(){
  //   FirebaseFirestore.instance.collection(Const.changesCollection).get().then((value) {
  //     lastChangesIndex = int.parse(value.docs.last.id);
  //     print(lastChangesIndex);
  //     HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", lastChangesIndex);
  //   });
  // }

  
  listenChanges(){
    FirebaseFirestore.instance.collection(Const.settingCollection).snapshots().listen((event) {
      print("I listen to Change!!!");
      FirebaseFirestore.instance.collection(Const.changesCollection).where("changeId",isGreaterThan:HiveDataBase.lastChangesIndexBox.get("lastChangesIndex") ).get().then((value) {
        print("The Number Of Changes: "+value.docs.length.toString());
        for (var element in value.docs) {
              if(element['changeType'] == Const.productsCollection){
                ProductViewModel productViewModel =Get.find<ProductViewModel>();
                productViewModel.addProductToMemory(element.data());
              }else if(element['changeType'] == "remove_"+Const.productsCollection){
                ProductViewModel productViewModel =Get.find<ProductViewModel>();
                productViewModel.removeProductFromMemory(element.data());
              }else if(element['changeType'] == Const.accountsCollection){
                AccountViewModel accountViewModel =Get.find<AccountViewModel>();
                accountViewModel.addAccountToMemory(element.data());
              }else if(element['changeType'] == "remove_"+Const.accountsCollection){
                AccountViewModel accountViewModel =Get.find<AccountViewModel>();
                accountViewModel.removeAccountFromMemory(element.data());
              }else if(element['changeType'] == Const.storeCollection){
                StoreViewModel storeViewModel =Get.find<StoreViewModel>();
                storeViewModel.addStoreToMemory(element.data());
              }else if(element['changeType'] == "remove_"+Const.storeCollection){
                StoreViewModel storeViewModel =Get.find<StoreViewModel>();
                storeViewModel.removeStoreFromMemory(element.data());
              } else if(element['changeType'] == Const.bondsCollection){
                GlobalViewModel globalViewModel =Get.find<GlobalViewModel>();
                globalViewModel.addGlobalBondToMemory(GlobalModel.fromJson(element.data()));
              } else if(element['changeType'] == Const.invoicesCollection){
                GlobalViewModel globalViewModel =Get.find<GlobalViewModel>();
                globalViewModel.addGlobalInvoiceToMemory(GlobalModel.fromJson(element.data()));
              } else if(element['changeType'] == Const.chequesCollection){
                GlobalViewModel globalViewModel =Get.find<GlobalViewModel>();
                globalViewModel.addGlobalChequeToMemory(GlobalModel.fromJson(element.data()));
              }else if(element['changeType'] == "remove_"+Const.globalCollection){
                GlobalViewModel globalViewModel =Get.find<GlobalViewModel>();
                globalViewModel.deleteGlobal(GlobalModel.fromJson(element.data()));
              }else{
                print("UNKNOWN CHANGE "*20);
              }

              print( int.parse(element.data()['changeId'].toString()));
              HiveDataBase.lastChangesIndexBox.put("lastChangesIndex", int.parse(element.data()['changeId'].toString()));
        }});
    });
  }

 String getLastChangesIndexWithPad(){
   return (HiveDataBase.lastChangesIndexBox.get("lastChangesIndex")!+1).toString().padLeft(padWidth,"0");
  }

  addChangeToChanges(Map json,changeType) async {
    String _lastChangesIndex = getLastChangesIndexWithPad();
    print(_lastChangesIndex);
   await FirebaseFirestore.instance.collection(Const.changesCollection).doc(_lastChangesIndex).set({
      "changeType":changeType,
      "changeId":int.parse(_lastChangesIndex),
      ...json,
    });
    await FirebaseFirestore.instance.collection(Const.settingCollection).doc("data").update({"lastChangesIndex":Random.secure().nextInt(999999999)});
  }

  addRemoveChangeToChanges(Map json,changeType) async {
    String _lastChangesIndex = getLastChangesIndexWithPad();
    print(_lastChangesIndex);
    await FirebaseFirestore.instance.collection(Const.changesCollection).doc(_lastChangesIndex).set({
      "changeType":"remove_"+changeType,
      "changeId":int.parse(_lastChangesIndex),
      ...json
    });
    FirebaseFirestore.instance.collection(Const.settingCollection).doc("data").update({"lastChangesIndex":Random.secure().nextInt(999999999)});
  }
}