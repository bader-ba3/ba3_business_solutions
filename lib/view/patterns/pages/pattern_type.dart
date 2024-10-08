import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/view/patterns/pages/all_pattern.dart';
import 'package:ba3_business_solutions/view/patterns/pages/pattern_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';

class PatternType extends StatefulWidget {
  const PatternType({super.key});

  @override
  State<PatternType> createState() => _PatternTypeState();
}

class _PatternTypeState extends State<PatternType> {
  PatternViewModel patternController = Get.find<PatternViewModel>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("أنماط البيع"),
        ),
        body: Column(
          children: [
            Item("إضافة نمط", () {
              Get.to(() => const PatternDetails());
            }),
            Item("معاينة الانماط", () {
              checkPermissionForOperation(
                      AppStrings.roleUserRead, AppStrings.roleViewPattern)
                  .then((value) {
                if (value) Get.to(() => const AllPattern());
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ))),
      ),
    );
  }
}
