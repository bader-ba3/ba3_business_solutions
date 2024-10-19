import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/global/global_controller.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_controller.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_pluto_edit_controller.dart';
import 'package:ba3_business_solutions/controller/print/print_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_pluto_with_edite.dart';
import 'package:ba3_business_solutions/core/shared/widgets/get_product_enter_short_cut.dart';
import 'package:ba3_business_solutions/data/model/product/product_imei.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controller/bond/entry_bond_controller.dart';
import '../../../controller/invoice/screen_controller.dart';
import '../../../controller/product/product_controller.dart';
import '../../../controller/seller/sellers_controller.dart';
import '../../../controller/store/store_controller.dart';
import '../../../controller/user/user_management_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/services/Get_Date_From_String.dart';
import '../../../core/shared/widgets/custom_pluto_short_cut.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../../core/shared/widgets/option_text_widget.dart';
import '../../../core/styling/app_colors.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../core/utils/date_picker.dart';
import '../../../core/utils/generate_id.dart';
import '../../../data/model/account/account_model.dart';
import '../../../data/model/global/global_model.dart';
import '../../../data/model/invoice/invoice_record_model.dart';
import '../../../data/model/patterens/pattern_model.dart';
import '../../../data/model/store/store_model.dart';
import '../../entry_bond/pages/entry_bond_details_view.dart';
import '../../sellers/pages/add_seller_page.dart';
import '../../stores/pages/add_store.dart';

class InvoiceView extends StatefulWidget {
  const InvoiceView({super.key, required this.billId, required this.patternId, this.recentScreen = false});

  final String billId;
  final String patternId;
  final bool recentScreen;

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  late final PatternModel? patternModel;
  final invoiceController = Get.find<InvoiceController>();
  final globalController = Get.find<GlobalController>();
  final accountController = Get.find<AccountController>();
  final storeController = Get.find<StoreController>();
  final plutoEditController = Get.find<InvoicePlutoController>();
  ScreenController screenController = Get.find<ScreenController>();

  List<String> codeInvList = [];

  String typeBill = AppConstants.invoiceTypeSales;
  bool isEditDate = false;

  @override
  void initState() {
    if (widget.recentScreen) {
      patternModel = invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.initModel = screenController.openedScreen[widget.billId]!;
      // invoiceController.buildInvInit(false, widget.billId);
      plutoEditController.getRows(invoiceController.initModel.invRecords?.toList() ?? []);
      invoiceController.buildInvInitRecent(screenController.openedScreen[widget.billId]!);
    } else if (widget.billId != "1") {
      patternModel =
          invoiceController.patternController.patternModel[invoiceController.invoiceModel[widget.billId]!.patternId!];
      invoiceController.buildInvInit(true, widget.billId);
      plutoEditController.getRows(invoiceController.invoiceModel[widget.billId]?.invRecords?.toList() ?? []);
    } else {
      patternModel = invoiceController.patternController.patternModel[widget.patternId];
      invoiceController.getInit(patternModel!.patId!);
      invoiceController.selectedPayType = AppConstants.invPayTypeCash;
      invoiceController.invReturnCodeController.text = '';
      invoiceController.invReturnDateController.text = '';
      // globalController.dateController = DateTime.now().toString().split(" ")[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        screenController.openedScreen.removeWhere(
                          (key, value) =>
                              key == _updateData(plutoEditController.invoiceRecord).invId || key == widget.billId,
                        );
                        screenController.update();

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
                        plutoEditController.handleSaveAll(withOutProud: patternModel!.patFullName == "مبيعات بدون اصل");
                        if (plutoEditController.invoiceRecord.firstOrNull?.invRecProduct != null &&
                            _updateData(plutoEditController.invoiceRecord).invIsPending == null) {
                          screenController.openedScreen[widget.billId == "1"
                              ? _updateData(plutoEditController.invoiceRecord).invId!
                              : widget.billId] = _updateData(plutoEditController.invoiceRecord);
                          screenController.update();
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
                title: Text(widget.billId == "1"
                    ? "فاتورة ${patternModel?.patFullName ?? ""}"
                    : "تفاصيل فاتورة ${patternModel?.patFullName ?? ""}"),
                actions: [
                  SizedBox(
                    height: AppConstants.constHeightTextField,
                    child: Row(
                      children: [
                        if (patternModel!.patType != AppConstants.invoiceTypeSalesWithPartner)
                          SizedBox(
                            width: 250,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 80,
                                  child: Text(
                                    "نوع الفاتورة" ": ",
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      height: AppConstants.constHeightTextField,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black38),
                                          borderRadius: BorderRadius.circular(8)),
                                      child: DropdownButton(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        underline: const SizedBox(),
                                        value: invoiceController.selectedPayType,
                                        isExpanded: true,
                                        onChanged: (_) {
                                          invoiceController.selectedPayType = _!;
                                          if (invoiceController.selectedPayType == AppConstants.invPayTypeCash) {
                                            invoiceController.firstPayController.clear();
                                          }
                                          setState(() {});
                                        },
                                        items: [AppConstants.invPayTypeDue, AppConstants.invPayTypeCash]
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
                        if (checkPermission(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice))
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    invoiceController.invNextOrPrev(
                                        patternModel!.patId!, invoiceController.invCodeController.text, true);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.keyboard_double_arrow_right)),
                              // const Text("Invoice Code : "),
                              SizedBox(
                                  width: Get.width * 0.10,
                                  child: CustomTextFieldWithoutIcon(
                                    isNumeric: true,
                                    controller: invoiceController.invCodeController,
                                    onSubmitted: (text) {
                                      invoiceController.getInvByInvCode(
                                        patternModel!.patId!,
                                        text,
                                      );
                                    },
                                  )),
                              IconButton(
                                  onPressed: () {
                                    invoiceController.invNextOrPrev(
                                        patternModel!.patId!, invoiceController.invCodeController.text, false);

                                    // invoiceController.nextInv(patternModel!.patId!, invoiceController.invCodeController.text);
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
              body: GetBuilder<InvoiceController>(builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (patternModel!.patType != AppConstants.invoiceTypeChange)
                      Column(
                        children: [
                          SizedBox(
                            width: Get.width - 20,
                            child: Wrap(
                              spacing: 20,
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: 10,
                              children: [
                                SizedBox(
                                  width: Get.width * 0.45,
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 100, child: Text("تاريخ الفاتورة : ", style: TextStyle())),
                                      Expanded(
                                        child: GetBuilder<InvoiceController>(builder: (controller) {
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
                                if (patternModel?.patType != AppConstants.invoiceTypeSalesWithPartner &&
                                    invoiceController.selectedPayType == AppConstants.invPayTypeDue)
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                            width: 100, child: Text("تاريخ الاستحقاق : ", style: TextStyle())),
                                        Expanded(
                                          child: GetBuilder<InvoiceController>(builder: (controller) {
                                            return DatePicker(
                                              initDate: invoiceController.invDueDateController,
                                              onSubmit: (_) {
                                                invoiceController.invDueDateController = _.toString().split(".")[0];
                                                isEditDate = true;
                                                controller.update();
                                              },
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (patternModel!.patType == AppConstants.invoiceTypeSales)
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
                                        if (patternModel!.patType == AppConstants.invoiceTypeSales)
                                          Expanded(
                                            child: CustomTextFieldWithIcon(
                                                controller: invoiceController.secondaryAccountController,
                                                onSubmitted: (text) async {
                                                  invoiceController.secondaryAccountController.text =
                                                      await getAccountComplete(
                                                          invoiceController.secondaryAccountController.text);
                                                  if (getIfAccountHaveCustomers(
                                                      invoiceController.secondaryAccountController.text)) {
                                                    invoiceController.invCustomerAccountController.text =
                                                        getAccountCustomers(
                                                                invoiceController.secondaryAccountController.text)
                                                            .first
                                                            .customerAccountName!;
                                                    invoiceController.changeCustomer();
                                                  }
                                                  // invoiceController.getAccountComplete();
                                                  // invoiceController.changeSecAccount();
                                                },
                                                onIconPressed: () {
                                                  AccountModel? _ = accountController.accountList.values
                                                      .toList()
                                                      .firstWhereOrNull((element) =>
                                                          element.accName ==
                                                          invoiceController.secondaryAccountController.text);
                                                  if (_ != null) {
                                                    // Get.to(AccountDetails(modelKey: _.accId!));
                                                  }
                                                }),
                                          )
                                        else if (patternModel!.patType == AppConstants.invoiceTypeBuy)
                                          SizedBox(
                                            width: Get.width * 0.10,
                                            child: CustomTextFieldWithoutIcon(
                                              controller: invoiceController.secondaryAccountController,
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                else if (patternModel!.patType == AppConstants.invoiceTypeBuy)
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 100, child: Text("الدائن : ", style: TextStyle())),
                                        Expanded(
                                          child: CustomTextFieldWithIcon(
                                              controller: invoiceController.primaryAccountController,
                                              onSubmitted: (text) async {
                                                invoiceController.primaryAccountController.text =
                                                    await getAccountComplete(
                                                        invoiceController.primaryAccountController.text);
                                                if (getIfAccountHaveCustomers(
                                                    invoiceController.primaryAccountController.text)) {
                                                  invoiceController.invCustomerAccountController.text =
                                                      getAccountCustomers(
                                                              invoiceController.primaryAccountController.text)
                                                          .first
                                                          .customerAccountName!;
                                                  invoiceController.changeCustomer();
                                                }
                                                // invoiceController.getAccountComplete();
                                                // invoiceController.changeSecAccount();
                                              },
                                              onIconPressed: () {
                                                AccountModel? _ = accountController.accountList.values
                                                    .toList()
                                                    .firstWhereOrNull((element) =>
                                                        element.accName ==
                                                        invoiceController.primaryAccountController.text);
                                                if (_ != null) {
                                                  // Get.to(AccountDetails(modelKey: _.accId!));
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
                                        child: CustomTextFieldWithIcon(
                                            controller: invoiceController.storeController,
                                            onSubmitted: (text) {
                                              invoiceController.getStoreComplete();
                                            },
                                            onIconPressed: () {
                                              StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull(
                                                  (element) =>
                                                      element.stName == invoiceController.storeController.text);
                                              if (_ != null) {
                                                Get.find<StoreController>().initStore(_.stId!);
                                                Get.to(const AddStore());
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
                                        child: CustomTextFieldWithoutIcon(
                                            controller: invoiceController.mobileNumberController),
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
                                        child: CustomTextFieldWithIcon(
                                            controller: invoiceController.invCustomerAccountController,
                                            onSubmitted: (text) async {
                                              invoiceController.changeCustomer();
                                            },
                                            onIconPressed: () {
                                              AccountModel? _ = accountController.accountList.values
                                                  .toList()
                                                  .firstWhereOrNull((element) =>
                                                      element.accName ==
                                                      invoiceController.invCustomerAccountController.text);
                                              if (_ != null) {
                                                // Get.to(AccountDetails(modelKey: _.accId!));
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
                                        child: CustomTextFieldWithIcon(
                                            controller: invoiceController.sellerController,
                                            onSubmitted: (text) async {
                                              String selectedSellerName =
                                                  await Get.find<SellersController>().selectSeller(text);
                                              invoiceController.initModel.invSeller = selectedSellerName;
                                              invoiceController.sellerController.text = selectedSellerName;
                                            },
                                            onIconPressed: () {
                                              AccountModel? account = accountController.accountList.values
                                                  .toList()
                                                  .firstWhereOrNull((element) =>
                                                      element.accName ==
                                                      invoiceController.secondaryAccountController.text);
                                              if (account != null) {
                                                Get.to(AddSellerPage(oldKey: account.accId!));
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
                                        child: CustomTextFieldWithoutIcon(controller: invoiceController.noteController),
                                      ),
                                    ],
                                  ),
                                ),
                                if (patternModel?.patType == AppConstants.invoiceTypeSalesWithPartner)
                                  SizedBox(
                                    width: Get.width * 0.45,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 100, child: Text("رقم فاتورة الشريك")),
                                        Expanded(
                                          child: CustomTextFieldWithoutIcon(
                                              controller: invoiceController.invPartnerCodeController),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
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
                                      child: CustomTextFieldWithIcon(
                                          controller: invoiceController.storeController,
                                          onSubmitted: (text) {
                                            invoiceController.getStoreComplete();
                                          },
                                          onIconPressed: () {
                                            StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull(
                                                (element) => element.stName == invoiceController.storeController.text);
                                            if (_ != null) {
                                              Get.find<StoreController>().initStore(_.stId!);
                                              Get.to(const AddStore());
                                            }
                                          }),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('المستودع الجديد :'),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.15,
                                      child: CustomTextFieldWithIcon(
                                          controller: invoiceController.storeNewController,
                                          onSubmitted: (text) {
                                            invoiceController.getStoreComplete();
                                          },
                                          onIconPressed: () {
                                            StoreModel? _ = storeController.storeMap.values.toList().firstWhereOrNull(
                                                (element) =>
                                                    element.stName == invoiceController.storeNewController.text);
                                            if (_ != null) {
                                              Get.find<StoreController>().initStore(_.stId!);
                                              Get.to(const AddStore());
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
                                  child: CustomTextFieldWithoutIcon(controller: invoiceController.noteController),
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
                    Expanded(
                      // flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: GetBuilder<InvoicePlutoController>(builder: (controller) {
                          return FocusScope(
                            autofocus: true, // لتمكين التركيز تلقائيًا عند إنشاء الشاشة

                            child: CustomPlutoWithEdite(
                              evenRowColor: Color(patternModel!.patColor!),
                              controller: controller,
                              shortCut:
                                  customPlutoShortcut(GetProductEnterPlutoGridAction(controller, "invRecProduct")),
                              onRowSecondaryTap: (event) {
                                if (event.cell.column.field == "invRecSubTotal") {
                                  if (getProductModelFromName(
                                          controller.stateManager.currentRow?.cells['invRecProduct']?.value!) !=
                                      null) {
                                    controller.showContextMenuSubTotal(
                                        index: event.rowIdx,
                                        productModel: getProductModelFromName(
                                            controller.stateManager.currentRow?.cells['invRecProduct']?.value!)!,
                                        tapPosition: event.offset);
                                  }
                                }
                                if (event.cell.column.field == "invRecProduct") {
                                  if (getProductModelFromName(
                                          controller.stateManager.currentRow?.cells['invRecProduct']?.value!) !=
                                      null) {
                                    TextEditingController imeiController = TextEditingController();
                                    Get.defaultDialog(
                                        title: "اضافة IMEI",
                                        content: CustomTextFieldWithoutIcon(
                                          controller: imeiController,
                                          onSubmitted: (p0) {
                                            if (!checkProdHaveImei(
                                                getProductIdFromName(controller
                                                        .stateManager.currentRow?.cells['invRecProduct']?.value!) ??
                                                    '',
                                                p0)) {
                                              invoiceController.imeiMap[
                                                  getProductIdFromName(controller
                                                          .stateManager.currentRow?.cells['invRecProduct']?.value!) ??
                                                      'sd'] = ProductImei(
                                                  imei: p0,
                                                  invId:
                                                      "${patternModel!.patName!}: ${invoiceController.invCodeController.text}");
                                              Get.back();
                                            }
                                          },
                                        ),
                                        actions: [
                                          AppButton(
                                              title: "اضافة",
                                              onPressed: () {
                                                if (!checkProdHaveImei(
                                                    getProductIdFromName(controller
                                                            .stateManager.currentRow?.cells['invRecProduct']?.value!) ??
                                                        '',
                                                    imeiController.text)) {
                                                  invoiceController.imeiMap[
                                                      getProductIdFromName(controller.stateManager.currentRow
                                                              ?.cells['invRecProduct']?.value!) ??
                                                          'sd'] = ProductImei(
                                                      imei: imeiController.text,
                                                      invId:
                                                          "${patternModel!.patName!}: ${invoiceController.invCodeController.text}");
                                                  Get.back();
                                                }
                                              },
                                              iconData: Icons.check),
                                        ]);
                                  }
                                }
                                if (event.cell.column.field == "invRecId") {
                                  Get.defaultDialog(
                                      title: "تأكيد الحذف",
                                      content: const Text("هل انت متأكد من حذف هذا العنصر"),
                                      actions: [
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
                                String quantityNum = extractNumbersAndCalculate(
                                    controller.stateManager.currentRow!.cells["invRecQuantity"]?.value?.toString() ??
                                        '');
                                String? subTotalStr = extractNumbersAndCalculate(
                                    controller.stateManager.currentRow!.cells["invRecSubTotal"]?.value);
                                String? totalStr = extractNumbersAndCalculate(
                                    controller.stateManager.currentRow!.cells["invRecTotal"]?.value);
                                String? vat = extractNumbersAndCalculate(
                                    controller.stateManager.currentRow!.cells["invRecVat"]?.value ?? "0");

                                double subTotal = controller.parseExpression(subTotalStr);
                                double total = controller.parseExpression(totalStr);
                                int quantity = double.parse(quantityNum).toInt();
                                if (event.column.field == "invRecSubTotal") {
                                  controller.updateInvoiceValues(subTotal, quantity);
                                }
                                if (event.column.field == "invRecTotal") {
                                  controller.updateInvoiceValuesByTotal(total, quantity);
                                }
                                // if (event.column.field == "invRecDis" && quantity > 0) {
                                //   controller.updateInvoiceValuesByDiscount(total, quantity, double.parse(dis));
                                // }
                                if (event.column.field == "invRecQuantity" && quantity > 0) {
                                  controller.updateInvoiceValuesByQuantity(quantity, subTotal, double.parse(vat));
                                }
                                WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then(
                                  (value) {
                                    controller.update();
                                  },
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (patternModel!.patType != AppConstants.invoiceTypeChange) ...[
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      GetBuilder<InvoicePlutoController>(builder: (controller) {
                        return SizedBox(
                          width: Get.width,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              if (patternModel!.patType == AppConstants.invoiceTypeSalesWithPartner)
                                Wrap(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        color: Color(patternModel!.patColor!),
                                        width: 150,
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Column(
                                          children: [
                                            Text(
                                              patternModel?.patName == "م Tabby"
                                                  ? (((controller.computeWithVatTotal() *
                                                                  (patternModel!.patPartnerRatio! / 100)) +
                                                              patternModel!.patPartnerCommission!) *
                                                          1.05)
                                                      .toStringAsFixed(2)
                                                  : ((controller.computeWithVatTotal() *
                                                              (patternModel!.patPartnerRatio! / 100)) +
                                                          patternModel!.patPartnerCommission!)
                                                      .toStringAsFixed(2),
                                              style: const TextStyle(fontSize: 30, color: Colors.white),
                                            ),
                                            const Text(
                                              "النسبة",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: Color(patternModel!.patColor!),
                                        width: 150,
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Column(
                                          children: [
                                            Text(
                                              patternModel?.patName == "م Tabby"
                                                  ? (controller.computeWithVatTotal() -
                                                          (((controller.computeWithVatTotal() *
                                                                      (patternModel!.patPartnerRatio! / 100)) +
                                                                  patternModel!.patPartnerCommission!) *
                                                              1.05))
                                                      .toStringAsFixed(2)
                                                  : (controller.computeWithVatTotal() -
                                                          ((controller.computeWithVatTotal() *
                                                                  (patternModel!.patPartnerRatio! / 100)) +
                                                              patternModel!.patPartnerCommission!))
                                                      .toStringAsFixed(2),
                                              style: const TextStyle(fontSize: 30, color: Colors.white),
                                            ),
                                            const Text(
                                              "الصافي",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])
                              else
                                const SizedBox(),
                              Wrap(
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
                                          (controller.computeWithVatTotal() - controller.computeWithoutVatTotal())
                                              .toStringAsFixed(2),
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
                              ),
                            ],
                          ),
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
                                hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewInvoice)
                                    .then((value) {
                                  if (value) {
                                    controller.getInit(controller.initModel.patternId!);
                                    controller.update();
                                    plutoEditController.getRows([]);
                                    plutoEditController.update();
                                  }
                                });
                              },
                              iconData: Icons.create_new_folder_outlined),
                          if (controller.initModel.invId == null || controller.initModel.invIsPending == null)
                            AppButton(
                                title: "إضافة",
                                onPressed: () async {
                                  plutoEditController.handleSaveAll(
                                      withOutProud: patternModel!.patFullName == "مبيعات بدون اصل");
                                  if (invoiceController.checkInvCode()) {
                                    Get.snackbar("فحص المطاييح",
                                        "هذا الرمز الرمز يرجى استخدام الرمز: ${invoiceController.getNextCodeInv()}");
                                  } else if (!invoiceController.checkSellerComplete() &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() &&
                                      patternModel!.patType == AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController
                                          .checkAccountComplete(invoiceController.secondaryAccountController.text) &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا الحساب غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty &&
                                      patternModel!.patType != AppConstants.invoiceTypeAdd &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ تعباية", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text ==
                                          invoiceController.secondaryAccountController.text &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ تعباية", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditController.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ تعباية", "يرجى إضافة مواد الى الفاتورة");
                                  } else if (invoiceController.checkAllDiscountRecords()) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                                  } else if (patternModel?.patType == AppConstants.invoiceTypeSalesWithPartner &&
                                      controller.invPartnerCodeController.text.isEmpty) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في رقم فاتورة الشريك");
                                  } else {
                                    hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewInvoice)
                                        .then((value) async {
                                      if (value) {
                                        screenController.openedScreen.removeWhere(
                                          (key, value) =>
                                              key == _updateData(plutoEditController.invoiceRecord).invId ||
                                              key == widget.billId,
                                        );
                                        // await invoiceController.computeTotal(plutoEditViewModel.invoiceRecord);

                                        globalController
                                            .addGlobalInvoice(_updateData(plutoEditController.invoiceRecord));
                                        addImeiToProducts(invoiceController.imeiMap);
                                        sendEmailWithPdfAttachment(
                                          _updateData(plutoEditController.invoiceRecord),
                                          false,
                                        );
                                        // invoiceController.initModel=_updateData(plutoEditViewModel.invoiceRecord);
                                        plutoEditController.update();
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
                                  plutoEditController.handleSaveAll(
                                      withOutProud: patternModel!.patFullName == "مبيعات بدون اصل");

                                  // if (globalController.invCodeList.contains(
                                  //     globalController.invCodeController.text)) {
                                  if (!invoiceController.checkSellerComplete() &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() &&
                                      patternModel!.patType == AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController
                                          .checkAccountComplete(invoiceController.secondaryAccountController.text) &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
                                    // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                                    //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text ==
                                      invoiceController.secondaryAccountController.text) {
                                    Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditController.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ ", "بعض المنتجات فارغة");
                                  } else
                                  /*if (invoiceController.checkAllRecordPrice() && patternModel!.patType == Const.invoiceTypeSales) {
                                    Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                                  } else if (invoiceController.checkAllDiscountRecords()) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                                  } else*/
                                  {
                                    hasPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice)
                                        .then((value) async {
                                      if (value) {
                                        await invoiceController.computeTotal(plutoEditController.invoiceRecord);
                                        invoiceController.initModel.invIsPending = false;
                                        globalController
                                            .updateGlobalInvoice(_updateData(plutoEditController.invoiceRecord));
                                        sendEmailWithPdfAttachment(
                                          _updateData(plutoEditController.invoiceRecord),
                                          false,
                                        );
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
                                  plutoEditController.handleSaveAll(
                                      withOutProud: patternModel!.patFullName == "مبيعات بدون اصل");

                                  // if (globalController.invCodeList.contains(
                                  //     globalController.invCodeController.text)) {
                                  if (!invoiceController.checkSellerComplete() &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() &&
                                      patternModel!.patType == AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController
                                          .checkAccountComplete(invoiceController.secondaryAccountController.text) &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
                                    // } else if (!invoiceController.checkAccountComplete(invoiceController.invCustomerAccountController.text)) {
                                    //   Get.snackbar("فحص المطاييح", "هذا العميل غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text ==
                                          invoiceController.secondaryAccountController.text &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditController.invoiceRecord
                                      .where(
                                        (element) => element.invRecId != null,
                                      )
                                      .isEmpty) {
                                    Get.snackbar("خطأ ", "يرجى إضافة مواد الى الفاتورة+");
                                  } else if (plutoEditController.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ ", "بعض المنتجات فارغة");
                                  }
                                  /* else if (invoiceController.checkAllRecordPrice() && patternModel!.patType == Const.invoiceTypeSales) {
                                    Get.snackbar("خطأ ", "تم البيع بأقل من الحد المسموح");
                                  } else if (invoiceController.checkAllDiscountRecords()) {
                                    Get.snackbar("خطأ تعباية", "يرجى تصحيح الخطأ في الحسميات");
                                  } */
                                  else {
                                    hasPermissionForOperation(AppConstants.roleUserUpdate, AppConstants.roleViewInvoice)
                                        .then((value) async {
                                      if (value) {
                                        addImeiToProducts(invoiceController.imeiMap);
                                        globalController
                                            .updateGlobalInvoice(_updateData(plutoEditController.invoiceRecord));
                                        sendEmailWithPdfAttachment(
                                            _updateData(plutoEditController.invoiceRecord), false,
                                            update: true, invoiceOld: invoiceController.initModel);
                                      }
                                    });
                                  }
                                },
                                iconData: Icons.edit_outlined),
                            if (patternModel!.patFullName == "مبيعات بدون اصل" && controller.initModel.invId != null)
                              AppButton(
                                title: "مبيعات",
                                onPressed: () async {
                                  plutoEditController.handleSaveAll(withOutProud: false);
                                  // controller.initCodeList(Const.salleTypeId);

                                  // if (globalController.invCodeList.contains(
                                  //     globalController.invCodeController.text)) {
                                  if (!invoiceController.checkSellerComplete() &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا البائع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreComplete()) {
                                    Get.snackbar("فحص ", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController.checkStoreNewComplete() &&
                                      patternModel!.patType == AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص المطاييح", "هذا المستودع غير موجود من قبل");
                                  } else if (!invoiceController
                                          .checkAccountComplete(invoiceController.secondaryAccountController.text) &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("فحص ", "هذا الحساب غير موجود من قبل");
                                  } else if (invoiceController.primaryAccountController.text.isEmpty &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "يرجى كتابة حساب البائع");
                                  } else if (invoiceController.primaryAccountController.text ==
                                          invoiceController.secondaryAccountController.text &&
                                      patternModel!.patType != AppConstants.invoiceTypeChange) {
                                    Get.snackbar("خطأ ", "لا يمكن تشابه البائع و المشتري");
                                  } else if (plutoEditController.invoiceRecord
                                      .where(
                                        (element) => element.invRecId != null,
                                      )
                                      .isEmpty) {
                                    Get.snackbar("خطأ ", "يرجى إضافة مواد الى الفاتورة");
                                  } else if (plutoEditController.invoiceRecord.isEmpty) {
                                    Get.snackbar("خطأ ", "بعض المنتجات فارغة");
                                  } else {
                                    hasPermissionForOperation(AppConstants.roleUserUpdate, AppConstants.roleViewInvoice)
                                        .then((value) async {
                                      if (value) {
                                        controller.initCodeList(AppConstants.salleTypeId);
                                        controller.initModel
                                          ..invRecords = plutoEditController.handleSaveAll(withOutProud: false)
                                          ..patternId = AppConstants.salleTypeId
                                          ..invCode = controller.getNextCodeInv()
                                          ..invFullCode = "مبيعات : ${controller.getNextCodeInv()}"
                                          ..entryBondRecord = []
                                          ..bondDescription = '';
                                        globalController.updateGlobalInvoice(controller.initModel);
                                        Get.back();
                                      }
                                    });
                                  }
                                },
                                iconData: Icons.done_all,
                                color: Colors.green,
                              ),
                            if (controller.initModel.invId != null) ...[
                              AppButton(
                                iconData: Icons.print_outlined,
                                title: 'طباعة',
                                onPressed: () async {
                                  plutoEditController.handleSaveAll(
                                      withOutProud: patternModel!.patFullName == "مبيعات بدون اصل");

                                  hasPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice)
                                      .then((value) async {
                                    if (value) {
                                      PrintController printViewModel = Get.find<PrintController>();
                                      printViewModel.printFunction(invoiceController.initModel);
                                    }
                                  });
                                },
                              ),
                              AppButton(
                                  title: "E-Invoice",
                                  onPressed: () {
                                    showEInvoiceDialog(
                                        mobileNumber: controller.initModel.invMobileNumber ?? "",
                                        invId: controller.initModel.invId!);
                                  },
                                  iconData: Icons.link),
                              if (screenController.openedScreen[widget.billId] == null)
                                AppButton(
                                  iconData: Icons.delete_outline,
                                  color: Colors.red,
                                  title: 'حذف',
                                  onPressed: () async {
                                    confirmDeleteWidget().then((value) {
                                      if (value) {
                                        hasPermissionForOperation(
                                                AppConstants.roleUserDelete, AppConstants.roleViewInvoice)
                                            .then((value) async {
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
                          if (patternModel!.patName == AppConstants.invoiceTypeSalesWithPartner ||
                              controller.selectedPayType == AppConstants.invPayTypeDue)
                            AppButton(
                              iconData: Icons.more_horiz_outlined,
                              title: 'المزيد',
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    backgroundColor: AppColors.backGroundColor,
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
                                                child: CustomTextFieldWithoutIcon(
                                                  controller: invoiceController.firstPayController,
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
                          if ((patternModel?.patName == "م. مبيع" || patternModel?.patName == "م. شراء"))
                            AppButton(
                              iconData: Icons.more_horiz_outlined,
                              title: 'المزيد',
                              onPressed: () async {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                    backgroundColor: AppColors.backGroundColor,
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

  GlobalModel _updateData(List<InvoiceRecordModel> record) {
    return GlobalModel(
        firstPay: double.tryParse(invoiceController.firstPayController.text),
        invReturnCode: invoiceController.invReturnCodeController.text,
        invReturnDate: invoiceController.invReturnDateController.text,
        invGiftAccount: invoiceController.initModel.invGiftAccount,
        invSecGiftAccount: invoiceController.initModel.invSecGiftAccount,
        invVatAccount: patternModel?.patType == AppConstants.invoiceTypeBuy
            ? getAccountIdFromText("استرداد ضريبة القيمة المضافة رأس الخيمة")
            : getAccountIdFromText("ضريبة القيمة المضافة رأس الخيمة"),
        invPayType: invoiceController.selectedPayType,
        invIsPaid: invoiceController.selectedPayType == AppConstants.invPayTypeDue
            ? getInvIsPay(patternModel!.patType!)
            : true,
        invPartnerCode: invoiceController.invPartnerCodeController.text,
        invDueDate: patternModel?.patType == AppConstants.invoiceTypeSalesWithPartner
            ? getDueDate(getPatNameFromId(widget.patternId)).toIso8601String().split(".")[0]
            : invoiceController.invDueDateController,
        invDiscountRecord: /*invoiceController.discountRecords*/ [],
        invIsPending: invoiceController.initModel.invIsPending,
        // invVatAccount: getVatAccountFromPatternId(patternModel!.patId!),

        entryBondId: invoiceController.initModel.invId == null
            ? generateId(RecordType.entryBond)
            : invoiceController.initModel.entryBondId,
        entryBondCode: invoiceController.initModel.invId == null
            ? getNextEntryBondCode().toString()
            : invoiceController.initModel.entryBondCode,
        invRecords: record,
        patternId: patternModel!.patId!,
        invType: patternModel!.patType!,
        invTotal: Get.find<InvoicePlutoController>().computeWithVatTotal(),
        invProFit: Get.find<InvoicePlutoController>().computeProFit().toString(),
        invFullCode: invoiceController.initModel.invId == null
            ? "${patternModel!.patName!}: ${invoiceController.invCodeController.text}"
            : invoiceController.initModel.invFullCode,
        invId: invoiceController.initModel.invId ?? generateId(RecordType.invoice),
        invStorehouse: getStoreIdFromText(invoiceController.storeController.text),
        invSecStorehouse: getStoreIdFromText(invoiceController.storeNewController.text),
        invComment: invoiceController.noteController.text,
        invPrimaryAccount: getAccountIdFromText(invoiceController.primaryAccountController.text),
        invSecondaryAccount: getAccountIdFromText(invoiceController.secondaryAccountController.text),
        invCustomerAccount: invoiceController.invCustomerAccountController.text.isEmpty
            ? ""
            : getAccountIdFromText(invoiceController.invCustomerAccountController.text),
        invCode: invoiceController.invCodeController.text,
        invSeller: getSellerIdFromText(invoiceController.sellerController.text),
        invDate: isEditDate ? invoiceController.dateController : DateTime.now().toString().split(".").first,
        invMobileNumber: invoiceController.mobileNumberController.text,
        invTotalPartner: patternModel?.patType == AppConstants.invoiceTypeSalesWithPartner
            ? patternModel?.patName == "م Tabby"
                ? Get.find<InvoicePlutoController>().computeWithVatTotal() -
                    (((Get.find<InvoicePlutoController>().computeWithVatTotal() *
                                (patternModel!.patPartnerRatio! / 100)) +
                            patternModel!.patPartnerCommission!) *
                        1.05)
                : Get.find<InvoicePlutoController>().computeWithVatTotal() -
                    ((Get.find<InvoicePlutoController>().computeWithVatTotal() *
                            (patternModel!.patPartnerRatio! / 100)) +
                        patternModel!.patPartnerCommission!)
            : 0,
        globalType: AppConstants.globalTypeInvoice);
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
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(color),
            shape: const WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))))),
        onPressed: onPressed,
        child: SizedBox(
          width: 100,
          height: AppConstants.constHeightTextField,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // const Spacer(),
                Icon(
                  iconData,
                  size: 22,
                ),
              ],
            ),
          ),
        ));
  }
}
