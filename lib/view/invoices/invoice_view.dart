import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/utils/date_picker.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/invoices/widget/qr_invoice.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
import 'package:ba3_business_solutions/view/stores/add_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../controller/bond_view_model.dart';
import '../../controller/invoice_view_model.dart';
import '../../controller/pattern_model_view.dart';
import '../../controller/user_management_model.dart';
import '../../model/invoice_record_model.dart';
import '../../utils/generate_id.dart';
import '../../utils/see_details.dart';

class InvoiceView extends StatefulWidget {
  InvoiceView({Key? key, required this.billId, required this.patternId}) : super(key: key);
  String billId;
  String patternId;
  PatternModel? patternModel;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final invoiceController = Get.find<InvoiceViewModel>();
  final globalController = Get.find<GlobalViewModel>();
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
      widget.patternModel = invoiceController.patternController.patternModel[invoiceController.invoiceModel[widget.billId]!.patternId!];
      invoiceController.buildInvInit(true, widget.billId);
    } else {
      widget.patternModel = invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.getInit(widget.patternModel!.patId!);
     // globalController.dateController = DateTime.now().toString().split(" ")[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.patternModel!.toJson());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

        appBar: AppBar(
          title:  Text(widget.billId == "1"?"فاتورة "+(widget.patternModel?.patName??""):"تفاصبل فاتورة "+(widget.patternModel?.patName??"")),
          actions: [
            IconButton(onPressed: () async {
            var  a = await Get.to(()=>QRScannerView()) as List<ProductModel>?;
            if(a==null){
            }else{
              invoiceController.addProductToInvoice(a);
            }

            }, icon: Icon(Icons.qr_code)),
            SizedBox(width: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Text("تاريخ الفاتورة : ", style: TextStyle()),
                      SizedBox(
                        //  width: Get.width * 0.07,
                        child: GetBuilder<InvoiceViewModel>(builder: (controller) {
                          return DatePicker(
                            initDate: invoiceController.dateController,
                            onSubmit: (_) {
                              invoiceController.dateController = _.toString().split(" ")[0];
                              controller.update();
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                  SizedBox(width: 20,),
                  IconButton(
                      onPressed: () {
                        invoiceController.prevInv(widget.patternModel!.patId!, invoiceController.invCodeController.text);
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_right)),
                  // const Text("Invoice Code : "),
                  SizedBox(width: Get.width * 0.10, child: customTextFieldWithoutIcon(invoiceController.invCodeController, true)),
                  IconButton(
                      onPressed: () {
                        invoiceController.nextInv(widget.patternModel!.patId!, invoiceController.invCodeController.text);
                      },
                      icon: const Icon(Icons.keyboard_double_arrow_left)),
                ],
              ),
              // child: Row(
              //   children: [
              //     SizedBox(width: Get.width * 0.30, child: customTextFieldWithoutIcon(TextEditingController(text:invoiceController.initModel.invId), false)),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     SizedBox(width: Get.width * 0.30, child: customTextFieldWithoutIcon(TextEditingController(text:invoiceController.initModel.bondId), false)),
              //   ],
              // ),
            ),
            SizedBox(width: 20,),
          ],
        ),
        body: GetBuilder<InvoiceViewModel>(builder: (controller) {
          return ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height:  250,
                // color: Colors.white12,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // const Text("من : ", style: TextStyle()),
                            // color: globalController.initModel.invType == "sales"
                            //     ? Colors.redAccent
                            //     : Colors.greenAccent)),
                            SizedBox(
                              width: Get.width * 0.10,
                              child: customTextFieldWithoutIcon(
                                invoiceController.primaryAccountController,
                                false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),

                        SizedBox(
                          width: 30,
                        ),
                        Row(
                          children: [
                            const Text("رقم الجوال : "),
                            SizedBox(
                              width: Get.width * 0.17,
                              child: customTextFieldWithoutIcon(invoiceController.mobileNumberController,true),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Row(
                          children: [
                            const Text("حساب العميل : "),
                            SizedBox(
                              width: Get.width * 0.20,
                              child: customTextFieldWithIcon(invoiceController.invCustomerAccountController, (text)async {
                                invoiceController.invCustomerAccountController.text= await invoiceController.getAccountComplete(invoiceController.invCustomerAccountController.text);
                              }, onIconPressed: () {
                                AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.invCustomerAccountController.text);
                                if (_ != null) {
                                  Get.to(AccountDetails(modelKey: _.accId!));
                                }
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
                            // const Text(
                            //   "الى : ",
                            // ),
                            SizedBox(
                              width: Get.width * 0.30,
                              child: customTextFieldWithIcon(invoiceController.secondaryAccountController, (text) async {
                                invoiceController.secondaryAccountController.text= await invoiceController.getAccountComplete(invoiceController.secondaryAccountController.text);
                                // invoiceController.getAccountComplete();
                                invoiceController.changeSecAccount();
                              }, onIconPressed: () {
                                AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
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
                              "البائع : ",
                            ),
                            SizedBox(
                              width: Get.width * 0.15,
                              child: customTextFieldWithIcon(invoiceController.sellerController, (text) async {
                                //   globalController.getAccountComplete();
                                var seller = await getSellerComplete(text);
                                // globalController.changeSecAccount();
                                invoiceController.initModel.invSeller = seller;
                                invoiceController.sellerController.text = seller;
                              }, onIconPressed: () {
                                AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
                                if (_ != null) {
                                  Get.to(AddSeller(oldKey: _.accId!));
                                }
                              }),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("المستودع : "),
                            SizedBox(
                              width: Get.width * 0.30,
                              child: Form(
                                key: _formKey,
                                child: customTextFieldWithIcon(invoiceController.storeController, (text) {
                                  invoiceController.getStoreComplete();
                                }, onIconPressed: () {
                                  StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeController.text);
                                  if (_ != null) {
                                    Get.to(AddStore(oldKey: _.stId!));
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
                        const Text("البيان"),
                        SizedBox(
                          height: 35,
                          width: Get.width * 0.7,
                          child: customTextFieldWithoutIcon(invoiceController.noteController, true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(0),
                child: LayoutBuilder(
                  builder: (context, constraints) => SfDataGrid(
                    horizontalScrollPhysics: NeverScrollableScrollPhysics(),
                    verticalScrollPhysics: BouncingScrollPhysics(),
                    source: invoiceController.invoiceRecordSource,
                    // tableSummaryRows: [
                    //   GridTableSummaryRow(color: Colors.blueGrey, showSummaryInRow: true, title: 'Total : {Total} AED', columns: [const GridSummaryColumn(name: 'Total', columnName: Const.rowInvTotal, summaryType: GridSummaryType.sum)], position: GridTableSummaryRowPosition.bottom),
                    // ],
                    columns: [
                      GridColumn(
                          allowEditing: false,
                          width: 50,
                          columnName: Const.rowInvId,
                          label: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(25)),
                              color: Colors.grey,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'الرقم',
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
                              'المادة',
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
                              'الكمية',
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
                              'السعر الإفرادي',
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
                              'إفرادي الضريبة',
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
                              'المجموع',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )),
                      GridColumn(
                          visible: false,
                          allowEditing: false,
                          columnName: Const.rowInvTotalVat,
                          label: const Text('ID'
                          )),
                      // GridColumn(
                      //     allowEditing: false,
                      //     columnName: Const.rowInvTotalVat,
                      //     label: Container(
                      //       decoration: const BoxDecoration(
                      //         borderRadius: BorderRadius.only(topLeft: Radius.circular(25)),
                      //         color: Colors.grey,
                      //       ),
                      //       alignment: Alignment.center,
                      //       child: const Text(
                      //         'مجموع الضريبة',
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     )),
                    ],
                    controller: invoiceController.dataGridController,
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
                            invoiceController.invoiceRecordSource.dataGridRows.removeAt(rowIndex);
                            invoiceController.records.removeAt(rowIndex);
                            invoiceController.invoiceRecordSource.updateDataGridSource();
                          },
                          child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                    },
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
                        Text("المجموع بدون الضريبة"),
                        SizedBox(
                          width: 20,
                        ),
                        Text(invoiceController.computeWithoutVatTotal().toStringAsFixed(2))
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
                        Text("مجموع الضريبة"),
                        SizedBox(
                          width: 20,
                        ),
                        Text(invoiceController.computeVatTotal().toStringAsFixed(2))
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
                          "المجموع مع الضريبة",
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          invoiceController.computeAllTotal().toStringAsFixed(2),
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
                                  'فاتورة جديدة',
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
                                    'إضافة فاتورة',
                                    style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                                  ),
                                  onPressed: () async {
                                    if (invoiceController.checkInvCode()) {
                                      Get.snackbar("فحص المطاييح", "هذا الرمز الرمز يرجى استخدام الرمز: "+invoiceController.getNextCodeInv());
                                    } else if (!invoiceController.checkSellerComplete()) {
                                      Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
                                    } else if (!invoiceController.checkStoreComplete()) {
                                      Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                    } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text)) {
                                      Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
                                    // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                                    //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                                    }else if (invoiceController.primaryAccountController.text.isEmpty) {
                                      Get.snackbar("خطأ تعباية", "يرجى كتابة حشاب البائع");
                                    } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text) {
                                      Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
                                    } else if (invoiceController.records.length < 2) {
                                      Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة");
                                    } else if (invoiceController.checkAllRecord()) {
                                      Get.snackbar("خطأ تعباية", "بعض المنتجات فارغة");
                                    } else {
                                      checkPermissionForOperation(Const.roleUserWrite,Const.roleViewInvoice).then((value) async {
                                        if(value){
                                          await invoiceController.computeTotal(invoiceController.records);
                                         globalController.addGlobalInvoice(_updateData(invoiceController.records));
                                          }
                                      });
                                    }
                                  }),
                            ),
                        ],
                      ),
                      if (controller.initModel.invId != null)
                        Column(
                          children: [
                            ElevatedButton(
                                child: const Text(
                                  'عرض الأصل',
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                                ),
                                onPressed: () async {
                                  seeDetails(invoiceController.initModel.bondId!);
                                }),
                            Spacer(),
                            ElevatedButton(
                                child: const Text(
                                  'تعديل الفاتورة',
                                  style: TextStyle(color: Colors.blueGrey, fontSize: 25),
                                ),
                                onPressed: () async {
                                  // if (globalController.invCodeList.contains(
                                  //     globalController.invCodeController.text)) {
                                  if (!invoiceController.checkSellerComplete()) {
                                    Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text)) {
                                    Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
                                  // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                                  //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty) {
                                    Get.snackbar("خطأ تعباية", "يرجى كتابة حشاب البائع");
                                  } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text) {
                                    Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
                                  } else if (invoiceController.records.length < 2) {
                                    Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة+");
                                  } else if (invoiceController.checkAllRecord()) {
                                    Get.snackbar("خطأ تعباية", "بعض المنتجات فارغة");
                                  } else {
                                    checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewInvoice).then((value) async {
                                      if(value){
                                        await invoiceController.computeTotal(invoiceController.records);
                                        globalController.updateGlobalInvoice(_updateData(invoiceController.records));
                                      }
                                    });

                                      }
                                }),
                          ],
                        ),
                      if (controller.initModel.invId != null)
                        ElevatedButton(
                          style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
                          child: const Text(
                            'حذف الفاتورة',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () async {
                            confirmDeleteWidget().then((value) {
                              if(value){
                                checkPermissionForOperation(Const.roleUserDelete,Const.roleViewInvoice).then((value) async {
                                  if(value){
                                    globalController.deleteGlobal(invoiceController.initModel);
                                    Get.back();
                                  }
                                });
                              }
                            });
                          },
                        )
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  GlobalModel _updateData(List<InvoiceRecordModel> record) {
    var bondController = Get.find<BondViewModel>();
    return GlobalModel(
        readFlags: [HiveDataBase.getMyReadFlag()],
        invVatAccount: getVatAccountFromPatternId(widget.patternModel!.patId!),
        bondId: widget.billId == "1" ? generateId(RecordType.bond) : invoiceController.bondIdController.text,
        invRecords: record,
        patternId: widget.patternModel!.patId!,
        invType: widget.patternModel!.patType!,
        invTotal: invoiceController.total,
        invFullCode: widget.billId == "1" ? widget.patternModel!.patName!+": "+invoiceController.invCodeController.text:invoiceController.initModel.invFullCode,
        invId: widget.billId == "1" ? generateId(RecordType.invoice) : widget.billId,
        invStorehouse: getStoreIdFromText(invoiceController.storeController.text),
        invComment: invoiceController.noteController.text,
        invPrimaryAccount: getAccountIdFromText(invoiceController.primaryAccountController.text),
        invSecondaryAccount: getAccountIdFromText(invoiceController.secondaryAccountController.text),
        invCustomerAccount: invoiceController.invCustomerAccountController.text.isEmpty ?"":getAccountIdFromText(invoiceController.invCustomerAccountController.text),
        invCode: widget.billId == "1" ?invoiceController.invCodeController.text:invoiceController.initModel.invCode,
        invSeller: getSellerIdFromText(invoiceController.sellerController.text),
        invDate: invoiceController.dateController,
        invMobileNumber: invoiceController.mobileNumberController.text,
        bondType: Const.bondTypeDaily,
        bondCode: widget.billId == "1" ? (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString() : invoiceController.initModel.bondCode,
        globalType: Const.globalTypeInvoice
    );
  }
}
