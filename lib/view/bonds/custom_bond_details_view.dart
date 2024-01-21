import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../controller/account_view_model.dart';
import '../../controller/user_management_model.dart';
import '../../model/account_model.dart';

import '../../model/bond_record_model.dart';
import '../../utils/see_details.dart';


class CustomBondDetailsView extends StatefulWidget {
  CustomBondDetailsView({
    Key? key,
    this.oldBondModel,
    this.oldId,
    this.oldModelKey,
    required this.isDebit,
  }) : super(key: key);
  final GlobalModel? oldBondModel;
  final String? oldModelKey;
  final String? oldId;
  final bool isDebit;

  @override
  _CustomBondDetailsViewState createState() => _CustomBondDetailsViewState();
}

class _CustomBondDetailsViewState extends State<CustomBondDetailsView> {
  var bondController = Get.find<BondViewModel>();
  var i = 0;
  List<BondRecordModel> record = <BondRecordModel>[];
  bool isNew = false;
  var newCodeController = TextEditingController();
  var userAccountController = TextEditingController();
  String defualtCode = '';
  var accountController = Get.find<AccountViewModel>();

  //late GlobalModel bondModel;
  @override
  void initState() {
    super.initState();
    initPage();
  }

  void initPage() {
    if (widget.oldId != null || widget.oldBondModel != null) {
      bondController.tempBondModel = GlobalModel.fromJson(widget.oldBondModel?.toFullJson() ?? bondController.allBondsItem[widget.oldId]!.toFullJson());
      bondController.bondModel = widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!;
      isNew = false;
      var _ = accountController.accountList.values.toList().firstWhere((e) => e.accId == bondController.tempBondModel.bondRecord?[0].bondRecAccount).accName;
      userAccountController.text = _!;
      bondController.tempBondModel.bondRecord?.removeAt(0);
    } else {
      bondController.tempBondModel = getBondData();
      bondController.bondModel = getBondData();
      isNew = true;
      bondController.tempBondModel.bondType = widget.isDebit ? Const.bondTypeDebit : Const.bondTypeCredit;
    }
    bondController.initPage();

    newCodeController.text = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
    while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
      newCodeController.text = (int.parse(newCodeController.text) + 1).toString();
      defualtCode = newCodeController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<BondViewModel>(builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.isEdit) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("هل تريد تجاهل التغييرات"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                controller.restoreOldData();
                                bondController.initPage();
                                isNew = false;
                                controller.isEdit = false;
                                Get.back();
                                Get.back();
                              },
                              child: Text("تجاهل")),
                          ElevatedButton(
                              onPressed: () {
                                var mainAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == userAccountController.text).accId;
                                var total = double.parse(bondController.tempBondModel.bondTotal!);
                                bondController.tempBondModel.bondRecord?.add(BondRecordModel("0", widget.isDebit ? total : 0, widget.isDebit ? 0 : total, mainAccount, "BondRecDescription"));
                                if (isNew) {
                                  bondController.postOneBond(isNew);
                                  isNew = false;
                                  controller.isEdit = false;
                                } else {
                                  bondController.updateBond(modelKey: widget.oldModelKey);
                                  isNew = false;
                                  controller.isEdit = false;
                                }
                              },
                              child: Text("قم بالتغييرات")),

                        ],
                      ));
              return false;
            } else {
              return true;
            }
          },
          // )
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text(bondController.bondModel.bondCode ?? "سند جديد"),
                leading: BackButton(),
                actions: isNew
                    ? [
                  Text("الرمز التسلسلي: "),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: newCodeController,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onTapOutside: (_) {
                              if (controller.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
                                Get.snackbar("Error", "Is Used");
                                newCodeController.text = defualtCode;
                              } else {
                                controller.tempBondModel.bondCode = newCodeController.text;
                              }
                            },
                            onFieldSubmitted: (_) {
                              if (controller.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
                                Get.snackbar("Error", "Is Used");
                                newCodeController.text = defualtCode;
                              } else {
                                controller.tempBondModel.bondCode = newCodeController.text;
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          width: 30,
                        ),
                      ]
                    : [
                        if (controller.allBondsItem.values.toList().firstOrNull?.bondId != controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.prevBond();
                                var _ = accountController.accountList.values.toList().firstWhere((e) => e.accId == bondController.tempBondModel.bondRecord?[0].bondRecAccount).accName;
                                userAccountController.text = _!;
                                bondController.tempBondModel.bondRecord?.removeAt(0);
                              },
                              child: Text("السابق"))
                        else
                          SizedBox(
                            width: 50,
                          ),
                        // Text((isNew
                        //         ? controller.allBondsItem.length
                        //         : controller.allBondsItem.values
                        //             .toList()
                        //             .indexWhere((element) => element.bondId == controller.bondModel.bondId))
                        //     .toString()),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          padding: EdgeInsets.all(5),
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onFieldSubmitted: (_) {
                              controller.changeIndexCode(code: _);
                              bondController.initPage();
                            },
                            decoration: InputDecoration.collapsed(hintText: ""),
                            controller: TextEditingController(text: bondController.tempBondModel.bondCode),
                          ),
                        ),
                        if (controller.allBondsItem.values.toList().lastOrNull?.bondId != controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.nextBond();
                                var _ = accountController.accountList.values.toList().firstWhere((e) => e.accId == bondController.tempBondModel.bondRecord?[0].bondRecAccount).accName;
                                userAccountController.text = _!;
                                bondController.tempBondModel.bondRecord?.removeAt(0);
                              },
                              child: Text("التالي"))
                        else
                          SizedBox(
                            width: 55,
                          ),
                        SizedBox(
                          width: 50,
                        ),
                        if (!isNew)
                          ElevatedButton(
                              onPressed: () async {
                                checkPermissionForOperation(Const.roleUserDelete, Const.roleViewBond).then((value) async{
                                  if(value){
                                    await controller.deleteOneBonds();
                                    Get.back();
                                    controller.update();
                                  }
                                });
                              },
                              child: Text("حذف"))
                        else
                          SizedBox(
                            width: 20,
                          ),
                        SizedBox(
                          width: 50,
                        ),
                      ]),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Text("اسم الحساب"),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: userAccountController,
                          onFieldSubmitted: (_) async {

                            List<String> result = searchText(_);
                            if (result.isEmpty) {
                              Get.snackbar("خطأ", "غير موجود");
                            } else if (result.length == 1) {
                              userAccountController.text = result[0];
                            } else {
                              await Get.defaultDialog(
                                  title: "اختر احد الحسابات",
                                  content: SizedBox(
                                    height: 500,
                                    width: 500,
                                    child: ListView.builder(
                                        itemCount: result.length,
                                        itemBuilder: (contet, index) {
                                          return InkWell(
                                            onTap: () {
                                              userAccountController.text = result[index];
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
                                        child: Text("خروج"))
                                  ]);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection(Const.bondsCollection).doc(controller.tempBondModel.bondId).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting && (controller.bondModel.originId != null)) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return GetBuilder<BondViewModel>(builder: (controller) {
                              // if (controller.bondModel.originId != null) {
                              // initPage();
                              // }
                              controller.initPage();
                              return SfDataGrid(
                                source: bondController.customBondRecordDataSource,
                                allowEditing: controller.bondModel.originId == null,
                                selectionMode: SelectionMode.singleDeselect,
                                editingGestureType: EditingGestureType.tap,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.fill,
                                allowSwiping: controller.bondModel.originId == null,
                                swipeMaxOffset: 200,
                                onSwipeStart: (swipeStartDetails) {
                                  if (swipeStartDetails.swipeDirection == DataGridRowSwipeDirection.endToStart) {
                                    return false;
                                  }
                                  if (swipeStartDetails.rowIndex == bondController.tempBondModel.bondRecord?.length || bondController.tempBondModel.bondRecord?.length == 1) {
                                    return false;
                                  }
                                  return true;
                                },
                                startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
                                  return GestureDetector(
                                      onTap: () {
                                        controller.deleteOneRecord(rowIndex);
                                        controller.initPage();
                                      },
                                      child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                                },
                                columns: <GridColumn>[
                                  GridColumnItem(label: "الرمز التسلسلي", name: Const.rowBondId),
                                  GridColumnItem(label: 'الحساب', name: Const.rowBondAccount),
                                  widget.isDebit ? GridColumnItem(label: ' مدين', name: Const.rowBondDebitAmount) : GridColumnItem(label: ' دائن', name: Const.rowBondCreditAmount),
                                  GridColumnItem(label: "البيان", name: Const.rowBondDescription),
                                ],
                              );
                            });
                          }
                        }),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Text("المجموع"),
                      SizedBox(
                        width: 30,
                      ),
                      if (widget.isDebit)
                        Builder(builder: (context) {
                          double _ = 0;
                          bondController.tempBondModel.bondRecord!.forEach((element) {
                            _ = _ + element.bondRecDebitAmount!;
                          });
                          return Container(color: Colors.green, padding: EdgeInsets.all(8), child: Text(_.toString()));
                        }),
                      SizedBox(
                        width: 20,
                      ),
                      if (!widget.isDebit)
                        Builder(builder: (context) {
                          double _ = 0;
                          bondController.tempBondModel.bondRecord!.forEach((element) {
                            _ = _ + element.bondRecCreditAmount!;
                          });
                          return Container(color: Colors.green, padding: EdgeInsets.all(8), child: Text(_.toString()));
                        }),
                      SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (userAccountController.text.isEmpty) {
                          Get.snackbar("خطأ", "حقل الحساب فارغ");
                          return;
                        }
                        var validate = bondController.checkValidate();
                        if (validate != null) {
                          Get.snackbar("خطأ", validate);
                          return;
                        }
                        var mainAccount = accountController.accountList.values.toList().firstWhere((e) => e.accName == userAccountController.text).accId;
                        double total = 0;
                        bondController.tempBondModel.bondRecord?.forEach((element) {
                          if (bondController.tempBondModel.bondType == Const.bondTypeDebit) {
                            total += element.bondRecDebitAmount ?? 0;
                          } else {
                            total += element.bondRecCreditAmount ?? 0;
                          }
                        });
                        // var total = int.parse(bondController.tempBondModel.bondTotal!);

                        if (!isNew) {
                          bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "0");
                        }
                        bondController.tempBondModel.bondRecord?.add(BondRecordModel("0", widget.isDebit ? total : 0, widget.isDebit ? 0 : total, mainAccount, "تم توليده بشكل تلقائي"));
                        var validate2 = bondController.checkValidate();
                        if (isNew) {
                          if (validate2 == null) {
                            checkPermissionForOperation(Const.roleUserWrite,Const.roleViewBond).then((value) {
                              if (value) {
                                bondController.postOneBond(isNew, withLogger: true);
                                isNew = false;
                                controller.isEdit = false;
                                bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "0");
                              }
                            });
                          } else {
                            Get.snackbar("خطأ", validate2);
                          }
                        } else if (controller.bondModel.originId == null) {
                          if (validate2 == null) {
                            checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewBond).then((value) {
                              if (value) {
                                bondController.updateBond(modelKey: widget.oldModelKey, withLogger: true);
                                isNew = false;
                                controller.isEdit = false;
                              }
                            });
                          } else {
                            Get.snackbar("خطأ", validate2);
                          }
                        } else {
                          seeDetails(controller.bondModel.originId!);
                        }
                      },
                      child: Text(
                        isNew
                            ? "إضافة"
                            : controller.bondModel.originId == null
                                ? "تحديث"
                            : "ذهاب للتفاصيل",
                        maxLines: 4,
                      )),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  GridColumn GridColumnItem({required label, name}) {
    return GridColumn(
        allowEditing: name == Const.rowBondId ? false : true,
        columnName: name,
        label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              label.toString(),
            )));
  }

  late List<AccountModel> products = <AccountModel>[];

  List<String> searchText(String query) {
    AccountViewModel accountController = Get.find<AccountViewModel>();
    products = accountController.accountList.values.toList().where((item) {
      var name = item.accName.toString().toLowerCase().contains(query.toLowerCase());
      var code = item.accCode.toString().toLowerCase().contains(query.toLowerCase());
      return name || code;
    }).toList();
    return products.map((e) => e.accName!).toList();
  }
}
