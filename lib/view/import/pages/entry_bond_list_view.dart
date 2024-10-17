import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/databsae/import_controller.dart';
import '../../../data/model/bond/entry_bond_record_model.dart';
import '../../../data/model/global/global_model.dart';

class EntryBondListView extends StatelessWidget {
  final List<GlobalModel> bondList;

  EntryBondListView({super.key, required this.bondList});

  final ImportController importViewModel = Get.find<ImportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                if (importViewModel.checkAllAccount(bondList)) {
                  importViewModel.addBond(bondList);
                }
              },
              child: const Text("add"))
        ],
      ),
      body: ListView.builder(
          itemCount: bondList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(bondList[index].bondId.toString()),
                      Text("المجموع: ${bondList[index].bondTotal}"),
                      Text("الوقت: ${bondList[index].bondDate}"),
                      // Text("نوع الفاتورة: "+getBondTypeFromEnum(bondList[index].bondType.toString())),
                      Text("الرمز: ${bondList[index].bondCode}"),
                      // Text("الرمز: "+bondList[index].bondType.toString()),
                      // Text("سند قيد: "+bondList[index].originAmenId.toString()),
                      Text("الوصف: ${bondList[index].bondDescription}"),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "الوصف",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "دائن",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "مدين",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 300,
                            child: Text(
                              "الحساب",
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          height: 30,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                            width: 50,
                            child: Text(
                              "الرمز",
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                  ),
                  for (EntryBondRecordModel e
                      in bondList[index].entryBondRecord ?? [])
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              width: 50,
                              child: Text(e.bondRecDescription.toString())),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 50,
                              child: Text(e.bondRecCreditAmount.toString())),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 50,
                              child: Text(e.bondRecDebitAmount.toString())),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (getAccountNameFromId(e.bondRecAccount) ==
                                      "")
                                    Text(
                                      "غير موجود${e.bondRecAccount}",
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  Expanded(
                                      child: Text(
                                          "${e.bondRecAccount} ${getAccountNameFromId(e.bondRecAccount)}")),
                                ],
                              )),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(
                              width: 50, child: Text(e.bondRecId.toString())),
                        ],
                      ),
                    ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
