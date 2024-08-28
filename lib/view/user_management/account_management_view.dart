import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}
class _UserManagementState extends State<UserManagement> {
   var _alertShowing = false;
  @override
  void initState() {


    FlutterWindowClose.setWindowShouldCloseHandler(() async {

      if (_alertShowing) return false;
        _alertShowing = true;
        bool a= false;
       bool?_ = await Get.defaultDialog(
        content: const Text('Do you really want to quit?'),
        confirm: ElevatedButton(onPressed: (){
           Get.back(result: true);
            _alertShowing = false;
        }, child: const Text("YES")),
        cancel: ElevatedButton(onPressed: (){
           Get.back(result: false);
           _alertShowing = false;
        }, child: const Text("NO")),
      );
      if(_!=null){
        a = _;
      }else{
          _alertShowing = false;
      }
      return a;
    });
  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
    userManagementViewController.checkUserStatus();
    return const Scaffold(
        body: Center(
      child: Text("يتم تسجيل الدخول"),
    ));
  }
}
