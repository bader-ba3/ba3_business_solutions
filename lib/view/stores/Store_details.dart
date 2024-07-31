// import 'package:ba3_business_solutions/controller/store_view_model.dart';
// import 'package:ba3_business_solutions/model/product_model.dart';
// import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
// import 'package:ba3_business_solutions/utils/see_details.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../Const/const.dart';
// import '../../controller/product_view_model.dart';
// import '../../controller/user_management_model.dart';
// import '../../model/store_record_model.dart';
// import 'add_store.dart';

// class StoreDetails extends StatefulWidget {
//   final String? oldKey;
//   const StoreDetails({super.key, this.oldKey});

//   @override
//   State<StoreDetails> createState() => _StoreDetailsState();
// }

// class _StoreDetailsState extends State<StoreDetails> {
//   var storeViewController = Get.find<StoreViewModel>();
//   @override
//   void initState() {
//     super.initState();
    // storeViewController.initStorePage(widget.oldKey);
//     storeViewController.openedStore=widget.oldKey;
//   }
//   @override
//   void dispose() {
//     super.dispose();
//     storeViewController.openedStore=null;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           actions: [
//             ElevatedButton(onPressed: (){
//               Get.to(()=>AddStore(oldKey: widget.oldKey,));
//             }, child: Text("تعديل")),
//             SizedBox(width: 20,),
//             ElevatedButton(onPressed: (){
//               storeViewController.exportStore(widget.oldKey);
//             }, child: Text("إستخراج البيانات")),
//             SizedBox(width: 20,),
//             if(storeViewController.totalAmountPage.isEmpty)
//               ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
//                     foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
//                   ),
//                   onPressed: () {
//                     confirmDeleteWidget().then((value) {
//                       if(value){
//                     checkPermissionForOperation(Const.roleUserDelete,Const.roleViewStore).then((value) {
//                       if(value){
//                         storeViewController.deleteStore(widget.oldKey);
//                         Get.back();
//                       }
//                     });
//     }
//   });

//                   },
//                   child: const Text("حذف")),
//             SizedBox(width: 20,),
//           ],
//         ),
//         body: GetBuilder<StoreViewModel>(
//           builder: (controller) {
//            return controller.totalAmountPage.isEmpty
//              ?Center(child: Text("هذا المستودع فارغ"),)
//              :ListView.builder(
//                itemCount: controller.totalAmountPage.length,
//                itemBuilder: (context,index){
//                  MapEntry<String,double> model= controller.totalAmountPage.entries.toList()[index];
//                  ProductModel product = getProductModelFromId(model.key)!;
//              return Column(
//                children: [
//                  Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: [
//                        Text(product.prodFullCode!,style: TextStyle(fontSize: 20),),
//                        SizedBox(
//                         width: 400,
//                         child: Text(product.prodName!,style: TextStyle(fontSize: 20),)),
//                        Text(model.value.toString(),style: TextStyle(fontSize: 20),),
//                      ],
//                    ),
//                  ),
//                  Container(width: double.infinity,height: 2,color: Colors.grey.shade200,)
//                ],
//              );
//            });
//           }
//         ),
//       ),
//     );
//   }
// }
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/store_record_model.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../widget/filtering_data_grid.dart';


class StoreDetails extends StatelessWidget {
    final String? oldKey;
  const StoreDetails({super.key, this.oldKey});

  @override
  Widget build(BuildContext context) {
    StoreViewModel storeViewModel = Get.find<StoreViewModel>();
    RxMap<String, StoreRecordView> data =  storeViewModel.allData.obs;
    return Scaffold(
      body: FilteringDataGrid<StoreRecordView>(
        title: storeViewModel.storeMap[oldKey]!.stName.toString(),
        constructor: StoreRecordView(),
        dataGridSource:data,
        onCellTap: (index,id,init) {
          Get.to(() => ProductDetails(
            oldKey: id,
          ));
        },
        init: ()async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          final a = await   compute<({IsolateViewModel isolateViewModel , String storeKey}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
             message.isolateViewModel.initStorePage(message.storeKey);
            List<DataGridRow> dataGridRow  = message.isolateViewModel.allData.entries
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: "storeRecId", value: order.key),
              ...order
                  .value.toAR()
                  .entries
                  .map((mapEntry) {
                    if(mapEntry.value.runtimeType == int){
                             return DataGridCell<int>(columnName: mapEntry.key, value: mapEntry.value);
                    }else{
                        return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
                    }
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(isolateViewModel:isolateViewModel,storeKey:oldKey!));
          
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;

        },
      ),
    );
  }
}