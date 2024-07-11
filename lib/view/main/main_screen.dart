import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/accounts/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/cheque_type.dart';
import 'package:ba3_business_solutions/view/dashboard/dashboard_view.dart';
import 'package:ba3_business_solutions/view/due/due_type.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_type.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_type.dart';
import 'package:ba3_business_solutions/view/products/product_type.dart';
import 'package:ba3_business_solutions/view/report/report_view.dart';
import 'package:ba3_business_solutions/view/stores/store_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  List<({String name, String img, Widget widget,String role})> rowData = [
    (name: "لوحة التحكم", img: "assets/icons/menu_dashboard.svg", widget: DashboardView(),role:Const.roleViewHome ),
    (name: "الفواتير", img: "assets/icons/menu_profile.svg", widget: InvoiceType(),role:Const.roleViewInvoice ),
    (name: "السندات", img: "assets/icons/menu_profile.svg", widget: BondType(),role:Const.roleViewBond ),
    (name: "الحسابات", img: "assets/icons/menu_tran.svg", widget: AccountType(),role:Const.roleViewAccount ),
    (name: "المواد", img: "assets/icons/menu_task.svg", widget: ProductType(),role:Const.roleViewProduct ),
    (name: "المستودعات", img: "assets/icons/menu_task.svg", widget: StoreType(),role:Const.roleViewStore ),
    (name: "أنماط البيع", img: "assets/icons/menu_task.svg", widget: PatternType(), role:Const.roleViewPattern),
    (name: "الشيكات", img: "assets/icons/trip.svg", widget:ChequeType(),role:Const.roleViewCheques ),
    (name: "الاستحقاق", img: "assets/icons/garage.svg", widget: DueType(),role:Const.roleViewDue ),
    (name: "تقرير المبيعات", img: "assets/icons/garage.svg", widget: ReportGridView(), role:Const.roleViewReport),
    (name: "الاحصائيات", img: "assets/icons/menu_tran.svg", widget: StatisticsType(), role:Const.roleViewStatistics),
    (name: "البائعون", img: "assets/icons/menu_setting.svg", widget: SellerType(), role:Const.roleViewSeller),
    (name: "استيراد المعلومات", img: "assets/icons/menu_setting.svg", widget: FilePickerWidget(),role:Const.roleViewImport ),
    (name: "الجرد", img: "assets/icons/garage.svg", widget: InventoryType(),role:Const.roleViewInventory ),
    (name: "إدارة المستخدمين", img: "assets/icons/garage.svg", widget: UserManagementType(),role:Const.roleViewUserManagement ),
    (name: "إدارة التارجيت", img: "assets/icons/garage.svg", widget: TargetManagementType(),role:Const.roleViewTarget ),
    (name: "إدارة الوقت", img: "assets/icons/garage.svg", widget: TimeType(),role:Const.roleViewTimer ),
    (name: "إدارة البطاقات", img: "assets/icons/garage.svg", widget: CardManagementType(),role:Const.roleViewCard ),
    (name: "إدارة قواعد البيانات", img: "assets/icons/garage.svg", widget: DataBaseType(),role:Const.roleViewDataBase ),
  ];
 List<({String name, String img, Widget widget,String role})> allData=[];
  //  TabController? tabController;
  late PageController pageController;
  late TabController tabController ;
int tabIndex= 0;
  @override
  void initState() {
    allData = rowData.where((element) => checkMainPermission(element.role),).toList();

    tabController = TabController(length: allData.length, vsync: this,initialIndex: tabIndex);
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
                  allData = rowData.where((element) => checkMainPermission(element.role),).toList();
                 tabController = TabController(length: allData.length, vsync: this,initialIndex: tabIndex);
                //   pageController = PageController(initialPage: tabIndex);
                //  print(tabIndex);
                //  print(tabController.index);
                //  GlobalKey tabKey = GlobalKey();
                //  tabController.addListener(() {
                //   pageController.jumpToPage(tabController.index);
                //   setState(() {});
                // });
                  if(allData.isEmpty){
                    return Center(child: Text("ليس لديك صلاحيات",style: TextStyle(color:Colors.white,fontSize: 30),),);
                  }
                  return StatefulBuilder(
                    builder: (context,setstate) {
                      return TabContainer(
                     //  key: tabKey,
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
                        unselectedTextStyle: TextStyle(
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
                              svgSrc: allData[index].img,
                              press: () {
                                print(index);
                                tabController.index = index;
                                tabIndex = index;
                               pageController.jumpToPage(index);
                                setstate(() {});
                              },
                            );
                          },
                        ),
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: List.generate(allData.length, (index) => ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: allData[index].widget,
                          )),
                        ),
                      );
                    }
                  );
                }
              ),
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
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalViewModel>(builder: (controller) {
      return InkWell(
        onTap: press,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: controller.isDrawerOpen
              ? Center(child: Row(
            children: [
              SizedBox(width: 30,),
              // SvgPicture.asset(
              //   svgSrc,
              //   colorFilter: ColorFilter.mode(Color(0xff00308F), BlendMode.srcIn),
              //   height: 20,
              // ),
              SizedBox(width: 10,),
        
              Text(title, style: TextStyle(color:Colors.black),),
            ],
          ))
              : Center(child: Row(
            children: [
              SizedBox(width: 20,),
              // SvgPicture.asset(
              //   svgSrc,
              //   colorFilter: ColorFilter.mode(Color(0xff00308F), BlendMode.srcIn),
              //   height: 20,
              // ),
            ],
          ),),
        ),
      );
    });
  }
}
