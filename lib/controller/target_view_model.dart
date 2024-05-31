import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Const/const.dart';
import '../model/seller_model.dart';
import '../model/target_model.dart';

class TargetViewModel extends GetxController{

  RxMap<String , TaskModel> allTarget = <String , TaskModel>{}.obs;

  TargetViewModel(){
    getAllTargets();
  }

  getAllTargets(){
    FirebaseFirestore.instance.collection(Const.tasksCollection).snapshots().listen((value) {
      allTarget.clear();
      for (var element in value.docs) {
        TaskModel model = TaskModel.fromJson(element.data());
        allTarget[model.taskId!] = model;
      }
      print(allTarget);
      update();
    });
  }

  void addTask(TaskModel targetModel) {
    targetModel.taskId = generateId(RecordType.task);
    FirebaseFirestore.instance.collection(Const.tasksCollection).doc(targetModel.taskId).set(targetModel.toJson());
  }

  void updateTask(TaskModel targetModel) {
    FirebaseFirestore.instance.collection(Const.tasksCollection).doc(targetModel.taskId).update(targetModel.toJson(),);
  }

  void deleteTask(TaskModel targetModel) {
    FirebaseFirestore.instance.collection(Const.tasksCollection).doc(targetModel.taskId).delete();
  }


  ({double mobileTotal,double otherTotal,  Map<String,int> productsMap}) checkTask(String sellerId) {
    double mobileTotal =0 ;
    double otherTotal =0 ;
    Map<String,int> productsMap= {};
   SellersViewModel sellersViewModel =  Get.find<SellersViewModel>();
   InvoiceViewModel invoiceViewModel =  Get.find<InvoiceViewModel>();
   sellersViewModel.allSellers[sellerId]?.sellerRecord?.forEach((element) {
     // total = total + double.parse(element.selleRecAmount!);
     invoiceViewModel.invoiceModel[element.selleRecInvId]?.invRecords?.forEach((e) {
      if (productsMap[e.invRecProduct!]==null){
         productsMap[e.invRecProduct!]=0;
       }
     if(e.invRecTotal!/e.invRecQuantity!>=1000){
       mobileTotal  =mobileTotal+  e.invRecTotal!;
     }else{
       otherTotal=otherTotal+ e.invRecTotal!;
     }
       productsMap[e.invRecProduct!]=productsMap[e.invRecProduct!]!+e.invRecQuantity!;
     });
   });
      print(productsMap);
   return (mobileTotal:mobileTotal,otherTotal:otherTotal,productsMap:productsMap);
  }


  List accountPickList = [];
  Future<String> getComplete(text) async {
    ProductViewModel productController  =Get.find<ProductViewModel>();
    var _ = '';
    accountPickList = [];
    productController.productDataMap.forEach((key, value) {
      accountPickList.addIf(!value.prodIsGroup!&&(value.prodCode!.toLowerCase().contains(text.toLowerCase()) ||value.prodFullCode!.toLowerCase().contains(text.toLowerCase()) || value.prodName!.toLowerCase().contains(text.toLowerCase())), value.prodName!);
    });
    // print(accountPickList.length);
    if (accountPickList.length > 1) {
      await Get.defaultDialog(
        title: "Chose form dialog",
        content: SizedBox(
          width: 500,
          height: 500,
          child: ListView.builder(
            itemCount: accountPickList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _ = accountPickList[index];
                  update();
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(
                      accountPickList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (accountPickList.length == 1) {
      _ = accountPickList[0];
    } else {
      Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
    }
    return _;
  }

}