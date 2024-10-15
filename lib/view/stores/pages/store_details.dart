import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:ba3_business_solutions/model/store/store_record_model.dart';
import 'package:ba3_business_solutions/view/products/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/widgets/new_pluto.dart';

class StoreDetails extends StatelessWidget {
  final String? oldKey;

  const StoreDetails({super.key, this.oldKey});

  @override
  Widget build(BuildContext context) {
    StoreController storeViewModel = Get.find<StoreController>();
    RxMap<String, StoreRecordView> data = storeViewModel.allData.obs;
    storeViewModel.initStorePage(oldKey);
    return GetBuilder<StoreController>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع الحركات ${storeViewModel.storeMap[oldKey]!.stName}",
        onLoaded: (e) {},
        onSelected: (p0) {
          Get.to(() => ProductDetailsPage(
                oldKey: p0.row?.cells["id"]?.value,
              ));
          // Get.to(() => InvoiceView(
          //   billId:p0.row?.cells["الرقم التسلسلي"]?.value,
          //   patternId: "",
          // ));
        },
        modelList: data.values.toList(),
      );
    });
  }
}
