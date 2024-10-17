import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import 'all_entry_bonds.dart';

class EntryBondType extends StatelessWidget {
  const EntryBondType({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("سندات القيد"),
        ),
        body: Column(
          children: [
            AppMenuItem(
              text: 'سند قيد',
              onTap: () {},
            ),
            if (checkPermission(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice))
              AppMenuItem(
                  text: 'عرض سندات القيد',
                  onTap: () {
                    hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewBond).then((value) {
                      if (value) Get.to(() => const AllEntryBonds());
                    });
                  }),
          ],
        ),
      ),
    );
  }
}
