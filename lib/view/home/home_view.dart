import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/accounts/account_type.dart';
import 'package:ba3_business_solutions/view/bonds/bond_type.dart';
import 'package:ba3_business_solutions/view/cheques/cheque_type.dart';
import 'package:ba3_business_solutions/view/face/faceView.dart';
import 'package:ba3_business_solutions/view/invoices/invoice_type.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_type.dart';
import 'package:ba3_business_solutions/view/products/product_type.dart';
import 'package:ba3_business_solutions/view/sellers/all_seller_invoice_view.dart';
import 'package:ba3_business_solutions/view/accounts/acconts_view.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds.dart';
import 'package:ba3_business_solutions/view/cheques/all_cheques_view.dart';
import 'package:ba3_business_solutions/view/cost_center/cost_center_view.dart';
import 'package:ba3_business_solutions/view/import/picker_file.dart';

import 'package:ba3_business_solutions/view/invoices/all_Invoice.dart';
import 'package:ba3_business_solutions/view/patterns/all_pattern.dart';
import 'package:ba3_business_solutions/view/products/product_view.dart';
import 'package:ba3_business_solutions/view/sellers/all_sellers_view.dart';
import 'package:ba3_business_solutions/view/sellers/seller_type.dart';
import 'package:ba3_business_solutions/view/stores/store_type.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/all_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/invoice_view_model.dart';
import '../database/database_type.dart';
import '../sellers/widget/SellerChart.dart';
import '../stores/all_store.dart';
import 'dart:io';

import '../user_management/account_management_view.dart';
import '../user_management/user_management.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello " + getMyUserName()+"     "+Const.dataName+"   "+Const.bondsCollection),
        actions: [
          if(getMyUserSellerId()!=null)
          ElevatedButton(onPressed: (){
            Get.to(()=> AllSellerInvoice(oldKey: getMyUserSellerId(),));
          }, child: Text("ملفي الشخصي")),
          SizedBox(width: 20,),
          if(!Platform.isMacOS)
          ElevatedButton(onPressed: (){
            Get.to(()=>FaceView());
          }, child: Text("التعرف على الوجه"))
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text("مييعاتي",style: TextStyle(fontSize: 25),),),
            SellerChart(),
            Expanded(
              child: SingleChildScrollView(
                physics:const BouncingScrollPhysics(),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Wrap(
                    children: [
                    item("الفواتير",1,InvoiceType()),
                    item("السندات",2,BondType()),
                    item("الحسابات",3,AccountType()),
                    item("المواد",4,ProductType()),
                    item("المستودعات",5,StoreType()),
                    item("أنماط البيع",6,PatternType()),
                    item("الشيكات",7,ChequeType()),
                  //  item("شجرة",8,CostCenterView()),
                    item("البائعون",9,SellerType()),
                    item("استيراد معلومات",10,FilePickerWidget()),
                    item("إدارة المستخدمين",11,UserManagementType()),
                    item("إدارة قواعد البيانات",12,DataBaseType()),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllBonds());
                    //     },
                    //     child:),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AccountsView());
                    //     },
                    //     child: Text("account")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllInvoice());
                    //     },
                    //     child: Text("invoices")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => ProductView());
                    //     },
                    //     child: Text("product")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllStore());
                    //     },
                    //     child: Text("store")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllPattern());
                    //     },
                    //     child: Text("pattern")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllCheques());
                    //     },
                    //     child: Text("cheques")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => CostCenterView());
                    //     },
                    //     child: Text("Tree")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllSellers());
                    //     },
                    //     child: Text("Seller")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => FilePickerWidget());
                    //     },
                    //     child: Text("Import")),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.to(() => AllUserView());
                    //     },
                    //     child: Text("User Management")),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
  Widget item(text,index,Widget nextPage){
  return  SizedBox(
    width: 250,
    height: 250,
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (){
            Get.to(() => nextPage);
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(index.toString(),style: TextStyle(fontSize: 70,fontWeight: FontWeight.bold),),
                Text(text,style: TextStyle(fontSize: 30),),
              ],
            ),
          ),
        ),
      ),
  );
  }
}
