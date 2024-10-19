import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/styling/app_colors.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_layout.dart';
import 'package:ba3_business_solutions/view/bonds/pages/bond_layout.dart';
import 'package:ba3_business_solutions/view/cheques/pages/cheque_layout.dart';
import 'package:ba3_business_solutions/view/dashboard/dashboard_layout.dart';
import 'package:ba3_business_solutions/view/invoices/pages/invoice_layout.dart';
import 'package:ba3_business_solutions/view/main/widgets/drawer_list_tile.dart';
import 'package:ba3_business_solutions/view/main/widgets/window_buttons.dart';
import 'package:ba3_business_solutions/view/patterns/pages/pattern_layout.dart';
import 'package:ba3_business_solutions/view/products/pages/product_layout.dart';
import 'package:ba3_business_solutions/view/stores/pages/store_layout.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../../controller/global/changes_controller.dart';
import '../card_management/card_management_layout.dart';
import '../database/database_layout.dart';
import '../import/pages/importing_date_layout.dart';
import '../inventory/pages/inventory_layout.dart';
import '../sellers/pages/seller_layout.dart';
import '../statistics/pages/statistics_layout.dart';
import '../target_management/pages/target_management_layout.dart';
import '../timer/pages/time_layout.dart';
import '../user_management/pages/user_management_layout.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<({String name, Widget widget, String role})> rowData = [
    (name: "لوحة التحكم", widget: const DashboardLayout(), role: AppConstants.roleViewHome),
    (name: "الفواتير", widget: const InvoiceLayout(), role: AppConstants.roleViewInvoice),
    (name: "السندات", widget: const BondLayout(), role: AppConstants.roleViewBond),
    (name: "الحسابات", widget: const AccountLayout(), role: AppConstants.roleViewAccount),
    (name: "المواد", widget: const ProductLayout(), role: AppConstants.roleViewProduct),
    (name: "المستودعات", widget: const StoreLayout(), role: AppConstants.roleViewStore),
    (name: "أنماط البيع", widget: const PatternLayout(), role: AppConstants.roleViewPattern),
    (name: "الشيكات", widget: const ChequeLayout(), role: AppConstants.roleViewCheques),
    (name: "الاحصائيات", widget: const StatisticsLayout(), role: AppConstants.roleViewStatistics),
    (name: "البائعون", widget: const SellerLayout(), role: AppConstants.roleViewSeller),
    (name: "استيراد المعلومات", widget: ImportingDateLayout(), role: AppConstants.roleViewImport),
    (name: "الجرد", widget: const InventoryLayout(), role: AppConstants.roleViewInventory),
    (name: "إدارة المستخدمين", widget: const UserManagementLayout(), role: AppConstants.roleViewUserManagement),
    (name: "إدارة التارجيت", widget: const TargetManagementLayout(), role: AppConstants.roleViewTarget),
    (name: "إدارة الوقت", widget: const TimeLayout(), role: AppConstants.roleViewTimer),
    (name: "إدارة البطاقات", widget: const CardManagementLayout(), role: AppConstants.roleViewCard),
    (name: "إدارة قواعد البيانات", widget: const DataBaseLayout(), role: AppConstants.roleViewDataBase),
  ];
  List<({String name, Widget widget, String role})> allData = [];
  late PageController pageController;
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    allData = rowData.where((element) => checkMainPermission(element.role)).toList();
    tabController = TabController(length: allData.length, vsync: this, initialIndex: tabIndex);
    pageController = PageController();
    Get.find<ChangesController>().listenChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backGroundColor,
        body: WindowBorder(
          color: Colors.blue,
          width: 1,
          child: Row(
            children: [
              Container(
                  width: 250,
                  color: Colors.blue,
                  child: Column(
                    children: [
                      WindowTitleBarBox(child: MoveWindow()),
                      Expanded(
                        child: TabContainer(
                          textDirection: TextDirection.rtl,
                          controller: tabController,
                          tabEdge: TabEdge.right,
                          tabsEnd: 1,
                          tabsStart: 0,
                          tabMaxLength: 60,
                          tabExtent: 250,
                          borderRadius: BorderRadius.circular(0),
                          tabBorderRadius: BorderRadius.circular(20),
                          childPadding: const EdgeInsets.all(0.0),
                          selectedTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          unselectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                          ),
                          colors: List.generate(rowData.length, (index) => AppColors.backGroundColor),
                          tabs: List.generate(
                            rowData.length,
                            (index) {
                              return DrawerListTile(
                                index: index,
                                title: rowData[index].name,
                                press: () {
                                  tabController.animateTo(index);
                                  tabIndex = index;
                                  setState(() {});
                                },
                              );
                            },
                          ),
                          children: List.generate(
                            rowData.length,
                            (index) => const SizedBox(
                              width: 1,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
              Expanded(
                child: Column(children: [
                  WindowTitleBarBox(
                    child: Row(
                      children: [
                        Expanded(child: MoveWindow()),
                        const AppWindowControlButtons(),
                      ],
                    ),
                  ),
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: allData[tabIndex].widget,
                  ))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
