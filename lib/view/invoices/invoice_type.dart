import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../model/Pattern_model.dart';
import 'all_invoices.dart';
import 'all_pending_invoices.dart';
import 'invoice_view.dart';

class InvoiceType extends StatefulWidget {
  const InvoiceType({super.key});

  @override
  State<InvoiceType> createState() => _InvoiceTypeState();
}

class _InvoiceTypeState extends State<InvoiceType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الفواتير"),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Wrap(
                spacing: 15.0,
                runSpacing: 15.0,
                children: patternController.patternModel.entries.toList().map((MapEntry<String, PatternModel> i) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => InvoiceView(billId: '1', patternId: i.key));
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.2),
                        border: Border.all(
                          color: Color(i.value.patColor!).withOpacity(0.5),
                          width: 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(30.0),
                      child: Center(
                        child: Text(
                          i.value.patName ?? "error",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (checkPermission(Const.roleUserAdmin, Const.roleViewInvoice))
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    checkPermissionForOperation(Const.roleUserRead, Const.roleViewInvoice).then((value) {
                      if (value) Get.to(() => const AllInvoice());
                    });
                  },
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.all(30.0),
                      child: const Center(
                        child: Text(
                          "عرض جميع الفواتير",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                      )),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: InkWell(
                onTap: () {
                  checkPermissionForOperation(Const.roleUserRead, Const.roleViewInvoice).then((value) {
                    if (value) Get.to(() => AllPendingInvoice());
                  });
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(30.0),
                    child: const Center(
                      child: Text(
                        "عرض جميع الفواتير الغير مؤكدة",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textDirection: TextDirection.rtl,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
