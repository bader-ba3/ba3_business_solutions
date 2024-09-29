import 'package:ba3_business_solutions/Dialogs/CustomerDialog.dart';
import 'package:ba3_business_solutions/Widgets/Discount_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/Widgets/GetProductEnterShortCut.dart';
import 'package:ba3_business_solutions/Widgets/Custom_Pluto_With_Edite.dart';
import 'package:ba3_business_solutions/Widgets/Invoice_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/main.dart';
import 'package:ba3_business_solutions/model/AccountCustomer.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/Warranty/Controller/warranty_view_model.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../Const/const.dart';
import '../../Dialogs/Widgets/Option_Text_Widget.dart';
import '../../Services/Get_Date_From_String.dart';
import '../../Widgets/CustomPlutoShortCut.dart';
import '../../Widgets/GetAccountEnterPlutoAction.dart';
import '../../Widgets/warranty_pluto_view_model.dart';
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
import '../../model/store_model.dart';
import '../../utils/confirm_delete_dialog.dart';
import '../../utils/date_picker.dart';
import '../../utils/generate_id.dart';
import '../entry_bond/entry_bond_details_view.dart';
import '../invoices/New_Invoice_View.dart';
import '../widget/CustomWindowTitleBar.dart';

class WarrantyInvoiceView extends StatefulWidget {
  const WarrantyInvoiceView({super.key, required this.billId});
  final String billId;

  @override
  State<WarrantyInvoiceView> createState() => _WarrantyInvoiceViewState();
}

class _WarrantyInvoiceViewState extends State<WarrantyInvoiceView> {
  WarrantyViewModel invoiceController = Get.find<WarrantyViewModel>();
  WarrantyPlutoViewModel plutoEditViewModel = Get.find<WarrantyPlutoViewModel>();
  List<String> codeInvList = [];

  @override
  void initState() {
    if (widget.billId != "1") {
      invoiceController.buildInvInit(widget.billId);
      plutoEditViewModel.getRows(invoiceController.warrantyMap[widget.billId]?.invRecords?.toList() ?? []);
    } else {
      invoiceController.getInit();
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
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 16,
                      )),
                ),
                title: Text(widget.billId == "1" ? "فاتورة الضمان" : "تفاصيل فاتورة الضمان"),
                actions: [
                  /*       IconButton(
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
                  ),*/

                  SizedBox(
                    height: Const.constHeightTextField,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  invoiceController.invNextOrPrev(invoiceController.invCodeController.text, true);
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
                                      text,
                                    );
                                  },
                                )),
                            IconButton(
                                onPressed: () {
                                  invoiceController.invNextOrPrev(invoiceController.invCodeController.text, false);

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
              body: GetBuilder<WarrantyViewModel>(builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
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
                                    child: DatePicker(
                                      initDate: invoiceController.dateController,
                                      onSubmit: (_) {
                                        invoiceController.dateController = _.toString().split(".")[0];

                                        controller.update();
                                      },
                                    ),
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
                                    child: CustomTextFieldWithoutIcon(controller: invoiceController.mobileNumberController),
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
                                      "اسم الزبون : ",
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextFieldWithIcon(controller: invoiceController.customerNameController, onSubmitted: (text) async {}, onIconPressed: () {}),
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
                          ],
                        ),
                      )
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      // flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: GetBuilder<WarrantyPlutoViewModel>(builder: (controller) {
                          return CustomPlutoWithEdite(
                            evenRowColor: Colors.redAccent,
                            controller: controller,
                            shortCut: customPlutoShortcut(GetProductEnterPlutoGridAction(controller, "invRecProduct")),
                            onRowSecondaryTap: (event) {
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
                            onChanged: (PlutoGridOnChangedEvent event) async {},
                          );
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                                    controller.getInit();
                                    controller.update();
                                    plutoEditViewModel.getRows([]);
                                    plutoEditViewModel.update();
                                  }
                                });
                              },
                              iconData: Icons.create_new_folder_outlined),
                          if (controller.isNew )
                            AppButton(
                                title: "إضافة",
                                onPressed: () async {
                                  plutoEditViewModel.handleSaveAll();
                                  checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewInvoice).then((value) async {
                                    if (value) {
                                      controller.updateInvoice(isAdd: true,done: false);
                                    }
                                  });
                                },
                                iconData: Icons.add_chart_outlined),
                          if(controller.isNew ==false)
                            ...[    AppButton(
                              title: "تعديل",
                              onPressed: () async {
                                plutoEditViewModel.handleSaveAll();
                                checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewInvoice).then((value) async {
                                  if (value) {
                                    controller.updateInvoice(isAdd: false,done: false);
                                  }
                                });
                              },
                              iconData: Icons.edit_outlined),
                              if(!(controller.initModel.done??true))
                                AppButton(
                                  iconData: Icons.done_all,
                                  color: Colors.green,
                                  title: 'تسليم',
                                  onPressed: () async {
                                    plutoEditViewModel.handleSaveAll();

                                    checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice).then((value) async {
                                      if (value) {
                                        controller.updateInvoice(isAdd: false,done: true);

                                      }
                                    });
                                  },
                                ),
                            AppButton(
                              iconData: Icons.print_outlined,
                              title: 'طباعة',
                              onPressed: () async {
                                plutoEditViewModel.handleSaveAll();

                                checkPermissionForOperation(Const.roleUserAdmin, Const.roleViewInvoice).then((value) async {
                                  if (value) {
                                    PrintViewModel printViewModel = Get.find<PrintViewModel>();
                                    printViewModel.printFunction(GlobalModel(),warrantyModel:  controller.initModel);
                                  }
                                });
                              },
                            ),

                            AppButton(
                                title: "E-Invoice",
                                onPressed: () {
                                  showEIknvoiceDialog(mobileNumber: controller.initModel.customerPhone ?? "", invId: controller.initModel.invId!);
                                },
                                iconData: Icons.link),
                            AppButton(
                              iconData: Icons.delete_outline,
                              color: Colors.red,
                              title: 'حذف',
                              onPressed: () async {
                                confirmDeleteWidget().then((value) {
                                  if (value) {
                                    checkPermissionForOperation(Const.roleUserDelete, Const.roleViewInvoice).then((value) async {
                                      if (value) {
                                        controller.deleteInvoice();
                                        Get.back();
                                      }
                                    });
                                  }
                                });
                              },
                            )
                          ]
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
}
