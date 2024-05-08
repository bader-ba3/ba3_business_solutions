import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/import_view_model.dart';
import '../../old_model/bond_record_model.dart';
import '../../old_model/global_model.dart';
import '../../old_model/invoice_record_model.dart';

class InvoiceListView extends StatelessWidget {
  final List<GlobalModel>invoiceList;
   InvoiceListView({super.key, required this.invoiceList});
  var importViewModel = Get.find<ImportViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: (){
           // if( importViewModel.checkAllAccount(invoiceList)){
             importViewModel.addInvoice(invoiceList);
           // }
          }, child: Text("add"))
        ],
      ),
      body: ListView.builder(
          itemCount: invoiceList.length,
          itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(invoiceList[index].bondId.toString()),
                  Text(invoiceList[index].invId.toString()),
                  Text("المجموع: "+invoiceList[index].invTotal.toString()),
                  Text("الوقت: "+invoiceList[index].invDate.toString()),
                  Text("البائع: "+getSellerNameFromId(invoiceList[index].invSeller.toString())),
                  Text("المستودع: "+getStoreNameFromId(invoiceList[index].invStorehouse.toString())),
                  Text("من: "+getAccountNameFromId(invoiceList[index].invPrimaryAccount.toString())),
                  Text("الى: "+getAccountNameFromId(invoiceList[index].invSecondaryAccount.toString())),
                  Text("الرمز: "+invoiceList[index].invCode.toString()),
                ],
              ),
              SizedBox(height: 15,),
              // Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Spacer(),
                    Expanded(child: SizedBox(width: 20,)),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: 75,
                          child: Text("المجموع",style: TextStyle(fontSize: 20),)),
                    ),
                    // Expanded(child: Container(height: 30,width: 2,color:Colors.grey.shade300,)),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: 50,
                          child: Text("اجمالي الضريبة",style: TextStyle(fontSize: 20),)),
                    ),
                    // Container(height: 30,width: 2,color:Colors.grey.shade300,),
                    // Expanded(child: Container(height: 30,width: 2,color:Colors.grey.shade300,)),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: 50,
                          child: Text("السعر الإفرادي",style: TextStyle(fontSize: 20),)),
                    ),
                    // Expanded(child: Container(height: 30,width: 2,color:Colors.grey.shade300,)),
                    // Container(height: 30,width: 2,color: Colors.grey.shade300,),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: 50,
                          child: Text("الكمية",style: TextStyle(fontSize: 20),)),
                    ),
                    // Expanded(child: Container(height: 30,width: 2,color:Colors.grey.shade300,)),
                    // Container(height: 30,width: 2,color: Colors.grey.shade300,),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: 50,
                          child: Text("المادة",style: TextStyle(fontSize: 20),)),
                    ),
                    // Expanded(child: Container(height: 30,width: 2,color:Colors.grey.shade300,)),
                    // Container(height: 30,width: 2,color:Colors.grey.shade300,),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                          width: 25,
                          child: Text("الرمز",style: TextStyle(fontSize: 20),)),
                    ),
                  ],
                ),
              ),
              for(InvoiceRecordModel e in invoiceList[index].invRecords??[])
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 75,
                          child: Text(e.invRecTotal!.toStringAsFixed(2))),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(e.invRecVat!.toStringAsFixed(2))),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(e.invRecSubTotal!.toStringAsFixed(2))),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(e.invRecQuantity.toString()+" ")),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(getProductNameFromId(e.invRecProduct.toString()))),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 25,
                          child: Text(e.invRecId.toString())),
                    ],
                  ),
                ),
              Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
            ],
          ),
        );
      }),
    );
  }
}
