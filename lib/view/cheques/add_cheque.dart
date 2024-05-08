import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/old_model/cheque_model.dart';
import 'package:ba3_business_solutions/old_model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
import 'package:ba3_business_solutions/utils/see_details.dart';
import 'package:ba3_business_solutions/utils/date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../old_model/global_model.dart';

class AddCheque extends StatefulWidget {
  final String? modelKey;
  const AddCheque({super.key, this.modelKey});

  @override
  State<AddCheque> createState() => _AddChequeState();
}

var chequeController = Get.find<ChequeViewModel>();

var nameController = TextEditingController();
var numberController = TextEditingController();
var codeController = TextEditingController();
var allAmountController = TextEditingController();
var primeryController = TextEditingController();
var secoundryController = TextEditingController();
var bankController = TextEditingController();
var chequeType;

class _AddChequeState extends State<AddCheque> {
  @override
  void initState() {
    super.initState();
    if (widget.modelKey == null) {
      chequeController.initModel = GlobalModel(cheqRecords: []);
      chequeType = Const.chequeTypeList[0];
      chequeController.initModel?.cheqType = Const.chequeTypeList[0];
      if (chequeController.allCheques.isNotEmpty) {
        codeController.text = (int.parse(chequeController.allCheques.values.last.cheqCode ?? "0") + 1).toString();
      } else {
        codeController.text = "1";
      }
      chequeController.initModel?.cheqCode = codeController.text;
    } else {
      chequeController.initModel = GlobalModel.fromJson(chequeController.allCheques[widget.modelKey]?.toFullJson());
      initPage();
    }
  }

  void initPage() {
    numberController.text = chequeController.initModel?.cheqName ?? "";
    codeController.text = chequeController.initModel?.cheqCode ?? "";
    allAmountController.text = chequeController.initModel?.cheqAllAmount ?? "";
    primeryController.text = getAccountNameFromId(chequeController.initModel?.cheqPrimeryAccount ?? "");
    secoundryController.text = getAccountNameFromId(chequeController.initModel?.cheqSecoundryAccount ?? "");
    bankController.text = getAccountNameFromId(chequeController.initModel?.cheqBankAccount ?? "");
    chequeType = chequeController.initModel?.cheqType;
  }

  @override
  void dispose() {
    numberController.clear();
    codeController.clear();
    allAmountController.clear();
    primeryController.clear();
    secoundryController.clear();
    bankController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<ChequeViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(controller.initModel?.cheqName ?? "شيك جديد"),
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // textForm("cheque name", nameController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: controller.initModel!.cheqStatus == Const.chequeStatusPaid
                                  ? Colors.green.shade200
                                  : controller.initModel!.cheqStatus == Const.chequeStatusNotPaid
                                      ? Colors.red.shade200
                                      : controller.initModel!.cheqStatus == Const.chequeStatusNotAllPaid
                                          ? Colors.orange.shade200
                                          : Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("الحالة: "),
                              SizedBox(
                                width: 20,
                              ),
                              Text(getChequeStatusfromEnum(controller.initModel!.cheqStatus ?? Const.chequeStatusNotPaid)),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text("النوع: "),
                        StatefulBuilder(builder: (context, setstae) {
                          return DropdownButton<String>(
                            value: chequeType,
                            items: Const.chequeTypeList
                                .map((e) => DropdownMenuItem(
                                      child: Text(getChequeTypefromEnum(e)),
                                      value: e,
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
                      ],
                    ),
                    textForm("رقم الشيك", numberController, onChanged: (_) => controller.initModel?.cheqName = _),
                    //textForm("cheque code", codeController, onChanged: (_) => controller.initModel?.cheqCode = _),
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
                      "من",
                      primeryController,
                      onFieldSubmitted: (value) async {
                        var a = await controller.getAccountComplete(value, Const.accountTypeDefault);
                        primeryController.text = a;
                        controller.initModel?.cheqPrimeryAccount = a;
                      },
                    ),
                    textForm(
                      "الى",
                      secoundryController,
                      onFieldSubmitted: (value) async {
                        var a = await controller.getAccountComplete(value, chequeType == Const.chequeTypeCatch ? Const.accountTypeDefault : Const.accountTypeDefault);
                        secoundryController.text = a;
                        controller.initModel?.cheqSecoundryAccount = a;
                      },
                    ),
                    textForm(
                      "حساب البنك",
                      bankController,
                      onFieldSubmitted: (value) async {
                        var a = await controller.getAccountComplete(value, Const.accountTypeDefault);
                        bankController.text = a;
                        controller.initModel?.cheqBankAccount = a;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DatePicker(
                          initDate: controller.initModel?.cheqDate,
                          onSubmit: (_) {
                            controller.initModel?.cheqDate = _.toString().split(" ").first;
                            print(_);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (controller.initModel?.cheqId == null)
                      ElevatedButton(
                          onPressed: () async {
                            if (double.tryParse(controller.initModel?.cheqAllAmount ?? "a") == null) {
                              Get.snackbar("خطأ", "يرجى كتابة قيمة الشيك ");
                            } else if (controller.initModel?.cheqName?.isEmpty ?? true) {
                              Get.snackbar("خطأ", "يرجى كتابة رقم الشيك ");
                            } else if (controller.initModel?.cheqDate?.isEmpty ?? true) {
                              Get.snackbar("خطأ", "يرجى كتابة تاريخ الشيك ");
                            } else if (controller.initModel?.cheqCode?.isEmpty ?? true) {
                              Get.snackbar("خطأ", "يرجى كتابة رمز الشيك");
                            } else if (bankController.text.isEmpty || !controller.checkAccountComplete(bankController.text!, Const.accountTypeDefault)) {
                              Get.snackbar("خطأ", "يرجى كتابة حساب البنك");
                            } else if (primeryController.text.isEmpty || !controller.checkAccountComplete(primeryController.text, Const.accountTypeDefault)) {
                              Get.snackbar("خطأ", "يرجى كتابة المعلومات");
                            } else if (secoundryController.text.isEmpty || !controller.checkAccountComplete(secoundryController.text, Const.accountTypeDefault)) {
                              Get.snackbar("خطأ", "يرجى كتابة المعلومات");
                            } else {
                              checkPermissionForOperation(Const.roleUserWrite, Const.roleViewCheques).then((value) {
                                if (value) controller.addCheque();
                              });
                            }
                          },
                          child: Text("إضافة"))
                    else
                      Column(
                        children: [
                          Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    List<ChequeRecModel?>? payment_list = controller.initModel?.cheqRecords?.cast<ChequeRecModel?>().where((element) => element?.cheqRecType == Const.chequeRecTypePartPayment).toList();
                                    if (payment_list!.isNotEmpty) {
                                      if ((payment_list?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) ?? 0) > double.parse(controller.initModel!.cheqAllAmount!)) {
                                        Get.snackbar("خطأ", "الدفعات اكبر من القيمة الجديدة");
                                      }
                                    } else if (double.tryParse(controller.initModel?.cheqAllAmount ?? "a") == null) {
                                      Get.snackbar("خطأ", "يرجى كتابة قيمة الشيك ");
                                    } else if (controller.initModel?.cheqName?.isEmpty ?? true) {
                                      Get.snackbar("خطأ", "يرجى كتابة رقم الشيك ");
                                    } else if (controller.initModel?.cheqDate?.isEmpty ?? true) {
                                      Get.snackbar("خطأ", "يرجى كتابة تاريخ الشيك ");
                                    } else if (controller.initModel?.cheqCode?.isEmpty ?? true) {
                                      Get.snackbar("خطأ", "يرجى كتابة رمز الشيك");
                                    } else if (bankController.text.isEmpty || !controller.checkAccountComplete(bankController.text!, Const.accountTypeDefault)) {
                                      Get.snackbar("خطأ", "يرجى كتابة حساب البنك");
                                    } else if (primeryController.text.isEmpty || !controller.checkAccountComplete(primeryController.text, Const.accountTypeDefault)) {
                                      Get.snackbar("خطأ", "يرجى كتابة المعلومات");
                                    } else if (secoundryController.text.isEmpty || !controller.checkAccountComplete(secoundryController.text, Const.accountTypeDefault)) {
                                      Get.snackbar("خطأ", "يرجى كتابة المعلومات");
                                    } else {
                                      checkPermissionForOperation(Const.roleUserWrite, Const.roleViewCheques).then((value) {
                                        if (value) controller.updateCheque();
                                      });
                                    }
                                  },
                                  child: Text("تعديل")),
                              SizedBox(
                                width: 50,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    confirmDeleteWidget().then((value) {
                                      if (value) {
                                        checkPermissionForOperation(Const.roleUserDelete, Const.roleViewCheques).then((value) {
                                          if (value) {
                                            var globalController = Get.find<GlobalViewModel>();
                                            globalController.deleteGlobal(controller.initModel!);
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: Text("حذف")),
                              SizedBox(
                                width: 50,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    var bondId = controller.initModel?.cheqRecords?.firstWhere((e) => e.cheqRecType == Const.chequeRecTypeInit).cheqRecBondId;
                                    seeDetails(bondId!);
                                  },
                                  child: Text("السند الاساسي")),
                              SizedBox(
                                width: 50,
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          SizedBox(
                            height: 70,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                              Builder(builder: (context) {
                                var record = controller.initModel?.cheqRecords?.toList().firstWhereOrNull((e) => e.cheqRecType == Const.chequeRecTypeAllPayment);
                                if (record == null && controller.initModel?.cheqStatus == Const.chequeStatusNotPaid) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        checkPermissionForOperation(Const.roleUserWrite, Const.roleViewCheques).then((value) {
                                          if (value) controller.payAllAmount(ispayEdit: false);
                                        });
                                      },
                                      child: Text("تسديد كل المبلغ"));
                                } else {
                                  if (record != null) {
                                    return Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              seeDetails(record.cheqRecBondId!);
                                            },
                                            child: Text("سند تسديد كل المبلغ")),
                                        ElevatedButton(
                                            onPressed: () {
                                              confirmDeleteWidget().then((value) {
                                                if (value) {
                                                  checkPermissionForOperation(Const.roleUserDelete, Const.roleViewCheques).then((value) {
                                                    if (value) {
                                                      controller.updateDeleteRecord(record.cheqRecBondId!, type: Const.chequeStatusNotPaid, isPayEdit: false);
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                            child: Text("حذف سند تسديد كل المبلغ"))
                                      ],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }
                              }),
                              SizedBox(
                                width: 50,
                              ),
                              Builder(builder: (context) {
                                var record = controller.initModel?.cheqRecords?.toList().cast<ChequeRecModel?>().where((e) => e?.cheqRecType == Const.chequeRecTypePartPayment).toList();
                                if ((record == null || record.isEmpty) && controller.initModel?.cheqStatus != Const.chequeStatusPaid) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        var con = TextEditingController();
                                        Get.defaultDialog(
                                            title: "اكتب المبلغ",
                                            content: SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: TextFormField(
                                                controller: con,
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    List<ChequeRecModel?>? payment_list = controller.initModel?.cheqRecords?.cast<ChequeRecModel?>().where((element) => element?.cheqRecType == Const.chequeRecTypePartPayment).toList();
                                                    if (payment_list!.isNotEmpty && (payment_list?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) ?? 0) + double.parse(con.text) > double.parse(controller.initModel!.cheqAllAmount!)) {
                                                    } else {
                                                      checkPermissionForOperation(Const.roleUserWrite, Const.roleViewCheques).then((value) {
                                                        if (value) {
                                                          Get.back();
                                                          controller.payAmount(con.text, ispayEdit: false);
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Text("دفع")),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text("إلغاء"))
                                            ]);
                                      },
                                      child: Text("دفع قسم من المبلغ"));
                                } else {
                                  if (record!.isNotEmpty) {
                                    return Row(
                                      children: [
                                        if (record?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) != double.parse(controller.initModel!.cheqAllAmount!))
                                          ElevatedButton(
                                              onPressed: () {
                                                var con = TextEditingController();
                                                Get.defaultDialog(
                                                    title: "اكتب المبلغ",
                                                    content: SizedBox(
                                                      height: 100,
                                                      width: 100,
                                                      child: TextFormField(
                                                        controller: con,
                                                      ),
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            List<ChequeRecModel?>? payment_list = controller.initModel?.cheqRecords?.cast<ChequeRecModel?>().where((element) => element?.cheqRecType == Const.chequeRecTypePartPayment).toList();

                                                            if (payment_list!.isNotEmpty && (payment_list?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) ?? 0) + double.parse(con.text) > double.parse(controller.initModel!.cheqAllAmount!)) {
                                                            } else {
                                                              checkPermissionForOperation(Const.roleUserWrite, Const.roleViewCheques).then((value) {
                                                                if (value) {
                                                                  Get.back();
                                                                  controller.payAmount(con.text, ispayEdit: false);
                                                                }
                                                              });
                                                            }
                                                          },
                                                          child: Text("دفع")),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("إلغاء"))
                                                    ]);
                                              },
                                              child: Text("دفع قسم من المبلغ")),
                                        ...List<Widget>.generate(
                                            record!.length,
                                                (index) => SizedBox(
                                              height: 70,
                                              width: 150,
                                              child: Column(children: [
                                                Text(record[index]!.cheqRecAmount!),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        seeDetails(record![index]!.cheqRecBondId!);
                                                      },
                                                      child: Text("عرض"),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        confirmDeleteWidget().then((value) {
                                                          if (value) {
                                                            checkPermissionForOperation(Const.roleUserDelete, Const.roleViewCheques).then((value) {
                                                              if (value) {
                                                                controller.updateDeleteRecord(record![index]!.cheqRecBondId!, type: record.length == 1 ? Const.chequeStatusNotPaid : Const.chequeStatusNotAllPaid, isPayEdit: false);
                                                              }
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Text("حذف"),
                                                    )
                                                  ],
                                                )
                                              ]),
                                            )).toList()
                                      ],
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }
                              })
                            ],),
                          )
                        ],
                      ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              if (controller.initModel?.cheqId != null)
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
                          decoration: InputDecoration.collapsed(hintText: ""),
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
              else
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text("الرمز التسلسلي:"),
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
                )
            ],
          ),
        );
      }),
    );
  }

  Widget textForm(text, controller, {Function(String value)? onFieldSubmitted, Function(String value)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(text),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(), borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.all(8),
            width: 300,
            height: 40,
            child: TextFormField(
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              controller: controller,
              decoration: InputDecoration.collapsed(hintText: text),
            ),
          ),
        ],
      ),
    );
  }
}
