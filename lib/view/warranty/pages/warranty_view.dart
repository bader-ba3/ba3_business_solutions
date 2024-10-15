import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/view/warranty/widgets/warranty_page_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/warranty/warranty_controller.dart';
import '../../../controller/warranty/warranty_pluto_controller.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../widgets/warranty_app_bar.dart';
import '../widgets/warranty_page_bottom_bar.dart';
import '../widgets/warranty_table.dart';

class WarrantyInvoiceView extends StatelessWidget {
  const WarrantyInvoiceView({super.key});

  @override
  Widget build(BuildContext context) {
    WarrantyPlutoController plutoEditViewModel =
        Get.find<WarrantyPlutoController>();

    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: const WarrantyAppBar(),
              body:
                  GetBuilder<WarrantyController>(builder: (warrantyController) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WarrantyPageTopBar(warrantyController: warrantyController),
                    const VerticalSpace(20),
                    Expanded(
                      // flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: GetBuilder<WarrantyPlutoController>(
                            builder: (warrantyPlutoViewModel) => WarrantyTable(
                                warrantyPlutoViewModel:
                                    warrantyPlutoViewModel)),
                      ),
                    ),
                    const VerticalSpace(),
                    const Divider(),
                    WarrantyPageBottomBar(
                        plutoEditViewModel: plutoEditViewModel,
                        warrantyController: warrantyController),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
