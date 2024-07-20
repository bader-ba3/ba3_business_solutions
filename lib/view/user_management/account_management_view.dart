import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_window_close/flutter_window_close.dart';

class UserManagement extends StatefulWidget {
  UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}
class _UserManagementState extends State<UserManagement> {
   var _alertShowing = false;
  var _index = 0;
  @override
  void initState() {
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      print("aaa");
      if (_alertShowing) return false;
        _alertShowing = true;
        bool a= false;
       bool?_ = await Get.defaultDialog(
        content: Text('Do you really want to quit?'),
        confirm: ElevatedButton(onPressed: (){
           Get.back(result: true);
            _alertShowing = false;
        }, child: Text("YES")),
        cancel: ElevatedButton(onPressed: (){
           Get.back(result: false);
           _alertShowing = false;
        }, child: Text("NO")),
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
    return Scaffold(
        body: Center(
      child: Text("يتم تسجيل الدخول"),
    ));
  }
}
