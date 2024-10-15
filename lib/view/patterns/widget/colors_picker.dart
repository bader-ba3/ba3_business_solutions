import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../../../controller/pattern/pattern_controller.dart';

class ColorsPicker extends StatelessWidget {
  const ColorsPicker({super.key, required this.patternController});

  final PatternController patternController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialColorPicker(
          allowShades: false,
          onMainColorChange: (ColorSwatch? color) {
            patternController.editPatternModel?.patColor = color?.value;
          },
          selectedColor: Color(patternController.editPatternModel?.patColor ?? 4294198070)),
    );
  }
}
