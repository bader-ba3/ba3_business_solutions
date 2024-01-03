import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/account_model.dart';
import '../../invoices/widget/custom_TextField.dart';

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
  String? accParentId;
  bool accIsRoot=false;
  AccountModel accountModel = AccountModel();
  bool isNew = true;
  AccountViewModel accountController = Get.find<AccountViewModel>();

  @override
  void initState() {
    super.initState();
      accParentId=widget.oldParent;
    if (widget.modelKey != null) {
      isNew = false;
      accountModel = AccountModel.fromJson(accountController.accountList[widget.modelKey]!.toJson(), widget.modelKey);
      nameController.text = accountModel.accName ?? "23232332";
      accountType = accountModel.accType ?? "23232332";
      notesController.text = accountModel.accComment ?? "23232332";
      codeController.text = accountModel.accCode ?? "23232332";
      accVat = accountModel.accVat ?? "GCC";
      accParentId = accountModel.accParentId ;
      accIsRoot=accountModel.accParentId==null;
      // idController.text = accountModel.accCode??"23232332";
    } else {
      accVat = "GCC";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        actions: [
          Container(
            width: Get.width * 0.3,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const Flexible(flex: 3, child: Text("Account NO :")),
                Flexible(flex: 3, child: customTextFieldWithoutIcon(codeController, true)),
              ],
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(flex: 2, child: Text("Account Name :")),
                        Flexible(flex: 3, child: customTextFieldWithoutIcon(nameController, true)),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(flex: 2, child: Text("Account Type :")),
                        Flexible(
                            flex: 3,
                            child: StatefulBuilder(builder: (context, setstae) {
                              return DropdownButton(
                                value: accountType,
                                items: Const.accountTypeList
                                    .map((e) => DropdownMenuItem(
                                          child: Text(getAccountTypefromEnum(e)),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (value) {
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
                  const Flexible(flex: 1, child: Text("Notes:")),
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
                  Flexible(
                      flex: 1,
                      child:
                          //  customTextFieldWithoutIcon(accVatController, true)
                          StatefulBuilder(builder: (context, setstate) {
                        return DropdownButton(
                          value: accVat,
                          items: [
                            DropdownMenuItem<String>(
                              child: Text("ضريبة القيمة المضافة في دول الخليج"),
                              value: "GCC",
                            ),
                            DropdownMenuItem(
                              child: Text("a"),
                              value: "a",
                            ),
                          ],
                          onChanged: (_) {
                            setstate(() {
                              accVat = _.toString();
                            });
                          },
                        );
                      })),
                  SizedBox(
                    width: 30,
                  ),
                  Flexible(flex: 2, child: Text("الحساب يخضع للضريبة")),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 1,
                      child:
                      //  customTextFieldWithoutIcon(accVatController, true)
                      StatefulBuilder(builder: (context, setstate) {
                        return Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Checkbox(
                                      value: accIsRoot,
                                      onChanged: (_) {
                                        setstate(() {
                                          accIsRoot = _!;
                                          accParentId=null;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                   Text("is root"),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child:
                                      //  customTextFieldWithoutIcon(accVatController, true)
                                         IgnorePointer(
                                           ignoring: accIsRoot,
                                           child: Container(
                                             color: accIsRoot?Colors.grey.shade700:Colors.transparent,
                                             child: DropdownButton(
                                              value: accParentId,
                                              items: accountController.accountList.keys.toList().map((e) => DropdownMenuItem(value: e,child: Text(accountController.accountList[e]!.accName!))).toList(),
                                              onChanged: (_) {
                                                setstate(() {
                                                  accParentId = _.toString();
                                                });
                                              },
                                        ),
                                           ),
                                         )),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Flexible(flex: 2, child: Text("الحساب الاب")),
                                ],
                              ),
                            ],
                          ),
                        );
                      })),

                ],
              ),

              SizedBox(height: 40,),
              GetBuilder<AccountViewModel>(builder: (accountController) {
                return ElevatedButton(
                    onPressed: () async {
                      await updateData(nameController, accountType!, notesController, idController, accVat!, codeController,accParentId,accIsRoot);
                      if (isNew) {
                        checkPermissionForOperation(Const.roleUserWrite,Const.roleViewAccount).then((value) {
                          if(value)accountController.addNewAccount(accountModel, withLogger: true);
                        });
                      } else {
                        checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewAccount).then((value) {
                          if(value)accountController.updateAccount(accountModel, withLogger: true);
                        });

                      }
                    },
                    child: Text(isNew ? "Add Account" : "update"));
              })
            ],
          ),
        ),
      ),
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
}
