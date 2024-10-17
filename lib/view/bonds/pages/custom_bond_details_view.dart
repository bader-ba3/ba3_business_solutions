import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/date_picker.dart';
import 'package:ba3_business_solutions/data/model/global/global_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../controller/account/account_controller.dart';
import '../../../controller/global/global_controller.dart';
import '../../../controller/user/user_management_controller.dart';
import '../../../core/helper/functions/functions.dart';
import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../../core/shared/widgets/grid_column_item.dart';
import '../../../core/utils/confirm_delete_dialog.dart';
import '../../../data/model/account/account_model.dart';
import '../../../data/model/bond/bond_record_model.dart';

class CustomBondDetailsView extends StatefulWidget {
  const CustomBondDetailsView({
    super.key,
    this.oldBondModel,
    this.oldId,
    this.oldModelKey,
    required this.isDebit,
  });

  final GlobalModel? oldBondModel;
  final String? oldModelKey;
  final String? oldId;
  final bool isDebit;

  @override
  _CustomBondDetailsViewState createState() => _CustomBondDetailsViewState();
}

class _CustomBondDetailsViewState extends State<CustomBondDetailsView> {
  var bondController = Get.find<BondController>();
  var i = 0;
  List<BondRecordModel> record = <BondRecordModel>[];
  var globalController = Get.find<GlobalController>();

  bool isNew = false;
  var newCodeController = TextEditingController();

  // var controller.userAccountController = TextEditingController();
  String defualtCode = '';
  var accountController = Get.find<AccountController>();

  //late GlobalModel bondModel;
  @override
  void initState() {
    super.initState();
    initPage();
  }

  late AccountModel primeryAccount;

  void initPage() {
    bondController.initCodeList(widget.isDebit ? AppConstants.bondTypeDebit : AppConstants.bondTypeCredit);
    if (widget.oldId != null || widget.oldBondModel != null) {
      print("init");
      bondController.tempBondModel =
          GlobalModel.fromJson(widget.oldBondModel?.toFullJson() ?? bondController.allBondsItem[widget.oldId]!.toFullJson());
      print(bondController.tempBondModel);
      bondController.bondModel = widget.oldBondModel ?? bondController.allBondsItem[widget.oldId]!;
      print(bondController.tempBondModel.toFullJson());
      isNew = false;
    } else {
      bondController.tempBondModel = getBondData();
      bondController.bondModel = getBondData();
      isNew = true;
      bondController.tempBondModel.bondType = widget.isDebit ? AppConstants.bondTypeDebit : AppConstants.bondTypeCredit;
      newCodeController.text = bondController.getNextBondCode(type: widget.isDebit ? AppConstants.bondTypeDebit : AppConstants.bondTypeCredit);
      bondController.tempBondModel.bondCode = newCodeController.text;
    }
    defualtCode = bondController.tempBondModel.bondCode!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: GetBuilder<BondController>(builder: (controller) {
              return Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                        "${bondController.bondModel.bondCode ?? "سند جديد"} ${getBondTypeFromEnum(bondController.tempBondModel.bondType.toString())}"),
                    // leading: const BackButton(),
                    actions: !checkPermission(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice)
                        ? []
                        : isNew
                            ? [
                                Row(
                                  children: [
                                    const Text("تاريخ السند : ", style: TextStyle()),
                                    DatePicker(
                                      initDate: controller.tempBondModel.bondDate,
                                      onSubmit: (_) {
                                        controller.tempBondModel.bondDate = _.toString().split(".")[0];
                                        controller.update();
                                      },
                                    ),
                                    const SizedBox(width: 50),
                                  ],
                                ),
                                const Text("الرمز التسلسلي: "),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller: newCodeController,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    onTapOutside: (_) {
                                      if (controller.codeList.keys.toList().contains(newCodeController.text)) {
                                        Get.snackbar("Error", "Is Used");
                                        newCodeController.text = defualtCode;
                                      } else {
                                        controller.tempBondModel.bondCode = newCodeController.text;
                                      }
                                    },
                                    onFieldSubmitted: (_) {
                                      if (controller.codeList.keys.toList().contains(newCodeController.text)) {
                                        Get.snackbar("Error", "Is Used");
                                        newCodeController.text = defualtCode;
                                      } else {
                                        controller.tempBondModel.bondCode = newCodeController.text;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                              ]
                            : [
                                Row(
                                  children: [
                                    const Text("تاريخ السند : ", style: TextStyle()),
                                    DatePicker(
                                      initDate: controller.tempBondModel.bondDate,
                                      onSubmit: (_) {
                                        controller.tempBondModel.bondDate = _.toString().split(".")[0];
                                        controller.update();
                                      },
                                    ),
                                    const SizedBox(width: 50),
                                  ],
                                ),
                                if (controller.allBondsItem.values.toList().firstOrNull?.bondId != controller.bondModel.bondId)
                                  TextButton(
                                      onPressed: () {
                                        // controller.firstBond();
                                      },
                                      child: const Icon(Icons.keyboard_double_arrow_right))
                                else
                                  const SizedBox(
                                    width: 50,
                                  ),
                                if (controller.allBondsItem.values.toList().firstOrNull?.bondId != controller.bondModel.bondId)
                                  TextButton(
                                      onPressed: () {
                                        // controller.prevBond();
                                      },
                                      child: const Icon(Icons.keyboard_arrow_right))
                                else
                                  const SizedBox(
                                    width: 50,
                                  ),
                                Container(
                                  decoration: BoxDecoration(border: Border.all()),
                                  padding: const EdgeInsets.all(5),
                                  width: 80,
                                  child: TextFormField(
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    onFieldSubmitted: (_) {
                                      controller.changeIndexCode(
                                        code: _,
                                        type: controller.tempBondModel.bondType!,
                                      );
                                      // bondController.initPage(bondController.tempBondModel.bondType);
                                    },
                                    decoration: const InputDecoration.collapsed(hintText: ""),
                                    controller: TextEditingController(text: bondController.tempBondModel.bondCode),
                                  ),
                                ),
                                if (controller.allBondsItem.values.toList().lastOrNull?.bondId != controller.bondModel.bondId)
                                  TextButton(
                                      onPressed: () {
                                        // controller.nextBond();
                                      },
                                      child: const Icon(Icons.keyboard_arrow_left))
                                else
                                  const SizedBox(
                                    width: 55,
                                  ),
                                if (controller.allBondsItem.values.toList().lastOrNull?.bondId != controller.bondModel.bondId)
                                  TextButton(
                                      onPressed: () {
                                        // controller.lastBond();
                                      },
                                      child: const Icon(Icons.keyboard_double_arrow_left))
                                else
                                  const SizedBox(
                                    width: 55,
                                  ),
                                const SizedBox(
                                  width: 50,
                                ),
                                if (!isNew)
                                  ElevatedButton(
                                      onPressed: () async {
                                        confirmDeleteWidget().then((value) {
                                          if (value) {
                                            hasPermissionForOperation(AppConstants.roleUserDelete, AppConstants.roleViewBond).then((value) async {
                                              if (value) {
                                                globalController.deleteGlobal(bondController.tempBondModel);
                                                Get.back();
                                                controller.update();
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: const Text("حذف"))
                                else
                                  const SizedBox(
                                    width: 20,
                                  ),
                                const SizedBox(
                                  width: 50,
                                ),
                              ]),
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          const Text("اسم الحساب"),
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: controller.userAccountController,
                              decoration: const InputDecoration(fillColor: Colors.white, filled: true),
                              onFieldSubmitted: (value) async {
                                List<String> result = Get.find<AccountController>().searchText(value);
                                if (result.isEmpty) {
                                  Get.snackbar("خطأ", "غير موجود");
                                } else if (result.length == 1) {
                                  controller.userAccountController.text = result[0];
                                } else {
                                  await Get.defaultDialog(
                                      title: "اختر احد الحسابات",
                                      content: SizedBox(
                                        height: 500,
                                        width: Get.width / 1.5,
                                        child: ListView.builder(
                                            itemCount: result.length,
                                            itemBuilder: (contet, index) {
                                              return InkWell(
                                                onTap: () {
                                                  controller.userAccountController.text = result[index];
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
                                            child: const Text("خروج"))
                                      ]);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: StreamBuilder(
                            stream: controller.allBondsItem.stream,
                            builder: (context, snapshot) {
                              if (snapshot.data == "null") {
                                return const CircularProgressIndicator();
                              } else {
                                return GetBuilder<BondController>(builder: (controller) {
                                  // if (controller.bondModel.originId != null) {
                                  // initPage();
                                  // }
                                  // controller.initPage(bondController.tempBondModel.bondType);
                                  return SfDataGrid(
                                    source: bondController.customBondRecordDataSource,
                                    controller: bondController.dataGridController,
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
                                      if (swipeStartDetails.rowIndex == bondController.tempBondModel.bondRecord?.length ||
                                          bondController.tempBondModel.bondRecord?.length == 1) {
                                        return false;
                                      }
                                      return true;
                                    },
                                    startSwipeActionsBuilder: (BuildContext context, DataGridRow row, int rowIndex) {
                                      return GestureDetector(
                                          onTap: () {
                                            // controller.deleteOneRecord(rowIndex);
                                            // controller.initPage(bondController.tempBondModel.bondType);
                                          },
                                          child: Container(
                                              color: Colors.red,
                                              padding: const EdgeInsets.only(left: 30.0),
                                              alignment: Alignment.centerLeft,
                                              child: const Text('Delete', style: TextStyle(color: Colors.white))));
                                    },
                                    columns: <GridColumn>[
                                      gridColumnItem(label: "الرمز التسلسلي", name: AppConstants.rowBondId, color: Colors.blue),
                                      gridColumnItem(label: 'الحساب', name: AppConstants.rowBondAccount, color: Colors.blue),
                                      widget.isDebit
                                          ? gridColumnItem(label: ' مدين', name: AppConstants.rowBondDebitAmount, color: Colors.blue)
                                          : gridColumnItem(label: ' دائن', name: AppConstants.rowBondCreditAmount, color: Colors.blue),
                                      gridColumnItem(label: "البيان", name: AppConstants.rowBondDescription, color: Colors.blue),
                                    ],
                                  );
                                });
                              }
                            }),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          const Text("المجموع"),
                          const SizedBox(
                            width: 30,
                          ),
                          if (widget.isDebit)
                            Builder(builder: (context) {
                              double _ = 0;
                              for (var element in bondController.tempBondModel.bondRecord!) {
                                _ = _ + element.bondRecDebitAmount!;
                              }
                              return Container(color: Colors.green, padding: const EdgeInsets.all(8), child: Text(_.toString()));
                            }),
                          const SizedBox(
                            width: 20,
                          ),
                          if (!widget.isDebit)
                            Builder(builder: (context) {
                              double _ = 0;
                              for (var element in bondController.tempBondModel.bondRecord!) {
                                _ = _ + element.bondRecCreditAmount!;
                              }
                              return Container(color: Colors.green, padding: const EdgeInsets.all(8), child: Text(_.toString()));
                            }),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (controller.userAccountController.text.isEmpty) {
                              Get.snackbar("خطأ", "حقل الحساب فارغ");
                              return;
                            }
                            var validate = bondController.checkValidate();
                            if (validate != null) {
                              Get.snackbar("خطأ", validate);
                              return;
                            }
                            var mainAccount = accountController.accountList.values
                                .toList()
                                .firstWhere((e) => e.accName == controller.userAccountController.text)
                                .accId;
                            double total = 0;
                            bondController.tempBondModel.bondRecord?.forEach((element) {
                              if (bondController.tempBondModel.bondType == AppConstants.bondTypeDebit) {
                                total += element.bondRecDebitAmount ?? 0;
                              } else {
                                total += element.bondRecCreditAmount ?? 0;
                              }
                            });
                            bondController.tempBondModel.bondRecord?.add(
                                BondRecordModel("X", widget.isDebit ? total : 0, widget.isDebit ? 0 : total, mainAccount, "تم توليده بشكل تلقائي"));
                            var validate2 = bondController.checkValidate();
                            if (isNew) {
                              if (validate2 == null) {
                                hasPermissionForOperation(AppConstants.roleUserWrite, AppConstants.roleViewBond).then((value) async {
                                  if (value) {
                                    print(bondController.tempBondModel.bondRecord?.map((e) => e.toJson()));
                                    await globalController.addGlobalBond(bondController.tempBondModel);
                                    isNew = false;
                                    controller.isEdit = false;
                                    bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "X");
                                  }
                                });
                              } else {
                                Get.snackbar("خطأ", validate2);
                              }
                            } else if (controller.bondModel.originId == null) {
                              if (validate2 == null) {
                                hasPermissionForOperation(AppConstants.roleUserUpdate, AppConstants.roleViewBond).then((value) async {
                                  if (value) {
                                    GlobalModel temp = GlobalModel.fromJson(bondController.tempBondModel.toFullJson());
                                    bondController.tempBondModel.bondRecord?.removeWhere((element) => element.bondRecId == "X");
                                    await globalController.updateGlobalBond(temp);

                                    isNew = false;
                                    controller.isEdit = false;
                                  }
                                });
                              } else {
                                Get.snackbar("خطأ", validate2);
                              }
                            }
                          },
                          child: Text(
                            isNew ? "إضافة" : "تحديث",
                            maxLines: 4,
                          )),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
