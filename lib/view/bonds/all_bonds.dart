import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/new_Pluto.dart';

import '../../utils/hive.dart';
import 'bond_details_view.dart';
import 'custom_bond_details_view.dart';

class AllBonds extends StatelessWidget {
  const AllBonds({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BondViewModel>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع السندات",
        onLoaded: (e) {},
        type: Const.globalTypeBond,
        onSelected: (p0) {
          print(p0.row?.cells["bondId"]?.value);
          if (p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeDaily) ||
              p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeStart) ||
              p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeInvoice) ||
              p0.row?.cells["نوع السند"]?.value == (Const.bondTypeStart) ||
              p0.row?.cells["نوع السند"]?.value == (Const.bondTypeInvoice)) {
            Get.to(() => BondDetailsView(
                  oldId: p0.row?.cells["bondId"]?.value,
                  bondType: p0.row?.cells["نوع السند"]?.value,
                ));
          } else {
            Get.to(() => CustomBondDetailsView(
                  oldId: p0.row?.cells["bondId"]?.value,
                  isDebit: p0.row?.cells["نوع السند"]?.value == Const.bondTypeDebit || p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeDebit),
                ));
          }
        },
        modelList: controller.allBondsItem.values.where(
          (element) {
            if (HiveDataBase.getIsNunFree()) {
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
