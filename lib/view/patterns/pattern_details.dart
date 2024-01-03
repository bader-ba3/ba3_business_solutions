import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';

import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controller/user_management.dart';
import '../accounts/acconts_view.dart';

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
      hasVatController = patternController.editPatternModel?.patHasVat ?? false;
      patternController.editPatternModel?.patHasVat ??= false;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patterns"),
      ),
      body: GetBuilder<PatternViewModel>(
        builder: (patternController) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  width: Get.width * 0.5,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [const Flexible(flex: 2, child: Text("Pattern NO :")), Text(patternController.editPatternModel?.patId ?? "new Pattern")],
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Row(children: [
                  const Text("Name :"),
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
                  const Text("code :"),
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
                    const Text("primary :"),
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
                    const Text("المشتري :"),
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
                    const SizedBox(
                      width: 25,
                    ),
                    const Text("type :"),
                    const SizedBox(
                      width: 25,
                    ),
                    DropdownMenu(
                      requestFocusOnTap: false,
                      controller: typeController,
                      width: Get.width * 0.3,
                      hintText: "Select the pattern",
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
                    Text("Vat Account "),
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
                    Text("with VAT"),
                    Switch(
                        value: patternController.editPatternModel?.patHasVat ?? false,
                        onChanged: (_) {
                          setState(() {});
                          patternController.editPatternModel?.patHasVat = _;
                        })
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
                        child: const Text("Clear")),
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
                          child: const Text("Edit"))
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
                          child: const Text("New")),
                    if (patternController.editPatternModel?.patId != null)
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          onPressed: () {
                            checkPermissionForOperation(Const.roleUserDelete,Const.roleViewPattern).then((value) {
                              if(value)patternController.deletePattern();
                            });


                          },
                          child: const Text("Delete")),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
