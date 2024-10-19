import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_menu_item.dart';
import 'package:ba3_business_solutions/view/user_management/pages/role_management/role_management_view.dart';
import 'package:ba3_business_solutions/view/user_management/pages/user_crud/all_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';

class UserManagementLayout extends StatefulWidget {
  const UserManagementLayout({super.key});

  @override
  State<UserManagementLayout> createState() => _UserManagementLayoutState();
}

class _UserManagementLayoutState extends State<UserManagementLayout> {
  bool isAdmin = false;
  UserManagementController userManagementViewController = Get.find<UserManagementController>();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      hasPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewUserManagement).then((value) {
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
                        AppMenuItem(
                            text: "إدارة المستخدمين",
                            onTap: () {
                              Get.to(() => const AllUserView());
                            }),
                        AppMenuItem(
                            text: "إدارة الصلاحيات",
                            onTap: () {
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
