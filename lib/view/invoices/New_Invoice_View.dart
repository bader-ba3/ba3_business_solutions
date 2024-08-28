import 'package:ba3_business_solutions/Widgets/Discount_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/Widgets/InvoiceEnterShortCut.dart';
import 'package:ba3_business_solutions/Widgets/Custom_Pluto_With_Edite.dart';
import 'package:ba3_business_solutions/Widgets/Invoice_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:ba3_business_solutions/view/invoices/widget/qr_invoice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../Const/const.dart';
import '../../Dialogs/Widgets/Option_Text_Widget.dart';
import '../../Services/Get_Date_From_String.dart';
import '../../Widgets/CustomPlutoShortCut.dart';
import '../../Widgets/DiscountEnterPlutoAction.dart';
import '../../controller/account_view_model.dart';
import '../../controller/entry_bond_view_model.dart';
import '../../controller/global_view_model.dart';
import '../../controller/invoice_view_model.dart';
import '../../controller/pattern_model_view.dart';
import '../../controller/print_view_model.dart';
import '../../controller/product_view_model.dart';
import '../../controller/sellers_view_model.dart';
import '../../controller/store_view_model.dart';
import '../../controller/user_management_model.dart';
import '../../model/Pattern_model.dart';
import '../../model/account_model.dart';
import '../../model/global_model.dart';
import '../../model/invoice_record_model.dart';
import '../../model/product_model.dart';
import '../../model/store_model.dart';
import '../../utils/confirm_delete_dialog.dart';
import '../../utils/date_picker.dart';
import '../../utils/generate_id.dart';
import '../accounts/widget/account_details.dart';
import '../entry_bond/entry_bond_details_view.dart';
import '../sellers/add_seller.dart';
import '../stores/add_store.dart';
import '../widget/CustomWindowTitleBar.dart';
import 'Controller/Screen_View_Model.dart';

class NewInvoiceView extends StatefulWidget {
  NewInvoiceView({Key? key, required this.billId, required this.patternId, this.recentScreen = false}) : super(key: key);
  final String billId;
  final String patternId;
  late final PatternModel? patternModel;
  final bool recentScreen;

  @override
  State<NewInvoiceView> createState() => _NewInvoiceViewState();
}

class _NewInvoiceViewState extends State<NewInvoiceView> {
  final invoiceController = Get.find<InvoiceViewModel>();
  final globalController = Get.find<GlobalViewModel>();
  final accountController = Get.find<AccountViewModel>();
  final storeController = Get.find<StoreViewModel>();
  final plutoEditViewModel = Get.find<InvoicePlutoViewModel>();
  ScreenViewModel screenViewModel = Get.find<ScreenViewModel>();

  List<String> codeInvList = [];

  String? selectedPayType;
  String typeBill = Const.invoiceTypeSales;
  bool isEditDate = false;

  @override
  void initState() {
    if (widget.recentScreen) {
      widget.patternModel = invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.initModel = screenViewModel.openedScreen[widget.billId]!;
      // invoiceController.buildInvInit(false, widget.billId);
      plutoEditViewModel.getRows(invoiceController.initModel.invRecords?.toList() ?? []);
      invoiceController.buildInvInitRecent(screenViewModel.openedScreen[widget.billId]!);

      selectedPayType = invoiceController.initModel.invPayType;
    } else if (widget.billId != "1") {
      widget.patternModel = invoiceController.patternController.patternModel[invoiceController.invoiceModel[widget.billId]!.patternId!];
      invoiceController.buildInvInit(true, widget.billId);
      plutoEditViewModel.getRows(invoiceController.invoiceModel[widget.billId]?.invRecords?.toList() ?? []);
      selectedPayType = invoiceController.initModel.invPayType;
    } else {
      widget.patternModel = invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.getInit(widget.patternModel!.patId!);
      selectedPayType = Const.invPayTypeDue;
      invoiceController.invReturnCodeController.text='';
      invoiceController. invReturnDateController.text='';
      // globalController.dateController = DateTime.now().toString().split(" ")[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.patternModel!.toJson());
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                leadingWidth: 100,
                leading: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        screenViewModel.openedScreen.removeWhere(
                          (key, value) => key == _updateData(plutoEditViewModel.invoiceRecord).invId || key == widget.billId,
                        );
                        screenViewModel.update();

                        Get.back();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.red.shade800, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          )),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        plutoEditViewModel.handleSaveAll();
                        if (plutoEditViewModel.invoiceRecord.firstOrNull?.invRecProduct != null && _updateData(plutoEditViewModel.invoiceRecord).invIsPending == null) {
                          screenViewModel.openedScreen[widget.billId == "1" ? _updateData(plutoEditViewModel.invoiceRecord).invId! : widget.billId] = _updateData(plutoEditViewModel.invoiceRecord);
                          screenViewModel.update();
                        }

                        Get.back();
                      },
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: Colors.blue.shade800, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.download_outlined,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                title: Text(widget.billId == "1" ? "فاتورة ${widget.patternModel?.patName ?? ""}" : "تفاصيل فاتورة " + (widget.patternModel?.patName ?? "")),
                actions: [
                  IconButton(
                      onPressed: () async {
                        var a = await Get.to(() => const QRScannerView()) as List<ProductModel>?;
                        if (a == null) {
                        } else {
                          invoiceController.addProductToInvoice(a);
                        }
                      },
                      icon: const Icon(
                        Icons.qr_code,
                        color: Colors.black,
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: Const.constHeightTextField,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 250,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  "نوع الفاتورة" + ": ",
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    height: Const.constHeightTextField,
                                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black38), borderRadius: BorderRadius.circular(8)),
                                    child: DropdownButton(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      underline: const SizedBox(),
                                      value: selectedPayType,
                                      isExpanded: true,
                                      onChanged: (_) {
                                        selectedPayType = _!;
                                        setState(() {});
                                      },
                                      items: [Const.invPayTypeDue, Const.invPayTypeCash]
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: SizedBox(
                                                    width: double.infinity,
                                                    child: Text(
                                                      getInvPayTypeFromEnum(e),
                                                      textDirection: TextDirection.rtl,
                                                    )),
                                              ))
                                          .toList(),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 250,
                          child: Row(
                            children: [
                              const SizedBox(width: 100, child: Text("تاريخ الفاتورة : ", style: TextStyle())),
                              Expanded(
                                child: GetBuilder<InvoiceViewModel>(builder: (controller) {
                                  return DatePicker(
                                    initDate: invoiceController.dateController,
                                    onSubmit: (_) {
                                      invoiceController.dateController = _.toString().split(".")[0];
                                      isEditDate = true;
                                      controller.update();
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (checkPermission(Const.roleUserAdmin, Const.roleViewInvoice))
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    invoiceController.invNextOrPrev(widget.patternModel!.patId!, invoiceController.invCodeController.text, true);
                                  },
                                  icon: const Icon(Icons.keyboard_double_arrow_right)),
                              // const Text("Invoice Code : "),
                              SizedBox(
                                  width: Get.width * 0.10,
                                  child: customTextFieldWithoutIcon(
                                    invoiceController.invCodeController,
                                    true,
                                    onFieldSubmitted: (text) {
                                      invoiceController.getInvByInvCode(
                                        widget.patternModel!.patId!,
                                        text,
                                      );
                                    },
                                  )),
                              IconButton(
                                  onPressed: () {
                                    invoiceController.invNextOrPrev(widget.patternModel!.patId!, invoiceController.invCodeController.text, false);

                                    // invoiceController.nextInv(widget.patternModel!.patId!, invoiceController.invCodeController.text);
                                  },
                                  icon: const Icon(Icons.keyboard_double_arrow_left)),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              body: GetBuilder<InvoiceViewModel>(builder: (controller) {
                return ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    if (widget.patternModel!.patType != Const.invoiceTypeChange)
                      Column(
                        children: [
                          SizedBox(
                            width: Get.width - 20,
                            child: Wrap(
                              spacing: 20,
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: 10,
                              children: [
                                if (widget.patternModel!.patType == Const.invoiceTypeSales)
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          width: 100,
                                          child: Text(
                                            "المدين : ",
                                          ),
                                        ),
                                        if (widget.patternModel!.patType == Const.invoiceTypeSales)
                                          Expanded(
                                            child: customTextFieldWithIcon(invoiceController.secondaryAccountController, (text) async {
                                              invoiceController.secondaryAccountController.text = await getAccountComplete(invoiceController.secondaryAccountController.text);
                                              // invoiceController.getAccountComplete();
                                              invoiceController.changeSecAccount();
                                            }, onIconPressed: () {
                                              AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
                                              if (_ != null) {
                                                Get.to(AccountDetails(modelKey: _.accId!));
                                              }
                                            }),
                                          )
                                        else if (widget.patternModel!.patType == Const.invoiceTypeBuy)
                                          SizedBox(
                                            width: Get.width * 0.10,
                                            child: customTextFieldWithoutIcon(
                                              invoiceController.secondaryAccountController,
                                              false,
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                else if (widget.patternModel!.patType == Const.invoiceTypeBuy)
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 100, child: Text("الدائن : ", style: TextStyle())),
                                        Expanded(
                                          child: customTextFieldWithIcon(invoiceController.primaryAccountController, (text) async {
                                            invoiceController.primaryAccountController.text = await getAccountComplete(invoiceController.primaryAccountController.text);
                                            // invoiceController.getAccountComplete();
                                            invoiceController.changeSecAccount();
                                          }, onIconPressed: () {
                                            AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.primaryAccountController.text);
                                            if (_ != null) {
                                              Get.to(AccountDetails(modelKey: _.accId!));
                                            }
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 100, child: Text("المستودع : ")),
                                      Expanded(
                                        child: customTextFieldWithIcon(invoiceController.storeController, (text) {
                                          invoiceController.getStoreComplete();
                                        }, onIconPressed: () {
                                          StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeController.text);
                                          if (_ != null) {
                                            Get.to(AddStore(oldKey: _.stId!));
                                          }
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 100, child: Text("رقم الجوال : ")),
                                      Expanded(
                                        child: customTextFieldWithoutIcon(invoiceController.mobileNumberController, true),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 100, child: Text("حساب العميل : ")),
                                      Expanded(
                                        child: customTextFieldWithIcon(invoiceController.invCustomerAccountController, (text) async {
                                          invoiceController.invCustomerAccountController.text = await getAccountComplete(invoiceController.invCustomerAccountController.text);
                                        }, onIconPressed: () {
                                          AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.invCustomerAccountController.text);
                                          if (_ != null) {
                                            Get.to(AccountDetails(modelKey: _.accId!));
                                          }
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 100,
                                        child: Text(
                                          "البائع : ",
                                        ),
                                      ),
                                      Expanded(
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
                                ),
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 100, child: Text("البيان")),
                                      Expanded(
                                        child: customTextFieldWithoutIcon(invoiceController.noteController, true),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // const SizedBox(height: 40,),
                          // Wrap(
                          //   spacing: 40,
                          //   alignment: WrapAlignment.spaceBetween,
                          //   runSpacing: 40,
                          //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [

                          //
                          //     Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         const Text("رقم الجوال : "),
                          //         SizedBox(
                          //           width: Get.width * 0.15,
                          //
                          //           child: customTextFieldWithoutIcon(invoiceController.mobileNumberController, true),
                          //         ),
                          //       ],
                          //     ),
                          //
                          //     Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //
                          //       children: [
                          //
                          //         const Text("حساب العميل : "),
                          //         SizedBox(
                          //           width: Get.width * 0.15,
                          //           child: customTextFieldWithIcon(invoiceController.invCustomerAccountController, (text) async {
                          //             invoiceController.invCustomerAccountController.text = await getAccountComplete(invoiceController.invCustomerAccountController.text);
                          //           }, onIconPressed: () {
                          //             AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.invCustomerAccountController.text);
                          //             if (_ != null) {
                          //               Get.to(AccountDetails(modelKey: _.accId!));
                          //             }
                          //           }),
                          //         ),
                          //       ],
                          //     ),
                          //
                          //     Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //
                          //       children: [
                          //         const Text(
                          //           "البائع : ",
                          //         ),
                          //         SizedBox(
                          //           width: Get.width * 0.15,
                          //           child: customTextFieldWithIcon(invoiceController.sellerController, (text) async {
                          //             //   globalController.getAccountComplete();
                          //             var seller = await getSellerComplete(text);
                          //             // globalController.changeSecAccount();
                          //             invoiceController.initModel.invSeller = seller;
                          //             invoiceController.sellerController.text = seller;
                          //           }, onIconPressed: () {
                          //             AccountModel? _ = accountController.accountList.values.toList().firstWhereOrNull((element) => element.accName == invoiceController.secondaryAccountController.text);
                          //             if (_ != null) {
                          //               Get.to(AddSeller(oldKey: _.accId!));
                          //             }
                          //           }),
                          //         ),
                          //       ],
                          //     ),
                          //     Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //
                          //       children: [
                          //         const Text(
                          //           "نوع الفاتورة" + ": ",
                          //           textDirection: TextDirection.rtl,
                          //         ),
                          //         Container(
                          //             height: 50,
                          //             width: Get.width * 0.15,
                          //             decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 border: Border.all(color: Colors.black38), borderRadius: BorderRadius.circular(8)),
                          //             child: DropdownButton(
                          //               padding: const EdgeInsets.symmetric(horizontal: 8),
                          //               underline: const SizedBox(),
                          //               value: selectedPayType,
                          //               isExpanded: true,
                          //               onChanged: (_) {
                          //                 selectedPayType = _!;
                          //                 setState(() {});
                          //               },
                          //               items: [ Const.invPayTypeDue,Const.invPayTypeCash]
                          //                   .map((e) => DropdownMenuItem(
                          //                         value: e,
                          //                         child: SizedBox(
                          //                             width: double.infinity,
                          //                             child: Text(
                          //                               getInvPayTypeFromEnum(e),
                          //                               textDirection: TextDirection.rtl,
                          //                             )),
                          //                       ))
                          //                   .toList(),
                          //             )),
                          //       ],
                          //     ),
                          //
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 40,
                          // ),
                        ],
                      )
                    else
                      SizedBox(
                        height: 175,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    const Text('المستودع القديم :'),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.15,
                                      child: customTextFieldWithIcon(invoiceController.storeController, (text) {
                                        invoiceController.getStoreComplete();
                                      }, onIconPressed: () {
                                        StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeController.text);
                                        if (_ != null) {
                                          Get.to(AddStore(oldKey: _.stId!));
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('المستودع الجديد :'),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.15,
                                      child: customTextFieldWithIcon(invoiceController.storeNewController, (text) {
                                        invoiceController.getStoreComplete();
                                      }, onIconPressed: () {
                                        StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull((element) => element.stName == invoiceController.storeNewController.text);
                                        if (_ != null) {
                                          Get.to(AddStore(oldKey: _.stId!));
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
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
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 300,
                      child: GetBuilder<InvoicePlutoViewModel>(builder: (controller) {
                        return CustomPlutoWithEdite(
                          controller: controller,
                          shortCut: customPlutoShortcut(const InvoiceEnterPlutoGridAction()),
                          onRowSecondaryTap: (event) {
                            if (event.cell.column.field == "invRecSubTotal") {
                              if (getProductModelFromName(controller.stateManager.currentRow?.cells['invRecProduct']?.value!) != null) {
                                controller.showContextMenuSubTotal(index: event.rowIdx, productModel: getProductModelFromName(controller.stateManager.currentRow?.cells['invRecProduct']?.value!)!, tapPosition: event.offset);
                              }
                            }
                            if (event.cell.column.field == "invRecId") {
                              Get.defaultDialog(title: "تأكيد الحذف", content: const Text("هل انت متأكد من حذف هذا العنصر"), actions: [
                                AppButton(
                                    title: "نعم",
                                    onPressed: () {
                                      controller.clearRowIndex(event.rowIdx);
                                    },
                                    iconData: Icons.check),
                                AppButton(
                                  title: "لا",
                                  onPressed: () {
                                    Get.back();
                                  },
                                  iconData: Icons.clear,
                                  color: Colors.red,
                                ),
                              ]);
                            }
                          },
                          onChanged: (PlutoGridOnChangedEvent event) async {
                            String? quantityNum = controller.stateManager.currentRow!.cells["invRecQuantity"]?.value?.toString();
                            String? subTotalStr = controller.stateManager.currentRow!.cells["invRecSubTotal"]?.value == "" ? null : controller.stateManager.currentRow!.cells["invRecSubTotal"]?.value.toString();

                            /*     if (event.column.field != "invRecProduct") {
                                print("object");
                                controller.handleProductColumn("invRecProduct", event.value);
                              }*/

                            double subTotal = controller.parseExpression(subTotalStr ?? "00");
                            int quantity = int.tryParse(quantityNum ?? "0") ?? 0;

                            controller.updateInvoiceValues(subTotal, quantity);
                          },
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.patternModel!.patType != Const.invoiceTypeChange)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                height: 150,
                                width: Get.width / 1.3,
                                child: GetBuilder<DiscountPlutoViewModel>(builder: (controller) {
                                  return CustomPlutoWithEdite(
                                    controller: controller,
                                    shortCut: customPlutoShortcut(const DiscountEnterPlutoGridAction()),
                                    onRowSecondaryTap: (event) {},
                                    onChanged: (PlutoGridOnChangedEvent event) async {},
                                  );
                                }),
                                /*   child: SfDataGrid(
                                  horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics: const ClampingScrollPhysics(),
                                  source: invoiceController.invoiceDiscountRecordSource,
                                  // tableSummaryRows: [
                                  //   GridTableSummaryRow(color: Colors.blueGrey, showSummaryInRow: true, title: 'Total : {Total} AED', columns: [const GridSummaryColumn(name: 'Total', columnName: Const.rowInvTotal, summaryType: GridSummaryType.sum)], position: GridTableSummaryRowPosition.bottom),
                                  // ],
                                  columns: [
                                    GridColumn(
                                        allowEditing: false,
                                        width: 50,
                                        columnName: Const.rowInvDiscountId,
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
                                        columnName: Const.rowInvDiscountAccount,
                                        label: Container(
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'الحساب',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                    GridColumn(
                                        width: columnWidths['quantity']!,
                                        columnName: Const.rowInvDisAddedTotal,
                                        label: Container(
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "الإضافات",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                    GridColumn(
                                        width: columnWidths['subTotal']!,
                                        columnName: Const.rowInvDisAddedPercentage,
                                        label: Container(
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "النسبة المئوية للاضافات",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                    GridColumn(
                                        width: columnWidths['quantity']!,
                                        columnName: Const.rowInvDisDiscountTotal,
                                        label: Container(
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "الحسميات",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                    GridColumn(
                                        width: columnWidths['subTotal']!,
                                        columnName: Const.rowInvDisDiscountPercentage,
                                        label: Container(
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            "النسبة المئوية للحسميات",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                  ],
                                  // controller: invoiceController.dataGridController,
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
                                  swipeMaxOffset: Get.width / 2,
                                  startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
                                    return GestureDetector(
                                        onTap: () {
                                          invoiceController.invoiceRecordSource.dataGridRows.removeAt(rowIndex);
                                          plutoEditViewModel.invoiceRecord.removeAt(rowIndex);
                                          invoiceController.invoiceRecordSource.updateDataGridSource();
                                        },
                                        child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                                  },
                                ),*/
                              )),
                        ],
                      ),
                    if (widget.patternModel!.patType != Const.invoiceTypeChange) ...[
                      const Divider(),
                      GetBuilder<InvoicePlutoViewModel>(builder: (controller) {
                        return Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          alignment: WrapAlignment.end,
                          children: [
                            Container(
                              color: Colors.blueGrey.shade400,
                              width: 150,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Text(
                                    (controller.computeWithoutVatTotal() * 0.05).toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 30, color: Colors.white),
                                  ),
                                  const Text(
                                    "القيمة المضافة",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.grey.shade600,
                              width: 150,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Text(
                                    controller.computeWithoutVatTotal().toStringAsFixed(2),
                                    style: const TextStyle(fontSize: 30, color: Colors.white),
                                  ),
                                  const Text(
                                    "المجموع",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.blue,
                              width: 300,
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      (controller.computeWithVatTotal()).toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "النهائي",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 20,
                        children: [
                          AppButton(
                              title: 'جديد',
                              onPressed: () async {
                                checkPermissionForOperation(Const.roleUserWrite, Const.roleViewInvoice).then((value) {
                                  if (value) {
                                    controller.getInit(controller.initModel.patternId!);
                                    controller.update();
                                    plutoEditViewModel.getRows([]);
                                    plutoEditViewModel.update();
                                  }
                                });
                              },
                              iconData: Icons.create_new_folder_outlined),
                          if (controller.initModel.invId == null || controller.initModel.invIsPending == null)
                            AppButton(
                                title: "إضافة",
                                onPressed: () async {
                                  plutoEditViewModel.handleSaveAll();

                                  if (invoiceController.checkInvCode()) {
                                    Get.snackbar("فحص المطاييح", "هذا الرمز الرمز يرجى استخدام الرمز: ${invoiceController.getNextCodeInv()}");
                                  } else if (!invoiceController.checkSellerComplete() && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() && widget.patternModel!.patType == Const.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text) && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty && widget.patternModel!.patType != Const.invoiceTypeAdd && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("خطأ تعباية", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة");
                                  } else if (invoiceController.checkAllRecordPrice() && widget.patternModel!.patType == Const.invoiceTypeSales) {
                                    Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                                  } else if (invoiceController.checkAllDiscountRecords()) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                                  } else {
                                    checkPermissionForOperation(Const.roleUserWrite, Const.roleViewInvoice).then((value) async {
                                      if (value) {
                                        screenViewModel.openedScreen.removeWhere(
                                          (key, value) => key == _updateData(plutoEditViewModel.invoiceRecord).invId || key == widget.billId,
                                        );
                                        // await invoiceController.computeTotal(plutoEditViewModel.invoiceRecord);
                                        globalController.addGlobalInvoice(_updateData(plutoEditViewModel.invoiceRecord));
                                        screenViewModel.update();
                                      }
                                    });
                                  }
                                },
                                iconData: Icons.add_chart_outlined),
                          if (controller.initModel.invId != null && controller.initModel.invIsPending != null) ...[
                            if (!(controller.initModel.invIsPending ?? true))
                              AppButton(
                                  title: 'السند',
                                  onPressed: () async {
                                    Get.to(() => EntryBondDetailsView(
                                          oldId: controller.initModel.entryBondId,
                                        ));
                                  },
                                  iconData: Icons.file_open_outlined)
                            else
                              AppButton(
                                title: 'موافقة',
                                onPressed: () async {
                                  plutoEditViewModel.handleSaveAll();

                                  // if (globalController.invCodeList.contains(
                                  //     globalController.invCodeController.text)) {
                                  if (!invoiceController.checkSellerComplete() && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() && widget.patternModel!.patType == Const.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text) && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
                                    // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                                    //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text) {
                                    Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ ", "بعض المنتجات فارغة");
                                  } else
                                  /*if (invoiceController.checkAllRecordPrice() && widget.patternModel!.patType == Const.invoiceTypeSales) {
                                    Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                                  } else if (invoiceController.checkAllDiscountRecords()) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                                  } else*/
                                  {
                                    checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice).then((value) async {
                                      if (value) {
                                        await invoiceController.computeTotal(plutoEditViewModel.invoiceRecord);
                                        invoiceController.initModel.invIsPending = false;
                                        globalController.updateGlobalInvoice(_updateData(plutoEditViewModel.invoiceRecord));
                                      }
                                    });
                                  }
                                },
                                iconData: Icons.file_download_done_outlined,
                                color: Colors.green,
                              ),
                            AppButton(
                                title: "تعديل",
                                onPressed: () async {
                                  plutoEditViewModel.handleSaveAll();

                                  // if (globalController.invCodeList.contains(
                                  //     globalController.invCodeController.text)) {
                                  if (!invoiceController.checkSellerComplete() && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() && widget.patternModel!.patType == Const.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkAccountComplete(invoiceController.secondaryAccountController.text) && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
                                    // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                                    //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text == invoiceController.secondaryAccountController.text && widget.patternModel!.patType != Const.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditViewModel.invoiceRecord
                                      .where(
                                        (element) => element.invRecId != null,
                                      )
                                      .isEmpty) {
                                    Get.snackbar("خطأ ", "يرجى إضافة مواد الى الفاتورة+");
                                  } else if (plutoEditViewModel.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ ", "بعض المنتجات فارغة");
                                  } else if (invoiceController.checkAllRecordPrice() && widget.patternModel!.patType == Const.invoiceTypeSales) {
                                    Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                                  } else if (invoiceController.checkAllDiscountRecords()) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                                  } else {
                                    checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewInvoice).then((value) async {
                                      if (value) {
                                        // await invoiceController.computeTotal(plutoEditViewModel.invoiceRecord);
                                        globalController.updateGlobalInvoice(_updateData(plutoEditViewModel.invoiceRecord));
                                        invoiceController.buildSource(invoiceController.initModel.invId!);
                                        invoiceController.buildDiscountSource(invoiceController.initModel.invId!);
                                      }
                                    });
                                  }
                                },
                                iconData: Icons.edit_outlined),
                            if (controller.initModel.invId != null) ...[
                              AppButton(
                                iconData: Icons.print_outlined,
                                title: 'طباعة',
                                onPressed: () async {
                                  plutoEditViewModel.handleSaveAll();

                                  checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice).then((value) async {
                                    if (value) {
                                      PrintViewModel printViewModel = Get.find<PrintViewModel>();
                                      printViewModel.printFunction(invoiceController.initModel);
                                    }
                                  });
                                },
                              ),
                              if (screenViewModel.openedScreen[widget.billId] == null)
                                AppButton(
                                  iconData: Icons.delete_outline,
                                  color: Colors.red,
                                  title: 'حذف',
                                  onPressed: () async {
                                    confirmDeleteWidget().then((value) {
                                      if (value) {
                                        checkPermissionForOperation(Const.roleUserDelete, Const.roleViewInvoice).then((value) async {
                                          if (value) {
                                            globalController.deleteGlobal(invoiceController.initModel);
                                            Get.back();
                                          }
                                        });
                                      }
                                    });
                                  },
                                )
                            ]
                          ],
                          if (selectedPayType == Const.invPayTypeDue && widget.patternModel?.patName == "مبيع")
                            AppButton(
                              iconData: Icons.more_horiz_outlined,
                              title: 'المزيد',
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    backgroundColor: backGroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 200,
                                        height: 150,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const Center(
                                                  child: Text(
                                                'الخيارات',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                              )),
                                              const SizedBox(height: 15),
                                              const Text('الدفعة الاولى '),
                                              const SizedBox(height: 5),
                                              Expanded(
                                                child: customTextFieldWithoutIcon(
                                                  invoiceController.firstPayController,
                                                  true,
                                                  onChanged: (text) => invoiceController.firstPayController.text = text,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: const Text('موافق'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          if ((widget.patternModel?.patName == "م. مبيع" || widget.patternModel?.patName == "م. شراء"))
                            AppButton(
                              iconData: Icons.more_horiz_outlined,
                              title: 'المزيد',
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    backgroundColor: backGroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Text(
                                              'تفاصيل فاتورة المبيع المراد ارجاعها',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(height: 15),
                                            OptionTextWidget(
                                              title: "رقم الفاتورة :",
                                              controller: controller.invReturnCodeController,
                                              onSubmitted: (text) async {
                                                controller.invReturnCodeController.text = text;
                                              },
                                            ),
                                            const SizedBox(height: 5),
                                            OptionTextWidget(
                                              title: "تاريخ الفاتورة:  ",
                                              controller: controller.invReturnDateController,
                                              onSubmitted: (text) async {
                                                controller.invReturnDateController.text = getDateFromString(text);
                                              },
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('موافق'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  /* Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [

                                const SizedBox(
                                  height: 25,
                                ),

                              ],
                            ),
                            if (controller.initModel.invId != null && controller.initModel.invIsPending != null)
                              Column(
                                children: [

                                  //     ElevatedButton(
                                  //         style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.green), shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))))),
                                  //         child: const Text(
                                  //           'موافقة على الفاتورة',
                                  //           style: TextStyle(color: Colors.white, fontSize: 25),
                                  //         ),
                                  // ),
                                  const Spacer(),


                                ],
                              ),
                            if (controller.initModel.invId != null)
                              Column(
                                children: [

                                ],
                              )
                          ],
                        )*/

  GlobalModel _updateData(List<InvoiceRecordModel> record) {
    print(invoiceController.initModel.invId);
    return GlobalModel(
        firstPay: selectedPayType == Const.invPayTypeDue ? 150 : null,
        invReturnCode: invoiceController.invReturnCodeController.text,
        invReturnDate: invoiceController.invReturnDateController.text,
        invGiftAccount: invoiceController.initModel.invGiftAccount,
        invSecGiftAccount: invoiceController.initModel.invSecGiftAccount,
        invPayType: selectedPayType,
        invDiscountRecord: /*invoiceController.discountRecords*/ [],
        invIsPending: invoiceController.initModel.invIsPending,
        invVatAccount: getVatAccountFromPatternId(widget.patternModel!.patId!),
        entryBondId: invoiceController.initModel.invId == null ? generateId(RecordType.entryBond) : invoiceController.initModel.entryBondId,
        entryBondCode: invoiceController.initModel.invId == null ? getNextEntryBondCode().toString() : invoiceController.initModel.entryBondCode,
        invRecords: record,
        patternId: widget.patternModel!.patId!,
        invType: widget.patternModel!.patType!,
        invTotal: Get.find<InvoicePlutoViewModel>().computeWithVatTotal(),
        invFullCode: invoiceController.initModel.invId == null ? widget.patternModel!.patName! + ": " + invoiceController.invCodeController.text : invoiceController.initModel.invFullCode,
        invId: invoiceController.initModel.invId ?? generateId(RecordType.invoice),
        invStorehouse: getStoreIdFromText(invoiceController.storeController.text),
        invSecStorehouse: getStoreIdFromText(invoiceController.storeNewController.text),
        invComment: invoiceController.noteController.text,
        invPrimaryAccount: getAccountIdFromText(invoiceController.primaryAccountController.text),
        invSecondaryAccount: getAccountIdFromText(invoiceController.secondaryAccountController.text),
        invCustomerAccount: invoiceController.invCustomerAccountController.text.isEmpty ? "" : getAccountIdFromText(invoiceController.invCustomerAccountController.text),
        invCode: invoiceController.initModel.invId == null ? invoiceController.invCodeController.text : invoiceController.initModel.invCode,
        invSeller: getSellerIdFromText(invoiceController.sellerController.text),
        invDate: isEditDate ? invoiceController.dateController : DateTime.now().toString().split(".").first,
        invMobileNumber: invoiceController.mobileNumberController.text,
        globalType: Const.globalTypeInvoice);
  }
}

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.title, required this.onPressed, required this.iconData, this.color});

  final String title;
  final Color? color;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(color), shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))))),
        onPressed: onPressed,
        child: SizedBox(
          width: 100,
          height: Const.constHeightTextField,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                Icon(
                  iconData,
                  size: 24,
                ),
              ],
            ),
          ),
        ));
  }
}
