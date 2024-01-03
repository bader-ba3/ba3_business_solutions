import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/view/user_management/role_management/add_role.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/add_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_management.dart';
import '../role_management/role_management_view.dart';

class AllUserView extends StatefulWidget {
  AllUserView({super.key});

  @override
  State<AllUserView> createState() => _AllUserViewState();
}

class _AllUserViewState extends State<AllUserView> {
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewUserManagement).then((value) {
        print(value);
        if (value) userManagementViewController.initAllUser();
      });
    });

    // userManagementViewController.initAllUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userManagementViewController.allUserList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementViewModel>(builder: (controller) {
      return userManagementViewController.allUserList.isEmpty
          ? Scaffold(appBar: AppBar(), body: Text("not permission to do this process"))
          : Scaffold(
              appBar: AppBar(
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => RoleManagementView());
                      },
                      child: Text("role management")),
                  SizedBox(width: 20,),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => AddUserView());
                      },
                      child: Text("add User")),

                ],
              ),
              body: ListView.builder(
                  itemCount: userManagementViewController.allUserList.length,
                  itemBuilder: (contex, index) {
                    return Padding(
                      padding: EdgeInsets.all(8),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => AddUserView(
                                  oldKey: userManagementViewController.allUserList.values.toList()[index].userId,
                                ));
                          },
                          child: Text(userManagementViewController.allUserList.values.toList()[index].userName ?? "error")),
                    );
                  }));
    });
  }
}
