import 'package:ba3_business_solutions/controller/invoice/invoice_pluto_edit_controller.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/controller/warranty/warranty_controller.dart';
import 'package:ba3_business_solutions/core/router/app_routes.dart';
import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:ba3_business_solutions/view/invoices/widget/opened_screen_widget.dart';
import 'package:ba3_business_solutions/view/user_management/pages/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../controller/invoice/search_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared/dialogs/Invoice_Option_Dialog.dart';
import '../../../data/model/patterens/pattern_model.dart';
import '../../Warranty/pages/all_warranty_invoices.dart';
import 'all_pending_invoices.dart';

class InvoiceLayout extends StatelessWidget {
  const InvoiceLayout({super.key});

  @override
  Widget build(BuildContext context) {
    PatternController patternController = Get.find<PatternController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text(
                "الفواتير",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                Get.find<UserManagementController>().myUserModel?.userName ?? "",
                style: const TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.find<UserManagementController>().userStatus = UserManagementStatus.first;
                  Get.offAll(const LoginView());
                },
                icon: const Icon(Icons.logout, color: Colors.red))
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 10.0,
                runSpacing: 2.0,
                children: patternController.patternModel.entries.toList().asMap().entries.map((entry) {
                      int index = entry.key;
                      MapEntry<String, PatternModel> i = entry.value;

                      // Only display the first and last item
                      /* if (index == 0 ||
                          index ==
                              patternController.patternModel.entries.length -
                                  1)*/
                      {
                        return InkWell(
                          onTap: () {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeLeft,
                            ]);
                            Get.to(
                              () => InvoiceView(
                                billId: '1',
                                patternId: i.key,
                              ),
                              binding: BindingsBuilder(() {
                                Get.lazyPut(() => InvoicePlutoController());
                                // Get.lazyPut(() => DiscountPlutoViewModel());
                              }),
                            );
                          },
                          child: Container(
                            width: Get.width / 5.2,
                            margin: const EdgeInsets.all(2),
                            alignment: Alignment.center,
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
                                i.value.patFullName ?? "error",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(); // Return an empty container for other elements
                    }).toList() +
                    [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        width: Get.width,
                        child: InkWell(
                          onTap: () {
                            Get.find<WarrantyController>().initBills("1");
                            Get.toNamed(AppRoutes.warrantyInvoiceView);
                          },
                          child: Container(
                            width: Get.width * 0.19,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.all(30.0),
                            child: const Center(
                              child: Text(
                                "فاتورة ضمان",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
              ),
            ),
            if (checkPermission(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice))
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewInvoice).then((value) {
                      if (value) {
                        Get.to(
                          () => const AllWarrantyInvoices(),
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
                          "عرض فواتير ضمان",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textDirection: TextDirection.rtl,
                        ),
                      )),
                ),
              ),
            if (checkPermission(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice)) ...[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewInvoice).then((value) {
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
                    hasPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewInvoice).then((value) {
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
            ],
            OpenedScreenWidget(patternController: patternController)
          ],
        ),
      ),
    );
  }
}
