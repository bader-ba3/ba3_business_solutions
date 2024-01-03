import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/model/cheque_model.dart';
import 'package:ba3_business_solutions/model/cheque_rec_model.dart';
import 'package:ba3_business_solutions/utils/see_details.dart';
import 'package:ba3_business_solutions/utils/date_picker.dart';
import 'package:ba3_business_solutions/view/bonds/bond_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

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
      chequeController.initModel = ChequeModel(cheqRecords: []);
      chequeType = Const.chequeTypeList[0];
      chequeController.initModel?.cheqType = Const.chequeTypeList[0];
      codeController.text = (int.parse(chequeController.allCheques.values.last.cheqCode ?? "0") + 1).toString();
      chequeController.initModel?.cheqCode = codeController.text;
    } else {
      chequeController.initModel = ChequeModel.fromFullJson(chequeController.allCheques[widget.modelKey]?.toFullJson());
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
    return GetBuilder<ChequeViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.initModel?.cheqId ?? "new cheque"),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            Text("status"),
                            SizedBox(
                              width: 20,
                            ),
                            Text(getChequeStatusfromEnum(controller.initModel!.cheqStatus ?? Const.chequeStatusNotPaid)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
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
                  textForm("cheque nubmer", numberController, onChanged: (_) => controller.initModel?.cheqName = _),
                  //textForm("cheque code", codeController, onChanged: (_) => controller.initModel?.cheqCode = _),
                  textForm("cheque All Amount", allAmountController, onChanged: (_) {
                    if(double.tryParse(_)!=null){
                      controller.initModel?.cheqAllAmount = _;
                    }else{
                      if(_!="") {
                        Get.snackbar("error", "plz write int");
                      }
                    }

                  }),
                  textForm(
                    "cheque PrimeryAccount",
                    primeryController,
                    onFieldSubmitted: (value) async {
                      var a = await controller.getAccountComplete(value, Const.accountTypeDefault);
                      primeryController.text = a;
                      controller.initModel?.cheqPrimeryAccount = a;
                    },
                  ),
                  textForm(
                    "cheque SecoundryAccount",
                    secoundryController,
                    onFieldSubmitted: (value) async {
                      var a = await controller.getAccountComplete(value, chequeType == Const.chequeTypeCatch ? Const.accountTypeChequeCatch : Const.accountTypeChequePay);
                      secoundryController.text = a;
                      controller.initModel?.cheqSecoundryAccount = a;
                    },
                  ),
                  textForm(
                    "cheque bank",
                    bankController,
                    onFieldSubmitted: (value) async {
                      var a = await controller.getAccountComplete(value, Const.accountTypeBank);
                      bankController.text = a;
                      controller.initModel?.cheqBankAccount = a;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DatePicker(
                    initDate: controller.initModel?.cheqDate,
                    onSubmit: (_) {
                      controller.initModel?.cheqDate = _.toString().split(" ").first;
                      print(_);
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  if (controller.initModel?.cheqId == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              if(double.tryParse(controller.initModel?.cheqAllAmount??"a")==null){
                                Get.snackbar("error", "all amount is wrong");
                              }else if(controller.initModel?.cheqName?.isEmpty??true){
                                Get.snackbar("error", "cheqName");
                              }
                              else if(controller.initModel?.cheqDate?.isEmpty??true){
                                Get.snackbar("error", "cheqDate");
                              }
                              else if(controller.initModel?.cheqCode?.isEmpty??true){
                                Get.snackbar("error", "cheqCode");
                              }
                              else if(bankController.text.isEmpty||!controller.checkAccountComplete(bankController.text!, Const.accountTypeBank)){
                              Get.snackbar("error", "cheqBankAccount");
                              }
                              else if(primeryController.text.isEmpty||!controller.checkAccountComplete(primeryController.text, Const.accountTypeDefault )){
                                Get.snackbar("error", "cheqPrimeryAccount");
                              }
                              else if(secoundryController.text.isEmpty||!controller.checkAccountComplete(secoundryController.text, chequeType == Const.chequeTypeCatch ? Const.accountTypeChequeCatch : Const.accountTypeChequePay)){
                                Get.snackbar("error", "cheqSecoundryAccount");
                              }
                              else{
                                checkPermissionForOperation(Const.roleUserWrite, Const.roleViewCheques).then((value) {
                                  if(value) controller.addCheque();
                                });
                              }

                            },
                            child: Text("add")),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              List<ChequeRecModel?>? payment_list = controller.initModel?.cheqRecords?.cast<ChequeRecModel?>().where((element) => element?.cheqRecType == Const.chequeRecTypePartPayment).toList();
                             if(payment_list!.isNotEmpty){
                               if ((payment_list?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) ?? 0) > double.parse(controller.initModel!.cheqAllAmount!)) {
                                 Get.snackbar("error", "the payment is more than the total amount");
                               }
                             }else
                              if(double.tryParse(controller.initModel?.cheqAllAmount??"a")==null){
                                Get.snackbar("error", "all amount is wrong");
                              }else if(controller.initModel?.cheqName?.isEmpty??true){
                                Get.snackbar("error", "cheqName");
                              }
                              else if(controller.initModel?.cheqDate?.isEmpty??true){
                                Get.snackbar("error", "cheqDate");
                              }
                              else if(controller.initModel?.cheqCode?.isEmpty??true){
                                Get.snackbar("error", "cheqCode");
                              }
                              else if(bankController.text.isEmpty||!controller.checkAccountComplete(bankController.text!, Const.accountTypeBank)){
                                Get.snackbar("error", "cheqBankAccount");
                              }
                              else if(primeryController.text.isEmpty||!controller.checkAccountComplete(primeryController.text, Const.accountTypeDefault )){
                                Get.snackbar("error", "cheqPrimeryAccount");
                              }
                              else if(secoundryController.text.isEmpty||!controller.checkAccountComplete(secoundryController.text, chequeType == Const.chequeTypeCatch ? Const.accountTypeChequeCatch : Const.accountTypeChequePay)){
                                Get.snackbar("error", "cheqSecoundryAccount");
                              }
                              else{
                                checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewCheques).then((value) {
                                  if(value) controller.update();
                                });
                              }
                            },
                            child: Text("update")),
                        SizedBox(
                          width: 100,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              checkPermissionForOperation(Const.roleUserDelete, Const.roleViewCheques).then((value) {
                                if(value) controller.deleteCheque();
                              });
                            },
                            child: Text("delete")),
                        SizedBox(
                          width: 50,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              var bondId = controller.initModel?.cheqRecords?.firstWhere((e) => e.cheqRecType == Const.chequeRecTypeInit).cheqRecBondId;
                              seeDetails(bondId!);
                            },
                            child: Text("go to init bond")),
                        SizedBox(
                          width: 50,
                        ),
                        Builder(builder: (context) {
                          var record = controller.initModel?.cheqRecords?.toList().firstWhereOrNull((e) => e.cheqRecType == Const.chequeRecTypeAllPayment);
                          if (record == null && controller.initModel?.cheqStatus == Const.chequeStatusNotPaid) {
                            return ElevatedButton(
                                onPressed: () {
                                  checkPermissionForOperation(Const.roleUserWrite,Const.roleViewCheques).then((value) {
                                    if(value) controller.payAllAmount(ispayEdit: false);
                                  });
                                },
                                child: Text("pay all amount"));
                          } else {
                            if (record != null) {
                              return Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        seeDetails(record.cheqRecBondId!);
                                      },
                                      child: Text("show All payment Bond")),
                                  ElevatedButton(
                                      onPressed: () {
                                        checkPermissionForOperation(Const.roleUserDelete,Const.roleViewCheques).then((value) {
                                          if(value) controller.updateDeleteRecord(record.cheqRecBondId!, type: Const.chequeStatusNotPaid, isPayEdit: false);
                                        });
                                      },
                                      child: Text("Delete All payment Bond"))
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
                          print(record);
                          if ((record == null || record.isEmpty) && controller.initModel?.cheqStatus != Const.chequeStatusPaid) {
                            return ElevatedButton(
                                onPressed: () {
                                  var con = TextEditingController();
                                  Get.defaultDialog(
                                      title: "write the amount",
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

                                              if ((payment_list?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) ?? 0) + double.parse(con.text) > double.parse(controller.initModel!.cheqAllAmount!)) {
                                              } else {
                                                checkPermissionForOperation(Const.roleUserWrite,Const.roleViewCheques).then((value) {
                                                  if(value){
                                                    Get.back();
                                                    controller.payAmount(con.text, ispayEdit: false);
                                                  }
                                                });

                                              }
                                            },
                                            child: Text("yes")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text("no"))
                                      ]);
                                },
                                child: Text("add part payment"));
                          } else {
                            if (record!.isNotEmpty) {
                              return Row(
                                children: [
                                  if (record?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) != double.parse(controller.initModel!.cheqAllAmount!))
                                    ElevatedButton(
                                        onPressed: () {
                                          var con = TextEditingController();
                                          Get.defaultDialog(
                                              title: "write the amount",
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

                                                      if ((payment_list?.map((e) => double.parse(e!.cheqRecAmount!)).toList().reduce((value, element) => value + element) ?? 0) + double.parse(con.text) > double.parse(controller.initModel!.cheqAllAmount!)) {
                                                      } else {
                                                        checkPermissionForOperation(Const.roleUserWrite,Const.roleViewCheques).then((value) {
                                                          if(value){
                                                            Get.back();
                                                            controller.payAmount(con.text, ispayEdit: false);
                                                          }
                                                        });
                                                      }
                                                    },
                                                    child: Text("yes")),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text("no"))
                                              ]);
                                        },
                                        child: Text("add part payment")),
                                  ...List<Widget>.generate(
                                      record!.length,
                                      (index) => SizedBox(
                                            height: 70,
                                            width: 150,
                                            child: Column(children: [
                                              Text(record[index]!.cheqRecAmount!),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      seeDetails(record![index]!.cheqRecBondId!);
                                                    },
                                                    child: Text("view"),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      checkPermissionForOperation(Const.roleUserDelete,Const.roleViewCheques).then((value) {
                                                        if(value)controller.updateDeleteRecord(record![index]!.cheqRecBondId!, type: record.length == 1 ? Const.chequeStatusNotPaid : Const.chequeStatusNotAllPaid, isPayEdit: false);
                                                      });
                                                    },
                                                    child: Text("delete"),
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
                      ],
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
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: codeController,
                    onChanged: (_) => controller.initModel?.cheqCode = _,
                  ),
                ),
              )
          ],
        ),
      );
    });
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
