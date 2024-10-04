import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/search_view_controller.dart';
import '../../../main.dart';
import '../../../view/invoices/pages/all_invoices.dart';
import '../../../view/invoices/pages/new_invoice_view.dart';
import '../../helper/functions/functions.dart';
import '../../services/Get_Date_From_String.dart';
import '../widgets/Option_Text_Widget.dart';
import 'Search_Product_Text_Dialog.dart';

class InvoiceOptionDialog extends StatelessWidget {
  const InvoiceOptionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backGroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GetBuilder<SearchViewController>(builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('خيارت العرض'),
                const SizedBox(height: 15),
                OptionTextWidget(
                  title: "المادة :  ",
                  controller: controller.productForSearchController,
                  onSubmitted: (text) async {
                    controller.productForSearchController.text =
                        await searchProductTextDialog(
                                controller.productForSearchController.text) ??
                            "";
                    controller.update();
                  },
                ),
                OptionTextWidget(
                  title: "من تاريخ :  ",
                  controller: controller.startDateForSearchController,
                  onSubmitted: (text) async {
                    controller.startDateForSearchController.text =
                        getDateFromString(text);
                    controller.update();
                  },
                ),
                OptionTextWidget(
                  title: "الى تاريخ :  ",
                  controller: controller.endDateForSearchController,
                  onSubmitted: (text) async {
                    controller.endDateForSearchController.text =
                        getDateFromString(text);
                    controller.update();
                  },
                ),
                AppButton(
                  title: "موافق",
                  iconData: Icons.check,
                  onPressed: () {
                    Get.to(() => AllInvoice(
                        listDate: getDatesBetween(
                            DateTime.parse(
                                controller.startDateForSearchController.text),
                            DateTime.parse(
                                controller.endDateForSearchController.text)),
                        productName: getProductIdFromName(
                            controller.productForSearchController.text)));
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
