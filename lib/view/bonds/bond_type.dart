import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds_old.dart';
import 'package:ba3_business_solutions/view/bonds/bond_report.dart';
import 'package:ba3_business_solutions/view/invoices/all_Invoice_old.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../model/Pattern_model.dart';
import 'all_bonds.dart';
import 'bond_details_view.dart';
import 'custom_bond_details_view.dart';

class BondType extends StatefulWidget {
  const BondType({super.key});

  @override
  State<BondType> createState() => _BondTypeState();
}

class _BondTypeState extends State<BondType> {
  PatternViewModel patternController=Get.find<PatternViewModel>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("السندات"),
        ),
        body: Column(
          children: [
            Item("سند يومية",(){
              Get.to(() => BondDetailsView(bondType: Const.bondTypeDaily,));
            }),
            Item("سند دفع",(){
              Get.to(() => CustomBondDetailsView(isDebit: true));
            }),
            Item("سند قبض",(){
              Get.to(() => CustomBondDetailsView(isDebit: false));
            }),
            Item("قيد افتتاحي",(){
              Get.to(() => BondDetailsView(bondType: Const.bondTypeStart,));
            }),
             if(checkPermission(Const.roleUserAdmin , Const.roleViewInvoice))
            Item("عرض جميع السندات",(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewBond).then((value) {
                if(value) Get.to(()=>AllBonds());
              });
            }),
             if(checkPermission(Const.roleUserAdmin , Const.roleViewInvoice))
            Item("عرض تقرير السندات",(){
              checkPermissionForOperation(Const.roleUserRead , Const.roleViewBond).then((value) {
                if(value) Get.to(()=>BondReport());
              });
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
