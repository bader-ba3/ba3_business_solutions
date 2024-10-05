import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import 'all_entry_bonds.dart';

class EntryBondType extends StatefulWidget {
  const EntryBondType({super.key});

  @override
  State<EntryBondType> createState() => _EntryBondTypeState();
}

class _EntryBondTypeState extends State<EntryBondType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

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
            Item("سند قيد", () {}),
            if (checkPermission(
                AppStrings.roleUserAdmin, AppStrings.roleViewInvoice))
              Item("عرض سندات القيد ", () {
                checkPermissionForOperation(
                        AppStrings.roleUserRead, AppStrings.roleViewBond)
                    .then((value) {
                  if (value) Get.to(() => const AllEntryBonds());
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ))),
      ),
    );
  }
}
