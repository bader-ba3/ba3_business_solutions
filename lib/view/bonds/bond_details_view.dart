import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/utils/see_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../model/bond_record_model.dart';
import '../invoices/invoice_view.dart';

class BondDetailsView extends StatefulWidget {
  BondDetailsView({
    Key? key,
    this.oldBondModel,
    this.oldId,
    this.oldModelKey,
  }) : super(key: key);
  final GlobalModel? oldBondModel;
  final String? oldModelKey;
  final String? oldId;

  @override
  _BondDetailsViewState createState() => _BondDetailsViewState();
}

class _BondDetailsViewState extends State<BondDetailsView> {
  var bondController = Get.find<BondViewModel>();
  var i = 0;
  List<BondRecordModel> record = <BondRecordModel>[];
  bool isNew = false;
  var newCodeController = TextEditingController();
  String defualtCode = '';
  @override
  void initState() {
    super.initState();
    initPage();
  }

  void initPage() {
    if (widget.oldId != null || widget.oldBondModel != null) {
      bondController.tempBondModel = GlobalModel.fromJson(widget.oldBondModel?.toFullJson() ?? bondController.allBondsItem[widget.oldId]!.toFullJson());
      bondController.bondModel = widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!;
      // bondController.bondModel = GlobalModel.copy(
      //     widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!);
      isNew = false;
    } else {
      bondController.tempBondModel = getBondData();
      bondController.bondModel = getBondData();
      isNew = true;
    }
    bondController.tempBondModel.bondType = Const.bondTypeDaily;
    bondController.initPage();

    newCodeController.text = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
    while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(newCodeController.text)) {
      newCodeController.text = (int.parse(newCodeController.text) + 1).toString();
      defualtCode = newCodeController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BondViewModel>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          print("back");
          if (controller.isEdit) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("would you discard your edit"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              controller.restoreOldData();
                              controller.initPage();
                              isNew = false;
                              controller.isEdit = false;
                              Get.back();
                              Get.back();
                            },
                            child: Text("discard")),
                        ElevatedButton(
                            onPressed: () {
                              var validate=bondController.checkValidate();
                              if(validate==null) {
                                checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewBond).then((value) {
                                  bondController.updateBond(modelKey: widget.oldModelKey, withLogger: true);
                                  isNew = false;
                                  controller.isEdit = false;
                                });}else{
                                Get.snackbar("error", validate);
                              }
                              checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewBond).then((value) {
                                if (value) {
                                  if (controller.tempBondModel.bondTotal != "0") {
                                    Get.back();
                                    Get.snackbar("Error", "plz");
                                  } else {
                                    bondController.updateBond(modelKey: widget.oldModelKey, withLogger: true);
                                    isNew = false;
                                    controller.isEdit = false;
                                    Get.back();
                                    Get.back();
                                  }
                                }
                              });
                            },
                            child: Text("make change")),
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
              title: Text(bondController.bondModel.bondId ?? "new Item"),
              leading: BackButton(),
              actions: isNew
                  ? [
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
                            child: const Text("back"))
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
                            controller.initPage();
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
                            child: const Text("next"))
                      else
                        const SizedBox(width: 55),
                      const SizedBox(width: 50),
                      if (!isNew && controller.bondModel.originId == null)
                        ElevatedButton(
                            onPressed: () async {
                              checkPermissionForOperation(Const.roleUserDelete,Const.roleViewBond).then((value) async {
                                await controller.deleteOneBonds(withLogger: true);
                                Get.back();
                                controller.update();
                              });
                            },
                            child: Text("DELETE"))
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
                        stream: FirebaseFirestore.instance.collection(Const.bondsCollection).snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null || snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else {
                            return GetBuilder<BondViewModel>(builder: (controller) {
                              controller.initPage();
                              // initPage();
                              return SfDataGrid(
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
                                        controller.initPage();
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
                          }
                        })),
                Row(
                  children: [
                    Spacer(),
                    Text("المجموع"),
                    SizedBox(width: 30),
                    GetBuilder<BondViewModel>(builder: (controller) {
                      double _ = 0;
                      for (var element in bondController.tempBondModel.bondRecord!) {
                        _ = _ + element.bondRecDebitAmount!;
                      }
                      return Container(color: double.parse(controller.tempBondModel.bondTotal??"0")== 0 ? Colors.green : Colors.red, padding: EdgeInsets.all(8), child: Text(_.toStringAsFixed(2)));
                    }),
                    SizedBox(width: 20),
                    Builder(builder: (context) {
                      double _ = 0;
                      for (var element in bondController.tempBondModel.bondRecord!) {
                        _ = _ + element.bondRecCreditAmount!;
                      }
                      print(double.parse(controller.tempBondModel.bondTotal!));
                      print(controller.tempBondModel.bondTotal);
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
                            bondController.postOneBond(isNew, withLogger: true);
                            isNew = false;
                            controller.isEdit = false;
                          });
                        }else{
                          Get.snackbar("error", validate);
                        }
                      } else if (controller.bondModel.originId == null) {
                        if(validate==null) {
                        checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewBond).then((value) {
                          bondController.updateBond(modelKey: widget.oldModelKey, withLogger: true);
                          isNew = false;
                          controller.isEdit = false;
                        });}else{
                          Get.snackbar("error", validate);
                        }
                      } else {
                        seeDetails(controller.bondModel.originId!);
                      }
                    },
                    child: Text(
                      isNew
                          ? "add"
                          : controller.bondModel.originId == null
                              ? "update"
                              : "Go to Details",
                      maxLines: 4,
                    )),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      );
    });
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
