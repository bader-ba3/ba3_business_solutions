
import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/accounts/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/cheque_type.dart';
import 'package:ba3_business_solutions/view/dashboard/dashboard_view.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_type.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_type.dart';
import 'package:ba3_business_solutions/view/products/product_type.dart';
import 'package:ba3_business_solutions/view/stores/store_type.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tab_container/tab_container.dart';

import '../card_management/card_management_view.dart';
import '../database/database_type.dart';
import '../import/picker_file.dart';
import '../inventory/inventory_type.dart';
import '../sellers/seller_type.dart';
import '../statistics/statistics_type.dart';
import '../target_management/target_management_view.dart';
import '../timer/time_type.dart';
import '../user_management/user_management.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<({String name, Widget widget, String role})> rowData = [
    (name: "لوحة التحكم", widget: const DashboardView(), role: Const.roleViewHome),
    (name: "الفواتير", widget: const InvoiceType(), role: Const.roleViewInvoice),
    (name: "السندات", widget: const BondType(), role: Const.roleViewBond),
    // (name: "سندات القيد", widget: const EntryBondType(), role: Const.roleViewBond),
    (name: "الحسابات", widget: const AccountType(), role: Const.roleViewAccount),
    (name: "المواد", widget: const ProductType(), role: Const.roleViewProduct),
    (name: "المستودعات", widget: const StoreType(), role: Const.roleViewStore),
    (name: "أنماط البيع", widget: const PatternType(), role: Const.roleViewPattern),
    (name: "الشيكات", widget: const ChequeType(), role: Const.roleViewCheques),
    // (name: "الاستحقاق", widget: const DueType(), role: Const.roleViewDue),
    // (name: "تقرير المبيعات", widget: const ReportGridView(), role: Const.roleViewReport),
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
  late PageController pageController;
  late TabController tabController;
  int tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    allData = rowData.where((element) => checkMainPermission(element.role)).toList();
    tabController = TabController(length: allData.length, vsync: this, initialIndex: tabIndex);
    pageController = PageController();
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
                                 tabIndex=index;
                                 setState(() {

                                 });
         
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
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: MoveWindow()),
                        const WindowButtons(),
                      ],
                    ),
                  ),
                  Expanded(child: ClipRRect(
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

final buttonColors = WindowButtonColors(iconNormal: const Color(0xFF805306), mouseOver: const Color(0xFFF6A00C), mouseDown: const Color(0xFF805306), iconMouseOver: const Color(0xFF805306), iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(mouseOver: const Color(0xFFD32F2F), mouseDown: const Color(0xFFB71C1C), iconNormal: const Color(0xFF805306), iconMouseOver: Colors.white);

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
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
                      width: 40,
                    ),

                    Text(
                      title,
                      style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w700),
                    ),
                  ],
                ))),
      );
    });
  }
}
