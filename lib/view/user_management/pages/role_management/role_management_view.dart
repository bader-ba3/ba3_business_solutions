import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:ba3_business_solutions/view/user_management/pages/role_management/add_role.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/shared/widgets/custom_window_title_bar.dart';

class RoleManagementView extends StatelessWidget {
  const RoleManagementView({super.key});

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
                  title: const Text("إدارة الصلاحيات"),
                  actions: [
                    AppButton(
                        title: "إضافة",
                        onPressed: () {
                          Get.to(() => const AddRoleView());
                        },
                        iconData: Icons.add),
                    const SizedBox(width: 10),
                  ],
                ),
                body: GetBuilder<UserManagementController>(builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        children: List.generate(
                          controller.allRoles.values.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(() => AddRoleView(oldKey: controller.allRoles.keys.toList()[index]));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                height: 140,
                                width: 140,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      controller.allRoles.values.toList()[index].roleName ?? "",
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  //       return ListView.builder(
                  //         itemCount: controller.allRole.length,
                  //         itemBuilder: (context,index){
                  //         return InkWell(onTap: (){
                  //           Get.to(()=>AddRoleView(oldKey:controller.allRole.keys.toList()[index] ,));
                  //         },child: Text(controller.allRole.values.toList()[index].roleName??"error"));
                  // },
                  // );
                })),
          ),
        ),
      ],
    );
  }
}
