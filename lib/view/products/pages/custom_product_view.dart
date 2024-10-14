import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/view/products/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/Widgets/new_pluto.dart';

class CustomProductView extends StatelessWidget {
  const CustomProductView({super.key, this.nunSell, this.date});

  final bool? nunSell;
  final List<String>? date;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع المواد",
        onLoaded: (e) {},
        onSelected: (p0) {
          Get.to(() => ProductDetailsPage(
                oldKey: p0.row?.cells["الرقم التسلسلي"]?.value,
              ));
        },
        modelList: controller.productDataMap.values.where(
          (element) {
            if (nunSell == true) {
              return element.prodRecord!.isEmpty;
            } else {
              return true;
            }
          },
        ).toList(),
      );
    });
  }
}
