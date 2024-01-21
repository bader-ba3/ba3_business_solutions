import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/accounts/acconts_view.dart';
import 'package:ba3_business_solutions/view/accounts/account_tree_view.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds.dart';
import 'package:ba3_business_solutions/view/invoices/all_Invoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../model/Pattern_model.dart';

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
          title: Text("الحسابات"),
        ),
        body: Column(
          children: [
            Item("إنشاء حساب", () {
              Get.to(() => AddAccount());
            }),
            Item("شجرة الحسابات", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) Get.to(() => AccountTreeView());
              });
            }),
            Item("معاينة الحسابات", () {
              checkPermissionForOperation(Const.roleUserRead, Const.roleViewAccount).then((value) {
                if (value) Get.to(() => AccountsView());
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            )),
      ),
    );
  }
}
