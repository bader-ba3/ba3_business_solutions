import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/warranty/warranty_controller.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/shared/widgets/new_pluto.dart';

class AllWarrantyInvoices extends StatelessWidget {
  const AllWarrantyInvoices({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarrantyController>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع فواتير الضمان",
        onLoaded: (e) {},
        onSelected: (p0) {
          Get.toNamed(AppRoutes.warrantyInvoiceView,
              arguments: p0.row?.cells["invId"]?.value);

          /*   Get.to(() => InvoiceView(
                billId: p0.row?.cells["الرقم التسلسلي"]?.value,
                patternId: "",
              ));*/
        },
        modelList: controller.warrantyMap.values.toList(),
      );
    });
  }
}
