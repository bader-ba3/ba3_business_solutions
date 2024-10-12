import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:ba3_business_solutions/view/user_management/pages/user_crud/add_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/user/user_management_model.dart';
import '../../../../core/shared/widgets/custom_window_title_bar.dart';

class AllUserView extends StatefulWidget {
  const AllUserView({super.key});

  @override
  State<AllUserView> createState() => _AllUserViewState();
}

class _AllUserViewState extends State<AllUserView> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
  //     checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewUserManagement).then((value) {
  //       print(value);
  //       if (value) userManagementViewController.initAllUser();
  //     });
  //   });
  //
  //   // userManagementViewController.initAllUser();
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   userManagementViewController.allUserList.clear();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GetBuilder<UserManagementController>(
              builder: (controller) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("إدارة المستخدمين"),
                    actions: [
                      AppButton(
                          title: "إضافة",
                          onPressed: () {
                            Get.find<UserManagementController>().initUser();
                            Get.to(() => const AddUserView());
                          },
                          iconData: Icons.add),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        children: List.generate(
                          controller.allUserList.values.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.find<UserManagementController>().initUser(
                                    controller.allUserList.values
                                        .toList()[index]
                                        .userId);
                                Get.to(() => const AddUserView());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 140,
                                width: 140,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      controller.allUserList.values
                                              .toList()[index]
                                              .userName ??
                                          "",
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
