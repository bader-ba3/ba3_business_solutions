import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/shared/dialogs/Account_Option_Dialog.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_tree_view.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_view.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/search_view_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/shared/dialogs/AccountDueOption.dart';
import '../widget/customer_pluto_edit_view.dart';
import 'partner_due_account.dart';

class AccountType extends StatefulWidget {
  const AccountType({super.key});

  @override
  State<AccountType> createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

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
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewAccount)
                  .then((value) {
                if (value) {
                  Get.find<SearchViewController>().initController();
                  showDialog<String>(
                    context: Get.context!,
                    builder: (BuildContext context) =>
                        const AccountOptionDialog(),
                  );
                }
              });
            }),
            item("معاينة الحسابات", () {
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewAccount)
                  .then((value) {
                if (value) {
                  Get.to(() => const AllAccount());
                }
              });
            }),
            item("شجرة الحسابات", () {
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewAccount)
                  .then((value) {
                if (value) Get.to(() => AccountTreeView());
              });
            }),
            item("سجل استحقاق الشركاء", () {
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewAccount)
                  .then((value) {
                if (value) Get.to(() => const AllPartnerDueAccount());
              });
            }),
            item("المستحقات", () {
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewAccount)
                  .then((value) {
                if (value) {
                  Get.find<SearchViewController>().initController();
                  showDialog<String>(
                    context: Get.context!,
                    builder: (BuildContext context) =>
                        const AccountDueOptionDialog(),
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                text,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            )),
      ),
    );
  }
}
