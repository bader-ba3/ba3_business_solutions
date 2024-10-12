import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/target_controller.dart';
import 'package:ba3_business_solutions/core/utils/date_month_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/user/user_management_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../model/seller/seller_model.dart';
import '../../invoices/widget/custom_TextField.dart';

class AddTaskView extends StatelessWidget {
  final String? oldKey;

  const AddTaskView({super.key, this.oldKey});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<TargetController>(builder: (targetController) {
        return Scaffold(
            appBar: AppBar(
              title: Text(oldKey == null ? "إضافة التاسك" : "تعديل التاسك"),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GetBuilder<SellersViewModel>(builder: (controller) {
                      return Column(
                        children: [
                          const Text("المستخدمين :"),
                          const SizedBox(
                            height: 25,
                          ),
                          for (SellerModel i in controller.allSellers.values.toList()) ...[
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Checkbox(
                                    value: targetController.allUser.contains(i.sellerId),
                                    fillColor: WidgetStatePropertyAll(Colors.blue.shade800),
                                    checkColor: Colors.white,
                                    onChanged: (_) {
                                      if (targetController.allUser.contains(i.sellerId)) {
                                        targetController.allUser.remove(i.sellerId!);
                                      } else {
                                        if (targetController.taskModel.taskType == AppConstants.taskTypeProduct) {
                                          targetController.allUser.add(i.sellerId!);
                                        } else {
                                          targetController.allUser.assign(i.sellerId!);
                                        }
                                      }
                                      controller.update();
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  i.sellerName.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                )
                              ],
                            ),
                            const Divider()
                          ]
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: Get.width / 2.5,
                            child: Row(
                              children: [
                                const Text("المادة :"),
                                const SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: CustomTextFieldWithIcon(
                                    controller: targetController.productNameController,
                                    onSubmitted: (text) async {
                                      var a = await targetController.getComplete(text);
                                      if (a.isNotEmpty) {
                                        targetController.taskModel.taskProductId = getProductIdFromName(a);
                                        targetController.productNameController.text = a;
                                        targetController.update();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                if (targetController.taskModel.taskProductId != null) const Icon(Icons.check),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: Get.width / 5,
                            child: Row(
                              children: [
                                const Text("العدد المطلوب :"),
                                const SizedBox(
                                  width: 25,
                                ),
                                Expanded(
                                  child: TextFormField(
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(5.0), // Adjust border radius
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.blue,
                                            // Change the border color when focused
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                                      ),
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      controller: targetController.quantityController,
                                      onChanged: (_) {
                                        targetController.taskModel.taskQuantity = int.tryParse(targetController.quantityController.text);
                                      }),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("التاريخ:"),
                          const SizedBox(
                            width: 10,
                          ),
                          DateMonthPicker(
                            initDate: targetController.taskDate,
                            onSubmit: (date) {
                              targetController.taskDate = "${date.year}-${date.month}";
                              targetController.update();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            if (targetController.taskDate == null) {
                              Get.snackbar("خطأ", "يرجى كتابة تاريخ");
                            } else if (targetController.taskModel.taskProductId?.isEmpty ?? true) {
                              Get.snackbar("خطأ", "يرجى كتابة اسم المادة");
                            } else if (targetController.taskModel.taskQuantity == null || targetController.taskModel.taskQuantity == 0) {
                              Get.snackbar("خطأ", "يرجى كتابة عدد");
                            } else if ((targetController.allUser).isEmpty) {
                              Get.snackbar("خطأ", "يرجى إضافة مستخدمين");
                            } else {
                              targetController.taskModel.taskSellerListId = targetController.allUser;
                              targetController.taskModel.taskDate = targetController.taskDate;
                              if (targetController.taskModel.taskId != null) {
                                checkPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewTask).then((value) {
                                  if (value) targetController.updateTask(targetController.taskModel);
                                });
                              } else {
                                checkPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewTask).then((value) {
                                  if (value) targetController.addTask(targetController.taskModel);
                                });
                              }
                            }
                          },
                          child: Text(targetController.taskModel.taskId != null ? "تعديل" : "إنشاء")),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
