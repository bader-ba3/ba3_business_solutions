import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/view/accounts/widget/account_details.dart';
import 'package:ba3_business_solutions/view/dashboard/widget/dashboard_chart_widget1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../controller/account_view_model.dart';
import '../../model/account_model.dart';
import '../../utils/hive.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          width: MediaQuery
              .sizeOf(context)
              .width / 4,
          height: MediaQuery
              .sizeOf(context)
              .width / 4,
          child: GetBuilder<AccountViewModel>(builder: (accountController) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.25), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: (){


                          },
                          child: Text(
                            "الحسابات الرئيسية",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(onPressed: () async {
                          TextEditingController nameController = TextEditingController();
                          List<AccountModel> accountList = [];
                          await   Get.defaultDialog(
                              title: "اكتب اسم الحساب",
                              content: StatefulBuilder(
                                  builder: (context, setstate) {
                                    return SizedBox(
                                      height: MediaQuery
                                          .sizeOf(context)
                                          .width / 4,
                                      width: MediaQuery
                                          .sizeOf(context)
                                          .width / 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: TextFormField(
                                                textDirection: TextDirection.rtl,
                                                decoration: InputDecoration(hintText: "اكتب اسم الحساب او رقمه",hintTextDirection: TextDirection.rtl),
                                                onChanged: (_){
                                                  accountList = getAccountModelFromName(_);
                                                  print(accountList);
                                                  setstate(() {});
                                                },
                                                controller: nameController,
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Expanded(child: accountList.isEmpty
                                                ? Center(child: Text("لا يوجد نتائج"),)
                                                : ListView.builder(
                                              itemCount: accountList.length,
                                              itemBuilder: (context, index) {
                                                AccountModel model = accountList[index];
                                                return Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        HiveDataBase.mainAccountModelBox.put(model.accId, model);
                                                        Get.back();
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(model.accName.toString() + "   " + model.accCode.toString(),textDirection: TextDirection.rtl,),
                                                      )),
                                                );
                                              },))
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              )
                          );
                          accountController.update();
                        }, child: Text("إضافة حساب ")),
                        SizedBox(width: 20,),
                      ],
                    ),
                    Expanded(child:
                    ListView.builder(
                      itemCount: HiveDataBase.mainAccountModelBox.values
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        AccountModel model = HiveDataBase.mainAccountModelBox.values.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onSecondaryTapDown: (details) {
                              showContextMenu(context, details.globalPosition,model.accId!,accountController);
                            },
                            onLongPressStart: (details) {
                              showContextMenu(context, details.globalPosition,model.accId!,accountController);
                            },
                            child: Row(
                              children: [
                                Spacer(),
                                Text(model.accName.toString(), style: TextStyle(fontSize: 22),),
                                Spacer(flex: 2,),
                                Text(accountController.getBalance(model.accId).toStringAsFixed(2), style: TextStyle(fontSize: 22),),
                                Spacer(),
                              ],
                            ),
                          ),
                        );
                      },)),
                  ],
                ),
              ),
            );
          }),
        ),
        DashboardChartWidget1(),
      ],
    );
  }
  void showContextMenu(BuildContext parentContext, Offset tapPosition,String id,AccountViewModel accountController) {
    showMenu(
      context: parentContext,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1.0,
        tapPosition.dy * 1.0,
      ),
      items: [
         PopupMenuItem(
          value: 'details',
          child: ListTile(
            leading: Icon(Icons.search,color: Colors.blue.shade300,),
            title: Text('عرض الحركات'),
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.remove_circle_outline,color: Colors.red.shade700,),
            title: Text('حذف'),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'details') {
       Get.to(()=>AccountDetails(modelKey: id));
      }else if (value == 'delete') {
        HiveDataBase.mainAccountModelBox.delete(id);
        accountController.update();
      }
    });
  }

}
