import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/bonds/bond_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_bond_details_view.dart';

class AllBonds extends StatelessWidget {
  const AllBonds({super.key});
  @override
  Widget build(BuildContext context) {
    final BondViewModel controller = Get.find<BondViewModel>();
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text("السندات"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                  Get.to(() => BondDetailsView());

                  },
                  child: Text("سند يومية")),
              SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                   Get.to(() => CustomBondDetailsView(isDebit: true));

                  },
                  child: Text("سند دفع")),
              SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  onPressed: () {

                    Get.to(() => CustomBondDetailsView(isDebit: false));

                  },
                  child: Text("سند دفع")),
              SizedBox(
                width: 30,
              ),
            ],
          ),
          body: controller.allBondsItem.isEmpty
              ? Center(
                  child: Text("No Bond Yet"),
                )
              : ListView.builder(
                  itemCount: controller.allBondsItem.length,
                  itemBuilder: (context, index) {
                    String key = controller.allBondsItem.keys.toList()[index];
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: InkWell(
                          onTap: () {
                            if (controller.allBondsItem.values.toList()[index].bondType == Const.bondTypeDaily) {
                              Get.to(() => BondDetailsView(oldId: key));
                            } else {
                              Get.to(() => CustomBondDetailsView(
                                    oldId: key,
                                    isDebit: controller.allBondsItem.values.toList()[index].bondType == Const.bondTypeDebit,
                                  ));
                            }
                            logger(newData: controller.allBondsItem.values.toList()[index], transfersType: TransfersType.read);
                          },
                          child: Text(controller.allBondsItem[key]!.bondId ?? "")),
                    );
                  }),
        ));
  }
}
