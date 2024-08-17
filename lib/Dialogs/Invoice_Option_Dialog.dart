import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Services/Get_Date_From_String.dart';
import '../view/invoices/Controller/Search_View_Controller.dart';
import '../view/invoices/all_invoices.dart';
import 'Search_Product_Text_Dialog.dart';
import 'Widgets/Option_Text_Widget.dart';

class InvoiceOptionDialog extends StatelessWidget {
  const InvoiceOptionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    controller.productForSearchController.text = await searchProductTextDialog(controller.productForSearchController.text);
                    controller.update();
                  },
                ),
                OptionTextWidget(
                  title: "المجموعة :  ",
                  controller: controller.groupForSearchController,
                  onSubmitted: (text) async {},
                ),
                OptionTextWidget(
                  title: "المستودع :  ",
                  controller: controller.storeForSearchController,
                  onSubmitted: (text) async {},
                ),
                OptionTextWidget(
                  title: "الزبون :  ",
                  controller: controller.clientForSearchController,
                  onSubmitted: (text) async {},
                ),
                OptionTextWidget(
                  title: "من تاريخ :  ",
                  controller: controller.startDateForSearchController,
                  onSubmitted: (text) async {
                    controller.startDateForSearchController.text = getDateFromString(text);
                    controller.update();
                  },
                ),
                OptionTextWidget(
                  title: "الى تاريخ :  ",
                  controller: controller.endDateForSearchController,
                  onSubmitted: (text) async {
                    controller.endDateForSearchController.text = getDateFromString(text);
                    controller.update();
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    List<String> getDatesBetween(DateTime startDate, DateTime endDate) {
                      List<String> dates = [];
                      DateTime currentDate = startDate;

                      while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
                        dates.add(currentDate.toString().split(" ")[0]);
                        currentDate = currentDate.add(const Duration(days: 1));
                      }

                      return dates;
                    }

                    Get.to(() => AllInvoice(listDate: getDatesBetween(DateTime.parse(controller.startDateForSearchController.text), DateTime.parse(controller.endDateForSearchController.text)), productName: getProductIdFromName(controller.productForSearchController.text)));
                  },
                  child: const Text('موافق'),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

