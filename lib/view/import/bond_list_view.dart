import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/import_view_model.dart';
import '../../model/bond_record_model.dart';
import '../../model/global_model.dart';

class BondListView extends StatelessWidget {
  final List<GlobalModel>bondList;
   BondListView({super.key, required this.bondList});
  var importViewModel = Get.find<ImportViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: (){
           if( importViewModel.checkAllAccount(bondList)){
            importViewModel.addBond(bondList);
           }
          }, child: Text("add"))
        ],
      ),
      body: ListView.builder(
          itemCount: bondList.length,
          itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(bondList[index].bondId.toString()),
                  Text("المجموع: "+bondList[index].bondTotal.toString()),
                  Text("الوقت: "+bondList[index].bondDate.toString()),
                  Text("نوع الفاتورة: "+getBondTypeFromEnum(bondList[index].bondType.toString())),
                  Text("الرمز: "+bondList[index].bondCode.toString()),
                  Text("الرمز: "+bondList[index].bondType.toString()),
                  Text("الوصف: "+bondList[index].bondDescription.toString()),
                ],
              ),
              SizedBox(height: 15,),
              // Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      SizedBox(
                        width: 50,
                        child: Text("الوصف",style: TextStyle(fontSize: 20),)),
                    Container(height: 30,width: 2,color: Colors.grey.shade300,),
                    SizedBox(
                        width: 50,
                        child: Text("دائن",style: TextStyle(fontSize: 20),)),
                    Container(height: 30,width: 2,color: Colors.grey.shade300,),
                    SizedBox(
                        width: 50,
                        child: Text("مدين",style: TextStyle(fontSize: 20),)),
                    Container(height: 30,width: 2,color: Colors.grey.shade300,),
                    SizedBox(
                      width: 300,
                        child: Text("الحساب",style: TextStyle(fontSize: 20),)),
                    Container(height: 30,width: 2,color:Colors.grey.shade300,),
                    SizedBox(
                        width: 50,
                        child: Text("الرمز",style: TextStyle(fontSize: 20),)),
                  ],
                ),
              ),
              for(BondRecordModel e in bondList[index].bondRecord??[])
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 50,
                          child: Text(e.bondRecDescription.toString())),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(e.bondRecCreditAmount.toString())),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(e.bondRecDebitAmount.toString())),
                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(getAccountNameFromId(e.bondRecAccount)=="")
                                Text("غير موجود"+ e.bondRecAccount.toString(),style: TextStyle(color: Colors.red),),
                              Expanded(child: Text(e.bondRecAccount.toString()+" "+getAccountNameFromId(e.bondRecAccount))),
                            ],
                          )),

                      Container(height: 30,width: 2,color: Colors.grey.shade300,),
                      SizedBox(
                          width: 50,
                          child: Text(e.bondRecId.toString())),
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

