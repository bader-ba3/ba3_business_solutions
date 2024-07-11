import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds_old.dart';
import 'package:ba3_business_solutions/view/card_management/read_card_view.dart';
import 'package:ba3_business_solutions/view/card_management/write_card_view.dart';
import 'package:ba3_business_solutions/view/cheques/add_cheque.dart';
import 'package:ba3_business_solutions/view/cheques/all_cheques_view.dart';
import 'package:ba3_business_solutions/view/invoices/all_Invoice_old.dart';
import 'package:ba3_business_solutions/view/patterns/all_pattern.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_details.dart';
import 'package:ba3_business_solutions/view/products/product_view_old_old.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:ba3_business_solutions/view/user_management/role_management/role_management_view.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/all_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../model/Pattern_model.dart';

class CardManagementType extends StatefulWidget {
  const CardManagementType({super.key});

  @override
  State<CardManagementType> createState() => _CardManagementTypeState();
}

class _CardManagementTypeState extends State<CardManagementType> {
  bool isAdmin=false;
  UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
  @override
  void initState() {
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
    //   checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewCard).then((value) {
    //     print(value);
    //     if (value) {
    //       isAdmin = true;
    //       setState(() {

    //       });
    //     }
    //   });
    // });

    // userManagementViewController.initAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("الإدارة"),
        ),
        body:Column(
          children: [
            Item("قراءة بطاقة",(){
              Get.to(() => ReadCardView());
            }),
            Item("تعديل بطاقة",(){
              Get.to(() => WriteCardView());
            }),
            Item("حذف صلاحيات بطاقة",(){
              Get.to(() => WriteCardView());
            }),
          ],
        ),
      ),
    );
  }
  Widget Item(text,onTap){
    return   Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1),borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textDirection: TextDirection.rtl,)),
      ),
    );
  }
}

