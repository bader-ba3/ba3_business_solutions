import 'package:ba3_business_solutions/core/shared/dialogs/BondDebitOption.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_menu_item.dart';
import 'package:ba3_business_solutions/view/bonds/widget/bond_record_pluto_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import 'bond_details_view.dart';

class BondLayout extends StatelessWidget {
  const BondLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("السندات"),
        ),
        body: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            AppMenuItem(
                text: "سند يومية",
                onTap: () {
                  Get.to(
                    () => const BondDetailsView(
                      bondType: AppConstants.bondTypeDaily,
                    ),
                    binding: BindingsBuilder(() {
                      Get.lazyPut(() => BondRecordPlutoViewModel(AppConstants.bondTypeDaily));
                    }),
                  );
                }),
            AppMenuItem(
                text: "سند دفع",
                onTap: () {
                  Get.to(
                    () => const BondDetailsView(
                      bondType: AppConstants.bondTypeDebit,
                    ),
                    binding: BindingsBuilder(() {
                      Get.lazyPut(() => BondRecordPlutoViewModel(AppConstants.bondTypeDebit));
                    }),
                  );
                }),
            AppMenuItem(
                text: "سند قبض",
                onTap: () {
                  Get.to(
                    () => const BondDetailsView(
                      bondType: AppConstants.bondTypeCredit,
                    ),
                    binding: BindingsBuilder(() {
                      Get.lazyPut(() => BondRecordPlutoViewModel(AppConstants.bondTypeCredit));
                    }),
                  );
                }),
            AppMenuItem(
                text: "سند دفع اجل",
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => BondDebitDialog(),
                  );
                }),
            AppMenuItem(
                text: "قيد افتتاحي",
                onTap: () {
                  Get.to(
                    () => const BondDetailsView(
                      bondType: AppConstants.bondTypeStart,
                    ),
                    binding: BindingsBuilder(() {
                      Get.lazyPut(() => BondRecordPlutoViewModel(AppConstants.bondTypeStart));
                    }),
                  );
                }),
/*            if (checkPermission(Const.roleUserAdmin, Const.roleViewInvoice))
              Item("عرض جميع السندات", () {
                checkPermissionForOperation(Const.roleUserRead, Const.roleViewBond).then((value) {
                  if (value) Get.to(() => const AllBonds());
                });
              }),*/

            /*           Item("عرض سندات القيد ", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewBond).then((value) {
                if (value) Get.to(() => const AllEntryBonds());
              });
            }),*/
          ],
        ),
      ),
    );
  }
}
