import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/target_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/target_management/task/add_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../model/seller/task_model.dart';

class AllTaskView extends StatelessWidget {
  const AllTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("عرض المهام"),
        ),
        body: GetBuilder<TargetController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: controller.allTarget.length,
                itemBuilder: (context, index) {
                  MapEntry<String, TaskModel> model = controller.allTarget.entries.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text(
                          "يجب بيع ",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          getProductNameFromId(model.value.taskProductId.toString()),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "بعدد",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model.value.taskQuantity.toString(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          "بتاريخ",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model.value.taskDate.toString(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          model.value.isTaskAvailable.toString(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "قائمة المشاركين",
                                  content: SizedBox(
                                    height: Get.width / 4,
                                    width: Get.width / 4,
                                    child: ListView.builder(
                                      itemCount: model.value.taskSellerListId.length,
                                      itemBuilder: (context, index) {
                                        String seller = model.value.taskSellerListId[index];
                                        return Text(getSellerNameFromId(seller).toString());
                                      },
                                    ),
                                  ));
                            },
                            child: const Text("قائمة المشاركين")),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () async {
                              checkPermissionForOperation(
                                AppConstants.roleUserUpdate,
                                AppConstants.roleViewTask,
                              ).then((value) async {
                                if (value) {
                                  Get.find<TargetController>().initTask(model.key);
                                  Get.to(() => AddTaskView(oldKey: model.key));
                                }
                              });
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blueAccent.shade700,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () async {
                              confirmDeleteWidget().then((value) {
                                if (value) {
                                  checkPermissionForOperation(
                                    AppConstants.roleUserDelete,
                                    AppConstants.roleViewTask,
                                  ).then((value) async {
                                    if (value) {
                                      controller.deleteTask(model.value);
                                    }
                                  });
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
