import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_context_menu.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/refresh_icon_widget.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/search_account_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/account/account_controller.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/utils/hive.dart';
import '../../../data/model/account/account_model.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width / 4,
        height: Get.width / 4,
        child: GetBuilder<AccountController>(builder: (accountController) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const VerticalSpace(20),
                  Row(
                    children: [
                      const HorizontalSpace(20),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "الحسابات الرئيسية",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      RefreshIconWidget(accountController: accountController),
                      const SearchAccountWidget(),
                      const HorizontalSpace(20),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: HiveDataBase.mainAccountModelBox.values.toList().length,
                    itemBuilder: (context, index) {
                      AccountModel model = HiveDataBase.mainAccountModelBox.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onSecondaryTapDown: (details) {
                            dashboardContextMenu(context, details.globalPosition, model.accId!, accountController);
                          },
                          onLongPressStart: (details) {
                            dashboardContextMenu(context, details.globalPosition, model.accId!, accountController);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                  width: Get.width / 4,
                                  child: Text(
                                    model.accName.toString(),
                                    style: const TextStyle(fontSize: 22),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              SizedBox(
                                width: Get.width / 4,
                                child: Text(
                                  formatDecimalNumberWithCommas(model.finalBalance ?? 0),
                                  // model.accId!,
                                  style: const TextStyle(fontSize: 22),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
                ],
              ),
            ),
          );
        }));
  }
}
