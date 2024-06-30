import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_TextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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
      codeController.text  = ((int.tryParse(patternController.patternModel.values.map((e) => e.patCode).last.toString())??0)+1).toString();
      patternController.editPatternModel!.patCode =codeController.text;
      patternController.editPatternModel?.patColor = 4294198070;
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
          title: Text(
              patternController.editPatternModel!.patId!=null
              ? patternController.editPatternModel!.patName!
              : "إنشاء نمط"
          ),
        ),
        body: GetBuilder<PatternViewModel>(
          builder: (patternController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    SizedBox(
                      width: Get.width/2.5,
                      child: Row(
                        children: [
                          const Text("الاسم :"),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: customTextFieldWithoutIcon(
                              nameController,
                              true,
                              onChanged: (_) {
                                patternController.editPatternModel?.patName = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      width: Get.width/2.5,
                      child: Row(
                        children: [
                          const Text("الرمز :"),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: customTextFieldWithoutIcon(
                              codeController,
                              true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (_) {
                                patternController.editPatternModel?.patCode = _;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      IgnorePointer(
                        ignoring: typeController.text == Const.invoiceTypeAdd,
                        child: SizedBox(
                          width: Get.width/2.5,
                          child: Row(
                            children: [
                              const Text("الدائن"),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: Container(
                                  foregroundDecoration:typeController.text == Const.invoiceTypeAdd? BoxDecoration(color: Colors.grey.withOpacity(0.5)):null,
                                  child: customTextFieldWithIcon(
                                    primaryController,
                                    (text) async {
                                      var a = await getAccountComplete(text);
                                      patternController.update();
                                      if(a.isNotEmpty) {
                                        patternController.editPatternModel?.patPrimary = a;
                                        primaryController.text = a;
                                        setState(() {});
                                      }
                                    },
                                    onChanged: (_) {
                                      // patternController.editPatternModel?.patPrimary = _;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              if(patternController.editPatternModel?.patPrimary!=null)
                                Icon(Icons.check),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      SizedBox(
                        width: Get.width/2.5,
                        child: Row(
                          children: [
                            const Text("المدين"),
                            const SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: customTextFieldWithIcon(
                                secondaryController,
                                    (text) async {
                                      var a = await getAccountComplete(text);
                                      patternController.update();
                                  if(a.isNotEmpty) {
                                    patternController.editPatternModel?.patSecondary = a;
                                    secondaryController.text = a;
                                    setState(() {});
                                  }
                                },
                                onChanged: (_) {
                                  // patternController.editPatternModel?.patPrimary = _;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            if(patternController.editPatternModel?.patSecondary!=null)
                              Icon(Icons.check),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width/3,
                        child: Row(
                          children: [
                            const Text("النوع :"),
                            const SizedBox(
                              width: 25,
                            ),
                            SizedBox(
                              width: Get.width/4,
                              child: DropdownButton(
                                isExpanded: true,
                                  value: typeController.text.isEmpty?Const.invoiceTypeSales:typeController.text,
                                  items: [
                                DropdownMenuItem(value: Const.invoiceTypeSales, child: Container(
                                    width: double.infinity,
                                    child: Text("مبيع",textDirection: TextDirection.rtl,)),),
                                DropdownMenuItem(value: Const.invoiceTypeBuy, child: Container(
                                    width: double.infinity,
                                    child: Text("شراء",textDirection: TextDirection.rtl)),),
                                DropdownMenuItem(value: Const.invoiceTypeAdd, child: Container(
                                    width: double.infinity,
                                    child: Text("إدخال",textDirection: TextDirection.rtl)),),
                              ], onChanged: (_){
                                typeController.text = _!;
                                patternController.editPatternModel?.patType = _;
                                if(typeController.text == Const.invoiceTypeAdd){
                                  patternController.editPatternModel?.patPrimary = null;
                                  primaryController.clear();
                                }
                                setState(() {});
                              }),
                            ),
                            // DropdownMenu(
                            //   requestFocusOnTap: false,
                            //   controller: typeController,
                            // width: Get.width/4,
                            //
                            //   hintText: "اختر النمط",
                            //   onSelected: (value) {
                            //     patternController.editPatternModel?.patType = value;
                            //   },
                            //   dropdownMenuEntries: const [
                            //     DropdownMenuEntry(value: Const.invoiceTypeSales, label: "مبيع"),
                            //     DropdownMenuEntry(value: Const.invoiceTypeBuy, label: "شراء"),
                            //     DropdownMenuEntry(value: Const.invoiceTypeAdd, label: "إدخال"),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      SizedBox(
                        width: Get.width/3,
                        child: Row(
                          children: [
                            Text("حساب الضريبة "),
                            SizedBox(width: 25,),
                            Expanded(
                              child: customTextFieldWithIcon(
                                vatAccountController,
                                (text) async {
                                  var a = await getAccountComplete(text);
                                  patternController.update();
                                  if(a.isNotEmpty){
                                    patternController.editPatternModel?.patVatAccount = a;
                                    vatAccountController.text = a;
                                    setState(() {});
                                  }

                                },
                                onChanged: (_) {
                                  // patternController.editPatternModel?.patVatAccount = _;
                                },
                              ),
                            ),
                            SizedBox(width: 25,),
                            if(patternController.editPatternModel?.patVatAccount!=null&&(patternController.editPatternModel?.patHasVat??false))
                              Icon(Icons.check)
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("هل بخضع للضريبة"),
                      Checkbox(
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            if(a.isNotEmpty){
                              patternController.editPatternModel?.patStore = a;
                              storeController.text = a;
                              setState(() {});
                            }

                          },
                          onChanged: (_) {
                            // patternController.editPatternModel?.patStore = _;
                          },
                        ),
                      ),
                      SizedBox(width: 50,),
                      SizedBox(
                        width: Get.width * 0.5,
                        child: MaterialColorPicker(
                            allowShades: false, // default true
                            onMainColorChange: (ColorSwatch? color) {
                              print(color?.value);
                              patternController.editPatternModel?.patColor=color?.value;
                              // Handle main color changes
                            },
                            selectedColor: Color(patternController.editPatternModel?.patColor??4294198070)
                        ),
                      )
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
                              if(patternController.editPatternModel?.patName?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة الاسم");
                              }else if(patternController.editPatternModel?.patCode?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة الرمز");
                              }else if((patternController.editPatternModel?.patPrimary?.isEmpty??true)&&patternController.editPatternModel?.patType!=Const.invoiceTypeAdd){
                                Get.snackbar("خطأ", "يرجى كتابة الحساب الاساسي");
                              }else if(patternController.editPatternModel?.patSecondary?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة الحساب الثانوي");
                              }else if(patternController.editPatternModel?.patVatAccount?.isEmpty??true&&(patternController.editPatternModel?.patHasVat??false)){
                                Get.snackbar("خطأ", "يرجى كتابة حساب الضريبة");
                              }else if(patternController.editPatternModel?.patType?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة نوع النمط");
                              }else if(patternController.editPatternModel?.patStore?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة المستودع");
                              }else{
                                checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewPattern).then((value) {
                                  if(value)patternController.editPattern();
                                });
                              }
                            },
                            child: const Text("تعديل"))
                      else
                        ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            ),
                            onPressed: () {
                              print(patternController.editPatternModel?.patType);
                              print(patternController.editPatternModel?.patType!=Const.invoiceTypeAdd);
                              if(patternController.editPatternModel?.patName?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة الاسم");
                              }else if(patternController.editPatternModel?.patCode?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة الرمز");
                              }else if((patternController.editPatternModel?.patPrimary?.isEmpty??true)&&patternController.editPatternModel?.patType!=Const.invoiceTypeAdd){
                                Get.snackbar("خطأ", "يرجى كتابة الحساب الاساسي");
                              }else if(patternController.editPatternModel?.patSecondary?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة الحساب الثانوي");
                              }else if(patternController.editPatternModel?.patVatAccount?.isEmpty??true&&(patternController.editPatternModel?.patHasVat??false)){
                                Get.snackbar("خطأ", "يرجى كتابة حساب الضريبة");
                              }else if(patternController.editPatternModel?.patType?.isEmpty??true){
                                Get.snackbar("خطأ", "يرجى كتابة نوع النمط");
                              }else if(patternController.editPatternModel?.patStore?.isEmpty??true){
                                    Get.snackbar("خطأ", "يرجى كتابة المستودع");
                              }else{
                                checkPermissionForOperation(Const.roleUserWrite,Const.roleViewPattern).then((value) {
                                  if(value)patternController.addPattern();
                                });
                              }
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
