import 'package:ba3_business_solutions/controller/cheque/cheque_view_model.dart';
import 'package:ba3_business_solutions/core/shared/widgets/CustomWindowTitleBar.dart';
import 'package:ba3_business_solutions/view/cheques/pages/add_cheque.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/shared/Widgets/new_Pluto.dart';

class AllCheques extends StatelessWidget {
  const AllCheques({super.key, required this.isAll});

  final bool isAll;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChequeViewModel>(builder: (controller) {
      return Column(
        children: [
          const CustomWindowTitleBar(),
          Expanded(
            child: CustomPlutoGridWithAppBar(
              title: isAll ? "جميع الشيكات" : "الشيكات المستحقة",
              type: AppStrings.globalTypeCheque,
              onLoaded: (e) {},
              onSelected: (p0) {
                Get.to(() => AddCheque(
                      modelKey: p0.row?.cells["cheqId"]?.value,
                    ));
              },
              modelList: controller.allCheques.values.where(
                (element) {
                  if (isAll) {
                    return true;
                  } else {
                    return element.cheqStatus != AppStrings.chequeStatusPaid;
                  }
                },
              ).toList(),
            ),
          ),
        ],
      );
    });
/*    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الشيكات")),
        body: StreamBuilder(
                stream: controller.allCheques.stream,
                builder: (context, snapshot) {
                    return GetBuilder<ChequeViewModel>(builder: (controller) {
                      controller.initChequeViewPage();
                      if(controller.allCheques.isEmpty) {
                        return const Center(child: Text("لا يوجد شيكات بعد"),);
                      }

                      return SfDataGrid(
                        onCellTap: (DataGridCellTapDetails details) {
                          if (details.rowColumnIndex.rowIndex != 0) {
                            final rowIndex = details.rowColumnIndex.rowIndex - 1;
                            var rowData = controller.recordViewDataSource[rowIndex];
                            String model = rowData.getCells()[0].value;
                            print('Tapped Row Data: $model');
                            logger(
                                newData: GlobalModel(
                                  cheqId: model,
                                ),
                                transfersType: TransfersType.read);
                            Get.to(() => AddCheque(modelKey: model));
                          }
                        },
                        columns: <GridColumn>[
                          GridColumn(
                              visible: false,
                              allowEditing: false,
                              columnName:  Const.rowViewCheqId,
                              label: const Text('ID'
                              )),
                          GridColumnItem(label: "حالة الشيك", name: Const.rowViewChequeStatus),
                          GridColumnItem(label: 'دائن', name: Const.rowViewChequePrimeryAccount),
                          GridColumnItem(label: 'مدين', name: Const.rowViewChequeSecoundryAccount),
                          GridColumnItem(label: 'كامل المبلغ', name: Const.rowViewChequeAllAmount),
                        ],
                        source: controller.recordViewDataSource,
                        allowEditing: false,
                        selectionMode: SelectionMode.none,
                        editingGestureType: EditingGestureType.tap,
                        navigationMode: GridNavigationMode.cell,
                        columnWidthMode: ColumnWidthMode.fill,
                      );
                    });

                }),
      ),
    );*/
  }
}

GridColumn GridColumnItem({required label, name}) {
  return GridColumn(
      allowEditing: false,
      columnName: name,
      label: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          color: Colors.blue.shade700,
          child: Text(
            label.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          )));
}

// Padding(
// padding: const EdgeInsets.all(30.0),
// child: InkWell(
// onTap: (){
// Get.to(()=>AccountDetails(modelKey: model));
// },
// child: Row(
// children: [
// SizedBox(width:(Get.width*1/5)-15,child: Text(model ?? "")),
// SizedBox(width:(Get.width*1/5)-15,child: Text(accountModel.accId ?? "")),
// SizedBox(width:(Get.width*1/5)-15,child: Text(accountModel.accName ?? "")),
// SizedBox(width:(Get.width*1/5)-15,child: controller.allAccounts[model]!.isNotEmpty ?Text(controller.allAccounts[model]?.last.balance.toString()??""):Text(" ")),
// SizedBox(width:(Get.width*1/5)-15,child: Text(controller.allAccounts[model]!.toList().length.toString() ?? ""))
// ],
// )),
// );
