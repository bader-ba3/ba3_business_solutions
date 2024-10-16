import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/helper/functions/functions.dart';
import '../../../model/bond/bond_record_model.dart';

class BondReport extends StatelessWidget {
  const BondReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: GetBuilder<BondController>(
          builder: (controller) {
            List<GlobalModel> allBond = controller.allBondsItem.values.toList();
            return Column(
              children: [
                const SizedBox(
                  height: 55,
                  child: Row(
                    children: [
                      HorizontalSpace(),
                      SizedBox(
                        width: 100,
                        child: Text(
                          "التاريخ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          "النوع",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      HorizontalSpace(100),
                      SizedBox(
                        width: 100,
                        child: Text(
                          "الدائن",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      HorizontalSpace(100),
                      SizedBox(
                        width: 100,
                        child: Text(
                          "المدين",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: allBond.length,
                    itemBuilder: (context, index) {
                      GlobalModel model = allBond[index];
                      return Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                const HorizontalSpace(),
                                SizedBox(
                                  width: 100,
                                  child: Text(model.bondDate.toString()),
                                ),
                                SizedBox(width: 100, child: Text("${getBondTypeFromEnum(model.bondType.toString())}: ${model.bondCode}")),
                                const SizedBox(width: 100),
                                SizedBox(
                                  width: 100,
                                  child: Text(model.bondRecord!
                                      .map(
                                        (e) => e.bondRecCreditAmount!,
                                      )
                                      .reduce(
                                        (value, element) => value + element,
                                      )
                                      .toStringAsFixed(2)),
                                ),
                                const HorizontalSpace(100),
                                SizedBox(
                                  width: 100,
                                  child: Text(model.bondRecord!
                                      .map(
                                        (e) => e.bondRecCreditAmount!,
                                      )
                                      .reduce(
                                        (value, element) => value + element,
                                      )
                                      .toStringAsFixed(2)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                HorizontalSpace(10),
                                HorizontalSpace(100),
                                HorizontalSpace(100),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "الحساب",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                HorizontalSpace(100),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "دائن",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                HorizontalSpace(100),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "المدين",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    "الوصف",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          for (BondRecordModel i in model.bondRecord!)
                            SizedBox(
                              height: 100,
                              child: Row(
                                children: [
                                  const HorizontalSpace(),
                                  const HorizontalSpace(100),
                                  const HorizontalSpace(100),
                                  SizedBox(
                                    width: 100,
                                    child: Text(getAccountNameFromId(i.bondRecAccount)),
                                  ),
                                  const HorizontalSpace(100),
                                  SizedBox(
                                    width: 100,
                                    child: Text(i.bondRecCreditAmount!.toStringAsFixed(2)),
                                  ),
                                  const HorizontalSpace(100),
                                  SizedBox(
                                    width: 100,
                                    child: Text(i.bondRecDebitAmount!.toStringAsFixed(2)),
                                  ),
                                  SizedBox(
                                    child: Text(i.bondRecDescription.toString()),
                                  ),
                                ],
                              ),
                            ),
                          Container(
                            height: 5,
                            width: Get.width * 0.9,
                            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(8)),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
