import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:ba3_business_solutions/controller/seller/target_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/core/shared/widgets/target_pointer_widget.dart';
import 'package:ba3_business_solutions/view/sellers/widget/seller_days_off.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/widgets/custom_window_title_bar.dart';
import '../../../data/model/seller/task_model.dart';

class SellerTargetPage extends StatelessWidget {
  final String sellerId;

  const SellerTargetPage({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    TargetController targetController = Get.find<TargetController>();
    return Column(
      children: [
        const CustomWindowTitleBar(),
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                actions: const [],
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
                                key: targetController.mobileKey,
                                value: targetController.sellerData.mobileTotal.toInt(),
                              )),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "تارغيت الاكسسوارات ",
                            style: TextStyle(fontSize: 22),
                          ),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width / 2,
                              height: 500,
                              child: TargetPointerWidget(
                                key: targetController.othersKey,
                                value: targetController.sellerData.otherTotal.toInt(),
                              )),
                        ],
                      ),
                    ],
                  ),
                  GetBuilder<SellersController>(builder: (controller) {
                    if (targetController.sellerData.mobileTotal != targetController.sellerData.mobileTotal ||
                        targetController.sellerData.otherTotal != targetController.sellerData.otherTotal) {
                      if (targetController.sellerData.otherTotal - targetController.sellerData.otherTotal.toInt() > 0) {
                        targetController.othersKey.currentState!.addValue(targetController.sellerData.otherTotal.toInt());
                      } else {
                        targetController.othersKey.currentState!.removeValue(targetController.sellerData.otherTotal.toInt());
                      }
                      if (targetController.sellerData.mobileTotal - targetController.sellerData.mobileTotal.toInt() > 0) {
                        targetController.mobileKey.currentState!.addValue(targetController.sellerData.mobileTotal.toInt());
                      } else {
                        targetController.mobileKey.currentState!.removeValue(targetController.sellerData.mobileTotal.toInt());
                      }
                      targetController.mobileKey.currentState!.addValue(targetController.sellerData.mobileTotal.toInt());
                    }
                    return GetBuilder<TargetController>(builder: (controller) {
                      List<TaskModel> allUserTask = controller.allTarget.values
                          .where(
                            (element) => element.taskSellerListId.contains(sellerId) && element.isTaskAvailable!,
                          )
                          .toList();
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
                              int count = targetController.sellerData.productsMap[model.taskProductId!] ?? 0;
                              bool isDone = count >= model.taskQuantity!;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '*',
                                      style: TextStyle(color: Colors.red, fontSize: 28.0, fontWeight: FontWeight.bold),
                                    ),
                                    const HorizontalSpace(5),
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
                  }),
                  Column(
                    children: [
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
                                    child: Text(
                                      "وقت اول دخول:",
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      targetController.sellerModel?.sellerTime!.firstTimeEnter ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.blue),
                                    ),
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
                                    child: Text(
                                      "وقت اول خروج:",
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      targetController.sellerModel?.sellerTime!.firstTimeOut ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (targetController.sellerModel?.sellerTime!.secondTimeEnter != '' &&
                                targetController.sellerModel?.sellerTime!.secondTimeEnter != null) ...[
                              SizedBox(
                                width: Get.width * 0.27,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 200,
                                      child: Text(
                                        "وقت الاستراحة:",
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        targetController.sellerModel?.sellerTime!.firstTimeOut ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 24),
                                      ),
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
                                      child: Text(
                                        "انتهاء الاستراحة:",
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        targetController.sellerModel?.sellerTime!.secondTimeEnter ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.blue, fontSize: 24),
                                      ),
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
                                      child: Text(
                                        "وقت ثاني دخول:",
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        targetController.sellerModel?.sellerTime!.secondTimeEnter ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.blue),
                                      ),
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
                                      child: Text(
                                        "وقت ثاني خروج:",
                                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        targetController.sellerModel?.sellerTime!.secondTimeOut ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.blue),
                                      ),
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
                  const VerticalSpace(20),
                  if (targetController.sellerModel?.sellerDayOff?.firstOrNull != null)
                    const SellerDaysOff()
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
