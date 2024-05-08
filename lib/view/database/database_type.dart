import 'package:ba3_business_solutions/controller/database_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/bonds/all_bonds.dart';
import 'package:ba3_business_solutions/view/database/database_view.dart';
import 'package:ba3_business_solutions/view/invoices/all_Invoice.dart';
import 'package:ba3_business_solutions/view/patterns/all_pattern.dart';
import 'package:ba3_business_solutions/view/patterns/pattern_details.dart';
import 'package:ba3_business_solutions/view/products/product_view.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../old_model/Pattern_model.dart';

class DataBaseType extends StatefulWidget {
  const DataBaseType({super.key});

  @override
  State<DataBaseType> createState() => _DataBaseTypeState();
}

class _DataBaseTypeState extends State<DataBaseType> {
  DataBaseViewModel dataBaseController=Get.find<DataBaseViewModel>();

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value){
    checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewUserManagement).then((value) {
      if(value){
      }else{
        Get.back();
      }
    });
     });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("إدارة قواعد البيانات"),
        ),
        body: Column(
          children: [
            Item("إضافة قاعدة بيانات",(){
              Get.defaultDialog(content: SizedBox(
                height: 100,
                width: 200,
                child: TextFormField(onFieldSubmitted: (_){
                  Get.back();
                  dataBaseController.newDataBase(_);
                },),
              ));
            }),

            Item("تحديد قاعدة البيانات الافتراضية",(){
              // Get.to(() => AddDataBase());
              Get.defaultDialog(content: SizedBox(
                height: 100,
                width: 200,
                child: TextFormField(onFieldSubmitted: (_){
                  Get.back();
                  dataBaseController.setDefaultDataBase(_);
                },),
              ));

            }),
            Item("تغيير قاعدة البيانات",(){
              Get.to(()=> DataBaseView());
              // checkPermissionForOperation(Const.roleUserRead , Const.roleViewPattern).then((value) {
              //   if(value) Get.to(()=>AllPattern());
              // });
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
