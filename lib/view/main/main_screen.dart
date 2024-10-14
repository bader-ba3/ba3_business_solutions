import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/accounts/pages/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/pages/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/pages/cheque_type.dart';
import 'package:ba3_business_solutions/view/dashboard/dashboard_view.dart';
import 'package:ba3_business_solutions/view/invoices/pages/invoice_layout.dart';
import 'package:ba3_business_solutions/view/main/widgets/drawer_list_tile.dart';
import 'package:ba3_business_solutions/view/main/widgets/window_buttons.dart';
import 'package:ba3_business_solutions/view/patterns/pages/pattern_layout.dart';
import 'package:ba3_business_solutions/view/products/pages/product_layout.dart';
import 'package:ba3_business_solutions/view/stores/pages/store_type.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../../controller/global/changes_view_model.dart';
import '../card_management/card_management_view.dart';
import '../database/database_type.dart';
import '../import/pages/picker_file.dart';
import '../inventory/pages/inventory_layout.dart';
import '../sellers/pages/seller_layout.dart';
import '../statistics/pages/statistics_type.dart';
import '../target_management/pages/target_management_view.dart';
import '../timer/pages/time_type.dart';
import '../user_management/pages/user_management.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<({String name, Widget widget, String role})> rowData = [
    (name: "لوحة التحكم", widget: const DashboardView(), role: AppConstants.roleViewHome),
    (name: "الفواتير", widget: const InvoiceLayout(), role: AppConstants.roleViewInvoice),
    (name: "السندات", widget: const BondType(), role: AppConstants.roleViewBond),
    (name: "الحسابات", widget: const AccountType(), role: AppConstants.roleViewAccount),
    (name: "المواد", widget: const ProductType(), role: AppConstants.roleViewProduct),
    (name: "المستودعات", widget: const StoreType(), role: AppConstants.roleViewStore),
    (name: "أنماط البيع", widget: const PatternLayout(), role: AppConstants.roleViewPattern),
    (name: "الشيكات", widget: const ChequeType(), role: AppConstants.roleViewCheques),
    (name: "الاحصائيات", widget: const StatisticsType(), role: AppConstants.roleViewStatistics),
    (name: "البائعون", widget: const SellerLayout(), role: AppConstants.roleViewSeller),
    (name: "استيراد المعلومات", widget: FilePickerWidget(), role: AppConstants.roleViewImport),
    (name: "الجرد", widget: const InventoryLayout(), role: AppConstants.roleViewInventory),
    (name: "إدارة المستخدمين", widget: const UserManagementType(), role: AppConstants.roleViewUserManagement),
    (name: "إدارة التارجيت", widget: const TargetManagementType(), role: AppConstants.roleViewTarget),
    (name: "إدارة الوقت", widget: const TimeType(), role: AppConstants.roleViewTimer),
    (name: "إدارة البطاقات", widget: const CardManagementType(), role: AppConstants.roleViewCard),
    (name: "إدارة قواعد البيانات", widget: const DataBaseType(), role: AppConstants.roleViewDataBase),
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
    Get.find<ChangesViewModel>().listenChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backGroundColor,
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
                          colors: List.generate(rowData.length, (index) => backGroundColor),
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
                            ), // Placeholder widgets to match the tabs length
                          ), // Provide an empty list to avoid the assertion error
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
