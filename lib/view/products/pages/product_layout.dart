import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/view/products/pages/add_product_page.dart';
import 'package:ba3_business_solutions/view/products/pages/all_products_page.dart';
import 'package:ba3_business_solutions/view/products/pages/product_management_page.dart';
import 'package:ba3_business_solutions/view/products/pages/product_tree_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/app_menu_item.dart';

class ProductLayout extends StatelessWidget {
  const ProductLayout({super.key});

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
            AppMenuItem(
                text: "إضافة مادة",
                onTap: () {
                  Get.to(() => const AddProductPage());
                }),
            AppMenuItem(
                text: "معاينة المواد",
                onTap: () {
                  hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewProduct).then((value) {
                    if (value) Get.to(() => const AllProductsPage());
                  });
                }),
            AppMenuItem(
                text: "شجرة المواد",
                onTap: () {
                  hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewProduct).then((value) {
                    if (value) Get.to(() => ProductTreePage());
                  });
                }),
            AppMenuItem(
                text: "إدارة المخزون ",
                onTap: () {
                  hasPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewProduct).then((value) {
                    if (value) Get.to(() => const ProductManagementPage());
                  });
                }),
          ],
        ),
      ),
    );
  }
}
