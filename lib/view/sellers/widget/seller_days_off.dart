import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/seller/target_controller.dart';

class SellerDaysOff extends StatelessWidget {
  const SellerDaysOff({super.key});

  @override
  Widget build(BuildContext context) {
    TargetController targetController = Get.find<TargetController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          targetController.sellerModel?.sellerDayOff?.length ?? 0,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  targetController.sellerModel?.sellerDayOff![index].toString().split(" ")[0] ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
