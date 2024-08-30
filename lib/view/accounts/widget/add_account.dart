
import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/account_model.dart';
import '../../invoices/widget/custom_TextField.dart';
import '../../widget/CustomWindowTitleBar.dart';

class AddAccount extends StatefulWidget {
  final String? modelKey;
  final String? oldParent;
  const AddAccount({super.key, this.modelKey,  this.oldParent});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  TextEditingController nameController = TextEditingController();

  String? accountType;

  TextEditingController notesController = TextEditingController();

  TextEditingController codeController = TextEditingController();

  TextEditingController idController = TextEditingController();
  // TextEditingController accVatController = TextEditingController();
  String? accVat;
  TextEditingController accParentId=TextEditingController();
  bool accIsRoot=true;
  AccountModel accountModel = AccountModel();
  bool isNew = true;
  AccountViewModel accountController = Get.find<AccountViewModel>();

  @override
  void initState() {
    super.initState();
      accParentId.text=widget.oldParent??'';
    if (widget.modelKey != null) {
      isNew = false;
      accountModel = AccountModel.fromJson(accountController.accountList[widget.modelKey]!.toJson());
      nameController.text = accountModel.accName ?? "23232332";
      accountType = accountModel.accType ?? "23232332";
      notesController.text = accountModel.accComment ?? "23232332";
      codeController.text = accountModel.accCode ?? "23232332";
      accVat = accountModel.accVat ?? "GCC";
      accParentId.text = accountModel.accParentId??'' ;
      accIsRoot=accountModel.accParentId==null;
      //accountModel.accAggregateList=accountModel.accAggregateList.map((e) => getAccountNameFromId(e)).toList();
      // idController.text = accountModel.accCode??"23232332";
    } else {
      accVat = "GCC";
      codeController.text=accountController.getLastCode();
      accountType = Const.accountTypeList[0];
        if(accParentId.text !=''){
        accIsRoot=false;
      }
    }
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
                title:  const Text("بطاقة حساب"),
                actions: [
                  Container(
                    width: Get.width * 0.3,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        const Flexible(flex: 3, child: Text("رمز الحساب: ")),
                        Flexible(flex: 3, child: customTextFieldWithoutIcon(codeController, true)),
                      ],
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Flexible(flex: 2, child: Text("اسم الحساب :")),
                                Flexible(flex: 3, child: customTextFieldWithoutIcon(nameController, true)),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Flexible(flex: 2, child: Text("نوع الحساب :")),
                                Flexible(
                                    flex: 3,
                                    child: StatefulBuilder(builder: (context, setstae) {
                                      return DropdownButton(
                                        value: accountType,
                                        items: Const.accountTypeList
                                            .map((e) => DropdownMenuItem(
                                                  child: Text(getAccountTypeFromEnum(e)),
                                                  value: e,
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
          
                                          });
                                          setstae(() {
                                            accountType = value;
                                          });
                                        },
                                      );
                                    })),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Flexible(flex: 1, child: Text("ملاحظات:")),
                          Flexible(flex: 3, child: customTextFieldWithoutIcon(notesController, true)),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(flex: 2, child: Text("الحساب يخضع للضريبة")),
                          SizedBox(
                            width: 30,
                          ),
                          Flexible(
                              flex: 1,
                              child:
                                  //  customTextFieldWithoutIcon(accVatController, true)
                                  StatefulBuilder(builder: (context, setstate) {
                                return DropdownButton(
                                  value: accVat,
                                  items: const [
                                    DropdownMenuItem<String>(
                                      child: Text("ضريبة القيمة المضافة في دول الخليج"),
                                      value: "GCC",
                                    ),
                                  ],
                                  onChanged: (_) {
                                    setstate(() {
                                      accVat = _.toString();
                                    });
                                  },
                                );
                              })),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(flex: 2, child: Text("حساب اب")),
                          const SizedBox(
                            width: 30,
                          ),
                          Flexible(
                            child: StatefulBuilder(builder: (context, setstate) {
                                return SizedBox(
                                  width: 30,
                                  height: 100,
                                  child: Checkbox(
                                    value: accIsRoot,
                                    onChanged: (_) {
                                      setState(() {});
                                      setstate(() {
                                        accIsRoot = _!;
                                        accParentId.clear();
                                      });
                                    },
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Flexible(flex: 2, child: Text("الحساب الاب")),
                              const SizedBox(
                                width: 30,
                              ),
                              Flexible(
                                  flex: 1,
                                  child:
                                  //  customTextFieldWithoutIcon(accVatController, true)
                                  IgnorePointer(
                                    ignoring: accIsRoot,
                                   child:                    SizedBox(
                                     width: 300,
                                     child: TextFormField(
                                       controller: accParentId,
                                       decoration: const InputDecoration(
                                           fillColor: Colors.white,
                                           filled: true
                                       ),
                                       onFieldSubmitted: (_) async {
                                         List<String> result = searchText(_);
                                         if (result.isEmpty) {
                                           Get.snackbar("خطأ", "غير موجود");
                                         } else if (result.length == 1) {
                                           accParentId.text = result[0];
                                         } else {
                                           await Get.defaultDialog(
                                               title: "اختر احد الحسابات",
                                               content: SizedBox(
                                                 height: 500,
                                                 width: Get.width/1.5,
                                                 child: ListView.builder(
                                                     itemCount: result.length,
                                                     itemBuilder: (context, index) {
                                                       return InkWell(
                                                         onTap: () {
                                                           accParentId.text = result[index];
                                                           Get.back();
                                                         },
                                                         child: Row(
                                                           children: [
                                                             Text("${index+1}_ ",style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.blue.shade700),overflow: TextOverflow.ellipsis,),
          
                                                             Text(result[index],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),overflow: TextOverflow.ellipsis,),
                                                           ],
                                                         ),
                                                       );
                                                     }),
                                               ),
                                               actions: [
                                                 ElevatedButton(
                                                     onPressed: () {
                                                       Get.back();
                                                     },
                                                     child: const Text("خروج"))
                                               ]);
                                         }
                                       },
                                     ),
                                   ),
                        /*            child: Container(
                                      color: accIsRoot?Colors.grey.shade700:Colors.transparent,
                                      child: DropdownButton(
                                        value: accParentId,
                                        items: accountController.accountList.keys.toList().map((e) => DropdownMenuItem(value: e,child: Text(accountController.accountList[e]!.accName!))).toList(),
                                        onChanged: (_) {
                                          setState(() {
                                            accParentId = _.toString();
                                          });
                                        },
                                      ),
                                    ),*/
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 40,),
                      if(accountType==Const.accountTypeAggregateAccount)
                        Column(
                          children: [
                            Text("حسابات المربطة"),
                            SizedBox(height: 5,),
                            for(var element in accountController.aggregateList)
                              Container(
                                  width: 300,height: 40,
                                  decoration: BoxDecoration(border: Border.all()),
                                  child: Center(child: Text(element.accName??""))),
                            Container(
                                width: 300,height: 40,
                                decoration: BoxDecoration(border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    onFieldSubmitted: (_) async {
                                      List<String> result = searchText(_.toString());
                                      if (result.isEmpty) {
                                        Get.snackbar("error", "not found");
                                      } else if (result.length == 1) {
                                        var name = result[0];
                                        accountController.aggregateList.add(getAccountModelFromId(getAccountIdFromText(name))!);
                                        setState(() {});
                                      } else {
                                        await Get.defaultDialog(
                                            title: "اختر احد الحسابات",
                                            content: SizedBox(
                                              height: Get.height/2,
                                              width:Get.height/2,
                                              child: ListView.builder(
                                                  itemCount: result.length,
                                                  itemBuilder: (_, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        accountController.aggregateList.add(getAccountModelFromId(getAccountIdFromText(result[index]))!);
                                                        setState(() {});
                                                        Get.back();
                                                      },
                                                      child: Text(result[index]),
                                                    );
                                                  }),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text("رجوع"))
                                            ]);
                                      }
                                    },
                                  ),
                                )),
                            SizedBox(height: 40,),
                          ],
                        ),
                      Container(
                        alignment: Alignment.center,
                        child: GetBuilder<AccountViewModel>(builder: (accountController) {
                          return ElevatedButton(
                              onPressed: () async {
                                if(checkInput()){
                                  await updateData(nameController, accountType!, notesController, idController, accVat!, codeController, accParentId.text, accIsRoot);
                                  if (accountModel.accId == null) {
                                    checkPermissionForOperation(Const.roleUserWrite, Const.roleViewAccount).then((value) {
                                      if (value) accountController.addNewAccount(accountModel, withLogger: true);
                                    });
                                  } else {
                                    checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewAccount).then((value) {
                                      if (value) accountController.updateAccount(accountModel, withLogger: true);
                                    });
                                  }
                                }
                              },
                              child: Text(accountModel.accId==null ? "إضافة حساب" : "تعديل الحساب"));
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  updateData(TextEditingController nameController, String typeController, TextEditingController notesController, TextEditingController idController, String accVat, TextEditingController codeController,String? accParentId,bool isRoot) {
    accountModel.accCode = codeController.text;
    accountModel.accName = nameController.text;
    accountModel.accComment = notesController.text;
    accountModel.accType = typeController;
    accountModel.accVat = accVat;
    if(isRoot){
      accountModel.accParentId = null;
    }else{
      accountModel.accParentId = accParentId;
      
    }
  }
  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name = item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code = item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      print(item.accCode);
      return name || code;
    }).toList();
    return products.map((e) => e.accName!).toList();
  }

  bool checkInput() {
    if(nameController.text.isEmpty){
      Get.snackbar("خطأ", "يرجى كتابة اسم");
    }else if(accountType==null){
      Get.snackbar("خطأ", "يرجى كتابة نوع حساب");
    }
    else if(accVat==null){
      Get.snackbar("خطأ", "يرجى اختيار نوع الضريبة");
    }else if(codeController.text.isEmpty){
      Get.snackbar("خطأ", "يرجى كتابة رمز");
    }else if(!accIsRoot &&accParentId.text==""){
      Get.snackbar("خطأ", "يرجى إضافة حساب اب");
    }else{
      return true;
    }
    return false;
  }
}
