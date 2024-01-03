import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/view/user_management/login_view.dart';
import 'package:ba3_business_solutions/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserManagement extends StatelessWidget {
  UserManagement({super.key});

  @override
  Widget build(BuildContext context) {
    UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
    userManagementViewController.checkUserStatus();
    return Scaffold(
        body: Center(
      child: Text("يتم تسجيل الدخول"),
    ));
  }
}
