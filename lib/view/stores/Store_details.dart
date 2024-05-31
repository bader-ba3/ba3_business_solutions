import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/utils/see_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/product_view_model.dart';
import '../../controller/user_management_model.dart';
import '../../model/store_record_model.dart';
import 'add_store.dart';

class StoreDetails extends StatefulWidget {
  final String? oldKey;
  const StoreDetails({super.key, this.oldKey});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  var storeViewController = Get.find<StoreViewModel>();
  @override
  void initState() {
    super.initState();
    storeViewController.initStorePage(widget.oldKey);
    storeViewController.openedStore=widget.oldKey;
  }
  @override
  void dispose() {
    super.dispose();
    storeViewController.openedStore=null;
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(onPressed: (){
              Get.to(()=>AddStore(oldKey: widget.oldKey,));
            }, child: Text("تعديل")),
            SizedBox(width: 20,),
            ElevatedButton(onPressed: (){
              storeViewController.exportStore(widget.oldKey);
            }, child: Text("إستخراج البيانات")),
            SizedBox(width: 20,),
            if(storeViewController.totalAmountPage.isEmpty)
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    confirmDeleteWidget().then((value) {
                      if(value){
                    checkPermissionForOperation(Const.roleUserDelete,Const.roleViewStore).then((value) {
                      if(value){
                        storeViewController.deleteStore(widget.oldKey);
                        Get.back();
                      }
                    });
    }
  });

                  },
                  child: const Text("حذف")),
            SizedBox(width: 20,),
          ],
        ),
        body: GetBuilder<StoreViewModel>(
          builder: (controller) {
           return controller.totalAmountPage.isEmpty
             ?Center(child: Text("هذا المستودع فارغ"),)
             :ListView.builder(
               itemCount: controller.totalAmountPage.length,
               itemBuilder: (context,index){
                 MapEntry<String,double> model= controller.totalAmountPage.entries.toList()[index];
             return Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Text(getProductNameFromId(model.key),style: TextStyle(fontSize: 20),),
                       Text(model.value.toString(),style: TextStyle(fontSize: 20),),
                     ],
                   ),
                 ),
                 Container(width: double.infinity,height: 2,color: Colors.grey.shade200,)
               ],
             );
           });
            // return ListView.builder(
            //     itemCount: controller.storeMap[widget.oldKey]?.stRecords.length,
            //     itemBuilder: (context,index){
            //       StoreRecordModel? model = controller.storeMap[widget.oldKey]?.stRecords.values.toList()[index];
            //       return Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: [
            //             Row(
            //               children: [
            //                 Spacer(),
            //                 Text("sell invoice"),
            //                 SizedBox(width: 30,),
            //                 InkWell(
            //                   onTap: (){
            //                     seeDetails(model!.storeRecInvId!);
            //                   },
            //                   child: Container(
            //                     color: Colors.grey.shade200,
            //                     child: Row(
            //                       children: [
            //                         SizedBox(width: 5,),
            //                         Icon(Icons.search),
            //                         SizedBox(width: 10,),
            //                         Text("عرض المزيد"),
            //                         SizedBox(width: 5,),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 Spacer(),
            //               ],
            //             ),
            //            for(StoreRecProductModel element in model?.storeRecProduct?.values.toList()??[])
            //              SizedBox(
            //                height: 40,
            //                child: Row(
            //                  children: [
            //                    Spacer(),
            //                    Expanded(child: Text(getProductNameFromId(element.storeRecProductId))),
            //                    Expanded(child: Text(element.storeRecProductQuantity??"error")),
            //                    Expanded(child: Text(double.parse(element.storeRecProductPrice??"0").toStringAsFixed(2))),
            //                    Expanded(child: Text(double.parse(element.storeRecProductTotal??"0").toStringAsFixed(2))),
            //                  ],
            //                ),
            //              ),
            //             SizedBox(height: 10,),
            //             Container(width: double.infinity,color: Colors.grey.shade200,height: 2,),
            //             SizedBox(height: 10,)
            //           ],
            //         ),
            //       );
            // });
          }
        ),
      ),
    );
  }
}
