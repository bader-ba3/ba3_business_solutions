import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/view/user_management/role_management/add_role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleManagementView extends StatelessWidget {
  const RoleManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: (){
            Get.to(()=>AddRoleView());
          }, child: Text("add Role"))
        ],
      ),
      body: GetBuilder<UserManagementViewModel>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.allRole.length,
            itemBuilder: (context,index){
            return InkWell(onTap: (){
              Get.to(()=>AddRoleView(oldKey:controller.allRole.keys.toList()[index] ,));
            },child: Text(controller.allRole.values.toList()[index].roleName??"error"));
    },
    );
        }
      ));
  }
}
