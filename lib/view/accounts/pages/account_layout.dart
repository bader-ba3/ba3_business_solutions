import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/shared/dialogs/Account_Option_Dialog.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_tree_view.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_view.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/search_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared/dialogs/AccountDueOption.dart';
import '../widget/customer_pluto_edit_view.dart';
import 'partner_due_account.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الحسابات"),
        ),
        body: Column(
          children: [
            item("إنشاء حساب", () {
              Get.to(() => const AddAccount(),
                  binding: BindingsBuilder(
                    () => Get.lazyPut(() => CustomerPlutoEditViewModel()),
                  ));
            }),
            // item("معاينة الحسابات", () {
            //   checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
            //     if (value) Get.to(() => const AllAccountOLD());
            //   });
            // }),
            item("كشف حساب", () {
              hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewAccount).then((value) {
                if (value) {
                  Get.find<SearchViewController>().initController();
                  showDialog<String>(
                    context: Get.context!,
                    builder: (BuildContext context) => const AccountOptionDialog(),
                  );
                }
              });
            }),
            item("معاينة الحسابات", () {
              hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewAccount).then((value) {
                if (value) {
                  Get.to(() => const AllAccount());
                }
              });
            }),
            item("شجرة الحسابات", () {
              hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewAccount).then((value) {
                if (value) Get.to(() => AccountTreeView());
              });
            }),
            item("سجل استحقاق الشركاء", () {
              hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewAccount).then((value) {
                if (value) Get.to(() => const AllPartnerDueAccount());
              });
            }),
            item("المستحقات", () {
              hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewAccount).then((value) {
                if (value) {
                  Get.find<SearchViewController>().initController();
                  showDialog<String>(
                    context: Get.context!,
                    builder: (BuildContext context) => const AccountDueOptionDialog(),
                  );
                }
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            )),
      ),
    );
  }
}
