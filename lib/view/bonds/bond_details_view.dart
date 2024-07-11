import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/see_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../model/bond_record_model.dart';
import '../../utils/confirm_delete_dialog.dart';
import '../../utils/hive.dart';

class BondDetailsView extends StatefulWidget {
  BondDetailsView({
    Key? key,
    this.oldBondModel,
    required this.isStart,
    this.initFun,
    this.oldId,
    this.oldModelKey,
  }) : super(key: key);
  final GlobalModel? oldBondModel;
  final String? oldModelKey;
  final String? oldId;
  final bool isStart ;
  final Function? initFun ;

  @override
  _BondDetailsViewState createState() => _BondDetailsViewState();
}

class _BondDetailsViewState extends State<BondDetailsView> {
  var bondController = Get.find<BondViewModel>();
  var globalController = Get.find<GlobalViewModel>();
  var i = 0;
  List<BondRecordModel> record = <BondRecordModel>[];
  bool isNew = false;
  var newCodeController = TextEditingController();
  String defualtCode = '';
  @override
  void initState() {
    super.initState();
    initPage();
    bondController.lastBondOpened=widget.oldId;
  }

  void initPage() {
    bondController.initCodeList( widget.isStart ? Const.bondTypeStart:Const.bondTypeDaily);
    if (widget.oldId != null || widget.oldBondModel != null) {
      bondController.tempBondModel = GlobalModel.fromJson(widget.oldBondModel?.toFullJson() ?? bondController.allBondsItem[widget.oldId]!.toFullJson());
      bondController.bondModel = widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!;
      // bondController.bondModel = GlobalModel.copy(
      //     widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!);
      isNew = false;
    } else {
      bondController.tempBondModel = getBondData();
      bondController.bondModel = getBondData();
      bondController.tempBondModel.bondCode = bondController.getNextBondCode(type: widget.isStart ? Const.bondTypeStart:Const.bondTypeDaily);
      isNew = true;
    }
    bondController.tempBondModel.bondType = widget.isStart ? Const.bondTypeStart:Const.bondTypeDaily;
    bondController.initPage(bondController.tempBondModel.bondType);
    newCodeController.text = bondController.tempBondModel.bondCode!;
    defualtCode = bondController.tempBondModel.bondCode!;
    // newCodeController.text = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
    // while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<BondViewModel>(builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            // if (controller.isEdit) {
            //   showDialog(
            //       context: context,
            //       builder: (context) => AlertDialog(
            //             title: Text("هل تريد تجاهل التغييرات"),
            //             actions: [
            //               ElevatedButton(
            //                   onPressed: () {
            //                     controller.restoreOldData();
            //                     controller.initPage(bondController.tempBondModel.bondType);
            //                     isNew = false;
            //                     controller.isEdit = false;
            //                     Get.back();
            //                     Get.back();
            //                   },
            //                   child: Text("تجاهل")),
            //               ElevatedButton(
            //                   onPressed: () {
            //                     var validate=bondController.checkValidate();
            //                     if(validate==null) {
            //                       checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewBond).then((value) {
            //                         if (value) {
            //                           if (controller.tempBondModel.bondTotal != "0") {
            //                             Get.back();
            //                             Get.snackbar("خطأ", "يجب ان يكون المدين يساوي الدائن");
            //                           } else {
            //                             globalController.updateGlobalBond(bondController.tempBondModel);
            //                             isNew = false;
            //                             controller.isEdit = false;
            //                             Get.back();
            //                           }
            //                         }
            //                       });

            //                     }else{
            //                       Get.snackbar("خطأ", validate);
            //                     }

            //                   },
            //                   child: Text("قم بالتغييرات")),
            //             ],
            //           ));
            //   return false;
            // } else {
              return true;
            // }
          },
          // )
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text((bondController.bondModel.bondId ?? "سند جديد")+" "+  getBondTypeFromEnum(bondController.tempBondModel.bondType.toString())),
                leading: BackButton(),
                actions: !checkPermission(Const.roleUserAdmin, Const.roleViewInvoice)?[]: isNew
                    ? [
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: newCodeController,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onTapOutside: (_) {
                              if (controller.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
                                Get.snackbar("خطأ", "الرمز مستخدم");
                                newCodeController.text = defualtCode;
                              } else {
                                controller.tempBondModel.bondCode = newCodeController.text;
                              }
                            },
                            onFieldSubmitted: (_) {
                              if (controller.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
                                Get.snackbar("خطأ", "الرمز مستخدم");
                                newCodeController.text = defualtCode;
                              } else {
                                controller.tempBondModel.bondCode = newCodeController.text;
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 30),
                      ]
                    : [
                        if (controller.allBondsItem.values.toList().firstOrNull?.bondId != controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.prevBond();
                                // controller.changeIndex(isBack: true);
                                // controller.initPage();
                              },
                              child: const Text("السابق"))
                        else
                          const SizedBox(width: 50),
                        Container(
                          decoration: BoxDecoration(border: Border.all()),
                          padding: const EdgeInsets.all(5),
                          width: 80,
                          child: TextFormField(
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onFieldSubmitted: (_) {
                              controller.changeIndexCode(code: _);
                              controller.initPage(bondController.tempBondModel.bondType);
                            },
                            decoration: InputDecoration.collapsed(hintText: ""),
                            controller: TextEditingController(text: bondController.tempBondModel.bondCode),
                          ),
                        ),
                        if (controller.allBondsItem.values.toList().lastOrNull?.bondId != controller.bondModel.bondId)
                          TextButton(
                              onPressed: () {
                                controller.nextBond();
                              },
                              child: const Text("التالي"))
                        else
                          const SizedBox(width: 55),
                        const SizedBox(width: 50),
                        if (!isNew && controller.bondModel.originId == null)
                          ElevatedButton(
                              onPressed: () async {
                                confirmDeleteWidget().then((value) {
                                  if(value){
                                    checkPermissionForOperation(Const.roleUserDelete,Const.roleViewBond).then((value) async {
                                      if(value){
                                        globalController.deleteGlobal(bondController.tempBondModel);
                                        Get.back();
                                        controller.update();
                                      }
                                    });
                                  }
                                });
                              },
                              child: Text("حذف"))
                        else
                          const SizedBox(width: 100),
                        const SizedBox(width: 50),
                      ]),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder(
                          stream: controller.allBondsItem.stream,
                          builder: (context, snapshot) {
                         return GetBuilder<BondViewModel>(builder: (controller) {
                                //controller.initPage(bondController.tempBondModel.bondType);
                                // initPage();
                                return SfDataGrid(
                                  horizontalScrollPhysics: NeverScrollableScrollPhysics(),
                                  verticalScrollPhysics: BouncingScrollPhysics(),
                                  source: bondController.recordDataSource,
                                  allowEditing: controller.bondModel.originId == null,
                                  selectionMode: SelectionMode.singleDeselect,
                                  editingGestureType: EditingGestureType.tap,
                                  navigationMode: GridNavigationMode.cell,
                                  columnWidthMode: ColumnWidthMode.fill,
                                  controller: bondController.dataGridController,
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
                                          controller.initPage(bondController.tempBondModel.bondType);
                                        },
                                        child: Container(color: Colors.red, padding: const EdgeInsets.only(left: 30.0), alignment: Alignment.centerLeft, child: const Text('Delete', style: TextStyle(color: Colors.white))));
                                  },
                                  columns: <GridColumn>[
                                    gridColumnItem(label: "الرمز التسلسلي", name: Const.rowBondId),
                                    gridColumnItem(label: 'الحساب', name: Const.rowBondAccount),
                                    gridColumnItem(label: ' مدين', name: Const.rowBondDebitAmount),
                                    gridColumnItem(label: ' دائن', name: Const.rowBondCreditAmount),
                                    gridColumnItem(label: "البيان", name: Const.rowBondDescription),
                                  ],
                                );
                              });
                          })),
                  Row(
                    children: [
                      Spacer(),
                      Text("المجموع"),
                      SizedBox(width: 30),
                      GetBuilder<BondViewModel>(builder: (controller) {
                        double _ = 0;
                        for (var element in bondController.tempBondModel.bondRecord??[]) {
                          _ = _ + element.bondRecDebitAmount!;
                        }
                        return Container(color: double.parse(controller.tempBondModel.bondTotal??"0")== 0 ? Colors.green : Colors.red, padding: EdgeInsets.all(8), child: Text(_.toStringAsFixed(2)));
                      }),
                      SizedBox(width: 20),
                      Builder(builder: (context) {
                        double _ = 0;
                        for (var element in bondController.tempBondModel.bondRecord??[]) {
                          _ = _ + element.bondRecCreditAmount!;
                        }

                        return Container(color:double.parse(controller.tempBondModel.bondTotal??"0") == 0  ? Colors.green : Colors.red, padding: EdgeInsets.all(8), child: Text(_.toStringAsFixed(2)));
                      }),
                      SizedBox(width: 50),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        var validate=bondController.checkValidate();
                        if (isNew) {
                          if(validate==null) {
                            checkPermissionForOperation(Const.roleUserWrite,Const.roleViewBond).then((value) {
                              if(value){
                                globalController.addGlobalBond(bondController.tempBondModel);
                                //bondController.postOneBond(isNew, withLogger: true);
                                isNew = false;
                                controller.isEdit = false;
                              }
                            });
                          }else{
                            Get.snackbar("خطأ", validate);
                          }
                        } else if (controller.bondModel.originId == null) {
                          if(validate==null) {
                          checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewBond).then((value) async {
                            if(value){
                              isNew = false;
                              controller.isEdit = false;
                             await globalController.updateGlobalBond(bondController.tempBondModel);
                              // bondController.updateBond(modelKey: widget.oldModelKey, withLogger: true);
                              if(widget.initFun!=null){
                                widget.initFun!("");
                              }
                            }
                          });}else{
                            Get.snackbar("خطأ", validate);
                          }
                        } else {
                          seeDetails(controller.bondModel.originId!);
                        }
                      },
                      child: Text(
                        isNew
                            ? "إضافة"
                            : controller.bondModel.originId == null
                                ? "تعديل"
                                : "ذهاب للتفاصيل",
                        maxLines: 4,
                      )),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  GridColumn gridColumnItem({required label, name}) {
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
}
