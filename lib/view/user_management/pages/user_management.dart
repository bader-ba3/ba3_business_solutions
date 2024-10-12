import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/user_management/pages/role_management/role_management_view.dart';
import 'package:ba3_business_solutions/view/user_management/pages/user_crud/all_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';

class UserManagementType extends StatefulWidget {
  const UserManagementType({super.key});

  @override
  State<UserManagementType> createState() => _UserManagementTypeState();
}

class _UserManagementTypeState extends State<UserManagementType> {
  bool isAdmin = false;
  UserManagementController userManagementViewController =
      Get.find<UserManagementController>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then((value) {
      checkPermissionForOperation(
              AppConstants.roleUserAdmin, AppConstants.roleViewUserManagement)
          .then((value) {
        print(value);
        if (value) {
          isAdmin = true;
          setState(() {});
        }
      });
    });

    // userManagementViewController.initAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("الإدارة"),
              ),
              body: !isAdmin
                  ? const Center(
                      child: Text("غير مصرح لك بالدخول"),
                    )
                  : Column(
                      children: [
                        item("إدارة المستخدمين", () {
                          Get.to(() => const AllUserView());
                        }),
                        item("إدارة الصلاحيات", () {
                          Get.to(() => const RoleManagementView());
                        }),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget item(text, onTap) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: InkWell(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(30.0),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textDirection: TextDirection.rtl,
          ))),
    ),
  );
}
