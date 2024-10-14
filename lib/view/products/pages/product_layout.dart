import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/products/pages/add_product_page.dart';
import 'package:ba3_business_solutions/view/products/pages/all_products_page.dart';
import 'package:ba3_business_solutions/view/products/pages/product_management_page.dart';
import 'package:ba3_business_solutions/view/products/pages/product_tree_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';

class ProductType extends StatelessWidget {
  const ProductType({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المواد"),
        ),
        body: Column(
          children: [
            item("إضافة مادة", () {
              Get.to(() => const AddProductPage());
            }),
            item("معاينة المواد(الشكل الجديد)", () {
              checkPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewProduct).then((value) {
                if (value) Get.to(() => const AllProductsPage());
              });
            }),
            item("شجرة المواد", () {
              checkPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewProduct).then((value) {
                if (value) Get.to(() => ProductTreePage());
              });
            }),
            item("إدارة المخزون ", () {
              checkPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewProduct).then((value) {
                if (value) Get.to(() => const ProductManagementPage());
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
