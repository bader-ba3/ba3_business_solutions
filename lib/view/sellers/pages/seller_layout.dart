import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/view/sellers/pages/add_seller_page.dart';
import 'package:ba3_business_solutions/view/sellers/pages/all_sellers_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';

class SellerLayout extends StatelessWidget {
  const SellerLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("البائعون"),
        ),
        body: Column(
          children: [
            item("إضافة بائع", () {
              Get.to(() => const AddSellerPage());
            }),
            item("معاينة البائعون", () {
              hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewSeller).then((value) {
                if (value) Get.to(() => const AllSellersPage());
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
