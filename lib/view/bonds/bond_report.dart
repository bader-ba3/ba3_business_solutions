import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/bond_record_model.dart';

class BondReport extends StatefulWidget {
  const BondReport({super.key});

  @override
  State<BondReport> createState() => _BondReportState();
}

class _BondReportState extends State<BondReport> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: GetBuilder<BondViewModel>(
          builder: (controller){
            List<GlobalModel> allBond = controller.allBondsItem.values.toList();
            return Column(
              children: [
                SizedBox(
                  height: 55,
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      SizedBox(
                        width: 100,
                        child: Text("التاريخ"),),
                      SizedBox(
                          width: 100,
                          child: Text("النوع")),
                      SizedBox(
                        width: 100,),
                      SizedBox(
                        width: 100,
                        child: Text("الدائن"),),
                      SizedBox(
                        width: 100,),
                      SizedBox(
                        width: 100,
                        child: Text("المدين"),),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      GlobalModel model = allBond[index];
                    return Column(
                      children: [
                          SizedBox(
                            height: 100,
                            child: Row(
                              children: [
                                SizedBox(width: 10,),
                                SizedBox(
                                    width: 100,
                                    child: Text(model.bondDate.toString()),),
                                SizedBox(
                                    width: 100,
                                    child: Text(getBondTypeFromEnum(model.bondType.toString())+": "+model.bondCode.toString())),
                                SizedBox(
                                  width: 100,),
                                SizedBox(
                                  width: 100,
                                  child: Text(model.bondRecord!.map((e) => e.bondRecCreditAmount!,).reduce((value, element) => value+element,).toStringAsFixed(2)),),
                                SizedBox(
                                  width: 100,),
                                SizedBox(
                                  width: 100,
                                  child: Text(model.bondRecord!.map((e) => e.bondRecCreditAmount!,).reduce((value, element) => value+element,).toStringAsFixed(2)),),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              SizedBox(
                                width: 100,
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text("الحساب"),
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              SizedBox(
                                width: 100,
                                child:Text( "دائن",)),
                              SizedBox(
                                width: 100,),
                              SizedBox(
                                  width: 100,
                                  child:Text( "المدين",)),
                              SizedBox(
                                  width: 100,
                                  child:Text( "الوصف",)),
                            ],
                          ),
                        ),
                        for(BondRecordModel i in model.bondRecord!)
                        SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              SizedBox(
                                width: 100,
                              ),
                              SizedBox(
                                  width: 100,
                                  ),
                              SizedBox(
                                width: 100,
                                child: Text(getAccountNameFromId(i.bondRecAccount)),
                              ),
                              SizedBox(
                                width: 100,
                               ),
                              SizedBox(
                                width: 100,
                                child:Text( i.bondRecCreditAmount!.toStringAsFixed(2)),),
                              SizedBox(
                                width: 100,),
                              SizedBox(
                                width: 100,
                                child:Text( i.bondRecDebitAmount!.toStringAsFixed(2)),),
                              SizedBox(
                                width: 200,
                                child:Text( i.bondRecDescription.toString()),),
                            ],
                          ),
                        ),
                      ],
                    );
                  },),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
