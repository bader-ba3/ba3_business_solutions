import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controller/pattern_model_view.dart';
import '../../controller/sellers_view_model.dart';
import '../../model/global_model.dart';
import '../../utils/logger.dart';
import '../widget/filtering_data_grid.dart';
import 'bond_details_view.dart';
import 'custom_bond_details_view.dart';

class AllBonds extends StatelessWidget {
  const AllBonds({super.key});

  @override
  Widget build(BuildContext context) {
    BondViewModel bondViewModel = Get.find<BondViewModel>();
    RxMap<String, GlobalModel>data = bondViewModel.allBondsItem;
    return Scaffold(
      body: FilteringDataGrid<GlobalModel>(
        title: "السندات",
        constructor: GlobalModel(),
        dataGridSource: data,
        globalType: Const.globalTypeBond,
        onCellTap: (index,id,init) {
          GlobalModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          if (model.bondType == Const.bondTypeDaily) {
            Get.to(() => BondDetailsView(oldId: model.bondId,isStart: false,));
          } else if (model.bondType == Const.bondTypeStart) {
            Get.to(() => BondDetailsView(oldId: model.bondId,isStart: true,));
          }else {
            Get.to(() => CustomBondDetailsView(oldId: model.bondId, isDebit: model.bondType == Const.bondTypeDebit,));
          }
        },
        init: () async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          print("from bonds View");
          final a = await compute<({List<GlobalModel> a,IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.a
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: "bondId", value: order.toJson()['bondId']),
              ...order.toBondAR().entries.map((mapEntry) {
                if (int.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<int>(columnName: mapEntry.key, value: int.parse(mapEntry.value.toString()));
                } else if (double.tryParse(mapEntry.value.toString()) != null) {
                  return DataGridCell<double>(columnName: mapEntry.key, value: double.parse(mapEntry.value.toString()));
                }else if(DateTime.tryParse(mapEntry.value.toString())!=null){
                  return DataGridCell<DateTime>(columnName: mapEntry.key, value: DateTime.parse(mapEntry.value.toString()));
                }else{
                  return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
                }
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(a: data.values.toList(),isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource!.dataGridRows =a;
          return infoDataGridSource;
        },
      ),
    );
  }
}
