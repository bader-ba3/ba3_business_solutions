import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/view/stores/pages/add_store.dart';
import 'package:ba3_business_solutions/view/stores/pages/all_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/store/store_controller.dart';
import '../../../core/constants/app_constants.dart';

class StoreLayout extends StatelessWidget {
  const StoreLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المستودعات"),
        ),
        body: Column(
          children: [
            item("إضافة مستودع", () {
              Get.find<StoreController>().initStore();
              Get.to(() => const AddStore());
            }),
            item("معاينة المستودعات", () {
              checkPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewStore).then((value) {
                if (value) Get.to(() => const AllStore());
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
