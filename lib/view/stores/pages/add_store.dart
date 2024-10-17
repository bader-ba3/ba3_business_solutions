import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user/user_management_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../invoices/widget/custom_Text_field.dart';

class AddStore extends StatelessWidget {
  const AddStore({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إضافة مستودع"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: GetBuilder<StoreController>(builder: (storeController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const VerticalSpace(75),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(flex: 2, child: Text("اسم المستودع :")),
                          Flexible(
                              flex: 3,
                              child: CustomTextFieldWithoutIcon(
                                  controller: storeController.nameController,
                                  onChanged: (_) {
                                    storeController.editStoreModel?.stName = _;
                                  })),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(flex: 2, child: Text("رمز المستودع :")),
                          Flexible(
                              flex: 3,
                              child: CustomTextFieldWithoutIcon(
                                  controller: storeController.codeController,
                                  onChanged: (_) {
                                    storeController.editStoreModel?.stCode = _;
                                  })),
                        ],
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(25),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          storeController.nameController.clear();
                          storeController.codeController.clear();
                          storeController.clearController();
                        },
                        child: const Text("إفراغ")),
                    if (storeController.editStoreModel?.stId != null)
                      ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            if (storeController.nameController.text.isNotEmpty && storeController.codeController.text.isNotEmpty) {
                              hasPermissionForOperation(AppConstants.roleUserUpdate, AppConstants.roleViewStore).then((value) {
                                if (value) {
                                  storeController.editStore();
                                }
                              });
                            } else {
                              Get.snackbar("خطأ", "يرجى ملئ البيانات");
                            }
                          },
                          child: const Text("تعديل"))
                    else
                      ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            if (storeController.nameController.text.isNotEmpty && storeController.codeController.text.isNotEmpty) {
                              hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewStore).then((value) {
                                if (value) storeController.addNewStore();
                              });
                            } else {
                              Get.snackbar("خطأ", "يرجى ملئ البيانات");
                            }
                          },
                          child: const Text("إنشاء")),
                  ],
                ),
                const VerticalSpace(50),
              ],
            );
          }),
        ),
      ),
    );
  }
}
