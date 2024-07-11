import 'package:ba3_business_solutions/controller/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds_old.dart';
import 'package:ba3_business_solutions/view/inventory/add_inventory_view.dart';
import 'package:ba3_business_solutions/view/inventory/all_inventory_view.dart';
import 'package:ba3_business_solutions/view/inventory/delete_inventory_view.dart';
import 'package:ba3_business_solutions/view/inventory/new_inventory_view.dart';
import 'package:ba3_business_solutions/view/invoices/all_Invoice_old.dart';
import 'package:ba3_business_solutions/view/patterns/all_pattern.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_details.dart';
import 'package:ba3_business_solutions/view/products/product_view_old_old.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../model/Pattern_model.dart';
import '../../model/inventory_model.dart';

class InventoryType extends StatefulWidget {
  const InventoryType({super.key});

  @override
  State<InventoryType> createState() => _InventoryTypeState();
}

class _InventoryTypeState extends State<InventoryType> {
  InventoryViewModel inventoryViewModel = Get.find<InventoryViewModel>();
  TextEditingController inventoryName = TextEditingController();
  InventoryModel? selectedInventory;
  @override
  void initState() {
    // selectedInventory = (inventoryViewModel.allInventory.isNotEmpty)?inventoryViewModel.allInventory.values.last:null;
    selectedInventory = HiveDataBase.inventoryModelBox.get("0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الجرد"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: selectedInventory != null
              ?Container(
                  width: double.infinity,
                 // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                         (selectedInventory?.inventoryName?.toString() ?? "") ,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(width: 50,),
                      Text(
                        ("تم إتمام :"+((selectedInventory!.inventoryRecord.length/selectedInventory!.inventoryTargetedProductList.length)*100).toString()+"%") ,
                        style: TextStyle(fontSize: 20),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ))
              :InkWell(
                onTap: () async {
                  checkPermissionForOperation(Const.roleUserWrite, Const.roleViewInventory).then((value) async {
                      if (value) {
                       await Get.to(()=>NewInventoryView());
                 selectedInventory = HiveDataBase.inventoryModelBox.get("0");
                 setState(() {});
                      };
                    });
                    },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      "انشئ جرد" ,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textDirection: TextDirection.rtl,
                    )),
              ),
            ),
            if (selectedInventory != null)
              Column(
                children: [
                  Item("إكمال الجرد", () {
                    checkPermissionForOperation(Const.roleUserWrite, Const.roleViewInventory).then((value) async {
                      if (value) {
                        await Get.to(() => AddInventoryView(inventoryModel: selectedInventory!));
                        selectedInventory = HiveDataBase.inventoryModelBox.get("0");
                        setState(() {});
                      };
                    });
                  }),
                  Item("معاينة الجرد", () {
                    checkPermissionForOperation(Const.roleUserRead, Const.roleViewInventory).then((value) {
                      if (value) Get.to(() => AllInventoryView(inventoryModel:selectedInventory!));
                    });
                  }),
                  Item("إنهاء الجرد", () {
                    checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewInventory).then((value) {
                       if (value) {
                         FirebaseFirestore.instance.collection(Const.inventoryCollection).doc(selectedInventory!.inventoryId).set(selectedInventory!.toJson());
                         HiveDataBase.inventoryModelBox.delete("0");
                         selectedInventory = null;
                         setState(() {});
                       }
                    });
                  }),
                  Item("حذف الجرد", () {
                    checkPermissionForOperation(Const.roleUserDelete, Const.roleViewInventory).then((value) {
                      if (value) {
                        HiveDataBase.inventoryModelBox.delete("0");
                        selectedInventory = null;
                        setState(() {});
                      }
                    });
                  }),

                ],
              ),
            Item("معاينة الجرد قديم", () {
              checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInventory).then((value) {
                if (value) {
                  Get.defaultDialog(
                    title: "إختر احد الجرود",
                    content: SizedBox(
                      height: MediaQuery.sizeOf(context).width/4,
                      width: MediaQuery.sizeOf(context).width/4,
                      child: ListView.builder(
                        itemCount: inventoryViewModel.allInventory.length,
                        itemBuilder:(context, index) {
                          InventoryModel inv = inventoryViewModel.allInventory.values.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: (){
                                Get.back();
                                Get.to(() => AllInventoryView(inventoryModel: inv!));
                              },
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(inv.inventoryName!+"         "+"قام به: "+getUserNameById(inv.inventoryUserId),textDirection: TextDirection.rtl,),
                          )),
                        );
                      },),
                    )
                  );

                }
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            )),
      ),
    );
  }
}
