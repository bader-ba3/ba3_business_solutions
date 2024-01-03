import 'package:ba3_business_solutions/controller/cost_center_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/view/face/faceView.dart';
import 'package:ba3_business_solutions/view/face/sign-in_screen.dart';
import 'package:ba3_business_solutions/view/face/sign-up_screen.dart';
import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
import 'package:ba3_business_solutions/view/sellers/all_seller_invoice_view.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/add_user.dart';
import 'package:ba3_business_solutions/view/accounts/acconts_view.dart';
import 'package:ba3_business_solutions/view/accounts/widget/add_account.dart';

import 'package:ba3_business_solutions/view/bonds/all_bonds.dart';
import 'package:ba3_business_solutions/view/cheques/all_cheques_view.dart';
import 'package:ba3_business_solutions/view/cost_center/cost_center_view.dart';
import 'package:ba3_business_solutions/view/import/picker_file.dart';

import 'package:ba3_business_solutions/view/invoices/all_Invoice.dart';
import 'package:ba3_business_solutions/view/patterns/all_pattern.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_details.dart';
import 'package:ba3_business_solutions/view/products/product_view.dart';
import 'package:ba3_business_solutions/view/sellers/all_sellers_view.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/all_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/date_range_picker.dart';
import '../stores/all_store.dart';
import 'dart:io';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello " + getMyUserName()),
        actions: [
          if(getMyUserSellerId()!=null)
          ElevatedButton(onPressed: (){
            Get.to(()=> AllSellerInvoice(oldKey: getMyUserSellerId(),));
          }, child: Text("my profile")),
          SizedBox(width: 20,),
          if(!Platform.isMacOS)
          ElevatedButton(onPressed: (){
            Get.to(()=>FaceView());
          }, child: Text("Face"))
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllBonds());
                },
                child: Text("bonds")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AccountsView());
                },
                child: Text("account")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllInvoice());
                },
                child: Text("invoices")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => ProductView());
                },
                child: Text("product")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllStore());
                },
                child: Text("store")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllPattern());
                },
                child: Text("pattern")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllCheques());
                },
                child: Text("cheques")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => CostCenterView());
                },
                child: Text("Tree")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllSellers());
                },
                child: Text("Seller")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => FilePickerWidget());
                },
                child: Text("Import")),
            ElevatedButton(
                onPressed: () {
                  Get.to(() => AllUserView());
                },
                child: Text("User Management")),
          ],
        ),
      ),
    );
  }
}
