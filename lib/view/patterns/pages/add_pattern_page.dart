import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:ba3_business_solutions/core/shared/widgets/custom_window_title_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/add_pattern_bottom_buttons.dart';
import '../widget/add_pattern_form.dart';
import '../widget/colors_picker.dart';

class AddPatternPage extends StatelessWidget {
  const AddPatternPage({super.key});

  @override
  Widget build(BuildContext context) {
    PatternController patternController = Get.find<PatternController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          const CustomWindowTitleBar(),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(patternController.editPatternModel!.patId != null ? patternController.editPatternModel!.patName! : "إنشاء نمط"),
              ),
              body: GetBuilder<PatternController>(
                builder: (patternController) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      children: [
                        const VerticalSpace(20),
                        AddPatternForm(patternController: patternController),
                        const VerticalSpace(40),
                        ColorsPicker(patternController: patternController),
                        const VerticalSpace(40),
                        AddPatternBottomButtons(patternController: patternController),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
