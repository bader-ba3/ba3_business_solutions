import 'package:ba3_business_solutions/controller/global/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/model/account/account_model.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/pages/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/pages/cheque_type.dart';
import 'package:ba3_business_solutions/view/due/due_type.dart';
import 'package:ba3_business_solutions/view/import/pages/picker_file.dart';
import 'package:ba3_business_solutions/view/inventory/pages/inventory_type.dart';
import 'package:ba3_business_solutions/view/invoices/pages/invoice_type.dart';
import 'package:ba3_business_solutions/view/patterns/pages/pattern_type.dart';
import 'package:ba3_business_solutions/view/products/pages/product_type.dart';
import 'package:ba3_business_solutions/view/report/pages/report_grid_view.dart';
import 'package:ba3_business_solutions/view/sellers/pages/all_seller_invoice_view.dart';
import 'package:ba3_business_solutions/view/sellers/pages/seller_type.dart';
import 'package:ba3_business_solutions/view/statistics/pages/statistics_type.dart';
import 'package:ba3_business_solutions/view/stores/pages/store_type.dart';
import 'package:ba3_business_solutions/view/target_management/pages/target_management_view.dart';
import 'package:ba3_business_solutions/view/timer/pages/time_type.dart';
import 'package:ba3_business_solutions/view/timer/pages/timer_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/account/account_view_model.dart';
import '../../core/constants/app_strings.dart';
import '../card_management/card_management_view.dart';
import '../database/database_type.dart';
import '../user_management/pages/user_management.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              "Hello " + getMyUserName() + (" ") * 35 + AppStrings.dataName),
          actions: [
            if (getMyUserSellerId() != null)
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.lightBlue.shade100),
                    elevation: const WidgetStatePropertyAll(0),
                  ),
                  onPressed: () {
                    Get.to(() => TimerView(
                          oldKey: getMyUserUserId(),
                        ));
                  },
                  child: const Text("المؤقت")),
            const SizedBox(
              width: 20,
            ),
            if (getMyUserSellerId() != null)
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.lightBlue.shade100),
                    elevation: const WidgetStatePropertyAll(0),
                  ),
                  onPressed: () {
                    Get.to(() => AllSellerInvoice(
                          oldKey: getMyUserSellerId(),
                        ));
                  },
                  child: const Text("ملفي الشخصي")),

            const SizedBox(
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
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 4,
                          height: MediaQuery.sizeOf(context).width / 4,
                          child: GetBuilder<AccountViewModel>(
                              builder: (accountController) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "الحسابات الرئيسية",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      itemCount: HiveDataBase
                                          .mainAccountModelBox.values
                                          .toList()
                                          .length,
                                      itemBuilder: (context, index) {
                                        AccountModel model = HiveDataBase
                                            .mainAccountModelBox.values
                                            .toList()[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: GestureDetector(
                                            onSecondaryTapDown: (details) {
                                              showContextMenu(
                                                  context,
                                                  details.globalPosition,
                                                  model.accId!,
                                                  accountController);
                                            },
                                            onLongPressStart: (details) {
                                              showContextMenu(
                                                  context,
                                                  details.globalPosition,
                                                  model.accId!,
                                                  accountController);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  model.accName.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 22),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  accountController
                                                      .getBalance(model.accId!)
                                                      .toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      fontSize: 22),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                                    ElevatedButton(
                                        onPressed: () async {
                                          TextEditingController nameController =
                                              TextEditingController();
                                          List<AccountModel> accountList = [];
                                          await Get.defaultDialog(
                                              title: "اكتب اسم الحساب",
                                              content: StatefulBuilder(
                                                  builder: (context, setstate) {
                                                return SizedBox(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .width /
                                                          4,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width /
                                                          4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 40,
                                                          child: TextFormField(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            decoration: const InputDecoration(
                                                                hintText:
                                                                    "اكتب اسم الحساب او رقمه",
                                                                hintTextDirection:
                                                                    TextDirection
                                                                        .rtl),
                                                            onChanged: (_) {
                                                              accountList =
                                                                  getAccountModelsFromName(
                                                                      _);
                                                              print(
                                                                  accountList);
                                                              setstate(() {});
                                                            },
                                                            controller:
                                                                nameController,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                            child: accountList
                                                                    .isEmpty
                                                                ? const Center(
                                                                    child: Text(
                                                                        "لا يوجد نتائج"),
                                                                  )
                                                                : ListView
                                                                    .builder(
                                                                    itemCount:
                                                                        accountList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      AccountModel
                                                                          model =
                                                                          accountList[
                                                                              index];
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              HiveDataBase.mainAccountModelBox.put(model.accId, model);
                                                                              Get.back();
                                                                            },
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                "${model.accName}   ${model.accCode}",
                                                                                textDirection: TextDirection.rtl,
                                                                              ),
                                                                            )),
                                                                      );
                                                                    },
                                                                  ))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }));
                                          accountController.update();
                                        },
                                        child: const Text("إضافة حساب ")),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                        item(context, "الفواتير", 1, const InvoiceType()),
                        item(context, "السندات", 2, const BondType()),
                        item(context, "الحسابات", 3, const AccountType()),
                        item(context, "المواد", 4, const ProductType()),
                        item(context, "المستودعات", 5, const StoreType()),
                        item(context, "أنماط البيع", 6, const PatternType()),
                        item(context, "الشيكات", 7, const ChequeType()),
                        item(context, "الاستحقاق", 8, const DueType()),
                        item(context, "تقرير المبيعات", 9,
                            const ReportGridView()),
                        item(context, "الاحصائيات", 10, const StatisticsType()),
                        item(context, "البائعون", 11, const SellerType()),
                        item(
                            context, "استيراد معلومات", 12, FilePickerWidget()),
                        item(context, "الجرد", 13, const InventoryType()),
                        item(context, "إدارة المستخدمين", 14,
                            const UserManagementType()),
                        item(context, "إدارة التارجيت", 15,
                            const TargetManagementType()),
                        item(context, "إدارة الوقت", 16, const TimeType()),
                        item(context, "إدارة البطاقات", 17,
                            const CardManagementType()),
                        item(context, "إدارة قواعد البيانات", 18,
                            const DataBaseType()),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width / 4,
                          height: MediaQuery.sizeOf(context).width / 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                final globalController =
                                    Get.find<GlobalViewModel>();
                                globalController.deleteAllLocal();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "00",
                                      style: TextStyle(
                                          fontSize: 70,
                                          fontWeight: FontWeight.bold),
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

  Widget item(context, text, index, Widget nextPage) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width / 4,
      height: MediaQuery.sizeOf(context).width / 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Get.to(() => nextPage);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  index.toString(),
                  style: const TextStyle(
                      fontSize: 70, fontWeight: FontWeight.bold),
                ),
                Text(
                  text,
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showContextMenu(BuildContext parentContext, Offset tapPosition,
      String id, AccountViewModel accountController) {
    showMenu(
      context: parentContext,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy * 1.0,
      ),
      items: [
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Colors.red.shade700,
            ),
            title: const Text('حذف'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete') {
        HiveDataBase.mainAccountModelBox.delete(id);
        accountController.update();
      }
    });
  }
}
