import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/view/patterns/pages/add_pattern_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/Widgets/new_pluto.dart';

class AllPatternPage extends StatelessWidget {
  const AllPatternPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatternController>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "أنماط البيع",
        onLoaded: (e) {},
        onSelected: (p0) {
          Get.find<PatternController>().initPattern(p0.row?.cells["id"]?.value);
          Get.to(const AddPatternPage());
        },
        modelList: controller.patternModel.values.toList(),
      );
    });
  }
}
