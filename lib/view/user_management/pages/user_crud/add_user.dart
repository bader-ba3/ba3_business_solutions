import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/helper/extensions/class_extensions/context_extensions.dart';
import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:ba3_business_solutions/view/user_management/pages/user_crud/time_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../widgets/user_crud/add_edit_user_form.dart';

class AddUserView extends StatelessWidget {
  const AddUserView({super.key});

  @override
  Widget build(BuildContext context) {
    UserManagementController userManagementViewController =
        Get.find<UserManagementController>();
    SellersViewModel sellerViewController = Get.find<SellersViewModel>();
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: GetBuilder<UserManagementController>(builder: (controller) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  title: Text(
                      controller.initAddUserModel?.userName ?? "مستخدم جديد"),
                  actions: [
                    if (controller.initAddUserModel?.userId != null)
                      ElevatedButton(
                          onPressed: () {
                            Get.to(() => TimeDetails(
                                  oldKey: controller.initAddUserModel!.userId!,
                                  name: controller.initAddUserModel!.userName!,
                                ));
                          },
                          child: const Text("البريك")),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                body: Center(
                  child: Column(
                    // shrinkWrap: true,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: AddEditUserForm(
                          userManagementViewController:
                              userManagementViewController,
                          sellerViewController: sellerViewController,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: .15 * context.screenHeight),
                        child: AppButton(
                          title: controller.initAddUserModel?.userId == null
                              ? "إضافة"
                              : "تعديل",
                          onPressed: () {
                            if (controller.nameController.text.isEmpty) {
                              Get.snackbar("خطأ", "يرجى كتابة الاسم");
                            } else if (controller.pinController.text.length !=
                                6) {
                              Get.snackbar("خطأ", "يرجى كتابة كلمة السر");
                            } else if (controller
                                    .initAddUserModel?.userSellerId ==
                                null) {
                              Get.snackbar("خطأ", "يرجى اختيار البائع");
                            } else if (controller.initAddUserModel?.userRole ==
                                null) {
                              Get.snackbar("خطأ", "يرجى اختيار الصلاحيات");
                            } else {
                              controller.addUser();
                              Get.snackbar(
                                  "تمت العملية بنجاح",
                                  controller.initAddUserModel?.userId == null
                                      ? "تم اضافة الحساب"
                                      : "تم تعديل الحساب");
                            }
                          },
                          iconData: controller.initAddUserModel?.userId == null
                              ? Icons.add
                              : Icons.edit,
                          color: controller.initAddUserModel?.userId == null
                              ? null
                              : Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
