import 'package:ba3_business_solutions/view/target_management/target/all_targets.dart';
import 'package:ba3_business_solutions/view/target_management/task/task_management_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../controller/user/user_management_model.dart';

class TargetManagementType extends StatefulWidget {
  const TargetManagementType({super.key});

  @override
  State<TargetManagementType> createState() => _TargetManagementTypeState();
}

class _TargetManagementTypeState extends State<TargetManagementType> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدارة التارجيت"),
        ),
        body: Column(
          children: [
            Item("ادارة المهام", () {
              Get.to(() => const TaskManagementType());
            }),
            Item("معاينة التارجيت", () {
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewTarget)
                  .then((value) {
                if (value) Get.to(() => const AllTargets());
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget Item(text, onTap) {
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
}
