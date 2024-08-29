import 'package:ba3_business_solutions/Widgets/Discount_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/Widgets/Invoice_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';

import 'package:ba3_business_solutions/view/invoices/Controller/Screen_View_Model.dart';
import 'package:ba3_business_solutions/view/invoices/Controller/Search_View_Controller.dart';
import 'package:ba3_business_solutions/view/invoices/New_Invoice_View.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../Dialogs/Invoice_Option_Dialog.dart';
import '../../model/Pattern_model.dart';
import 'all_pending_invoices.dart';

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
                      Get.to(
                        () => InvoiceView(
                          billId: '1',
                          patternId: i.key,
                        ),
                        binding: BindingsBuilder(() {
                          Get.lazyPut(() => InvoicePlutoViewModel());
                          Get.lazyPut(() => DiscountPlutoViewModel());
                        }),
                      );
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
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
                      // if (value) Get.to(() => const AllInvoice());
                      if (value) {
                        Get.find<SearchViewController>().initController();
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => const InvoiceOptionDialog(),
                        );
                      }
                    });
                  },
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
                    if (value) Get.to(() => const AllPendingInvoice());
                  });
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
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
            GetBuilder<ScreenViewModel>(builder: (screenController) {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الفواتيير المفتوحة" "(${screenController.openedScreen.length})",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: screenController.openedScreen.entries.toList().map((i) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onTap: () {
                                // print(i.toFullJson());
                                Get.to(
                                  () => InvoiceView(
                                    billId: i.key,
                                    patternId: i.value.patternId!,
                                    recentScreen: true,
                                  ),
                                  binding: BindingsBuilder(() {
                                    Get.lazyPut(() => InvoicePlutoViewModel());
                                    Get.lazyPut(() => DiscountPlutoViewModel());
                                  }),
                                );
                 /*               Get.to(() => InvoiceView(
                                      billId: i.key,
                                      patternId: i.value.patternId!,
                                      recentScreen: true,
                                    ));*/
                              },
                              child: Container(
                                // width: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Color(patternController.patternModel[i.value.patternId]?.patColor! ?? 00000).withOpacity(0.5),
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "نمط الفاتورة:",
                                            style: TextStyle(fontSize: 16),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        SizedBox(
                                          child: Text(
                                            patternController.patternModel[i.value.patternId!]!.patName ?? "error",
                                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "رقم الفاتورة:",
                                            style: TextStyle(fontSize: 18),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(
                                          i.value.invCode.toString(),
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "وقت الفاتورة:",
                                            style: TextStyle(fontSize: 18),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(
                                          i.value.invDate.toString().split(" ")[1],
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 120,
                                          child: Text(
                                            "مجموع الفاتورة:",
                                            style: TextStyle(fontSize: 18),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                        Text(
                                          i.value.invTotal.toString(),
                                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                                top: -5,
                                left: -1,
                                child: GestureDetector(
                                  onTap: () {
                                    screenController.openedScreen.remove(i.key);
                                    screenController.update();
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(color: Colors.red.shade800, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, spreadRadius: 0.2)]),
                                      child: const Icon(
                                        Icons.close,
                                        size: 13,
                                        color: Colors.white,
                                      )),
                                ))
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
