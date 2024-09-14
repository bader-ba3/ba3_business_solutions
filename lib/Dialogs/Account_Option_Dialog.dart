import 'package:ba3_business_solutions/Dialogs/SearchAccuntTextDialog.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Const/const.dart';
import '../Services/Get_Date_From_String.dart';
import '../view/accounts/account_details.dart';
import '../view/invoices/Controller/Search_View_Controller.dart';
import 'Widgets/Option_Text_Widget.dart';

class AccountOptionDialog extends StatelessWidget {
  const AccountOptionDialog({
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
                  title: "اسم الحساب :  ",
                  controller: controller.accountForSearchController,
                  onSubmitted: (text) async {
                    controller.accountForSearchController.text = await searchAccountTextDialog(controller.accountForSearchController.text) ?? "";
                    controller.update();
                  },
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
                AppButton(
                  title: "موافق",

                  iconData: Icons.check,
                  onPressed: () {
                    AccountModel? model = getAccountModelFromName(controller.accountForSearchController.text);
                    if (model != null) {
                      List<String> listDate = getDatesBetween(DateTime.parse(controller.startDateForSearchController.text), DateTime.parse(controller.endDateForSearchController.text));

                      Get.to(() => AccountDetails(
                        modelKey: model.accChild
                            .map(
                              (e) => e.toString(),
                        )
                            .toList() +
                            [model.accId!],
                        listDate: listDate,
                      ));
                    } else {
                      Get.snackbar("خطأ ادخال", "يرجى ادخال اسم الحساب ", icon: const Icon(Icons.error_outline));
                    }
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
