import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/utils/date_picker.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
import 'package:ba3_business_solutions/view/stores/store_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../controller/invoice_view_model.dart';
import '../../controller/user_management.dart';
import '../../model/account_record_model.dart';
import '../../utils/generate_id.dart';

class InvoiceView extends StatefulWidget {
  InvoiceView({Key? key, required this.billId, required this.patternId}) : super(key: key);
  String billId;
  String patternId;
  PatternModel? patternModel;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final globalController = Get.find<InvoiceViewModel>();
  final accountController = Get.find<AccountViewModel>();
  final storeController = Get.find<StoreViewModel>();
  final _formKey = GlobalKey<FormState>();

  List<String> codeInvList = [];

  late Map<String, double> columnWidths = {'id': double.nan, 'product': double.nan, 'quantity': double.nan, 'subTotal': double.nan, 'total': double.nan};

  String typeBill = "sales";

  @override
  void initState() {
    if (widget.billId != "1") {
      // 1 == new bill
      widget.patternModel = globalController.patternController.patternModel[globalController.invoiceModel[widget.billId]!.patternId!];
      globalController.buildInvInit(true, widget.billId);
    } else {
      widget.patternModel = globalController.patternController.patternModel[widget.patternId];
      globalController.getInit(widget.patternModel!.patId!);
      globalController.dateController = DateTime.now().toString().split(" ")[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.patternModel!.toJson());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(width: Get.width * 0.30, child: customTextFieldWithoutIcon(globalController.billIDController, false)),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(width: Get.width * 0.30, child: customTextFieldWithoutIcon(globalController.bondIdController, false)),
              ],
            ),
          )
        ],
      ),
      body: GetBuilder<InvoiceViewModel>(builder: (controller) {
        return Container(
          clipBehavior: Clip.hardEdge,
          height: Get.height * 1,
          width: Get.width * 1,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: .5, color: Colors.white), color: Colors.white70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                color: Colors.white,
              ),
              Container(
                height:  300,
                // color: Colors.white12,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              globalController.prevInv(widget.patternModel!.patId!, globalController.invCodeController.text);
                            },
                            icon: const Icon(Icons.keyboard_double_arrow_left)),
                        // const Text("Invoice Code : "),
                        SizedBox(width: Get.width * 0.10, child: customTextFieldWithoutIcon(globalController.invCodeController, true)),

                        IconButton(
                            onPressed: () {
                              globalController.nextInv(widget.patternModel!.patId!, globalController.invCodeController.text);
                            },
                            icon: const Icon(Icons.keyboard_double_arrow_right)),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Text("Customer : ", style: TextStyle()),
                            // color: globalController.initModel.invType == "sales"
                            //     ? Colors.redAccent
                            //     : Colors.greenAccent)),
                            SizedBox(
                              width: Get.width * 0.30,
                              child: customTextFieldWithoutIcon(
                                globalController.primaryAccountController,
                                false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 100,
                        ),
                        Row(
                          children: [
                            const Text("Date : ", style: TextStyle()),
                            SizedBox(
                          //    width: Get.width * 0.07,
                              child: GetBuilder<InvoiceViewModel>(builder: (controller) {
                                return DatePicker(
                                  initDate: globalController.dateController,
                                  onSubmit: (_) {
                                    globalController.dateController = _.toString().split(" ")[0];
                                    controller.update();
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Account : ",
                            ),
                            SizedBox(
                              width: Get.width * 0.30,
                              child: customTextFieldWithIcon(globalController.secondaryAccountController, (text) {
                                globalController.getAccountComplete();
                                globalController.changeSecAccount();
                              }, onIconPressed: () {
                                AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == globalController.secondaryAccountController.text);
                                if (_ != null) {
                                  Get.to(AccountDetails(modelKey: _.accId!));
                                }
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Seller : ",
                            ),
                            SizedBox(
                              width: Get.width * 0.15,
                              child: customTextFieldWithIcon(globalController.sellerController, (text) async {
                                //   globalController.getAccountComplete();
                                var seller = await getSellerComplete(text);
                                // globalController.changeSecAccount();
                                globalController.initModel.invSeller = seller;
                                globalController.sellerController.text = seller;
                              }, onIconPressed: () {
                                AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == globalController.secondaryAccountController.text);
                                if (_ != null) {
                                  Get.to(AddSeller(oldKey: _.accId!));
                                }
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Storehouse : "),
                            SizedBox(
                              width: Get.width * 0.30,
                              child: Form(
                                key: _formKey,
                                child: customTextFieldWithIcon(globalController.storeController, (text) {
                                  globalController.getStoreComplete();
                                }, onIconPressed: () {
                                  StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == globalController.storeController.text);
                                  if (_ != null) {
                                    Get.to(StoreDetails(oldKey: _.stId!));
                                  }
                                }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("comments"),
                        SizedBox(
                          height: 35,
                          width: Get.width * 0.7,
                          child: customTextFieldWithoutIcon(globalController.noteController, true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(

                  margin: const EdgeInsets.all(0),
                  child: LayoutBuilder(
                    builder: (context, constraints) => SfDataGrid(
                      source: globalController.invoiceRecordSource,
                      // tableSummaryRows: [
                      //   GridTableSummaryRow(color: Colors.blueGrey, showSummaryInRow: true, title: 'Total : {Total} AED', columns: [const GridSummaryColumn(name: 'Total', columnName: Const.rowInvTotal, summaryType: GridSummaryType.sum)], position: GridTableSummaryRowPosition.bottom),
                      // ],
                      columns: [
                        GridColumn(
                            allowEditing: false,
                            width: columnWidths['id']!,
                            columnName: Const.rowInvId,
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
                        GridColumn(
                            width: columnWidths['product']!,
                            columnWidthMode: ColumnWidthMode.fill,
                            columnName: Const.rowInvProduct,
                            label: Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: const Text(
                                'Product',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        GridColumn(
                            width: columnWidths['quantity']!,
                            columnName: Const.rowInvQuantity,
                            label: Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: const Text(
                                'Quantity',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        GridColumn(
                            width: columnWidths['subTotal']!,
                            columnName: Const.rowInvSubTotal,
                            label: Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: const Text(
                                'SubTotal',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        GridColumn(
                            allowEditing: false,
                            columnName: Const.rowInvVat,
                            label: Container(
                              color: Colors.grey,
                              alignment: Alignment.center,
                              child: const Text(
                                'Vat',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        GridColumn(
                            allowEditing: true,

                            columnName: Const.rowInvTotal,
                            label: Container(
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Total',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                        GridColumn(
                            allowEditing: false,

                            columnName: Const.rowInvTotalVat,
                            label: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Total Vat',
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                      ],
                      controller: globalController.dataGridController,
                      columnWidthMode: ColumnWidthMode.none,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                        // setState(() {
                        //   columnWidths[details.column.columnName] =
                        //       details.width;
                        // });
                        return true;
                      },
                      // showColumnHeaderIconOnHover: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowEditing: true,
                      navigationMode: GridNavigationMode.cell,
                      selectionMode: SelectionMode.singleDeselect,
                      editingGestureType: EditingGestureType.tap,
                      // onCellTap: (DataGridCellTapDetails details) {
                      //   globalController.onCellTap(details);
                      // },

                      allowSwiping: false,
                      swipeMaxOffset: constraints.maxWidth / 2,
                      startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
                        return GestureDetector(
                            onTap: () {
                              globalController.invoiceRecordSource.dataGridRows.removeAt(rowIndex);
                              globalController.records.removeAt(rowIndex);
                              globalController.invoiceRecordSource.updateDataGridSource();
                            },
                            child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue.shade100,
                  width: 225,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Total Without Vat"),
                        SizedBox(
                          width: 20,
                        ),
                        Text(globalController.computeWithoutVatTotal().toStringAsFixed(2))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue.shade100,
                  width: 225,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Total Vat"),
                        SizedBox(
                          width: 20,
                        ),
                        Text(globalController.computeVatTotal().toStringAsFixed(2))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.blue.shade200,
                  width: 300,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Total With Vat",
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          globalController.computeAllTotal().toStringAsFixed(2),
                          style: TextStyle(fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Flexible(
                            child: ElevatedButton(
                                child: const Text(
                                  'New Invoice',
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                                ),
                                onPressed: () async {
                                  checkPermissionForOperation(Const.roleUserWrite,Const.roleViewInvoice).then((value) {
                                    if(value){
                                      controller.getInit(controller.initModel.patternId!);
                                      controller.update();
                                    }
                                  });


                                }),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          if (controller.initModel.invId == null)
                            Flexible(
                              child: ElevatedButton(
                                  // style: const ButtonStyle(
                                  //     backgroundColor: MaterialStatePropertyAll(
                                  //         Colors.indigo)),
                                  child: const Text(
                                    'Add Invoice',
                                    style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                                  ),
                                  onPressed: () async {
                                    if (!globalController.checkSellerComplete()) {
                                      Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
                                    } else if (!globalController.checkStoreComplete()) {
                                      Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                    } else if (!globalController.checkAccountComplete()) {
                                      Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
                                    } else if (globalController.primaryAccountController.text.isEmpty) {
                                      Get.snackbar("خطأ تعباية", "يرجى كتابة حشاب البائع");
                                    } else if (globalController.primaryAccountController.text == globalController.secondaryAccountController.text) {
                                      Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
                                    } else if (globalController.records.length < 2) {
                                      Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة+");
                                    } else if (globalController.checkAllRecord()) {
                                      Get.snackbar("خطأ تعباية", "بعض المنتجات فارغة");
                                    } else {
                                      checkPermissionForOperation(Const.roleUserWrite,Const.roleViewInvoice).then((value) async {
                                        if(value){
                                          await globalController.computeTotal(globalController.records);
                                          await globalController.addBills(_updateData(), globalController.records, false, withLogger: true);
                                        }
                                      });


                                    }
                                  }),
                            ),
                        ],
                      ),
                      if (controller.initModel.invId != null)
                        ElevatedButton(
                            child: const Text(
                              'Save Invoice',
                              style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                            ),
                            onPressed: () async {
                              // if (globalController.invCodeList.contains(
                              //     globalController.invCodeController.text)) {
                              if (!globalController.checkSellerComplete()) {
                                Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
                              } else if (!globalController.checkStoreComplete()) {
                                Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                              } else if (!globalController.checkAccountComplete()) {
                                Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
                              } else if (globalController.primaryAccountController.text.isEmpty) {
                                Get.snackbar("خطأ تعباية", "يرجى كتابة حشاب البائع");
                              } else if (globalController.primaryAccountController.text == globalController.secondaryAccountController.text) {
                                Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
                              } else if (globalController.records.length < 2) {
                                Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة+");
                              } else if (globalController.checkAllRecord()) {
                                Get.snackbar("خطأ تعباية", "بعض المنتجات فارغة");
                              } else {
                                checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewInvoice).then((value) async {
                                  if(value){
                                    await globalController.computeTotal(globalController.records);
                                    await globalController.updateInvoice(globalController.initModel, _updateData(), globalController.records, globalController.initModel.originId!, withLogger: true);

                                  }
                                });

                                  }
                            }),
                      if (controller.initModel.invId != null)
                        ElevatedButton(
                          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
                          child: const Text(
                            'Delete Invoice',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () async {
                            checkPermissionForOperation(Const.roleUserDelete,Const.roleViewInvoice).then((value) async {
                              if(value){
                                if (globalController.invCodeList.contains(globalController.invCodeController.text)) {
                                  await globalController.deleteBills(globalController.initModel, withLogger: true);
                                }
                              }
                            });


                          },
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  GlobalModel _updateData() {
    return GlobalModel(patternId: widget.patternModel!.patId!, invType: widget.patternModel!.patType!, invTotal: globalController.total, invId: widget.billId == "1" ? generateId(RecordType.invoice) : widget.billId, invStorehouse: globalController.storeController.text, invComment: globalController.noteController.text, invPrimaryAccount: globalController.primaryAccountController.text, invSecondaryAccount: globalController.secondaryAccountController.text, invCode: globalController.invCodeController.text, invSeller: globalController.sellerController.text, invDate: globalController.dateController);
  }
}
