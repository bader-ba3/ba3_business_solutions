import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_management_model.dart';

class PatternDetails extends StatefulWidget {
  final oldKey;

  const PatternDetails({super.key, this.oldKey});

  @override
  State<PatternDetails> createState() => _PatternDetailsState();
}

class _PatternDetailsState extends State<PatternDetails> {
  PatternViewModel patternController = Get.find<PatternViewModel>();
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController primaryController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController vatAccountController = TextEditingController();
  TextEditingController secondaryController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  bool hasVatController = false;

  @override
  void initState() {
    if (widget.oldKey == null) {
      patternController.editPatternModel = PatternModel();
      patternController.editPatternModel?.patHasVat ??= false;
    } else {
      patternController.editPatternModel = PatternModel.fromJson(patternController.patternModel[widget.oldKey]?.toJson());
      nameController.text = patternController.editPatternModel?.patName ?? "";
      codeController.text = patternController.editPatternModel?.patCode ?? "";
      primaryController.text = getAccountNameFromId(patternController.editPatternModel?.patPrimary) ?? "";
      typeController.text = patternController.editPatternModel?.patType ?? "";
      vatAccountController.text = getAccountNameFromId(patternController.editPatternModel?.patVatAccount) ?? "";
      secondaryController.text = getAccountNameFromId(patternController.editPatternModel?.patSecondary) ?? "";
      storeController.text=getStoreNameFromId(patternController.editPatternModel?.patStore);
      // storeController.text=getStoreNameFromId("store1702230185210544");
      hasVatController = patternController.editPatternModel?.patHasVat ?? false;
      patternController.editPatternModel?.patHasVat ??= false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(patternController.editPatternModel?.patName ?? "إنشاء نمط"),
        ),
        body: GetBuilder<PatternViewModel>(
          builder: (patternController) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                  ),
                  Row(children: [
                    const Text("الاسم :"),
                    const SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: customTextFieldWithoutIcon(
                        nameController,
                        true,
                        onChanged: (_) {
                          patternController.editPatternModel?.patName = _;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    const Text("الرمز :"),
                    const SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: Get.width * 0.3,
                      child: customTextFieldWithoutIcon(
                        codeController,
                        true,
                        onChanged: (_) {
                          patternController.editPatternModel?.patCode = _;
                        },
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Text("من :"),
                      const SizedBox(
                        width: 25,
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: customTextFieldWithIcon(
                          primaryController,
                          (text) async {
                            var a = await patternController.getComplete(text);
                            patternController.editPatternModel?.patPrimary = a;
                            primaryController.text = a;
                          },
                          onChanged: (_) {
                            patternController.editPatternModel?.patPrimary = _;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      const Text("الى :"),
                      const SizedBox(
                        width: 25,
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: customTextFieldWithIcon(
                          secondaryController,
                          (text) async {
                            var a = await patternController.getComplete(text);
                            patternController.editPatternModel?.patSecondary = a;
                            secondaryController.text = a;
                          },
                          onChanged: (_) {
                            patternController.editPatternModel?.patSecondary = _;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [

                      const Text("النوع :"),
                      const SizedBox(
                        width: 25,
                      ),
                      DropdownMenu(
                        requestFocusOnTap: false,
                        controller: typeController,
                        width: Get.width * 0.3,
                        hintText: "اختر النمط",
                        onSelected: (value) {
                          patternController.editPatternModel?.patType = value;
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: "sales", label: "sales"),
                          // DropdownMenuEntry(value: "1", label: "due sale"),
                          DropdownMenuEntry(value: "pay", label: "pay"),
                          // DropdownMenuEntry(value: "3", label: "due pay"),
                        ],
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Text("حساب الضريبة "),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: customTextFieldWithIcon(
                          vatAccountController,
                          (text) async {
                            var a = await patternController.getComplete(text);
                            patternController.editPatternModel?.patVatAccount = a;
                            vatAccountController.text = a;
                          },
                          onChanged: (_) {
                            patternController.editPatternModel?.patVatAccount = _;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("هل بخضع للضريبة"),
                      Switch(
                          value: patternController.editPatternModel?.patHasVat ?? false,
                          onChanged: (_) {
                            setState(() {});
                            patternController.editPatternModel?.patHasVat = _;
                          }),

                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      const Text("المستودع :"),
                      const SizedBox(
                        width: 25,
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: customTextFieldWithIcon(
                          storeController,
                              (text) async {
                            var a = await patternController.getStoreComplete(text);
                            patternController.editPatternModel?.patStore = a;
                            storeController.text = a;
                          },
                          onChanged: (_) {
                            patternController.editPatternModel?.patStore = _;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            patternController.clearController();
                          },
                          child: const Text("جديد")),
                      if (patternController.editPatternModel?.patId != null)
                        ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            ),
                            onPressed: () {
                              checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewPattern).then((value) {
                                if(value)patternController.editPattern();
                              });


                            },
                            child: const Text("تعديل"))
                      else
                        ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            ),
                            onPressed: () {
                              checkPermissionForOperation(Const.roleUserWrite,Const.roleViewPattern).then((value) {
                                if(value)patternController.addPattern();
                              });

                              // patternController.clearController();
                              //patternController.getNewCode();
                            },
                            child: const Text("إضافة")),
                      // if (patternController.editPatternModel?.patId != null)
                      //   ElevatedButton(
                      //       style: ButtonStyle(
                      //         backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                      //         foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      //       ),
                      //       onPressed: () {
                      //         checkPermissionForOperation(Const.roleUserDelete,Const.roleViewPattern).then((value) {
                      //           if(value)patternController.deletePattern();
                      //         });
                      //       },
                      //       child: const Text("حذف")),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
