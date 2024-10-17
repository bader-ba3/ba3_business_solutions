import 'package:ba3_business_solutions/controller/inventory/inventory_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_menu_item.dart';
import 'package:ba3_business_solutions/view/inventory/pages/add_inventory_view.dart';
import 'package:ba3_business_solutions/view/inventory/pages/all_inventory_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../data/model/inventory/inventory_model.dart';
import 'add_new_inventory_view.dart';

class InventoryLayout extends StatelessWidget {
  const InventoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryController>(builder: (controller) {
      InventoryModel? selectedInventory = controller.getSelectedInventory;

      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("الجرد"),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: selectedInventory != null
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                        child: Row(
                          children: [
                            Text(
                              (selectedInventory.inventoryName?.toString() ?? ""),
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            Text(
                              ("تم إتمام :${(selectedInventory.inventoryRecord.length / selectedInventory.inventoryTargetedProductList.length) * 100}%"),
                              style: const TextStyle(fontSize: 20),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ))
                    : InkWell(
                        onTap: () async {
                          hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewInventory).then((value) async {
                            if (value) {
                              await Get.to(() => const AddNewInventoryView());
                              // selectedInventory = HiveDataBase.inventoryModelBox.get("0");
                              // setState(() {});
                            }
                          });
                        },
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.all(30.0),
                            child: const Center(
                              child: Text(
                                "انشئ جرد",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                              ),
                            )),
                      ),
              ),
              if (selectedInventory != null)
                Column(
                  children: [
                    AppMenuItem(
                        text: "إكمال الجرد",
                        onTap: () {
                          hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewInventory).then((value) async {
                            if (value) {
                              await Get.to(() => AddInventoryView(inventoryModel: selectedInventory));
                              // selectedInventory = HiveDataBase.inventoryModelBox.get("0");
                              // setState(() {});
                            }
                          });
                        }),
                    AppMenuItem(
                        text: "معاينة الجرد",
                        onTap: () {
                          hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewInventory).then((value) {
                            if (value) {
                              Get.to(() => AllInventoryView(inventoryModel: selectedInventory));
                            }
                          });
                        }),
                    AppMenuItem(
                        text: "إنهاء الجرد",
                        onTap: () {
                          hasPermissionForOperation(AppConstants.roleUserUpdate, AppConstants.roleViewInventory).then((value) {
                            if (value) {
                              print(selectedInventory.toJson());
                              FirebaseFirestore.instance
                                  .collection(AppConstants.inventoryCollection)
                                  .doc(selectedInventory.inventoryId)
                                  .set((selectedInventory..isDone = true).toJson(), SetOptions(merge: true));
                              // HiveDataBase.inventoryModelBox.delete("0");
                              // selectedInventory = null;
                              // setState(() {});
                              controller.update();
                            }
                          });
                        }),
                    AppMenuItem(
                        text: "حذف الجرد",
                        onTap: () {
                          hasPermissionForOperation(AppConstants.roleUserDelete, AppConstants.roleViewInventory).then((value) {
                            if (value) {
                              confirmDeleteWidget().then((value) {
                                if (value) {
                                  FirebaseFirestore.instance.collection(AppConstants.inventoryCollection).doc(selectedInventory.inventoryId).delete();

                                  controller.update();
                                  // HiveDataBase.inventoryModelBox.delete("0");
                                  // selectedInventory = null;
                                  // setState(() {});
                                }
                              });
                            }
                          });
                        }),
                  ],
                ),
              AppMenuItem(
                  text: "معاينة الجرد قديم",
                  onTap: () {
                    hasPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewInventory).then((value) {
                      if (value) {
                        Get.defaultDialog(
                            title: "إختر احد الجرود",
                            content: SizedBox(
                              height: MediaQuery.sizeOf(context).width / 4,
                              width: MediaQuery.sizeOf(context).width / 4,
                              child: ListView.builder(
                                itemCount: controller.allInventory.length,
                                itemBuilder: (context, index) {
                                  InventoryModel inv = controller.allInventory.values.toList()[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        onTap: () {
                                          Get.back();
                                          Get.to(() => AllInventoryView(inventoryModel: inv));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${inv.inventoryName!}         قام به: " + getUserNameById(inv.inventoryUserId),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        )),
                                  );
                                },
                              ),
                            ));
                      }
                    });
                  }),
            ],
          ),
        ),
      );
    });
  }
}
