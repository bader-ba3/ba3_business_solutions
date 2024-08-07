import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/accounts/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/cheque_type.dart';
import 'package:ba3_business_solutions/view/dashboard/dashboard_view.dart';
import 'package:ba3_business_solutions/view/due/due_type.dart';
import 'package:ba3_business_solutions/view/entry_bond/entry_bond_type.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_type.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_type.dart';
import 'package:ba3_business_solutions/view/products/product_type.dart';
import 'package:ba3_business_solutions/view/stores/store_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../card_management/card_management_view.dart';
import '../database/database_type.dart';
import '../import/picker_file.dart';
import '../inventory/inventory_type.dart';
import '../report/report_grid_view.dart';
import '../sellers/seller_type.dart';
import '../statistics/statistics_type.dart';
import '../target_management/target_management_view.dart';
import '../timer/time_type.dart';
import '../user_management/user_management.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<({String name, Widget widget, String role})> rowData = [
    (name: "لوحة التحكم", widget: const DashboardView(), role: Const.roleViewHome),
    (name: "الفواتير", widget: const InvoiceType(), role: Const.roleViewInvoice),
    (name: "السندات", widget: const BondType(), role: Const.roleViewBond),
    (name: "سندات القيد", widget: const EntryBondType(), role: Const.roleViewBond),
    (name: "الحسابات", widget: const AccountType(), role: Const.roleViewAccount),
    (name: "المواد", widget: const ProductType(), role: Const.roleViewProduct),
    (name: "المستودعات", widget: const StoreType(), role: Const.roleViewStore),
    (name: "أنماط البيع", widget: const PatternType(), role: Const.roleViewPattern),
    (name: "الشيكات", widget: const ChequeType(), role: Const.roleViewCheques),
    (name: "الاستحقاق", widget: const DueType(), role: Const.roleViewDue),
    (name: "تقرير المبيعات", widget: const ReportGridView(), role: Const.roleViewReport),
    (name: "الاحصائيات", widget: const StatisticsType(), role: Const.roleViewStatistics),
    (name: "البائعون", widget: const SellerType(), role: Const.roleViewSeller),
    (name: "استيراد المعلومات", widget: FilePickerWidget(), role: Const.roleViewImport),
    (name: "الجرد", widget: const InventoryType(), role: Const.roleViewInventory),
    (name: "إدارة المستخدمين", widget: const UserManagementType(), role: Const.roleViewUserManagement),
    (name: "إدارة التارجيت", widget: const TargetManagementType(), role: Const.roleViewTarget),
    (name: "إدارة الوقت", widget: const TimeType(), role: Const.roleViewTimer),
    (name: "إدارة البطاقات", widget: const CardManagementType(), role: Const.roleViewCard),
    (name: "إدارة قواعد البيانات", widget: const DataBaseType(), role: Const.roleViewDataBase),
  ];
  List<({String name, Widget widget, String role})> allData = [];
  //  TabController? tabController;
  late PageController pageController;
  late TabController tabController;
  int tabIndex = 0;
  @override
  void initState() {
    allData = rowData.where((element) => checkMainPermission(element.role)).toList();
    tabController = TabController(length: allData.length, vsync: this, initialIndex: tabIndex);
    pageController = PageController();
    //  allData = rowData.where((element) => checkMainPermission(element.role),).toList();
    // tabController = TabController(length: allData.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<GlobalViewModel>(builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.teal.shade100,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<UserManagementViewModel>(builder: (sellersViewModel) {
                allData = rowData
                    .where(
                      (element) => checkMainPermission(element.role),
                    )
                    .toList();
                // tabController = TabController(length: allData.length, vsync: this, initialIndex: tabIndex);
                if (allData.isEmpty) {
                  return const Center(
                    child: Text(
                      "ليس لديك صلاحيات",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  );
                }
                return StatefulBuilder(builder: (context, setstate) {
                  return TabContainer(
                    textDirection: TextDirection.rtl,
                    controller: tabController,
                    tabEdge: TabEdge.right,
                    tabsEnd: 1,
                    tabsStart: 0,
                    tabMaxLength: controller.isDrawerOpen ? 60 : 60,
                    tabExtent: controller.isDrawerOpen ? 180 : 60,
                    borderRadius: BorderRadius.circular(10),
                    tabBorderRadius: BorderRadius.circular(20),
                    childPadding: const EdgeInsets.all(0.0),
                    selectedTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                    unselectedTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                    ),
                    colors: List.generate(allData.length, (index) => Colors.white),
                    tabs: List.generate(
                      allData.length,
                      (index) {
                        return DrawerListTile(
                          index: index,
                          title: allData[index].name,
                          press: () {
                            print(index);
                            pageController.jumpToPage(index);
                            tabController.index = index;
                          },
                        );
                      },
                    ),
                    child: SizedBox(
                      width: Get.width,
                      height: Get.height,
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: pageController,
                        children: List.generate(
                            allData.length,
                            (index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: allData[index].widget,
                                )),
                      ),
                    ),
                  );
                });
              }),
            ),
          ),
        );
      }),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.index,
    required this.press,
  }) : super(key: key);

  final String title;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalViewModel>(builder: (controller) {
      return InkWell(
        onTap: press,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
                child: Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ))),
      );
    });
  }
}
