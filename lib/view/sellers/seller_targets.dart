
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:ba3_business_solutions/view/widget/target_pointer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/seller_model.dart';
import '../../model/task_model.dart';
import '../widget/CustomWindowTitleBar.dart';



class SellerTarget extends StatefulWidget {
  final String sellerId;
  const SellerTarget({super.key, required this.sellerId});

  @override
  State<SellerTarget> createState() => _SellerTargetState();
}

class _SellerTargetState extends State<SellerTarget> {
  int num = 20000;
  final GlobalKey<TargetPointerWidgetState> othersKey = GlobalKey<TargetPointerWidgetState>();
  final GlobalKey<TargetPointerWidgetState> mobileKey = GlobalKey<TargetPointerWidgetState>();
  late ({Map<String, int> productsMap, double mobileTotal, double otherTotal}) sellerData;
  TargetViewModel targetViewModel = Get.find<TargetViewModel>();
  SellerModel? sellerModel;
  SellersViewModel sellersViewModel = Get.find<SellersViewModel>();

  // late ({double mobileTotal, double otherTotal, Map<String, int> productsMap}) newSellerData;
  @override
  void initState() {
    sellerData = targetViewModel.checkTask(widget.sellerId);
    sellerModel = sellersViewModel.allSellers[widget.sellerId];

    // newSellerData = targetViewModel.checkTask(widget.sellerId);

    super.initState();
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
                actions: [
                  // ElevatedButton(
                  //     onPressed: () {
                  //       num = num + 10000;
                  //       othersKey.currentState?.addValue(num);
                  //     },
                  //     child: Text("aaa"))
                ],
                title: const Text(
                  "لوحة الانجازات",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              body: ListView(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "تارغيت الجوالات ",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              height: 500,
                              child: TargetPointerWidget(
                                key: mobileKey,
                                value: sellerData.mobileTotal.toInt(),
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "تارغيت الاكسسوارات ",
                            style: TextStyle(fontSize: 22),
                          ),
                          Container(
                              width: MediaQuery.sizeOf(context).width / 2,
                              height: 500,
                              child: TargetPointerWidget(
                                key: othersKey,
                                value: sellerData.otherTotal.toInt(),
                              )),
                        ],
                      ),
                    ],
                  ),
                  GetBuilder<SellersViewModel>(builder: (controller) {
                    // print("SetState");
                    // print(newSellerData);
                    if (sellerData.mobileTotal != sellerData.mobileTotal || sellerData.otherTotal != sellerData.otherTotal) {
                      if(sellerData.otherTotal - sellerData.otherTotal.toInt() >0){
                        othersKey.currentState!.addValue(sellerData.otherTotal.toInt());
                      }else{
                        othersKey.currentState!.removeValue(sellerData.otherTotal.toInt());
                      }
                      if(sellerData.mobileTotal - sellerData.mobileTotal.toInt() >0){
                        mobileKey.currentState!.addValue(sellerData.mobileTotal.toInt());
                      }else{
                        mobileKey.currentState!.removeValue(sellerData.mobileTotal.toInt());
                      }
                      // sellerData = sellerData;
                      mobileKey.currentState!.addValue(sellerData.mobileTotal.toInt());
                    }
                    return GetBuilder<TargetViewModel>(builder: (controller) {
                     List<TaskModel>allUserTask= controller.allTarget.values.where((element) => element.taskSellerListId.contains(widget.sellerId)&&element.isTaskAvailable!,).toList();
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "المهام",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          for (TaskModel model in allUserTask)
                            Builder(builder: (context) {
                              int count = sellerData.productsMap[model.taskProductId!] ?? 0;
                              bool isDone = count >= model.taskQuantity!;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Radio(toggleable: false, value: isDone, groupValue: true, onChanged: null),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "بيع  ${model.taskQuantity}  من  ${getProductNameFromId(model.taskProductId)}  لقد بعت  $count",
                                      style: TextStyle(fontSize: 20, color: isDone ? Colors.green : Colors.red),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      );
                    });
                  })
                  ,        Column(
                    children: [
                      // Text(sellerModel?.sellerName ?? ''),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        width: Get.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 20,
                          spacing: 20,
                          children: [
                            SizedBox(
                              width: Get.width * 0.27,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 200,
                                    child: Text("وقت اول دخول:",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                  ),
                                  Expanded(
                                    child: Text(sellerModel?.sellerTime!.firstTimeEnter ?? '',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Colors.blue),),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.27,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 200,
                                    child: Text("وقت اول خروج:",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                  ),
                                  Expanded(
                                    child: Text(sellerModel?.sellerTime!.firstTimeOut ?? '',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Colors.blue),),
                                  ),
                                ],
                              ),
                            ),
                            if(sellerModel?.sellerTime!.secondTimeEnter!=''&&sellerModel?.sellerTime!.secondTimeEnter!=null)
                              ...[  SizedBox(
                                width: Get.width * 0.27,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 200,
                                      child: Text("وقت الاستراحة:",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                    ),
                                    Expanded(
                                      child: Text(sellerModel?.sellerTime!.firstTimeOut ?? '',style: const TextStyle(fontWeight: FontWeight.w700,color: Colors.blue,fontSize: 24),),
                                    ),
                                  ],
                                ),
                              ),
                                SizedBox(
                                  width: Get.width * 0.27,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 200,
                                        child: Text("انتهاء الاستراحة:",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                      ),
                                      Expanded(
                                        child: Text(sellerModel?.sellerTime!.secondTimeEnter ?? '',style: const TextStyle(fontWeight: FontWeight.w700,color: Colors.blue,fontSize: 24),),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.27,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 200,
                                        child: Text("وقت ثاني دخول:",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                      ),
                                      Expanded(
                                        child: Text(sellerModel?.sellerTime!.secondTimeEnter ?? '',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Colors.blue),),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.27,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        width: 200,
                                        child: Text("وقت ثاني خروج:",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                                      ),
                                      Expanded(
                                        child: Text(sellerModel?.sellerTime!.secondTimeOut ?? '',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Colors.blue),),
                                      ),
                                    ],
                                  ),
                                ),
                              ],



                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (sellerModel?.sellerDayOff?.firstOrNull != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          sellerModel?.sellerDayOff?.length ?? 0,
                              (index) => Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(5),
                            width: Get.width / 6.4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 2.0, color: Colors.green),
                            ),
                            child: Row(
                              // mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  sellerModel?.sellerDayOff![index].toString().split(" ")[0] ?? '',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2.0, color: Colors.red),
                      ),
                      margin: const EdgeInsets.all(15),
                      child: const Center(child: Text("لا يوجد ايام عطل")),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
