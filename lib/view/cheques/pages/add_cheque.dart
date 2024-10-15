import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_controller.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_controller.dart';
import 'package:ba3_business_solutions/controller/global/global_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/core/utils/date_picker.dart';
import 'package:ba3_business_solutions/view/entry_bond/pages/entry_bond_details_view.dart';
import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_Text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/bond/bond_controller.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/utils/generate_id.dart';
import '../../../model/bond/bond_record_model.dart';
import '../../../model/bond/entry_bond_record_model.dart';
import '../../../model/global/global_model.dart';
import '../../bonds/pages/bond_details_view.dart';
import '../../bonds/widget/bond_record_pluto_view_model.dart';

class AddCheque extends StatefulWidget {
  final String? modelKey;

  const AddCheque({super.key, this.modelKey});

  @override
  State<AddCheque> createState() => _AddChequeState();
}

class _AddChequeState extends State<AddCheque> {
  var chequeController = Get.find<ChequeController>();

  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var codeController = TextEditingController();
  var allAmountController = TextEditingController();
  var primaryController = TextEditingController()..text = getAccountNameFromId("اوراق الدفع");
  var secondaryController = TextEditingController();
  var bankController = TextEditingController()..text = getAccountNameFromId("المصرف");
  var chequeType;

  @override
  void initState() {
    super.initState();
    if (widget.modelKey == null) {
      chequeController.initModel = GlobalModel();
      print(DateTime.now().toString().split(" ")[0]);
      chequeController.initModel!.cheqDate = DateTime.now().toString().split(" ")[0];
      chequeType = AppConstants.chequeTypeList[0];
      chequeController.initModel?.cheqType = AppConstants.chequeTypeList[0];
      if (chequeController.allCheques.isNotEmpty) {
        codeController.text = (int.parse(chequeController.allCheques.values.last.cheqCode ?? "0") + 1).toString();
      } else {
        codeController.text = "1";
      }
      chequeController.initModel?.cheqCode = codeController.text;
    } else {
      chequeController.initModel = chequeController.allCheques[widget.modelKey];
      initPage();
    }
  }

  void initPage() {
    numberController.text = chequeController.initModel?.cheqName ?? "";
    codeController.text = chequeController.initModel?.cheqCode ?? "";
    allAmountController.text = chequeController.initModel?.cheqAllAmount ?? "";
    primaryController.text = getAccountNameFromId(chequeController.initModel?.cheqPrimeryAccount ?? "");
    secondaryController.text = getAccountNameFromId(chequeController.initModel?.cheqSecoundryAccount ?? "");
    bankController.text = getAccountNameFromId(chequeController.initModel?.cheqBankAccount ?? "");
    chequeType = chequeController.initModel?.cheqType;
  }

  @override
  void dispose() {
    numberController.clear();
    codeController.clear();
    allAmountController.clear();
    primaryController.clear();
    secondaryController.clear();
    bankController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<ChequeController>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.initModel?.cheqName ?? "شيك جديد"),
            toolbarHeight: 100,
            actions: [
              /*        if (controller.initModel?.cheqId != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.prevCheq();
                            initPage();
                          },
                          icon: Icon(Icons.arrow_back)),
                      Container(
                        decoration: BoxDecoration(border: Border.all()),
                        padding: const EdgeInsets.all(5),
                        width: 100,
                        child: TextFormField(
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onFieldSubmitted: (_) {
                            controller.changeIndexCode(code: _);
                            initPage();
                          },
                          decoration: const InputDecoration.collapsed(hintText: ""),
                          controller: TextEditingController(text: codeController.text),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.nextCheq();
                            initPage();
                          },
                          icon: Icon(Icons.arrow_forward)),
                    ],
                  ),
                )
              else*/
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: controller.initModel!.cheqStatus == AppConstants.chequeStatusPaid
                              ? Colors.green.shade200
                              : controller.initModel!.cheqStatus == AppConstants.chequeStatusNotPaid
                                  ? Colors.red.shade200
                                  : controller.initModel!.cheqStatus == AppConstants.chequeStatusNotAllPaid
                                      ? Colors.orange.shade200
                                      : Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("الحالة: "),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(getChequeStatusFromEnum(controller.initModel!.cheqStatus ?? AppConstants.chequeStatusNotPaid)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("الرمز التسلسلي:"),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: codeController,
                          onChanged: (_) => controller.initModel?.cheqCode = _,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // textForm("cheque name", nameController),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(
                      width: 50,
                    ),
                    const Text("النوع: "),
                    StatefulBuilder(builder: (context, setstae) {
                      return DropdownButton<String>(
                        value: chequeType,
                        items: AppConstants.chequeTypeList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(getChequeTypeFromEnum(e)),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setstae(() {
                            chequeType = value;
                          });
                          controller.initModel?.cheqType = value;
                        },
                      );
                    }),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 20,
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 20,
                    children: [
                      SizedBox(
                        width: Get.width * .45,
                        height: 40,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text("تاريخ التحرير"),
                            ),
                            Expanded(
                              child: DatePicker(
                                initDate: controller.initModel?.cheqDate,
                                onSubmit: (_) {
                                  controller.initModel?.cheqDate = _.toString().split(" ").first;
                                  print(_);
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * .45,
                        height: 40,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text("تاريخ الاستحقاق"),
                            ),
                            Expanded(
                              child: DatePicker(
                                initDate: controller.initModel?.cheqDeuDate,
                                onSubmit: (_) {
                                  controller.initModel!.cheqDeuDate = _.toString().split(" ").first;
                                  setState(() {});
                                  print(_);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      textForm("رقم الشيك", numberController, onChanged: (_) => controller.initModel?.cheqName = _),
                      textForm("قيمة الشيك", allAmountController, onChanged: (_) {
                        if (double.tryParse(_) != null) {
                          controller.initModel?.cheqAllAmount = _;
                        } else {
                          if (_ != "") {
                            Get.snackbar("خطأ", "يرجى كتابة رقم");
                          }
                        }
                      }),
                      textForm(
                        "الحساب",
                        primaryController,
                        onFieldSubmitted: (value) async {
                          var a = await controller.getAccountComplete(value, AppConstants.accountTypeDefault);
                          primaryController.text = a;
                          controller.initModel?.cheqPrimeryAccount = a;
                        },
                      ),
                      textForm(
                        "دفع إلى",
                        secondaryController,
                        onFieldSubmitted: (value) async {
                          var a = await controller.getAccountComplete(
                              value, chequeType == AppConstants.chequeTypeCatch ? AppConstants.accountTypeDefault : AppConstants.accountTypeDefault);
                          secondaryController.text = a;
                          controller.initModel?.cheqSecoundryAccount = a;
                        },
                      ),
                      textForm(
                        "حساب البنك",
                        bankController,
                        onFieldSubmitted: (value) async {
                          var a = await controller.getAccountComplete(value, AppConstants.accountTypeDefault);
                          bankController.text = a;
                          controller.initModel?.cheqBankAccount = a;
                        },
                      ),
                    ],
                  ),
                  //textForm("cheque code", codeController, onChanged: (_) => controller.initModel?.cheqCode = _),

                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppButton(
                        onPressed: () async {
                          if (double.tryParse(controller.initModel?.cheqAllAmount ?? "a") == null) {
                            Get.snackbar("خطأ", "يرجى كتابة قيمة الشيك ");
                          } else if (controller.initModel?.cheqName?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة رقم الشيك ");
                          } else if (controller.initModel?.cheqDate?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة تاريخ الشيك ");
                          } else if (controller.initModel?.cheqCode?.isEmpty ?? true) {
                            Get.snackbar("خطأ", "يرجى كتابة رمز الشيك");
                          } else if (getAccountIdFromText(secondaryController.text) == '') {
                            Get.snackbar("خطأ", "يرجى كتابة المعلومات");
                          } else {
                            checkPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewCheques).then((value) {
                              if (value) {
                                String des = "سند قيد مولد من شيك رقم ${numberController.text}";

                                if (controller.initModel!.cheqId == null) {
                                  controller.addCheque(GlobalModel(
                                      globalType: AppConstants.globalTypeCheque,
                                      cheqDeuDate: controller.initModel!.cheqDeuDate,
                                      cheqDate: controller.initModel!.cheqDate,
                                      entryBondCode: getNextEntryBondCode().toString(),
                                      entryBondId: generateId(RecordType.entryBond),
                                      cheqCode: codeController.text,
                                      cheqId: generateId(RecordType.cheque),
                                      cheqAllAmount: allAmountController.text,
                                      cheqBankAccount: getAccountIdFromText(bankController.text),
                                      cheqName: "${getGlobalTypeFromEnum(chequeType)} ${numberController.text}",
                                      cheqPrimeryAccount: getAccountIdFromText(primaryController.text),
                                      cheqSecoundryAccount: getAccountIdFromText(secondaryController.text),
                                      cheqStatus: AppConstants.chequeStatusNotPaid,
                                      cheqType: chequeType,
                                      cheqRemainingAmount: allAmountController.text,
                                      entryBondRecord: [
                                        EntryBondRecordModel("01", double.tryParse(allAmountController.text) ?? 0, 0,
                                            getAccountIdFromText(primaryController.text), des),
                                        EntryBondRecordModel("02", 0, double.tryParse(allAmountController.text) ?? 0,
                                            getAccountIdFromText(secondaryController.text), des),
                                      ]));
                                } else {
                                  controller.addCheque(GlobalModel(
                                      globalType: AppConstants.globalTypeCheque,
                                      cheqDeuDate: controller.initModel!.cheqDeuDate,
                                      cheqDate: controller.initModel!.cheqDate,
                                      entryBondCode: controller.initModel!.entryBondCode,
                                      entryBondId: controller.initModel!.entryBondId,
                                      cheqCode: codeController.text,
                                      cheqId: controller.initModel!.cheqId,
                                      cheqAllAmount: allAmountController.text,
                                      cheqBankAccount: getAccountIdFromText(bankController.text),
                                      cheqName: getGlobalTypeFromEnum(chequeType) + numberController.text,
                                      cheqPrimeryAccount: getAccountIdFromText(primaryController.text),
                                      cheqSecoundryAccount: getAccountIdFromText(secondaryController.text),
                                      cheqStatus: AppConstants.chequeStatusNotPaid,
                                      cheqType: chequeType,
                                      cheqRemainingAmount: allAmountController.text,
                                      entryBondRecord: [
                                        EntryBondRecordModel("01", double.tryParse(allAmountController.text) ?? 0, 0,
                                            getAccountIdFromText(primaryController.text), des),
                                        EntryBondRecordModel("02", 0, double.tryParse(allAmountController.text) ?? 0,
                                            getAccountIdFromText(secondaryController.text), des),
                                      ]));
                                }
                              }
                            });
                          }
                        },
                        title: controller.initModel!.cheqId == null ? "إضافة" : "تعديل",
                        iconData: controller.initModel!.cheqId == null ? Icons.add : Icons.edit,
                        color: controller.initModel!.cheqId == null ? null : Colors.green,
                      ),
                      if (controller.initModel?.cheqId != null) ...[
                        const SizedBox(
                          width: 50,
                        ),
                        AppButton(
                          onPressed: () {
                            confirmDeleteWidget().then((value) {
                              if (value) {
                                checkPermissionForOperation(AppConstants.roleUserDelete, AppConstants.roleViewCheques).then((value) {
                                  if (value) {
                                    var globalController = Get.find<GlobalController>();
                                    globalController.deleteGlobal(controller.initModel!);
                                  }
                                });
                              }
                            });
                          },
                          title: "حذف",
                          iconData: Icons.delete_outline,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        AppButton(
                          onPressed: () {
                            // print(controller.initModel!.entryBondId);
                            Get.to(() => EntryBondDetailsView(
                                  oldId: controller.initModel!.entryBondId,
                                ));
                          },
                          title: "السند",
                          iconData: Icons.view_list_outlined,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        AppButton(
                          onPressed: () async {
                            if (controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid) {
                              String des = controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid
                                  ? "سند دفع ${controller.initModel?.cheqName}"
                                  : "سند ارجاع قيمة  ${controller.initModel?.cheqName}";
                              List<BondRecordModel> bondRecord = [];
                              List<EntryBondRecordModel> entryBondRecord = [];
                              if (controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid) {
                                bondRecord.add(BondRecordModel(
                                    "00", 0, double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, getAccountIdFromText("اوراق الدفع"), des));
                                bondRecord.add(BondRecordModel(
                                    "01", double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, 0, getAccountIdFromText("المصرف"), des));
                              } else {
                                bondRecord.add(BondRecordModel(
                                    "00", 0, double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, getAccountIdFromText("المصرف"), des));
                                bondRecord.add(BondRecordModel(
                                    "01", double.tryParse(controller.initModel!.cheqAllAmount!) ?? 0, 0, getAccountIdFromText("اوراق الدفع"), des));
                              }

                              // bondRecord.add(BondRecordModel("03", controller.invoiceForSearch!.invTotal! - double.parse(controller.totalPaidFromPartner.text), 0, patternController.patternModel[controller.invoiceForSearch!.patternId]!.patSecondary!, des));

                              for (var element in bondRecord) {
                                entryBondRecord.add(EntryBondRecordModel.fromJson(element.toJson()));
                              }

                              GlobalController globalViewModel = Get.find<GlobalController>();
                              String bondId = generateId(RecordType.bond);
                              await globalViewModel.addGlobalBond(
                                GlobalModel(
                                  bondId: bondId,
                                  globalType: AppConstants.globalTypeBond,
                                  bondDate: DateTime.now().toString(),
                                  bondRecord: bondRecord,
                                  bondCode: Get.find<BondController>().getNextBondCode(type: AppConstants.bondTypeDebit),
                                  entryBondRecord: entryBondRecord,
                                  bondDescription: des,
                                  bondType: AppConstants.bondTypeDebit,
                                  bondTotal: "0",
                                ),
                              );
                              await controller.addCheque(GlobalModel(
                                  bondId: bondId,
                                  globalType: AppConstants.globalTypeCheque,
                                  cheqDeuDate: controller.initModel!.cheqDeuDate,
                                  cheqDate: controller.initModel!.cheqDate,
                                  entryBondCode: controller.initModel!.entryBondCode,
                                  entryBondId: controller.initModel!.entryBondId,
                                  cheqCode: codeController.text,
                                  cheqId: controller.initModel!.cheqId,
                                  cheqAllAmount: allAmountController.text,
                                  cheqBankAccount: getAccountIdFromText(bankController.text),
                                  cheqName: getGlobalTypeFromEnum(chequeType) + numberController.text,
                                  cheqPrimeryAccount: getAccountIdFromText(primaryController.text),
                                  cheqSecoundryAccount: getAccountIdFromText(secondaryController.text),
                                  cheqStatus: AppConstants.chequeStatusPaid,
                                  cheqType: chequeType,
                                  cheqRemainingAmount: allAmountController.text,
                                  entryBondRecord: [
                                    EntryBondRecordModel(
                                        "01", double.tryParse(allAmountController.text) ?? 0, 0, getAccountIdFromText(primaryController.text), des),
                                    EntryBondRecordModel(
                                        "02", 0, double.tryParse(allAmountController.text) ?? 0, getAccountIdFromText(secondaryController.text), des),
                                  ]));
                            } else {}
                          },
                          title: controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid ? "دفع" : "ارجاع",
                          color: controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid ? Colors.black : Colors.red,
                          iconData:
                              controller.initModel?.cheqStatus == AppConstants.chequeStatusNotPaid ? Icons.paid : Icons.real_estate_agent_outlined,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        AppButton(
                          onPressed: () {
                            Get.to(
                              () => BondDetailsView(
                                oldId: controller.initModel!.bondId,
                                bondType: AppConstants.bondTypeDebit,
                              ),
                              binding: BindingsBuilder(() {
                                Get.lazyPut(() => BondRecordPlutoViewModel(AppConstants.bondTypeDebit));
                              }),
                            );
                            // print(controller.initModel!.entryBondId);
                          },
                          title: "سند الدفع",
                          iconData: Icons.view_list_outlined,
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget textForm(text, controller, {Function(String value)? onFieldSubmitted, Function(String value)? onChanged}) {
    return SizedBox(
      width: Get.width * .45,
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(text)),
          Expanded(
            child: CustomTextFieldWithoutIcon(
              onChanged: onChanged,
              onSubmitted: onFieldSubmitted,
              controller: controller,
              // decoration: InputDecoration.collapsed(hintText: text),
            ),
          ),
        ],
      ),
    );
  }
}
