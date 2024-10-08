import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/functions/functions.dart';
import '../../../core/shared/Widgets/new_Pluto.dart';
import '../../../core/utils/hive.dart';
import '../widget/bond_record_pluto_view_model.dart';
import 'bond_details_view.dart';

class AllBonds extends StatelessWidget {
  const AllBonds({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BondViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع السندات",
        onLoaded: (e) {},
        type: AppStrings.globalTypeBond,
        onSelected: (p0) {
          Get.to(
              () => BondDetailsView(
                    oldId: p0.row?.cells["bondId"]?.value,
                    bondType: p0.row?.cells["نوع السند"]?.value,
                  ),
              binding: BindingsBuilder(
                () => Get.lazyPut(
                  () => BondRecordPlutoViewModel(
                      getBondEnumFromType(p0.row?.cells["نوع السند"]?.value)),
                ),
              ));
        },
        modelList: controller.allBondsItem.values.where(
          (element) {
            if (HiveDataBase.getWithFree()) {
              return !(element.bondCode?.startsWith("F") ?? true);
            } else {
              return true;
            }
          },
        ).toList(),
      );
    });
  }
}
