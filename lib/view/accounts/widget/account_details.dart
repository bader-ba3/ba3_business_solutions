import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../Const/const.dart';
import '../../../Widgets/new_Pluto.dart';
import '../../../controller/account_view_model.dart';
import '../../bonds/bond_details_view.dart';
import '../../bonds/custom_bond_details_view.dart';
import '../../entry_bond/entry_bond_details_view.dart';

class AccountDetails extends StatefulWidget {
  final String modelKey;
  final List<String> listDate;

  const AccountDetails({super.key, required this.modelKey,required this.listDate});

  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  var accountController = Get.find<AccountViewModel>();
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  List<AccountRecordModel> record = <AccountRecordModel>[];

  @override
  void initState() {
    super.initState();

    accountController.getAllBondForAccount(widget.modelKey,widget.listDate);
    // accountController.initAccountPage(widget.modelKey);

  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AccountViewModel>(builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: CustomPlutoGridWithAppBar(
                title: "حركات ${getAccountNameFromId(widget.modelKey)} من تاريخ  ${widget.listDate.first}  إلى تاريخ  ${widget.listDate.last}",
                // type: Const.globalTypeInvoice,
                onLoaded: (e) {},
                onSelected: (p0) {
                  if (p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeDaily) ||
                      p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeStart) ||
                      p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeInvoice) ||
                      p0.row?.cells["نوع السند"]?.value == (Const.bondTypeStart) ) {
                    Get.to(() => BondDetailsView(
                      bondType: p0.row?.cells["نوع السند"]?.value,
                    ));
                  } else if(p0.row?.cells["نوع السند"]?.value.toString().contains("مولد")??false) {
                    Get.off(() => EntryBondDetailsView(oldId: p0.row?.cells["id"]?.value));
                  }else{
                    Get.to(() => CustomBondDetailsView(
                      oldId: p0.row?.cells["id"]?.value,
                      isDebit: p0.row?.cells["نوع السند"]?.value == Const.bondTypeDebit || p0.row?.cells["نوع السند"]?.value == getBondTypeFromEnum(Const.bondTypeDebit),
                    ));
                  }
                },
                modelList: controller.currentViewAccount,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("المجموع :",style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 24),),
                const SizedBox(width: 10,),
                Text("${controller.searchValue}",style:  TextStyle(color: Colors.blue.shade700,fontWeight: FontWeight.w600,fontSize: 32),),
              ],
            ),
          ],
        ),
      );
    });
  }

/*    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<AccountViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              ElevatedButton(
                  onPressed: () {
                    print(controller.accountList[widget.modelKey]!.toJson());
                    // controller.accountList[widget.modelKey]!.accChild.add("acc1720547397835219");
                    // HiveDataBase.accountModelBox.put(widget.modelKey, controller.accountList[widget.modelKey]!);
                    // FirebaseFirestore.instance.collection(Const.accountsCollection).doc(widget.modelKey).update(controller.accountList[widget.modelKey]!.toJson());
                    Get.to(AddAccount(modelKey: widget.modelKey));
                  },
                  child: Text("تعديل بطاقة الحساب")),

              const SizedBox(
                width: 20,
              ),
              if (controller.accountList[widget.modelKey]!.accRecord.isEmpty)
              ...[  ElevatedButton(
                    onPressed: () {
                      confirmDeleteWidget().then((value) {
                        if (value) {
                          checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewAccount).then((value) {
                            if (value) {
                              controller.deleteAccount(controller.accountList[widget.modelKey]!, withLogger: true);
                              Get.back();
                            }
                          });
                        }
                      });
                    },
                    child: Text("حذف")),    const SizedBox(
                width: 40,
              ),]
            ],
            title: Text(controller.accountList[widget.modelKey]?.accName ?? "error"),
          ),
          body: Column(
            children: [
              Expanded(
                child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SfDataGrid(
                      onCellTap: (DataGridCellTapDetails _) {
                        controller.recordDataSource.dataGridRows[_.rowColumnIndex.rowIndex - 1].getCells().forEach((element) {
                          if (element.columnName == Const.rowAccountId) {
                            var value = element.value;
                            Get.to(() => EntryBondDetailsView(
                                  oldId: value,
                                ));
                          }
                        });
                      },
                      source: controller.recordDataSource,
                      allowEditing: false,
                      selectionMode: SelectionMode.none,
                      editingGestureType: EditingGestureType.tap,
                      navigationMode: GridNavigationMode.cell,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: <GridColumn>[
                        GridColumnItem(label: "الحساب", name: Const.rowAccountName),
                        GridColumnItem(label: "التاريخ", name: Const.rowAccountDate),
                        GridColumnItem(label: "النوع", name: Const.rowAccountType),
                        GridColumnItem(label: 'دائن', name: Const.rowAccountTotal),
                        GridColumnItem(label: 'المدين', name: Const.rowAccountTotal2),
                        GridColumnItem(label: ' الحساب بعد العملية', name: Const.rowAccountBalance),
                        GridColumn(
                            visible: false,
                            allowEditing: false,
                            columnName: Const.rowAccountId,
                            label: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'ID',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        // GridColumnItem(label: 'الرمز التسلسي للعملية',name: Const.rowAccountId),
                      ],
                    )),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "الرصيد النهائي:",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(controller.getBalance(widget.modelKey).toStringAsFixed(2),
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold,fontSize: 24),)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }),
    );*/


  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: false,
        columnName: name,
        label: Container(
            color: Colors.blue.shade700,
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              label.toString(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            )));
  }
}
