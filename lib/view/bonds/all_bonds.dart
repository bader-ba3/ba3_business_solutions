import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Widgets/new_Pluto.dart';

import 'bond_details_view.dart';
import 'custom_bond_details_view.dart';

class AllBonds extends StatelessWidget {
  const AllBonds({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BondViewModel>(builder: (controller) {
      return CustomPlutoGrid(
        title: "جميع الفواتير",
        onLoaded: (e) {},
        onSelected: (p0) {

          if (p0.row?.cells["bondType"]?.value == getBondTypeFromEnum(Const.bondTypeDaily) || p0.row?.cells["bondType"]?.value == getBondTypeFromEnum(Const.bondTypeStart) || p0.row?.cells["bondType"]?.value == getBondTypeFromEnum(Const.bondTypeInvoice)) {
            Get.to(() => BondDetailsView(
                  oldId: p0.row?.cells["bondId"]?.value,
                  bondType: p0.row?.cells["bondType"]?.value,
                ));
          } else {
            Get.to(() => CustomBondDetailsView(
                  oldId: p0.row?.cells["bondId"]?.value,
                  isDebit: p0.row?.cells["bondType"]?.value == Const.bondTypeDebit,
                ));
          }
        },
        modelList: controller.allBondsItem.values.toList(),
      );
    });
  }
}
/*  return Scaffold(
      body: */ /*FilteringDataGrid<GlobalModel>(
        title: "السندات",
        constructor: GlobalModel(),
        dataGridSource: data,
        globalType: Const.globalTypeBond,
        onCellTap: (index,id,init) {
          GlobalModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          if (model.bondType == Const.bondTypeDaily ||model.bondType == Const.bondTypeStart ||model.bondType == Const.bondTypeInvoice ) {
            Get.to(() => BondDetailsView(oldId: model.bondId,bondType: model.bondType!,));
          } else {
            Get.to(() => CustomBondDetailsView(oldId: model.bondId, isDebit: model.bondType == Const.bondTypeDebit,));
          }
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          final a = await compute<({List<GlobalModel> a,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.a
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: "bondId", value: order.toJson()['bondId']),
              ...order.toBondAR().entries.map((mapEntry) {
                // if (int.tryParse(mapEntry.value.toString()) != null) {
                //   return DataGridCell<int>(columnName: mapEntry.key, value: int.parse(mapEntry.value.toString()));
                // } else if (double.tryParse(mapEntry.value.toString()) != null) {
                //   return DataGridCell<double>(columnName: mapEntry.key, value: double.parse(mapEntry.value.toString()));
                // }
                // else
                if(mapEntry.key == "bondDate"){
                  // int day = int.parse(mapEntry.value.toString().split("-")[2]);
                  // int month =  int.parse(mapEntry.value.toString().split("-")[1]);
                  // int year =  int.parse(mapEntry.value.toString().split("-")[0]);
                  return DataGridCell<DateTime>(columnName: mapEntry.key, value:DateTime.parse(mapEntry.value));
                }
                else{
                  return DataGridCell<String>(columnName: mapEntry.key, value: (mapEntry.value??"-").toString());
                }
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(a: data.values.toList(),isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;
        },
      ),*/ /*
    );*/
