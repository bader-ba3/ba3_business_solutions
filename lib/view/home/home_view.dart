import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/products/product_view_old.dart';
import 'package:ba3_business_solutions/view/accounts/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/cheque_type.dart';
import 'package:ba3_business_solutions/view/face/faceView.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_type.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_type.dart';
import 'package:ba3_business_solutions/view/products/product_type.dart';
import 'package:ba3_business_solutions/view/report/report_grid_view.dart';
import 'package:ba3_business_solutions/view/sellers/all_seller_invoice_view.dart';
import 'package:ba3_business_solutions/view/accounts/acconts_view_old.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds_old.dart';
import 'package:ba3_business_solutions/view/cheques/all_cheques_view.dart';
import 'package:ba3_business_solutions/view/cost_center/cost_center_view.dart';
import 'package:ba3_business_solutions/view/import/picker_file.dart';

import 'package:ba3_business_solutions/view/invoices/all_Invoice_old.dart';
import 'package:ba3_business_solutions/view/patterns/all_pattern.dart';
import 'package:ba3_business_solutions/view/products/product_view_old_old.dart';
import 'package:ba3_business_solutions/view/sellers/all_sellers_view.dart';
import 'package:ba3_business_solutions/view/sellers/seller_type.dart';
import 'package:ba3_business_solutions/view/stores/store_type.dart';
import 'package:ba3_business_solutions/view/target_management/target_management_view.dart';
import 'package:ba3_business_solutions/view/timer/time_type.dart';
import 'package:ba3_business_solutions/view/timer/timer_view.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/all_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../widget/sliver_list_widget.dart';
import '../../controller/invoice_view_model.dart';
import '../../model/product_model.dart';
import '../card_management/card_management_view.dart';
import '../database/database_type.dart';
import '../report/report_view.dart';
import '../sellers/widget/SellerChart.dart';
import '../stores/all_store.dart';
import 'dart:io';

import '../user_management/account_management_view.dart';
import '../user_management/user_management.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Hello " + getMyUserName() + (" ") * 70 + Const.dataName),
          actions: [
            if (getMyUserSellerId() != null)
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.lightBlue.shade100),
                    elevation: MaterialStatePropertyAll(0),),
                  onPressed: () {
                    Get.to(() => TimerView(oldKey: getMyUserUserId(),));
                  },
                  child: Text("المؤقت")),
            SizedBox(
              width: 20,
            ),
            if (getMyUserSellerId() != null)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.lightBlue.shade100),
                  elevation: MaterialStatePropertyAll(0),),
                  onPressed: () {
                    Get.to(() => AllSellerInvoice(
                          oldKey: getMyUserSellerId(),
                        ));
                  },
                  child: Text("ملفي الشخصي")),

            SizedBox(
              width: 20,
            ),
            // if (!Platform.isMacOS)
            //   ElevatedButton(
            //       onPressed: () {
            //         Get.to(() => FaceView());
            //       },
            //       child: Text("التعرف على الوجه"))
          ],
        ),
        body: SizedBox(
          width: double.infinity,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Center(
              //   child: Text(
              //     "مييعاتي",
              //     style: TextStyle(fontSize: 25),
              //   ),
              // ),
             // SellerChart(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Wrap(
                      children: [
                        item(context,"الفواتير", 1, InvoiceType()),
                        item(context,"السندات", 2, BondType()),
                        item(context,"الحسابات", 3, AccountType()),
                        item(context,"المواد", 4, ProductType()),
                        item(context,"المستودعات", 5, StoreType()),
                        item(context,"أنماط البيع", 6, PatternType()),
                        item(context,"الشيكات", 7, ChequeType()),
                        item(context,"تقرير المبيعات", 8, ReportGridView()),
                        // item("التقارير",8,ReportView()),
                        //  item("شجرة",8,CostCenterView()),
                        item(context,"البائعون", 9, SellerType()),
                        item(context,"استيراد معلومات", 10, FilePickerWidget()),
                        item(context,"إدارة المستخدمين", 11, UserManagementType()),
                        item(context,"إدارة التارجيت", 12, TargetManagementType()),
                        item(context,"إدارة الوقت", 13, TimeType()),
                        item(context,"إدارة البطاقات", 14, CardManagementType()),
                        item(context,"إدارة قواعد البيانات", 15, DataBaseType()),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width/4,
                          height: MediaQuery.sizeOf(context).width/4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                final globalController = Get.find<GlobalViewModel>();
                                globalController.deleteAllLocal();
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "00",
                                      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "clear database ",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }

  Widget item(context,text, index, Widget nextPage) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width/4,
      height: MediaQuery.sizeOf(context).width/4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.to(() => nextPage);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  index.toString(),
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
