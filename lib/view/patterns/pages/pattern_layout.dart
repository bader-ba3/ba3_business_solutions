import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/view/patterns/pages/add_pattern_page.dart';
import 'package:ba3_business_solutions/view/patterns/pages/all_pattern_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/pattern/pattern_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/shared/widgets/app_menu_item.dart';

class PatternLayout extends StatelessWidget {
  const PatternLayout({super.key});

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
            AppMenuItem(
              text: "إضافة نمط",
              onTap: () {
                Get.find<PatternController>().initPattern();
                Get.to(() => const AddPatternPage());
              },
            ),
            AppMenuItem(
              text: "معاينة الانماط",
              onTap: () {
                checkPermissionForOperation(AppConstants.roleUserRead, AppConstants.roleViewPattern).then((value) {
                  if (value) Get.to(() => const AllPatternPage());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
