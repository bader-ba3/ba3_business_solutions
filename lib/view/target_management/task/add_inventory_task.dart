import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/target_view_model.dart';
import 'package:ba3_business_solutions/model/inventory/inventory_model.dart';
import 'package:ba3_business_solutions/model/seller/task_model.dart';
import 'package:ba3_business_solutions/view/target_management/task/select_inventory_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../controller/user/user_management_model.dart';
import '../../../model/user/user_model.dart';

class AddInventoryTaskView extends StatefulWidget {
  final String? oldKey;

  const AddInventoryTaskView({super.key, this.oldKey});

  @override
  State<AddInventoryTaskView> createState() => _AddInventoryTaskViewState();
}

class _AddInventoryTaskViewState extends State<AddInventoryTaskView> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TargetViewModel targetViewModel = Get.find<TargetViewModel>();
  List<String> allUser = [];
  late TaskModel taskModel;
  InventoryModel? inventoryModel;

  @override
  void initState() {
    if (widget.oldKey == null) {
      taskModel = TaskModel(taskType: AppConstants.taskTypeInventory);
      allUser.clear();
    } else {
      taskModel = TaskModel.fromJson(
          targetViewModel.allTarget[widget.oldKey]!.toJson());
      productNameController.text =
          getProductNameFromId(taskModel.taskProductId);
      quantityController.text = taskModel.taskQuantity.toString();
      allUser.assignAll(taskModel.taskSellerListId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<TargetViewModel>(builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title:
                  Text(widget.oldKey == null ? "إضافة التاسك" : "تعديل التاسك"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Get.width / 5,
                    child: GetBuilder<UserManagementViewModel>(
                        builder: (controller) {
                      return StatefulBuilder(builder: (context, setstate) {
                        return Column(
                          children: [
                            const Text("المستخدمين :"),
                            const SizedBox(
                              height: 25,
                            ),
                            for (UserModel i
                                in controller.allUserList.values.toList())
                              Row(
                                children: [
                                  Checkbox(
                                      value: allUser.contains(i.userId),
                                      onChanged: (_) {
                                        if (allUser.contains(i.userId)) {
                                          allUser.remove(i.userId!);
                                        } else {
                                          if (taskModel.taskType ==
                                              AppConstants.taskTypeProduct) {
                                            allUser.add(i.userId!);
                                          } else {
                                            allUser.assign(i.userId!);
                                          }
                                        }
                                        setstate(() {});
                                      }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(i.userName.toString())
                                ],
                              )
                          ],
                        );
                      });
                    }),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (inventoryModel != null)
                        Text(
                            "تم إضافة جرد يتضمن ${inventoryModel!.inventoryTargetedProductList.length} مواد")
                      else
                        ElevatedButton(
                            onPressed: () async {
                              if (allUser.isNotEmpty) {
                                InventoryModel? _ =
                                    await Get.to(() => SelectTaskInventory(
                                          userId: allUser.first,
                                        ));
                                print(_?.toJson());
                                inventoryModel = _;
                                setState(() {});
                              } else {
                                Get.snackbar("خطأ", "برجى إختيار حساب ");
                              }
                            },
                            child: const Text("إنشاء جرد"))
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        if (taskModel.taskProductId?.isEmpty ?? true) {
                          Get.snackbar("خطأ", "يرجى كتابة اسم المادة");
                        } else if (taskModel.taskQuantity == null ||
                            taskModel.taskQuantity == 0) {
                          Get.snackbar("خطأ", "يرجى كتابة عدد");
                        } else if (taskModel.taskSellerListId.isEmpty) {
                          Get.snackbar("خطأ", "يرجى إضافة مستخدمين");
                        } else {
                          if (taskModel.taskId != null) {
                            checkPermissionForOperation(AppConstants.roleUserRead,
                                    AppConstants.roleViewTask)
                                .then((value) {
                              if (value) controller.updateTask(taskModel);
                            });
                          } else {
                            checkPermissionForOperation(AppConstants.roleUserRead,
                                    AppConstants.roleViewTask)
                                .then((value) {
                              if (value) controller.addTask(taskModel);
                            });
                          }
                        }
                      },
                      child: Text(taskModel.taskId != null ? "تعديل" : "إنشاء"))
                ],
              ),
            ));
      }),
    );
  }
}
